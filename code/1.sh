#!/bin/sh
# time:2022-07-16 11:13:34
# author:xunpod
# website:blog.xunpod.com
# updated:2022-07-30 19:30:16

set -e

mkdir ~/app
mkdir ~/download
mkdir ~/code
mkdir ~/env

# 卸载cloud-init
apt remove -y cloud-init 
apt purge -y cloud-init 
rm -rf /etc/cloud && rm -rf /var/lib/cloud/

# 更新软件源为中科大源
cp /etc/apt/sources.list /etc/apt/sources.list.bak
rm /etc/apt/sources.list
echo -e "# 中科大源\ndeb https://mirrors.ustc.edu.cn/ubuntu/ focal main restricted universe multiverse \ndeb https://mirrors.ustc.edu.cn/ubuntu/ focal-updates main restricted universe multiverse \ndeb https://mirrors.ustc.edu.cn/ubuntu/ focal-backports main restricted universe multiverse \ndeb https://mirrors.ustc.edu.cn/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list
apt update && apt upgrade -y

apt install -y openssh-server vim gcc g++ cmake curl git wget unzip ntpdate apt-transport-https ca-certificates software-properties-common openjdk-8-jre-headless python2.7 python3 python3-pip ruby sqlite3 mysql-server
# 依赖库 可选
# apt install -y htop m4 ruby gfortran build-essential subversion perl mpich libblas-dev liblapack-dev libatlas-base-dev libpng-dev libtiff-dev libjpeg-dev libfftw3-dev automake autoconf libtool libnetcdf-dev pnetcdf-bin atool libxv-dev ncurses-dev libncurses5-dev python3-ck cakephp-scripts cme cde ack antlr3 asciidoc autopoint binutils bison bzip2 ccache cpio  device-tree-compiler fastjar flex gawk gettext gcc-multilib g++-multilib  gperf haveged help2man intltool libc6-dev-i386 libelf-dev libgmp3-dev libltdl-dev libmpc-dev libmpfr-dev libncursesw5-dev libreadline-dev libssl-dev lrzsz mkisofs msmtp nano ninja-build p7zip p7zip-full patch pkgconf  qemu-utils rsync scons squashfs-tools swig texinfo uglifyjs upx-ucl xmlto xxd zlib1g-dev 

# 设置时区
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# 校正时间
ntpdate cn.pool.ntp.org

# proxy bash
echo -e "export http_proxy="http://192.168.21.2:7890" \nexport https_proxy="https://192.168.21.2:7890/"" >> ~/.bashrc
source ~/.bashrc
# proxy curl
echo -e "proxy="http://192.168.21.2:7890/"" >> ~/.curlrc
source ~/.curlrc
# proxy git
# git全局代理
git config --global http.proxy http://192.168.21.2:7890
git config --global https.proxy https://192.168.21.2:7890
# 取消代理
git config --global --unset  http.proxy  
git config --global --unset  https.proxy 
# 对github设置代理
git config --global http.https://github.com.proxy http://192.168.21.2:7890

# 安装MicroSoft Edge & Visio Studio Code & Google Chrome
# 下载并安装Microsoft证书
wget -q -O-  https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
# 下载并安装Google证书
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
# 导入Microsoft Edge & Visual Studio Code官方源
echo 'deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main' | tee /etc/apt/sources.list.d/microsoft-edge.list
echo 'deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main' | tee /etc/apt/sources.list.d/microsoft-vscode.list
# 导入Google Chrome官方源
echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
apt update && apt install -y microsoft-edge-stable code google-chrome-stable




# 清理安装
apt autoremove -y
apt autoclean
apt clean
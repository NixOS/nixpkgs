#!/usr/bin/env bash
# Install gcc-14
set -e

apt-get update
apt-get -y install software-properties-common
add-apt-repository "deb http://archive.ubuntu.com/ubuntu/ noble main universe"
apt-get update
apt-get -y install gcc-14 g++-14
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 10
update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-14 10

#! @bash@/bin/sh -e

tty=$1

exec < $tty > $tty 2>&1

export PATH=@nix@/bin:@bash@/bin:@coreutils@/bin:@findutils@/bin:@utillinux@/bin:@utillinux@/sbin:@sysvinit@/bin:@sysvinit@/sbin:@e2fsprogs@/bin:@e2fsprogs@/sbin

echo
echo "=== Welcome to Nix! ==="

export HOME=/home/root
cd $HOME

exec @bash@/bin/sh

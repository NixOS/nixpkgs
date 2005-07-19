#! /bin/sh -e

sysvinitPath=@sysvinitPath@
bootPath=@bootPath@

if ! test -n "$1"
then
    echo "need URL for manifest!"
    exit
else
    manifest=$1
fi

make_dir() {
    mode=$1
    name=$2
    echo creating $name...
    if ! test -d $root/$name; then mkdir $root/$name; fi
    chmod $mode $root/$name
}


touch_file() {
    name=$1
    echo touching $name...
    if ! test -d $root/$name; then touch $root/$name; fi
}
root=/tmp/mnt

make_dir 00755 /bin
make_dir 00755 /dev
make_dir 00755 /proc
make_dir 01777 /tmp
make_dir 00755 /etc # global non-constant configuration
make_dir 00755 /etc-secret
make_dir 00755 /var
make_dir 00755 /nix
make_dir 00755 /nix/store
make_dir 00755 /nix/var
make_dir 00755 /nix/var/nix
make_dir 00755 /nix/var/nix/db
make_dir 00755 /nix/var/nix/manifests
make_dir 00755 /nix/var/log
make_dir 00755 /nix/var/log/nix
make_dir 00755 /nixpkgs
make_dir 00755 /nixpkgs/trunk
make_dir 00755 /mnt
make_dir 00755 /mnt/host
make_dir 00755 /home
make_dir 00755 /home/root

mknod $root/dev/null c 1 3

touch_file /etc/passwd
touch_file /etc/shadow
touch_file /etc/group

rm -f $root/etc/mtab
#ln -s /proc/mounts $root/etc/mtab

export NIX_DATA_DIR=$root/nix/share
export NIX_LOG_DIR=$root/nix/log/nix
export NIX_STATE_DIR=$root/nix/var/nix
export NIX_CONF_DIR=$root/nix/etc
NIX_CMD_PATH=@NIX_CMD_PATH@/bin

echo initialising Nix DB...
#/nix/bin/nix-store --init
$NIX_CMD_PATH/nix-store --init

echo verifying Nix DB...
$NIX_CMD_PATH/nix-store --verify

echo copying nixpkgs...
cp -fa ../pkgs $root/nixpkgs/trunk

make_dir 0755 /tmp/scripts
cp -fa ../scripts $root/tmp

echo adding manifest
$NIX_CMD_PATH/nix-pull $manifest

echo adding packages
export NIX_ROOT=$root
unset NIX_DATA_DIR
unset NIX_LOG_DIR
unset NIX_STATE_DIR
unset NIX_CONF_DIR

storeExpr=$(echo '(import ./pkgs.nix).everything' | $NIX_CMD_PATH/nix-instantiate -v -v -)
$NIX_CMD_PATH/nix-store -r $storeExpr

#echo registering valid paths...
#(while read storepath; do
#    echo PATH $storepath
#    if ! $NIX_CMD_PATH/nix-store --isvalid $storepath 2> /dev/null; then
#        (unset NIX_ROOT; $NIX_CMD_PATH/nix-store --dump $storepath) | $NIX_CMD_PATH/nix-store --restore $storepath
#        $NIX_CMD_PATH/nix-store --validpath $storepath
#    fi
#done) < /tmp/mystorepaths

#echo registering successors...
#(while read line; do
#    echo SUCC $line
#    $NIX_CMD_PATH/nix-store --successor $line
#done) < /tmp/mysuccessors

echo setting init symlink...
rm -f $root/init
ln -s $sysvinitPath/sbin/init $root/init

echo setting up inittab...
rm -f $root/etc/inittab
echo "id:2:initdefault:" >> $root/etc/inittab
echo "si::bootwait:$bootPath/bin/boot.sh" >> $root/etc/inittab
echo "ht:06:wait:$bootPath/bin/halt.sh" >> $root/etc/inittab
echo "1:2345:respawn:$bootPath/bin/login.sh /dev/ttys/0" >> $root/etc/inittab
#echo "2:2345:respawn:$bootPath/bin/login.sh /dev/ttys/1" >> $root/etc/inittab

echo setting up networking information...
make_dir 00755 /etc/networking
echo 192.168.150.1 > $root/etc/networking/local-ip
echo 192.168.150.3 > $root/etc/networking/gateway-ip
cp /etc/resolv.conf $root/etc
rm -f $root/etc/hosts
echo "127.0.0.1 localhost" >> $root/etc/hosts
echo "192.168.150.1 uml" >> $root/etc/hosts

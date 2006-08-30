#! @bash@/bin/sh -e

export PATH=@bash@/bin:@coreutilsdiet@/bin:@coreutils@/bin:@findutils@/bin:@utillinux@/bin:@utillinux@/sbin:@e2fsprogs@/sbin:@grub@/sbin:@sysvinitPath@/sbin:@gnugrep@/bin:@which@/bin:@gnutar@/bin:@busybox@/bin:@busybox@/sbin:@nano@/bin

#tty=$1

#exec < $tty > $tty 2>&1

echo
echo "=== Welcome to Nix! ==="
echo "NixOS Installation instructions"
echo ""
echo "* edit the file called 'disklayout' (vi is provided) and provide"
echo "  the following name=value pairs:"
echo "  * INSTALLDEVICE (root device, for example /dev/hda1)"
echo "  * SWAP (swap device, for example /dev/hda2)"
echo "  * TARGETDRIVE (target drive to install grub, for example /dev/hda)"
echo "* run: sh fill-disk.sh"
echo ""
echo ""
echo ""
echo ""

export HOME=/
cd $HOME

exec @bash@/bin/sh

source $stdenv/setup

ensureDir $out

ln -s $kernel $out/kernel
ln -s $grub $out/grub
ln -s $bootStage2 $out/init
ln -s $initrd $out/initrd
echo "$extraKernelParams" > $out/kernel-params

cat > $out/menu.lst << GRUBEND
kernel $kernel init=$bootStage2 $extraKernelParams
initrd $initrd
GRUBEND

ensureDir $out/bin

cat > $out/bin/switch-to-configuration <<EOF
#! $SHELL
set -e
export PATH=$coreutils/bin:$gnused/bin:$gnugrep/bin:$diffutils/bin
if test -n "$grubDevice"; then
    mkdir -m 0700 -p /boot/grub
    $grubMenuBuilder $out
    if test "\$NIXOS_INSTALL_GRUB" = 1; then
        $grub/sbin/grub-install "$grubDevice" --no-floppy --recheck
    fi
fi
sync
EOF

chmod +x $out/bin/switch-to-configuration

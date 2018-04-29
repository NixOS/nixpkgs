#! @bash@/bin/sh -e

copyForced() {
    local src="$1"
    local dst="$2"
    cp $src $dst.tmp
    mv $dst.tmp $dst
}

# Call the extlinux builder
"@extlinuxConfBuilder@" "$@"

# Add the firmware files
fwdir=@firmware@/share/raspberrypi/boot/
copyForced $fwdir/bootcode.bin  /boot/bootcode.bin
copyForced $fwdir/fixup.dat     /boot/fixup.dat
copyForced $fwdir/fixup_cd.dat  /boot/fixup_cd.dat
copyForced $fwdir/fixup_db.dat  /boot/fixup_db.dat
copyForced $fwdir/fixup_x.dat   /boot/fixup_x.dat
copyForced $fwdir/start.elf     /boot/start.elf
copyForced $fwdir/start_cd.elf  /boot/start_cd.elf
copyForced $fwdir/start_db.elf  /boot/start_db.elf
copyForced $fwdir/start_x.elf   /boot/start_x.elf

# Add the uboot file
copyForced @uboot@/u-boot.bin /boot/u-boot-rpi.bin

# Add the config.txt
copyForced @configTxt@ /boot/config.txt

#! @bash@/bin/sh -e

target=/boot # Target directory

while getopts "t:c:d:g:" opt; do
    case "$opt" in
        d) target="$OPTARG" ;;
        *) ;;
    esac
done

copyForced() {
    local src="$1"
    local dst="$2"
    cp -r $src $dst.tmp
    rm -rf $dst
    mv $dst.tmp $dst
}

# Call the extlinux builder
"@extlinuxConfBuilder@" "$@"

# Add the firmware files
fwdir=@firmware@/share/raspberrypi/boot/
copyForced $fwdir/overlays  $target/overlays
copyForced $fwdir/bootcode.bin  $target/bootcode.bin
copyForced $fwdir/fixup.dat     $target/fixup.dat
copyForced $fwdir/fixup_cd.dat  $target/fixup_cd.dat
copyForced $fwdir/fixup_db.dat  $target/fixup_db.dat
copyForced $fwdir/fixup_x.dat   $target/fixup_x.dat
copyForced $fwdir/start.elf     $target/start.elf
copyForced $fwdir/start_cd.elf  $target/start_cd.elf
copyForced $fwdir/start_db.elf  $target/start_db.elf
copyForced $fwdir/start_x.elf   $target/start_x.elf

# Add the config.txt
copyForced @configTxt@ $target/config.txt

# Add the uboot file
copyForced @uboot@/u-boot.bin $target/u-boot-rpi.bin

# Add the raspberry pi 4 specific files
if [[ "@version@" == "4" ]]; then
    copyForced @armstubs@/armstub8-gic.bin $target/armstub8-gic.bin

    copyForced $fwdir/fixup4.dat    $target/fixup4.dat
    copyForced $fwdir/fixup4cd.dat  $target/fixup4cd.dat
    copyForced $fwdir/fixup4db.dat  $target/fixup4db.dat
    copyForced $fwdir/fixup4x.dat   $target/fixup4x.dat
    copyForced $fwdir/start4.elf    $target/start4.elf
    copyForced $fwdir/start4cd.elf  $target/start4cd.elf
    copyForced $fwdir/start4db.elf  $target/start4db.elf
    copyForced $fwdir/start4x.elf   $target/start4x.elf

    copyForced @firmware@/share/raspberrypi/boot/bcm2711-rpi-4-b.dtb $target/bcm2711-rpi-4-b.dtb
    copyForced @firmware@/share/raspberrypi/boot/bcm2711-rpi-400.dtb $target/bcm2711-rpi-400.dtb
    copyForced @firmware@/share/raspberrypi/boot/bcm2711-rpi-cm4.dtb $target/bcm2711-rpi-cm4.dtb
fi

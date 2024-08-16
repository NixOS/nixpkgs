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
    cp $src $dst.tmp
    mv $dst.tmp $dst
}

# Call the extlinux builder
"@extlinuxConfBuilder@" "$@"

# Add the firmware files
fwdir=@firmware@/share/raspberrypi/boot/
copyForced $fwdir/bootcode.bin  $target/bootcode.bin
copyForced $fwdir/fixup.dat     $target/fixup.dat
copyForced $fwdir/fixup_cd.dat  $target/fixup_cd.dat
copyForced $fwdir/fixup_db.dat  $target/fixup_db.dat
copyForced $fwdir/fixup_x.dat   $target/fixup_x.dat
copyForced $fwdir/start.elf     $target/start.elf
copyForced $fwdir/start_cd.elf  $target/start_cd.elf
copyForced $fwdir/start_db.elf  $target/start_db.elf
copyForced $fwdir/start_x.elf   $target/start_x.elf

# Add the uboot file
copyForced @uboot@/u-boot.bin $target/u-boot-rpi.bin

# Add the config.txt
copyForced @configTxt@ $target/config.txt

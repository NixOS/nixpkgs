#! @bash@/bin/sh -e

target=@efiSysMountPoint@ # Target directory
config=""

while getopts "t:c:d:g:" opt; do
    case "$opt" in
        d) target="$OPTARG" ;;
        c) config="$OPTARG" ;;
        *) ;;
    esac
done

copyForced() {
    local src="$1"
    local dst="$2"
    cp $src $dst.tmp
    mv $dst.tmp $dst
}

"@grubBootBuilder@" "${config}"

# Add the firmware files
rpi4uefidir=@rpi4uefi@
copyForced $rpi4uefidir/start4.elf $target/start4.elf
copyForced $rpi4uefidir/fixup4.dat $target/fixup4.dat
copyForced $rpi4uefidir/RPI_EFI.fd $target/RPI_EFI.fd
copyForced $rpi4uefidir/config.txt $target/config.txt
copyForced $rpi4uefidir/bcm2711-rpi-4-b.dtb $target/bcm2711-rpi-4-b.dtb
copyForced $rpi4uefidir/bcm2711-rpi-400.dtb $target/bcm2711-rpi-400.dtb
copyForced $rpi4uefidir/bcm2711-rpi-cm4.dtb $target/bcm2711-rpi-cm4.dtb

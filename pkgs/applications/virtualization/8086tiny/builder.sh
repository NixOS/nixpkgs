
source $stdenv/setup

mkdir -p ./$name $out/bin $out/share/$name $out/share/doc/$name/images

cd $name
tar xf $src
make 8086tiny

install 8086tiny $out/bin
install bios $out/share/$name/8086tiny-bios
install fd.img $out/share/$name/8086tiny-floppy.img
install bios_source/bios.asm  $out/share/$name/8086tiny-bios-src.asmn
install docs/8086tiny.css  $out/share/doc/$name
install docs/doc.html  $out/share/doc/$name
for i in docs/images/*.gif
do
    install $i $out/share/doc/$name/images
done

# Refactoring "runme" script

cat << 'EOF' >> run-8086tiny
#!/bin/sh

# Setting vars: $1 = bios file, $2 = floppy image, $3= harddisk image
if [ $# -ne 2 -a $# -ne 3 ]; then
   echo "Usage: $0 <bios file> <floppy image> [harddisk image]"
   exit 1
fi

bios="$1"
floppy="$2"
hdimage="$3"

clear
stty cbreak raw -echo min 0
8086tiny $bios $floppy $hdimage
stty cooked echo

EOF

patchShebangs run-8086tiny
install run-8086tiny $out/bin


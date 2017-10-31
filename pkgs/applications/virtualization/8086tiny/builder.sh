
source $stdenv/setup

mkdir -p ./$name $out/bin $out/share/$name $out/share/doc/$name/images

cd $name
tar xf $src
make 8086tiny
if [ $bios ]; then
    cd bios_source
    nasm -f bin bios.asm -o bios
    cd ..
fi

install -m 755 8086tiny $out/bin
install -m 644 fd.img $out/share/$name/8086tiny-floppy.img
install -m 644 bios_source/bios.asm  $out/share/$name/8086tiny-bios-src.asm
install -m 644 docs/8086tiny.css  $out/share/doc/$name
install -m 644 docs/doc.html  $out/share/doc/$name
for i in docs/images/*.gif
do
    install -m 644 $i $out/share/doc/$name/images
done
if [ $bios ]; then
    install -m 644 bios_source/bios $out/share/$name/8086tiny-bios
else
    install -m 644 bios $out/share/$name/8086tiny-bios
fi

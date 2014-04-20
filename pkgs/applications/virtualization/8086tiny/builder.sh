
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

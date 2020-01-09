source $stdenv/setup

if [ -d "$src" ]; then
    cp $src/download.lst $out
else
    tar --extract --file=$src libreoffice-$version/download.lst -O > $out
fi

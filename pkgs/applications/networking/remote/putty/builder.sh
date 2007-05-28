source $stdenv/setup

tar zxvf $src
cd putty-*/unix/

ensureDir $out/bin
ensureDir $out/share/man/man1

./configure --prefix=$out --with-gtk-prefix=$gtk
make
make install


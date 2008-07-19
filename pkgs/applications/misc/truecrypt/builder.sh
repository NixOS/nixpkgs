source $stdenv/setup

# PATH=$perl/bin:$PATH

tar zxvf $wxWidgets

# we need the absolute path, relative will not work
wxwdir=$(pwd)/wxX11-*

tar xvfz $src
cd truecrypt-*

make WX_ROOT=$wxwdir wxbuild
make


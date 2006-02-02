source $stdenv/setup

PATH=$PATH
set
tar xvfz $src
cd joe-*
./configure --prefix=$out
make
make install

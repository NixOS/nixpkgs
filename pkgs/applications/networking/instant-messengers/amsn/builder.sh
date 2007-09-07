source $stdenv/setup

echo $libstdcpp
echo "-L$libstdcpp/lib"
LDFLAGS="-L$libstdcpp/lib"
CPPFLAGS="-L$libstdcpp/include"
CFLAGS="-lm"

configureFlags="--with-tcl=$tcl/lib --with-tk=$tk/lib --enable-static"

genericBuild

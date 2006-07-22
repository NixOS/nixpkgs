source $stdenv/setup

configureFlags="--with-tcl=$tcl/lib --with-tk=$tk/lib"

genericBuild

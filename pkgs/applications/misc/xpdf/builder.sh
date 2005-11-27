source $stdenv/setup

configureFlags="--x-includes=$libX11/include --x-libraries=$libX11/lib"

genericBuild

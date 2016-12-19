{ stdenv, fetchFromGitHub, unzip, pkgconfig, glib, clang, gcc }:

stdenv.mkDerivation rec {
  name = "milu-nightly-${version}";
  version = "2016-05-09";

  src = fetchFromGitHub {
    sha256 = "14cglw04cliwlpvw7qrs6rfm5sv6qa558d7iby5ng3wdjcwx43nk";
    rev = "b5f2521859c0319d321ad3c1ad793b826ab5f6e1";
    repo = "Milu";
    owner = "yuejia";
  };

  hardeningDisable = [ "format" ];

  preConfigure = ''
    sed -i 's#/usr/bin/##g' Makefile
    sed -i "s#-lclang#-L$(clang --print-search-dirs |
            sed -ne '/libraries:/{s/libraries: =//; s/:/ -L/gp}') -lclang#g" Makefile
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/milu $out/bin
  '';

  buildInputs = [
     pkgconfig
     glib
     unzip
     clang
     gcc
  ];

  meta = {
    description = "Higher Order Mutation Testing Tool for C and C++ programs";
    homepage = http://github.com/yuejia/Milu;
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.vrthra ];
  };
}


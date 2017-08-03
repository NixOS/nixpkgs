{ stdenv, fetchFromGitHub, zlib, openblas, darwin}:

stdenv.mkDerivation rec {
  name = "plink-ng-${version}";
  version = "1.90b3";

  src = fetchFromGitHub {
    owner = "chrchang";
    repo = "plink-ng";
    rev = "v${version}";
    sha256 = "1zhffjbwpd50dxywccbnv1rxy9njwz73l4awc5j7i28rgj3davcq";
  };

  buildInputs = [ zlib ] ++ (if stdenv.isDarwin then [ darwin.apple_sdk.frameworks.Accelerate ] else [ openblas ]) ;

  buildPhase = ''
    sed -i 's|zlib-1.2.8/zlib.h|zlib.h|g' *.c *.h
    ${if stdenv.cc.isClang then "sed -i 's|g++|clang++|g' Makefile.std" else ""}
    make ZLIB=-lz ${if stdenv.isDarwin then "" else "BLASFLAGS=-lopenblas"} -f Makefile.std
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp plink $out/bin
  '';

  meta = {
    description = "A comprehensive update to the PLINK association analysis toolset";
    homepage = https://www.cog-genomics.org/plink2;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.all;
  };
}


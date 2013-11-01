{ stdenv, fetchurl, zlib, unzip }:

stdenv.mkDerivation {
  name = "plink-1.07";

  src = fetchurl {
    url = "http://pngu.mgh.harvard.edu/~purcell/plink/dist/plink-1.07-src.zip";
    sha256 = "4af56348443d0c6a1db64950a071b1fcb49cc74154875a7b43cccb4b6a7f482b";
  };

  buildInputs = [ zlib unzip ] ;

  installPhase = ''
    mkdir -p $out/bin
    cp plink $out/bin
  '';
  
  meta = {
    description = "Whole genome association toolkit";
    homepage = "http://pngu.mgh.harvard.edu/~purcell/plink/";
    license = "GNUv2";
    platforms = stdenv.lib.platforms.all;
  };
}

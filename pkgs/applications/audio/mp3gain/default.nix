{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "mp3gain-1.5.2";
  src = fetchurl {
    url = "http://downloads.sourceforge.net/mp3gain/mp3gain-1_5_2-src.zip";
    sha256 = "1jkgry59m8cnnfq05b9y1h4x4wpy3iq8j68slb9qffwa3ajcgbfv";
  };

  buildInputs = [ unzip ];

  sourceRoot = ".";

  buildFlags = [ "OSTYPE=linux" ];

  installPhase = ''
    mkdir -p $out/usr/bin
    cp mp3gain $out/usr/bin
  '';

  meta = {
    description = "Lossless mp3 normalizer with statistical analysis";
    homepage = http://mp3gain.sourceforge.net/;
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}

{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "mp3gain-1.5.2";
  src = fetchurl {
    url = "mirror://sourceforge/mp3gain/mp3gain-1_5_2-src.zip";
    sha256 = "1jkgry59m8cnnfq05b9y1h4x4wpy3iq8j68slb9qffwa3ajcgbfv";
  };

  buildInputs = [ unzip ];

  sourceRoot = ".";

  buildFlags = [ "OSTYPE=linux" ];

  installPhase = ''
    install -vD mp3gain "$out/bin/mp3gain"
  '';

  meta = {
    description = "Lossless mp3 normalizer with statistical analysis";
    homepage = http://mp3gain.sourceforge.net/;
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}

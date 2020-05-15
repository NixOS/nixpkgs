{ stdenv, fetchurl, unzip, mpg123 }:

stdenv.mkDerivation {
  name = "mp3gain-1.6.2";
  src = fetchurl {
    url = "mirror://sourceforge/mp3gain/mp3gain-1_6_2-src.zip";
    sha256 = "0varr6y7k8zarr56b42r0ad9g3brhn5vv3xjg1c0v19jxwr4gh2w";
  };

  buildInputs = [ unzip mpg123 ];

  sourceRoot = ".";

  buildFlags = [ "OSTYPE=linux" ];

  installPhase = ''
    install -vD mp3gain "$out/bin/mp3gain"
  '';

  meta = {
    description = "Lossless mp3 normalizer with statistical analysis";
    homepage = "http://mp3gain.sourceforge.net/";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}

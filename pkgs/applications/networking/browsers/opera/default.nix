{stdenv, fetchurl, qt, zlib, libX11, motif ? null, libXt ? null, libXext ? null}:

assert stdenv.system == "i686-linux";
assert motif != null -> libXt != null && libXext != null;

stdenv.mkDerivation {
  name = "opera-8.51-20051114.6";

  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.tiscali.nl/pub/mirrors/opera/linux/851/final/en/i386/opera-8.51-20051114.6-shared-qt.i386-en.tar.bz2;
    md5 = "bf930c45023035ee4258b13b707176c2";
  };

  libPath = [qt zlib libX11 motif libXt libXext];
}

{stdenv, fetchurl, libXt, libXp, libXext, libX11}:

stdenv.mkDerivation {
  name = "acrobat-reader-5.0.10";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://ardownload.adobe.com/pub/adobe/acrobatreader/unix/5.x/linux-5010.tar.gz;
    md5 = "9721b85d54aab1d9ece37758cc6d64f2";
  };
  inherit libXt libXp libXext libX11;
}

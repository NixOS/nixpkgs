{stdenv, fetchurl, patchelf, libXt, libXp, libXext, libX11}:

stdenv.mkDerivation {
  name = "acrobat-reader-5.0.9";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://ardownload.adobe.com/pub/adobe/acrobatreader/unix/5.x/linux-509.tar.gz;
    md5 = "53b7ca0fc83ab81214ba82050ce89c64";
  };
  buildInputs = [patchelf];
  inherit libXt libXp libXext libX11;
}

{stdenv, fetchurl, libX11}:

stdenv.mkDerivation {
  name = "xpdf-3.01";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.foolabs.com/pub/xpdf/xpdf-3.01.tar.gz;
    md5 = "e004c69c7dddef165d768b1362b44268";
  };
  inherit libX11;
}

{stdenv, fetchurl, libX11, libXext}:

stdenv.mkDerivation {
  name = "aangifte2006-1";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://download.belastingdienst.nl/belastingdienst/apps/linux/ib2006_linux.tar.gz;
    sha256 = "1hgm3vmcr32v34h4y8yz3vxcxbcsxqb12qy1dqqwgbg1bja7nvrc";
  };

  inherit libX11 libXext;

  meta = {
    description = "Elektronische aangifte IB 2006";
    url = "http://www.belastingdienst.nl/download/1341.html";
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
  };
}

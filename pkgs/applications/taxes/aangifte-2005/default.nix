{stdenv, fetchurl, patchelf, libX11, libXext}:

stdenv.mkDerivation {
  name = "aangifte2005-1";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://download.belastingdienst.nl/belastingdienst/apps/linux/ib2005_linux.tar.gz;
    md5 = "9cc709b8ad041f4b20154ff1491d0436";
  };

  buildInputs = [patchelf];
  inherit libX11 libXext;
}

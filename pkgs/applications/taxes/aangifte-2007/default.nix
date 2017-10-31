{stdenv, fetchurl, libX11, libXext, libSM}:

stdenv.mkDerivation {
  name = "aangifte2007-1";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://download.belastingdienst.nl/belastingdienst/apps/linux/ib2007_linux.tar.gz;
    sha256 = "13p3gv086jn95wvmfygdmk9qjn0qxqdv7pp0v5pmw6i5hp8rmjxf";
  };

  inherit libX11 libXext libSM;

  dontStrip = true;
  dontPatchELF = true;

  meta = {
    description = "Elektronische aangifte IB 2007";
    url = "http://www.belastingdienst.nl/download/1341.html";
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
  };
}

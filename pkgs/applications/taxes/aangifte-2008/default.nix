{stdenv, fetchurl, libX11, libXext, libSM}:

stdenv.mkDerivation {
  name = "aangifte2008-1";
  
  builder = ./builder.sh;

  src = fetchurl {
    url = http://download.belastingdienst.nl/belastingdienst/apps/linux/ib2008_linux.tar.gz;
    sha256 = "0p46bc1b14hgf07illg3crjgjdflkcknk4nzm7b73cwkni57scx3";
  };

  inherit libX11 libXext libSM;

  dontStrip = true;
  dontPatchELF = true;

  meta = {
    description = "Elektronische aangifte IB 2008 (Dutch Tax Return Program)";
    url = http://www.belastingdienst.nl/particulier/aangifte2008/aangifte_2008/aangifte_2008.html;
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
  };
}

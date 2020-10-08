{ stdenv, lib, fetchurl, wrapQtAppsHook, qmake }:

stdenv.mkDerivation rec {
  pname = "xflr5";
  version = "6.47";

  src = fetchurl {
    url = "mirror://sourceforge/xflr5/${pname}_v${version}_src.tar.gz";
    sha256 = "02x3r9iv3ndwxa65mxn9m5dlhcrnjiq7cffi6rmb456gs3v3dnav";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ qmake wrapQtAppsHook ];

  meta = with stdenv.lib; {
    description = "An analysis tool for airfoils, wings and planes";
    homepage = https://sourceforge.net/projects/xflr5/;
    license = licenses.gpl3;
    maintainers = [ maintainers.esclear ];
    platforms = platforms.linux;
  };
}
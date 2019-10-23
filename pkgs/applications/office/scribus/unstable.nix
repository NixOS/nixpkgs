{ stdenv, fetchurl, mkDerivation, pkgconfig, cmake, qtbase, cairo, pixman,
boost, cups, fontconfig, freetype, hunspell, libjpeg, libtiff, libxml2, lcms2,
podofo, poppler, poppler_data, python2, qtimageformats, qttools, harfbuzzFull }:

let
  pythonEnv = python2.withPackages(ps: [ps.tkinter ps.pillow]);
in
mkDerivation rec {
  pname = "scribus";
  version = "1.5.5";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-devel/${pname}-${version}.tar.xz";
    sha256 = "eQiyGmzoQyafWM7fX495GJMlfmIBzOX73ccNrKL+P3E=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig cmake  ];
  buildInputs = [
    qtbase cairo pixman boost cups fontconfig
    freetype hunspell libjpeg libtiff libxml2 lcms2 podofo poppler
    poppler_data pythonEnv qtimageformats qttools harfbuzzFull
  ];

  meta = {
    maintainers = [ stdenv.lib.maintainers.erictapen ];
    platforms = stdenv.lib.platforms.linux;
    description = "Desktop Publishing (DTP) and Layout program for Linux";
    homepage = http://www.scribus.net;
    license = stdenv.lib.licenses.gpl2;
  };
}

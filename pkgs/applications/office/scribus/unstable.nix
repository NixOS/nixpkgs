{ stdenv, fetchurl, fetchpatch, mkDerivation, pkgconfig, cmake, qtbase, cairo, pixman,
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

  patches = [
    # fix build with Poppler 0.82
    (fetchpatch {
      url = "https://github.com/scribusproject/scribus/commit/6db15ec1af791377b28981601f8c296006de3c6f.patch";
      sha256 = "1y6g3avmsmiyaj8xry1syaz8sfznsavh6l2rp13pj2bwsxfcf939";
    })
    # fix build with Poppler 0.83
    (fetchpatch {
      url = "https://github.com/scribusproject/scribus/commit/b51c2bab4d57d685f96d427d6816bdd4ecfb4674.patch";
      sha256 = "031yy9ylzksczfnpcc4glfccz025sn47zg6fqqzjnqqrc16bgdlx";
    })
  ];

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

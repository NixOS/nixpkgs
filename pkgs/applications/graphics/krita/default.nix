{ stdenv, lib, fetchurl, cmake, extra-cmake-modules, makeQtWrapper
, karchive, kconfig, kwidgetsaddons, kcompletion, kcoreaddons
, kguiaddons, ki18n, kitemmodels, kitemviews, kwindowsystem
, kio, kcrash
, boost, libraw, fftw, eigen, exiv2, lcms2, gsl, openexr
, openjpeg, opencolorio, vc, poppler_qt5, curl, ilmbase
}:

stdenv.mkDerivation rec {
  name = "krita-${version}";
  version = "3.1.1";

  src = fetchurl {
    url = "http://download.kde.org/stable/krita/${version}/${name}.tar.gz";
    sha256 = "13qff9kdd38x81rq6yfmkm3083l8s0yn9h3d5qg3qmhrkd5jrvv2";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules makeQtWrapper ];

  buildInputs = [
    karchive kconfig kwidgetsaddons kcompletion kcoreaddons kguiaddons
    ki18n kitemmodels kitemviews kwindowsystem kio kcrash
    boost libraw fftw eigen exiv2 lcms2 gsl openexr
    openjpeg opencolorio vc poppler_qt5 curl ilmbase
  ];

  NIX_CFLAGS_COMPILE = [ "-I${ilmbase.dev}/include/OpenEXR" ];

  enableParallelBuilding = true;

  postInstall = ''
    for i in $out/bin/*; do
      wrapQtProgram "$i"
    done
  '';

  meta = with stdenv.lib; {
    description = "A free an open source painting application";
    homepage = "https://krita.org/";
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
    licenses = licenses.gpl2;
  };
}

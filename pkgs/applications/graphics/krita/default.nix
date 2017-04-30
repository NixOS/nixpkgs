{ stdenv, lib, fetchurl, cmake, extra-cmake-modules, makeQtWrapper
, karchive, kconfig, kwidgetsaddons, kcompletion, kcoreaddons
, kguiaddons, ki18n, kitemmodels, kitemviews, kwindowsystem
, kio, kcrash
, boost, libraw, fftw, eigen, exiv2, lcms2, gsl, openexr
, openjpeg, opencolorio, vc, poppler_qt5, curl, ilmbase
}:

stdenv.mkDerivation rec {
  name = "krita-${version}";
  ver_min = "3.1.3";
  version = "${ver_min}";

  src = fetchurl {
    url = "http://download.kde.org/stable/krita/${ver_min}/${name}.tar.gz";
    sha256 = "125js6c8aw4bqhs28pwnl3rbgqx5yx4zsklw7bfdhy3vf6lrysw1";
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
    license = licenses.gpl2;
  };
}

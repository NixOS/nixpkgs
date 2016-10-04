{ stdenv, lib, fetchgit, cmake, extra-cmake-modules, makeQtWrapper
, karchive, kconfig, kwidgetsaddons, kcompletion, kcoreaddons
, kguiaddons, ki18n, kitemmodels, kitemviews, kwindowsystem
, kio, kcrash
, boost, libraw, fftw, eigen, exiv2, lcms2, gsl, openexr
, openjpeg, opencolorio, vc, poppler_qt5, curl, ilmbase
}:

stdenv.mkDerivation rec {
  name = "krita-${version}";
  version = "3.0";

  src = fetchgit {
    url = "http://phabricator.kde.org/diffusion/KRITA/krita.git";
    rev = "refs/tags/v${version}";
    sha256 = "0aas86667ncp8jz00c8qk7bm26g76l65cysh06wxr8kxbvqynrdn";
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

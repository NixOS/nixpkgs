{ mkDerivation, lib, stdenv, fetchurl, cmake, extra-cmake-modules
, karchive, kconfig, kwidgetsaddons, kcompletion, kcoreaddons
, kguiaddons, ki18n, kitemmodels, kitemviews, kwindowsystem
, kio, kcrash
, boost, libraw, fftw, eigen, exiv2, libheif, lcms2, gsl, openexr, giflib
, openjpeg, opencolorio, vc, poppler, curl, ilmbase
, qtmultimedia, qtx11extras
, python3Packages
}:

let

major = "4.1";
minor = "8";
patch = null;

in

mkDerivation rec {
  name = "krita-${version}";
  version = "${major}.${minor}";

  src = fetchurl {
    url = "https://download.kde.org/stable/krita/${major}.${minor}/${name}.tar.gz";
    sha256 = "0h2rplc76r82b8smk61zci1ijj9xkjmf20pdqa8fc2lz4zicjxh4";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules python3Packages.sip ];

  buildInputs = [
    karchive kconfig kwidgetsaddons kcompletion kcoreaddons kguiaddons
    ki18n kitemmodels kitemviews kwindowsystem kio kcrash
    boost libraw fftw eigen exiv2 lcms2 gsl openexr libheif giflib
    openjpeg opencolorio poppler curl ilmbase
    qtmultimedia qtx11extras
    python3Packages.pyqt5
  ] ++ lib.optional (stdenv.hostPlatform.isi686 || stdenv.hostPlatform.isx86_64) vc;

  NIX_CFLAGS_COMPILE = [ "-I${ilmbase.dev}/include/OpenEXR" ];

  cmakeFlags = [
    "-DPYQT5_SIP_DIR=${python3Packages.pyqt5}/share/sip/PyQt5"
    "-DPYQT_SIP_DIR_OVERRIDE=${python3Packages.pyqt5}/share/sip/PyQt5"
    "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
  ];

  meta = with lib; {
    description = "A free and open source painting application";
    homepage = https://krita.org/;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}

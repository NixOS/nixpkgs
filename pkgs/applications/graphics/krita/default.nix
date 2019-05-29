{ mkDerivation, lib, stdenv, makeWrapper, fetchurl, cmake, extra-cmake-modules
, karchive, kconfig, kwidgetsaddons, kcompletion, kcoreaddons
, kguiaddons, ki18n, kitemmodels, kitemviews, kwindowsystem
, kio, kcrash
, boost, libraw, fftw, eigen, exiv2, libheif, lcms2, gsl, openexr, giflib
, openjpeg, opencolorio, vc, poppler, curl, ilmbase
, qtmultimedia, qtx11extras, quazip
, python3Packages
}:

let

major = "4.2";
minor = "0";
patch = null;

in

mkDerivation rec {
  name = "krita-${version}";
  version = "${major}.${minor}";

  src = fetchurl {
    url = "https://download.kde.org/stable/krita/${major}.${minor}/${name}.tar.gz";
    sha256 = "1l5bhk4b2f3qdzg9jk2sxz2bq8cqs10nm3wgkrkbqs6vig75rsym";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules python3Packages.sip makeWrapper ];

  buildInputs = [
    karchive kconfig kwidgetsaddons kcompletion kcoreaddons kguiaddons
    ki18n kitemmodels kitemviews kwindowsystem kio kcrash
    boost libraw fftw eigen exiv2 lcms2 gsl openexr libheif giflib
    openjpeg opencolorio poppler curl ilmbase
    qtmultimedia qtx11extras quazip
    python3Packages.pyqt5
  ] ++ lib.optional (stdenv.hostPlatform.isi686 || stdenv.hostPlatform.isx86_64) vc;

  NIX_CFLAGS_COMPILE = [ "-I${ilmbase.dev}/include/OpenEXR" ];

  cmakeFlags = [
    "-DPYQT5_SIP_DIR=${python3Packages.pyqt5}/share/sip/PyQt5"
    "-DPYQT_SIP_DIR_OVERRIDE=${python3Packages.pyqt5}/share/sip/PyQt5"
    "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
  ];

  postInstall = ''
    for i in $out/bin/*; do
      wrapProgram $i --prefix PYTHONPATH : "$PYTHONPATH"
    done
  '';

  meta = with lib; {
    description = "A free and open source painting application";
    homepage = https://krita.org/;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}

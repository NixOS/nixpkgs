{ mkDerivation, lib, stdenv, fetchpatch, makeWrapper, fetchurl, cmake, extra-cmake-modules
, karchive, kconfig, kwidgetsaddons, kcompletion, kcoreaddons
, kguiaddons, ki18n, kitemmodels, kitemviews, kwindowsystem
, kio, kcrash, breeze-icons
, boost, libraw, fftw, eigen, exiv2, fribidi, libaom, libheif, libkdcraw, lcms2, gsl, openexr, giflib
, libjxl, mlt , openjpeg, opencolorio, xsimd, poppler, curl, ilmbase, immer, kseexpr, lager
, libmypaint , libunibreak, libwebp
, qtmultimedia, qtx11extras, quazip, SDL2, zug, pkg-config
, python3Packages
, version
, kde-channel
, hash
}:

mkDerivation rec {
  pname = "krita";
  inherit version;

  src = fetchurl {
    url = "mirror://kde/${kde-channel}/krita/${version}/krita-${version}.tar.gz";
    inherit hash;
  };

  nativeBuildInputs = [ cmake extra-cmake-modules pkg-config python3Packages.sip makeWrapper ];

  buildInputs = [
    karchive kconfig kwidgetsaddons kcompletion kcoreaddons kguiaddons
    ki18n kitemmodels kitemviews kwindowsystem kio kcrash breeze-icons
    boost libraw fftw eigen exiv2 fribidi lcms2 gsl openexr lager libaom libheif libkdcraw giflib
    libjxl mlt openjpeg opencolorio xsimd poppler curl ilmbase immer kseexpr libmypaint
    libunibreak libwebp qtmultimedia qtx11extras quazip SDL2 zug
    python3Packages.pyqt5
  ];

  env.NIX_CFLAGS_COMPILE = toString ([ "-I${ilmbase.dev}/include/OpenEXR" ]
    ++ lib.optional stdenv.cc.isGNU "-Wno-deprecated-copy");

  # Krita runs custom python scripts in CMake with custom PYTHONPATH which krita determined in their CMake script.
  # Patch the PYTHONPATH so python scripts can import sip successfully.
  postPatch = let
    pythonPath = python3Packages.makePythonPath (with python3Packages; [ sip setuptools ]);
  in ''
    substituteInPlace cmake/modules/FindSIP.cmake \
      --replace 'PYTHONPATH=''${_sip_python_path}' 'PYTHONPATH=${pythonPath}'
    substituteInPlace cmake/modules/SIPMacros.cmake \
      --replace 'PYTHONPATH=''${_krita_python_path}' 'PYTHONPATH=${pythonPath}'

    substituteInPlace plugins/impex/jp2/jp2_converter.cc \
      --replace '<openjpeg.h>' '<${openjpeg.incDir}/openjpeg.h>'
  '';

  cmakeBuildType = "RelWithDebInfo";

  cmakeFlags = [
    "-DPYQT5_SIP_DIR=${python3Packages.pyqt5}/${python3Packages.python.sitePackages}/PyQt5/bindings"
    "-DPYQT_SIP_DIR_OVERRIDE=${python3Packages.pyqt5}/${python3Packages.python.sitePackages}/PyQt5/bindings"
    "-DBUILD_KRITA_QT_DESIGNER_PLUGINS=ON"
  ];

  preInstall = ''
    qtWrapperArgs+=(--prefix PYTHONPATH : "$PYTHONPATH")
  '';

  meta = with lib; {
    description = "A free and open source painting application";
    homepage = "https://krita.org/";
    maintainers = with maintainers; [ abbradar sifmelcara nek0 ];
    platforms = platforms.linux;
    license = licenses.gpl3Only;
  };
}

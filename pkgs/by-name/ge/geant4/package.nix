{
  lib,
  stdenv,
  fetchurl,
  callPackage,
  boost,
  clhep,
  cmake,
  coin3d,
  expat,
  libGL,
  libGLU,
  libGLX,
  libXext,
  libXmu,
  libXpm,
  motif,
  python3,
  qt5,
  soxt,
  xercesc,
  zlib,
  enableMultiThreading ? true,
  enableInventor ? false,
  enableQt ? false,
  enableXM ? false,
  enableOpenGLX11 ? !stdenv.hostPlatform.isDarwin,
  enablePython ? false,
  enableRaytracerX11 ? false,
}:

let
  boost_python = boost.override {
    enablePython = true;
    python = python3;
  };
in

stdenv.mkDerivation rec {
  version = "11.2.2";
  pname = "geant4";

  src = fetchurl {
    url = "https://cern.ch/geant4-data/releases/geant4-v${version}.tar.gz";
    hash = "sha256-0k9lc1uKCgOcAPlDSZHpnvEZuGxRDQ8qshFV24KjSR0=";
  };

  # Fix broken paths in a .pc
  postPatch = ''
    substituteInPlace source/externals/ptl/cmake/Modules/PTLPackageConfigHelpers.cmake \
      --replace '${"$"}{prefix}/${"$"}{PTL_INSTALL_' '${"$"}{PTL_INSTALL_'
  '';

  cmakeFlags =
    [
      "-DGEANT4_INSTALL_DATA=OFF"
      "-DGEANT4_USE_GDML=ON"
      "-DGEANT4_USE_G3TOG4=ON"
      "-DGEANT4_USE_QT=${if enableQt then "ON" else "OFF"}"
      "-DGEANT4_USE_XM=${if enableXM then "ON" else "OFF"}"
      "-DGEANT4_USE_OPENGL_X11=${if enableOpenGLX11 then "ON" else "OFF"}"
      "-DGEANT4_USE_INVENTOR=${if enableInventor then "ON" else "OFF"}"
      "-DGEANT4_USE_PYTHON=${if enablePython then "ON" else "OFF"}"
      "-DGEANT4_USE_RAYTRACER_X11=${if enableRaytracerX11 then "ON" else "OFF"}"
      "-DGEANT4_USE_SYSTEM_CLHEP=ON"
      "-DGEANT4_USE_SYSTEM_EXPAT=ON"
      "-DGEANT4_USE_SYSTEM_ZLIB=ON"
      "-DGEANT4_BUILD_MULTITHREADED=${if enableMultiThreading then "ON" else "OFF"}"
    ]
    ++ lib.optionals (enableOpenGLX11 && stdenv.hostPlatform.isDarwin) [
      "-DXQuartzGL_INCLUDE_DIR=${libGLX.dev}/include"
      "-DXQuartzGL_gl_LIBRARY=${libGLX}/lib/libGL.dylib"
    ]
    ++ lib.optionals (enableMultiThreading && enablePython) [
      "-DGEANT4_BUILD_TLS_MODEL=global-dynamic"
    ]
    ++ lib.optionals enableInventor [
      "-DINVENTOR_INCLUDE_DIR=${coin3d}/include"
      "-DINVENTOR_LIBRARY_RELEASE=${coin3d}/lib/libCoin.so"
    ];

  nativeBuildInputs = [ cmake ];

  propagatedNativeBuildInputs = lib.optionals enableQt [ qt5.wrapQtAppsHook ];
  dontWrapQtApps = true; # no binaries

  buildInputs =
    lib.optionals enableOpenGLX11 [
      libGLU
      libXext
      libXmu
    ]
    ++ lib.optionals enableInventor [
      libXpm
      coin3d
      soxt
      motif
    ]
    ++ lib.optionals enablePython [
      boost_python
      python3
    ];

  propagatedBuildInputs =
    [
      clhep
      expat
      xercesc
      zlib
    ]
    ++ lib.optionals enableOpenGLX11 [ libGL ]
    ++ lib.optionals enableXM [ motif ]
    ++ lib.optionals enableQt [ qt5.qtbase ];

  postFixup =
    ''
      # Don't try to export invalid environment variables.
      sed -i 's/export G4\([A-Z]*\)DATA/#export G4\1DATA/' "$out"/bin/geant4.sh
    ''
    + lib.optionalString enableQt ''
      wrapQtAppsHook
    '';

  setupHook = ./geant4-hook.sh;

  passthru = {
    data = callPackage ./datasets.nix { };

    tests = callPackage ./tests.nix { };

    inherit enableQt;
  };

  # Set the myriad of envars required by Geant4 if we use a nix-shell.
  shellHook = ''
    source $out/nix-support/setup-hook
  '';

  meta = with lib; {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    description = "Toolkit for the simulation of the passage of particles through matter";
    longDescription = ''
      Geant4 is a toolkit for the simulation of the passage of particles through matter.
      Its areas of application include high energy, nuclear and accelerator physics, as well as studies in medical and space science.
      The two main reference papers for Geant4 are published in Nuclear Instruments and Methods in Physics Research A 506 (2003) 250-303, and IEEE Transactions on Nuclear Science 53 No. 1 (2006) 270-278.
    '';
    homepage = "http://www.geant4.org";
    license = licenses.g4sl;
    maintainers = with maintainers; [
      omnipotententity
      veprbl
    ];
    platforms = platforms.unix;
  };
}

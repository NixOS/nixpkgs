{
  lib,
  callPackage,
  cmake,
  coin3d,
  doxygen,
  eigen,
  fetchFromGitHub,
  fmt,
  gfortran,
  gts,
  hdf5,
  libf2c,
  libGLU,
  libredwg,
  kdePackages,
  libspnav,
  libXmu,
  medfile,
  mpi,
  ninja,
  ode,
  opencascade-occt,
  pkg-config,
  python311Packages,
  spaceNavSupport ? stdenv.hostPlatform.isLinux,
  stdenv,
  swig,
  vtk,
  wrapGAppsHook3,
  xercesc,
  yaml-cpp,
  zlib,
  withWayland ? true,
}:
let
  # opencascade-occt = opencascade-occt_7_6; # is there a reason we don't use the current one?
  inherit (kdePackages)
    qtbase
    qtsvg
    qttools
    qtwayland
    qtwebengine
    wrapQtAppsHook
    ;
  inherit (python311Packages)
    boost
    gitpython
    matplotlib
    pivy
    ply
    pybind11
    pycollada
    pyside6
    python
    pyyaml
    scipy
    shiboken6
    ;
  freecad-utils = callPackage ../freecad/freecad-utils.nix { };
in
freecad-utils.makeCustomizable (
  stdenv.mkDerivation (finalAttrs: {
    pname = "freecad";
    version = "1.0.0";
    hash = "sha256-u7RYSImUMAgKaAQSAGCFha++RufpZ/QuHAirbSFOUCI=";

    src = fetchFromGitHub {
      owner = "FreeCAD";
      repo = "FreeCAD";
      rev = finalAttrs.version;
      inherit (finalAttrs) hash; # why don't we do this more often to be able to actually override the version easily?
      fetchSubmodules = true;
    };

    nativeBuildInputs = [
      cmake
      ninja
      pkg-config
      gfortran
      wrapQtAppsHook
      wrapGAppsHook3
    ];

    buildInputs = [
      gitpython # for addon manager
      boost
      coin3d
      doxygen
      eigen
      fmt
      gts
      hdf5
      libGLU
      libXmu
      libf2c
      matplotlib
      medfile
      mpi
      ode
      opencascade-occt
      pivy
      ply # for openSCAD file support
      pybind11
      pycollada
      pyside6
      python
      pyyaml # (at least for) PyrateWorkbench
      qtbase
      qtsvg
      qttools
      qtwayland
      qtwebengine
      scipy
      shiboken6
      swig
      vtk
      xercesc
      yaml-cpp
      zlib
    ] ++ lib.optionals spaceNavSupport [ libspnav ];

    patches = [
      ../freecad/0001-NIXOS-don-t-ignore-PYTHONPATH.patch
      ../freecad/0002-FreeCad-OndselSolver-pkgconfig.patch
      ../freecad/0003-Gui-take-in-account-module-path-argument.patch
    ];

    cmakeFlags = [
      "-Wno-dev" # turns off warnings which otherwise makes it hard to see what is going on
      "-DBUILD_FLAT_MESH:BOOL=ON"
      "-DBUILD_QT5=OFF"
      "-DBUILD_QT6=ON"
      "-DBUILD_DRAWING=ON"
      "-DBUILD_FLAT_MESH:BOOL=ON"
      "-DINSTALL_TO_SITEPACKAGES=OFF"
      "-DFREECAD_USE_PYBIND11=ON"
      "-DSHIBOKEN_INCLUDE_DIR=${shiboken6}/include"
      "-DSHIBOKEN_LIBRARY=Shiboken6::libshiboken"
      (
        "-DPYSIDE_INCLUDE_DIR=${pyside6}/include"
        + ";${pyside6}/include/PySide6/QtCore"
        + ";${pyside6}/include/PySide6/QtWidgets"
        + ";${pyside6}/include/PySide6/QtGui"
      )
      "-DPYSIDE_LIBRARY=PySide6::pyside6"
    ];

    # This should work on both x86_64, and i686 linux
    preBuild = ''
      export NIX_LDFLAGS="-L${gfortran.cc}/lib64 -L${gfortran.cc}/lib $NIX_LDFLAGS";
    '';

    preConfigure = ''
      qtWrapperArgs+=(--prefix PYTHONPATH : "$PYTHONPATH")
    '';

    qtWrapperArgs = [
      "--set COIN_GL_NO_CURRENT_CONTEXT_CHECK 1"
      "--prefix PATH : ${libredwg}/bin"
    ] ++ lib.optionals (!withWayland) [ "--set QT_QPA_PLATFORM xcb" ];

    postFixup = ''
      mv $out/share/doc $out
      ln -s $out/bin/FreeCAD $out/bin/freecad
      ln -s $out/bin/FreeCADCmd $out/bin/freecadcmd
    '';

    passthru.tests = callPackage ../freecad/tests { };

    meta = {
      homepage = "https://www.freecad.org";
      description = "General purpose Open Source 3D CAD/MCAD/CAx/CAE/PLM modeler";
      longDescription = ''
        FreeCAD is an open-source parametric 3D modeler made primarily to design
        real-life objects of any size. Parametric modeling allows you to easily
        modify your design by going back into your model history and changing its
        parameters.

        FreeCAD allows you to sketch geometry constrained 2D shapes and use them
        as a base to build other objects. It contains many components to adjust
        dimensions or extract design details from 3D models to create high quality
        production ready drawings.

        FreeCAD is designed to fit a wide range of uses including product design,
        mechanical engineering and architecture. Whether you are a hobbyist, a
        programmer, an experienced CAD user, a student or a teacher, you will feel
        right at home with FreeCAD.
      '';
      license = lib.licenses.lgpl2Plus;
      maintainers = with lib.maintainers; [
        gebner
        srounce
      ];
      platforms = lib.platforms.linux;
    };
  })
)

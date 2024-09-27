{ lib
, cmake
, coin3d
, doxygen
, eigen
, fetchFromGitHub
, fmt
, freecad
, gfortran
, gts
, hdf5
, libGLU
, libXmu
, libf2c
, libredwg
, libsForQt5
, libspnav
, medfile
, mpi
, ninja
, ode
, opencascade-occt_7_6
, pkg-config
, python311Packages
, runCommand  # for passthru.tests
, spaceNavSupport ? stdenv.hostPlatform.isLinux
, stdenv
, swig
, vtk
, wrapGAppsHook3
, xercesc
, zlib
, withWayland ? false
}:
let
  opencascade-occt = opencascade-occt_7_6;
  inherit (libsForQt5)
    qtbase
    qttools
    qtwebengine
    qtx11extras
    qtxmlpatterns
    soqt
    wrapQtAppsHook
    ;
  inherit (libsForQt5.qt5) qtwayland;
  inherit (python311Packages)
    boost
    gitpython
    matplotlib
    pivy
    ply
    pycollada
    pyside2
    pyside2-tools
    python
    pyyaml
    scipy
    shiboken2
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "freecad";
  version = "0.21.2";

  src = fetchFromGitHub {
    owner = "FreeCAD";
    repo = "FreeCAD";
    rev = finalAttrs.version;
    hash = "sha256-OX4s9rbGsAhH7tLJkUJYyq2A2vCdkq/73iqYo9adogs=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    pyside2-tools
    gfortran
    wrapQtAppsHook
    wrapGAppsHook3
  ];

  buildInputs =
    [
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
      pycollada
      pyside2
      pyside2-tools
      python
      pyyaml # (at least for) PyrateWorkbench
      qtbase
      qttools
      qtwayland
      qtwebengine
      qtxmlpatterns
      scipy
      shiboken2
      soqt
      swig
      vtk
      xercesc
      zlib
    ]
    ++ lib.optionals spaceNavSupport [
      libspnav
      qtx11extras
    ];

  patches = [
    ./0001-NIXOS-don-t-ignore-PYTHONPATH.patch
  ];

  cmakeFlags = [
    "-Wno-dev" # turns off warnings which otherwise makes it hard to see what is going on
    "-DBUILD_FLAT_MESH:BOOL=ON"
    "-DBUILD_QT5=ON"
    "-DSHIBOKEN_INCLUDE_DIR=${shiboken2}/include"
    "-DSHIBOKEN_LIBRARY=Shiboken2::libshiboken"
    (
      "-DPYSIDE_INCLUDE_DIR=${pyside2}/include"
      + ";${pyside2}/include/PySide2/QtCore"
      + ";${pyside2}/include/PySide2/QtWidgets"
      + ";${pyside2}/include/PySide2/QtGui"
    )
    "-DPYSIDE_LIBRARY=PySide2::pyside2"
  ];

  # This should work on both x86_64, and i686 linux
  preBuild = ''
    export NIX_LDFLAGS="-L${gfortran.cc}/lib64 -L${gfortran.cc}/lib $NIX_LDFLAGS";
  '';

  preConfigure = ''
    qtWrapperArgs+=(--prefix PYTHONPATH : "$PYTHONPATH")
  '';

  qtWrapperArgs =
    [
      "--set COIN_GL_NO_CURRENT_CONTEXT_CHECK 1"
      "--prefix PATH : ${libredwg}/bin"
    ]
    ++ lib.optionals (!withWayland) [ "--set QT_QPA_PLATFORM xcb" ];

  postFixup = ''
    mv $out/share/doc $out
    ln -s $out/bin/FreeCAD $out/bin/freecad
    ln -s $out/bin/FreeCADCmd $out/bin/freecadcmd
  '';

  passthru.tests = {
    # Check that things such as argument parsing still work correctly with
    # the above PYTHONPATH patch. Previously the patch used above changed
    # the `PyConfig_InitIsolatedConfig` to `PyConfig_InitPythonConfig`,
    # which caused the built-in interpreter to attempt (and fail) to doubly
    # parse argv. This should catch if that ever regresses and also ensures
    # that PYTHONPATH is still respected enough for the FreeCAD console to
    # successfully run and check that it was included in `sys.path`.
    python-path =
      runCommand "freecad-test-console"
        {
          nativeBuildInputs = [ freecad ];
        } ''
        HOME="$(mktemp -d)" PYTHONPATH="$(pwd)/test" FreeCADCmd --log-file $out -c "if not '$(pwd)/test' in sys.path: sys.exit(1)" </dev/null
      '';
  };

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
    maintainers = with lib.maintainers; [ gebner AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})

{ lib
<<<<<<< HEAD
, fmt
, stdenv
, fetchFromGitHub
, cmake
, doxygen
=======
, stdenv
, mkDerivation
, fetchFromGitHub
, cmake
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, ninja
, gitpython
, boost
, coin3d
, eigen
, gfortran
, gts
, hdf5
, libGLU
, libXmu
, libf2c
, libredwg
, libspnav
, matplotlib
, medfile
, mpi
, ode
, opencascade-occt
, pivy
, pkg-config
, ply
, pycollada
, pyside2
, pyside2-tools
, python
, pyyaml
, qtbase
, qttools
, qtwebengine
, qtx11extras
, qtxmlpatterns
, scipy
, shiboken2
, soqt
, spaceNavSupport ? stdenv.isLinux
, swig
, vtk
, wrapQtAppsHook
, wrapGAppsHook
, xercesc
, zlib
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "freecad";
  version = "0.21.1";
=======
mkDerivation rec {
  pname = "freecad";
  version = "0.20.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "FreeCAD";
    repo = "FreeCAD";
<<<<<<< HEAD
    rev = finalAttrs.version;
    hash = "sha256-rwt81Z+Bp8uZlR4iuGQEDKBu/Dr9Rqg7d9SsCdofTUU=";
=======
    rev = version;
    hash = "sha256-v8hanhy0UE0o+XqqIH3ZUtVom3q0KGELcfXFRSDr0TA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    pyside2-tools
    gfortran
    wrapQtAppsHook
    wrapGAppsHook
  ];

  buildInputs = [
    gitpython # for addon manager
    boost
    coin3d
<<<<<<< HEAD
    doxygen
    eigen
    fmt
=======
    eigen
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    qtwebengine
    qtxmlpatterns
    scipy
    shiboken2
    soqt
    swig
    vtk
    xercesc
    zlib
  ] ++ lib.optionals spaceNavSupport [
    libspnav
    qtx11extras
  ];

  cmakeFlags = [
    "-Wno-dev" # turns off warnings which otherwise makes it hard to see what is going on
    "-DBUILD_FLAT_MESH:BOOL=ON"
    "-DBUILD_QT5=ON"
    "-DSHIBOKEN_INCLUDE_DIR=${shiboken2}/include"
    "-DSHIBOKEN_LIBRARY=Shiboken2::libshiboken"
    ("-DPYSIDE_INCLUDE_DIR=${pyside2}/include"
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

  # Their main() removes PYTHONPATH=, and we rely on it.
  preConfigure = ''
    sed '/putenv("PYTHONPATH/d' -i src/Main/MainGui.cpp

    qtWrapperArgs+=(--prefix PYTHONPATH : "$PYTHONPATH")
  '';

  qtWrapperArgs = [
    "--set COIN_GL_NO_CURRENT_CONTEXT_CHECK 1"
    "--prefix PATH : ${libredwg}/bin"
    "--set QT_QPA_PLATFORM xcb"
  ];

  postFixup = ''
    mv $out/share/doc $out
    ln -s $out/bin/FreeCAD $out/bin/freecad
    ln -s $out/bin/FreeCADCmd $out/bin/freecadcmd
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://www.freecad.org";
=======
  meta = with lib; {
    homepage = "https://www.freecadweb.org/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ viric gebner AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
=======
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ viric gebner AndersonTorres ];
    platforms = platforms.linux;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

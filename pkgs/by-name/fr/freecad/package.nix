{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  ninja,
  pkg-config,
  swig,
  doxygen,

  # buildInputs
  fmt,
  gts,
  zlib,
  eigen,
  xercesc,
  yaml-cpp,
  coin3d,
  libGLU,
  libXmu,
  libspnav,
  ode,
  hdf5,
  medfile,
  opencascade-occt,
  microsoft-gsl,
  qt6,
  python3Packages,

  # extra command-line utilities in PATH
  which,
  gmsh,
  libredwg,

  # passthru attr
  callPackage,
  nix-update-script,
}:
let
  pythonDeps =
    ps: with ps; [
      boost
      gitpython # for addon manager
      ifcopenshell
      matplotlib
      opencamlib
      pivy
      ply # for openSCAD file support
      py-slvs
      pycollada
      pyside6
      pyyaml # (at least for) PyrateWorkbench
      scipy
      shiboken6
      vtk
      netgen-mesher
    ];
  pyenv = python3Packages.python.withPackages pythonDeps;
  freecad-utils = python3Packages.callPackage ./freecad-utils.nix { };
in
freecad-utils.makeCustomizable (
  stdenv.mkDerivation (finalAttrs: {
    pname = "freecad";
    version = "1.0.2";

    src = fetchFromGitHub {
      owner = "FreeCAD";
      repo = "FreeCAD";
      tag = finalAttrs.version;
      hash = "sha256-J//O/ABMFa3TFYwR0wc8d1UTA5iSFnEP2thOjuCN+uE=";
      fetchSubmodules = true;
    };

    nativeBuildInputs = [
      cmake
      ninja
      pkg-config
      swig
      doxygen
      qt6.wrapQtAppsHook
    ];

    buildInputs = [
      fmt
      gts
      zlib
      eigen
      xercesc
      yaml-cpp
      coin3d
      libGLU
      libXmu
      libspnav
      ode
      hdf5
      medfile
      opencascade-occt
      microsoft-gsl
      qt6.qtbase
      qt6.qtsvg
      qt6.qttools
      qt6.qtwayland
      qt6.qtwebengine
      python3Packages.python
      python3Packages.pybind11
    ]
    ++ pythonDeps python3Packages;

    patches = [
      # https://github.com/FreeCAD/FreeCAD/pull/21710
      (fetchpatch {
        url = "https://github.com/FreeCAD/FreeCAD/commit/f5db34501c2ab1ffe6dae34e928bed4bc249e1ac.patch?full_index=1";
        hash = "sha256-BAoRFp0YXfYt+L89Fr7Ioy5cy4kREvdGODUW1MhWHM8=";
      })
      # https://github.com/FreeCAD/FreeCAD/pull/17660
      (fetchpatch {
        url = "https://github.com/FreeCAD/FreeCAD/commit/8e04c0a3dd9435df0c2dec813b17d02f7b723b19.patch?full_index=1";
        hash = "sha256-H6WbJFTY5/IqEdoi5N+7D4A6pVAmZR4D+SqDglwS18c=";
      })
      # Inform Coin to use EGL when on Wayland
      # https://github.com/FreeCAD/FreeCAD/pull/21917
      (fetchpatch {
        url = "https://github.com/FreeCAD/FreeCAD/commit/60aa5ff3730d77037ffad0c77ba96b99ef0c7df3.patch?full_index=1";
        hash = "sha256-K6PWQ1U+/fsjDuir7MiAKq71CAIHar3nKkO6TKYl32k=";
      })
    ];

    # uncheck 'Legacy Netgen' as it is known broken on linux platform
    # https://github.com/FreeCAD/FreeCAD/pull/23387
    postPatch = ''
      substituteInPlace src/Mod/Fem/Gui/Resources/ui/DlgSettingsNetgen.ui \
        --replace-fail "true" "false"
    '';

    cmakeFlags = [
      (lib.cmakeBool "BUILD_DRAWING" true)
      (lib.cmakeBool "INSTALL_TO_SITEPACKAGES" false)

      # can be removed once sumodule OndselSolver support absolute cmake path
      (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
      (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
      (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
    ];

    qtWrapperArgs =
      let
        binPath = lib.makeBinPath [
          which
          gmsh
          libredwg
        ];
      in
      [
        "--prefix PATH : ${binPath}"
        "--add-flags"
        "--python-path=${pyenv}/${python3Packages.python.sitePackages}"
      ];

    postFixup = ''
      ln -s $out/bin/FreeCAD $out/bin/freecad
      ln -s $out/bin/FreeCADCmd $out/bin/freecadcmd
    '';

    passthru = {
      tests = lib.packagesFromDirectoryRecursive {
        inherit callPackage;
        directory = ./tests;
      };
      updateScript = nix-update-script {
        extraArgs = [
          "--version-regex"
          "([0-9.]+)"
        ];
      };
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
      maintainers = with lib.maintainers; [
        srounce
        grimmauld
      ];
      platforms = lib.platforms.linux;
    };
  })
)

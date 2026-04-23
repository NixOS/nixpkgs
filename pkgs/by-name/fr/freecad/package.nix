{
  lib,
  callPackage,
  cmake,
  coin3d,
  doxygen,
  eigen,
  fetchFromGitHub,
  fetchpatch,
  fmt,
  gts,
  hdf5,
  libGLU,
  libredwg,
  libspnav,
  libxmu,
  medfile,
  ninja,
  ode,
  opencascade-occt,
  microsoft-gsl,
  pkg-config,
  python3Packages,
  stdenv,
  swig,
  xercesc,
  yaml-cpp,
  zlib,
  qt6,
  nix-update-script,
  gmsh,
  which,
}:
let
  pythonDeps = with python3Packages; [
    boost
    gitpython # for addon manager
    ifcopenshell
    matplotlib
    opencamlib
    pivy
    ply # for openSCAD file support
    pybind11
    pycollada
    pyside6
    python
    pyyaml # (at least for) PyrateWorkbench
    scipy
    shiboken6
    vtk
  ];

  freecad-utils = callPackage ./freecad-utils.nix { inherit (python3Packages) python; };
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
      coin3d
      eigen
      fmt
      gts
      hdf5
      libGLU
      libxmu
      libspnav
      medfile
      ode
      xercesc
      yaml-cpp
      zlib
      opencascade-occt
      microsoft-gsl
      qt6.qtbase
      qt6.qtsvg
      qt6.qttools
      qt6.qtwayland
      qt6.qtwebengine
    ]
    ++ pythonDeps;

    patches = [
      ./0001-NIXOS-don-t-ignore-PYTHONPATH.patch
      ./0002-FreeCad-OndselSolver-pkgconfig.patch

      # https://github.com/FreeCAD/FreeCAD/pull/21710
      ./0003-FreeCad-fix-font-load-crash.patch

      # Fix build for boost 1.89 or later, remove once FreeCad 1.1 is released
      # based on https://github.com/FreeCAD/FreeCAD/commit/0f6d00d2a547df0f5c2ba5ef0f79044a49b0a2d
      ./0004-FreeCad-fix-boost-189-build.patch

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

    postPatch = ''
      substituteInPlace src/Mod/Fem/femmesh/gmshtools.py \
        --replace-fail 'self.gmsh_bin = "gmsh"' 'self.gmsh_bin = "${lib.getExe gmsh}"'
    '';

    cmakeFlags = [
      "-Wno-dev" # turns off warnings which otherwise makes it hard to see what is going on
      (lib.cmakeBool "BUILD_DRAWING" true)
      (lib.cmakeBool "BUILD_FLAT_MESH" true)
      (lib.cmakeBool "INSTALL_TO_SITEPACKAGES" false)
      (lib.cmakeBool "FREECAD_USE_PYBIND11" true)
      (lib.cmakeBool "BUILD_QT5" false)
      (lib.cmakeBool "BUILD_QT6" true)
    ];

    qtWrapperArgs =
      let
        binPath = lib.makeBinPath [
          libredwg
          which # for locating tools
        ];
      in
      [
        "--set COIN_GL_NO_CURRENT_CONTEXT_CHECK 1"
        "--prefix PATH : ${binPath}"
        "--prefix PYTHONPATH : ${python3Packages.makePythonPath pythonDeps}"
      ];

    postFixup = ''
      mv $out/share/doc $out
      ln -s $out/doc $out/share/doc
      ln -s $out/bin/FreeCAD $out/bin/freecad
      ln -s $out/bin/FreeCADCmd $out/bin/freecadcmd
    '';

    passthru = {
      tests = callPackage ./tests { };
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

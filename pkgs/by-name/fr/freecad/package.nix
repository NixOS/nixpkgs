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
  gfortran,
  gts,
  hdf5,
  libGLU,
  libredwg,
  libspnav,
  libXmu,
  medfile,
  ninja,
  ode,
  opencascade-occt,
  pkg-config,
  python3Packages,
  spaceNavSupport ? stdenv.hostPlatform.isLinux,
  stdenv,
  swig,
  vtk,
  wrapGAppsHook3,
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
      gfortran
      swig
      doxygen
      wrapGAppsHook3
      qt6.wrapQtAppsHook
    ];

    buildInputs = [
      coin3d
      eigen
      fmt
      gts
      hdf5
      libGLU
      libXmu
      medfile
      ode
      vtk
      xercesc
      yaml-cpp
      zlib
      opencascade-occt
      qt6.qtbase
      qt6.qtsvg
      qt6.qttools
      qt6.qtwayland
      qt6.qtwebengine
    ]
    ++ pythonDeps
    ++ lib.optionals spaceNavSupport [ libspnav ];

    patches = [
      ./0001-NIXOS-don-t-ignore-PYTHONPATH.patch
      ./0002-FreeCad-OndselSolver-pkgconfig.patch

      # https://github.com/FreeCAD/FreeCAD/pull/21710
      ./0003-FreeCad-fix-font-load-crash.patch
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
      "-DBUILD_DRAWING=ON"
      "-DBUILD_FLAT_MESH:BOOL=ON"
      "-DINSTALL_TO_SITEPACKAGES=OFF"
      "-DFREECAD_USE_PYBIND11=ON"
      "-DBUILD_QT5=OFF"
      "-DBUILD_QT6=ON"
    ];

    # This should work on both x86_64, and i686 linux
    preBuild = ''
      export NIX_LDFLAGS="-L${gfortran.cc.lib}/lib64 -L${gfortran.cc.lib}/lib $NIX_LDFLAGS";
    '';

    dontWrapGApps = true;

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
        "\${gappsWrapperArgs[@]}"
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

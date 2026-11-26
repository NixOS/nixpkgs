{
  lib,
  clangStdenv,
  llvmPackages,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  bison,
  boost,
  cairo,
  catch2_3,
  cgal,
  clipper2,
  double-conversion,
  eigen,
  flex,
  fontconfig,
  freetype,
  ghostscript,
  glib,
  glm,
  gmp,
  harfbuzz,
  hidapi,
  lib3mf,
  libGLU,
  libice,
  libsm,
  qt6Packages,
  libspnav,
  libzip,
  manifold,
  mesa,
  mpfr,
  python3,
  onetbb,
  wayland,
  wayland-protocols,
  wrapGAppsHook3,
  libxdmcp,
  mimalloc,
  opencsg,
  ctestCheckHook,
}:
# clang consume much less RAM than GCC
let
  python3withPackages = (
    python3.withPackages (
      ps: with ps; [
        numpy
        pillow
      ]
    )
  );
in
clangStdenv.mkDerivation rec {
  pname = "openscad-unstable";
  unstable_date = "2026-11-25";
  version = "2026.11-RC1-unstable-${unstable_date}";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "openscad";
    repo = "openscad";
    rev = "6ea4937838eaa39e0657a72fc3324e94c1b175f4";
    hash = "sha256-EmdvFoDPyDcbvYjo6dXb9EkEXxOxzKMYaEtgDGTR2fo=";
    fetchSubmodules = true; # Only really need sanitizers-cmake and MCAD and manifold
  };

  nativeBuildInputs = [
    python3withPackages
    bison
    cmake
    flex
    qt6Packages.wrapQtAppsHook
    llvmPackages.bintools
    wrapGAppsHook3
    ninja
    pkg-config
  ];

  buildInputs = [
    catch2_3
    clipper2
    glm
    onetbb
    mimalloc
    boost
    cairo
    cgal
    double-conversion
    eigen
    fontconfig
    freetype
    glib
    gmp
    opencsg
    harfbuzz
    hidapi
    lib3mf
    libspnav
    libzip
    manifold
    mpfr
    qt6Packages.qt5compat
    qt6Packages.qtbase
    qt6Packages.qscintilla
    qt6Packages.qtmultimedia
  ]
  ++ lib.optionals clangStdenv.hostPlatform.isLinux [
    libxdmcp
    libice
    libsm
    wayland
    wayland-protocols
    qt6Packages.qtwayland
    libGLU
  ];

  cmakeFlags = [
    (lib.cmakeBool "EXPERIMENTAL" true) # enable experimental options
    (lib.cmakeBool "SNAPSHOT" true) # nightly icons
    (lib.cmakeBool "USE_BUILTIN_OPENCSG" false)
    (lib.cmakeBool "USE_BUILTIN_MANIFOLD" false)
    (lib.cmakeBool "USE_BUILTIN_CLIPPER2" false)
    (lib.cmakeBool "USE_QT6" true)
    # Derive version from our unstable date
    (lib.cmakeFeature "OPENSCAD_VERSION" "${
      builtins.replaceStrings [ "-" ] [ "." ] unstable_date
    }-unstable")
    (lib.cmakeBool "CMAKE_UNITY_BUILD" false) # broken compile with unity
    # IPO
    (lib.cmakeBool "CMAKE_INTERPROCEDURAL_OPTIMIZATION" true)

    # For tests
    (lib.cmakeFeature "VENV_DIR" "${python3withPackages}")
    (lib.cmakeFeature "VENV_BIN_PATH" "${python3withPackages}/bin")
  ];

  # tests rely on sysprof which is not available on darwin
  doCheck = !clangStdenv.hostPlatform.isDarwin;

  # remove unused submodules, to ensure correct dependency usage
  postUnpack = ''
    ( cd $sourceRoot
      for m in submodules/OpenCSG submodules/mimalloc submodules/Clipper2
      do rm -r $m
      done )
  '';

  postPatch = ''
    patchShebangs scripts/

    # Take Python3 executable as passed
    sed -e '/set(VENV_DIR /d' -i tests/cmake/ImageCompare.cmake
    sed -e '/find_path(VENV_BIN_PATH /d' -i tests/cmake/ImageCompare.cmake
  '';

  postInstall = lib.optionalString clangStdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications
    mv $out/bin/*.app $out/Applications
    rm $out/bin/* || true
    ln -s $out/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD $out/bin/openscad
  '';

  nativeCheckInputs = [
    mesa.llvmpipeHook
    ctestCheckHook
    ghostscript
  ];

  dontUseNinjaCheck = true;

  # These tests consistently fail when building on aarch64-linux
  disabledTests = [
    "export-svg_spec-paths-arcs01"
    "export-svg-fill-stroke_spec-paths-arcs01"
    "export-svg-fill-only_spec-paths-arcs01"
  ];

  meta = {
    description = "3D parametric model compiler (unstable)";
    longDescription = ''
      OpenSCAD is a software for creating solid 3D CAD objects. It is free
      software and available for Linux/UNIX, MS Windows and macOS.

      Unlike most free software for creating 3D models (such as the famous
      application Blender) it does not focus on the artistic aspects of 3D
      modelling but instead on the CAD aspects. Thus it might be the
      application you are looking for when you are planning to create 3D models of
      machine parts but pretty sure is not what you are looking for when you are more
      interested in creating computer-animated movies.
    '';
    homepage = "https://openscad.org/";
    # note that the *binary license* is gpl3Plus due to CGAL
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      eclairevoyant
      hzeller
      pca006132
      raskin
    ];
    mainProgram = "openscad";
    mainDarwinApp = "OpenSCAD.app";
  };
}

{
  lib,
  stdenv,
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
  libsForQt5,
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
  unstable_date = "2026-02-25";
  version = "2021.01-unstable-${unstable_date}";
  src = fetchFromGitHub {
    owner = "openscad";
    repo = "openscad";
    rev = "ae3a780de777bcb96d41631818551650bc79650d";
    hash = "sha256-jCiCB3tbM0dyIC2gvQarzwjfYI9mnREkMI+0R3EaGPM=";
    fetchSubmodules = true; # Only really need sanitizers-cmake and MCAD and manifold
  };

  nativeBuildInputs = [
    python3withPackages
    bison
    cmake
    flex
    libsForQt5.qt5.wrapQtAppsHook
    llvmPackages.bintools
    wrapGAppsHook3
    ninja
    pkg-config
  ];
  buildInputs =
    with libsForQt5;
    with qt5;
    [
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
      qscintilla
      qtbase
      qtmultimedia
    ]
    ++ lib.optionals clangStdenv.hostPlatform.isLinux [
      libxdmcp
      libice
      libsm
      wayland
      wayland-protocols
      qtwayland
      libGLU
    ]
    ++ lib.optional clangStdenv.hostPlatform.isDarwin qtmacextras;
  cmakeFlags = [
    "-DEXPERIMENTAL=ON" # enable experimental options
    "-DSNAPSHOT=ON" # nightly icons
    "-DUSE_BUILTIN_OPENCSG=OFF"
    "-DUSE_BUILTIN_MANIFOLD=OFF"
    "-DUSE_BUILTIN_CLIPPER2=OFF"
    # Derive version from our unstable date
    "-DOPENSCAD_VERSION='${builtins.replaceStrings [ "-" ] [ "." ] unstable_date}-unstable'"
    "-DCMAKE_UNITY_BUILD=OFF" # broken compile with unity
    # IPO
    "-DCMAKE_EXE_LINKER_FLAGS=-fuse-ld=lld"
    "-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON"

    # The sources enable this for only apple. We turn it off globally anyway to stay
    # consistent.
    "-DUSE_QT6=OFF"

    # For tests
    "-DVENV_DIR=${python3withPackages}"
    "-DVENV_BIN_PATH=${python3withPackages}/bin"
  ];

  # tests rely on sysprof which is not available on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

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

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications
    mv $out/bin/*.app $out/Applications
    rm $out/bin/* || true
    ln -s $out/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD $out/bin/openscad-unstable
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
    # note that the *binary license* is gpl3 due to CGAL
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      hzeller
      pca006132
      raskin
    ];
    mainProgram = "openscad";
  };
}

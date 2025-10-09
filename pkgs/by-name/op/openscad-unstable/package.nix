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
  libICE,
  libSM,
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
  xorg,
  mimalloc,
  opencsg,
  ctestCheckHook,
}:
# clang consume much less RAM than GCC
clangStdenv.mkDerivation rec {
  pname = "openscad-unstable";
  version = "2025-06-04";
  src = fetchFromGitHub {
    owner = "openscad";
    repo = "openscad";
    rev = "65856c9330f8cc4ffcaccf03d91b4217f2eae28d";
    hash = "sha256-jozcLFGVSfw8G12oSxHjqUyFtAfENgIByID+omk08mU=";
    fetchSubmodules = true; # Only really need sanitizers-cmake and MCAD and manifold
  };

  patches = [ ./test.diff ];

  nativeBuildInputs = [
    (python3.withPackages (
      ps: with ps; [
        numpy
        pillow
      ]
    ))
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
      xorg.libXdmcp
      libICE
      libSM
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
    "-DOPENSCAD_VERSION=\"${builtins.replaceStrings [ "-" ] [ "." ] version}\""
    "-DCMAKE_UNITY_BUILD=OFF" # broken compile with unity
    # IPO
    "-DCMAKE_EXE_LINKER_FLAGS=-fuse-ld=lld"
    "-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON"

    # The sources enable this for only apple. We turn it off globally anyway to stay
    # consistent.
    "-DUSE_QT6=OFF"
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

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications
    mv $out/bin/*.app $out/Applications
    rmdir $out/bin
  '';

  nativeCheckInputs = [
    mesa.llvmpipeHook
    ctestCheckHook
    ghostscript
  ];

  dontUseNinjaCheck = true;

  meta = with lib; {
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
      pca006132
      raskin
    ];
    mainProgram = "openscad";
  };
}

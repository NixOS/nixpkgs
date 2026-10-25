{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  which,
  python3,
  rsync,
  qt6,
  libGLU,
  libGL,
  zlib,
  icu,
  freetype,
  pugixml,
  libxrandr,
  libxinerama,
  libxcursor,
  gflags,
  expat,
  jansson,
  boost,
  fast-float,
  utf8cpp,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "organicmaps";
  version = "2026.09.29-32";

  src = fetchFromGitHub {
    owner = "organicmaps";
    repo = "organicmaps";
    tag = "${finalAttrs.version}-android";
    hash = "sha256-9L5hsJVNENM5ORkykX2uoCzXATncDHQng5zFjiJipok=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    which
    python3
    rsync
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtpositioning
    qt6.qtsvg
    qt6.qtwayland
    libGLU
    libGL
    zlib
    icu
    freetype
    pugixml
    libxrandr
    libxinerama
    libxcursor
    gflags
    expat
    jansson
    boost
    fast-float
    utf8cpp
  ];

  cmakeFlags = [
    (lib.cmakeBool "WITH_SYSTEM_PROVIDED_3PARTY" true)
    (lib.cmakeBool "SKIP_TESTS" true)
    (lib.cmakeBool "SKIP_TOOLS" true)
  ];

  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev utf8cpp}/include/utf8cpp";

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "-vr"
        "(.*)-android"
      ];
    };
  };

  meta = {
    # darwin: "invalid application of 'sizeof' to a function type"
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://organicmaps.app/";
    description = "Detailed Offline Maps for Travellers, Tourists, Hikers and Cyclists";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
    mainProgram = "OMaps";
  };
})

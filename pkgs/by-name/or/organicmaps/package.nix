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
  utfcpp,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "organicmaps";
  version = "2026.03.11-12";

  src = fetchFromGitHub {
    owner = "organicmaps";
    repo = "organicmaps";
    tag = "${finalAttrs.version}-android";
    hash = "sha256-9UB/Qr+nNjNz8iDsxM7fTa6a2PDb7N90vE6cwkJ+K00=";
    fetchSubmodules = true;
  };

  patches = [
    # Adds a missing find_package
    # https://github.com/organicmaps/organicmaps/pull/11902
    ./boost.patch
    # Needs the very old protobuf 3.3, so we use the vendored one
    # https://github.com/organicmaps/organicmaps/pull/6310
    ./force-vendored-protobuf.patch
  ];

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
    utfcpp
  ];

  cmakeFlags = [
    (lib.cmakeBool "WITH_SYSTEM_PROVIDED_3PARTY" true)
    (lib.cmakeBool "SKIP_TESTS" true)
    (lib.cmakeBool "SKIP_TOOLS" true)
  ];

  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev utfcpp}/include/utf8cpp";

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

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
  version = "2026.07.23-6";

  src = fetchFromGitHub {
    owner = "organicmaps";
    repo = "organicmaps";
    tag = "${finalAttrs.version}-android";
    hash = "sha256-eAuR7xtB3d2ZMiD6lxwVjx6rHl8YiXcrMY9Yze5Maiw=";
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

  # The build system tries to install the vendored libblake3,
  # but it fails because it can't find the .pc file.
  # We create a dummy one and clean up everything afterwards.
  preInstall = ''
    touch libblake3.pc
  '';
  postInstall = ''
    # Only contains static libblake3 stuff
    rm -r $out/lib
  '';

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

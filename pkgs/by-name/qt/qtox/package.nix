{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  perl,
  kdePackages,
  libtoxcore,
  libpthread-stubs,
  libxdmcp,
  libxscrnsaver,
  ffmpeg,
  filter-audio,
  libexif,
  libsodium,
  libopus,
  libvpx,
  openal,
  pcre,
  qrencode,
  qt6,
  sqlcipher,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qtox";
  version = "1.18.4";

  src = fetchFromGitHub {
    owner = "TokTok";
    repo = "qTox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0g6gR4fweOqZLiL/3N7tfZQ3aRS1fWkE8kLpDipr+t0=";
  };

  buildInputs = [
    kdePackages.sonnet
    libtoxcore
    libpthread-stubs
    libxdmcp
    libxscrnsaver
    ffmpeg
    filter-audio
    libexif
    libopus
    libsodium
    libvpx
    openal
    pcre
    qrencode
    qt6.qtbase
    qt6.qtsvg
    sqlcipher
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ perl ];

  cmakeFlags = [
    "-DGIT_DESCRIBE=v${finalAttrs.version}"
    "-DTIMESTAMP=1"
  ];

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Qt Tox client";
    mainProgram = "qtox";
    homepage = "https://tox.chat";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      akaWolf
      peterhoeg
    ];
    platforms = lib.platforms.all;
  };
})

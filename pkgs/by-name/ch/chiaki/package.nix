{
  lib,
  stdenv,
  fetchgit,
  cmake,
  pkg-config,
  ffmpeg,
  libopus,
  SDL2,
  libevdev,
  udev,
  nanopb,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chiaki";
  version = "2.2.0-unstable-2026-01-04";

  src = fetchgit {
    url = "https://git.sr.ht/~thestr4ng3r/chiaki";
    rev = "ab55cf4c95f7723faae08a546fbe14e0f6bddf45";
    fetchSubmodules = true;
    hash = "sha256-GYhbq3QCyykMu5K1ITJ+XqNU593Gn3eBTM9coKmh/Vk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    ffmpeg
    libopus
    libsForQt5.qtbase
    libsForQt5.qtmultimedia
    libsForQt5.qtsvg
    SDL2
    nanopb
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libevdev
    udev
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libsForQt5.qtmacextras
  ];

  doCheck = true;

  installCheckPhase = "$out/bin/chiaki --help";

  meta = {
    homepage = "https://git.sr.ht/~thestr4ng3r/chiaki";
    description = "Free and Open Source PlayStation Remote Play Client";
    license = lib.licenses.agpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "chiaki";
  };
})

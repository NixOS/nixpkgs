{
  lib,
  stdenv,
  fetchgit,
  cmake,
  pkg-config,
  ffmpeg_7,
  libopus,
  SDL2,
  libevdev,
  udev,
  nanopb,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chiaki";
  version = "2.2.0";

  src = fetchgit {
    url = "https://git.sr.ht/~thestr4ng3r/chiaki";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-mLx2ygMlIuDJt9iT4nIj/dcLGjMvvmneKd49L7C3BQk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
    'cmake_minimum_required(VERSION 3.2)' \
    'cmake_minimum_required(VERSION 3.5)'
  '';

  buildInputs = [
    ffmpeg_7 # needs avcodec_close which was removed in ffmpeg 8
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

{
  lib,
  stdenv,
  fetchgit,
  cmake,
  pkg-config,
  ffmpeg,
  libopus,
  libsForQt5,
  SDL2,
  libevdev,
  udev,
  nanopb,
}:

stdenv.mkDerivation rec {
  pname = "chiaki";
  version = "2.2.0";

  src = fetchgit {
    url = "https://git.sr.ht/~thestr4ng3r/chiaki";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-mLx2ygMlIuDJt9iT4nIj/dcLGjMvvmneKd49L7C3BQk=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "VERSION 3.2" "VERSION 3.10"
  '';

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

  meta = with lib; {
    homepage = "https://git.sr.ht/~thestr4ng3r/chiaki";
    description = "Free and Open Source PlayStation Remote Play Client";
    license = licenses.agpl3Only;
    maintainers = [ ];
    platforms = platforms.all;
    mainProgram = "chiaki";
  };
}

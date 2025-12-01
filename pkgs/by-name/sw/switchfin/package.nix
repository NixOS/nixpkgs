{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  curl,
  dbus,
  ffmpeg,
  fmt_11,
  libwebp,
  mpv,
  SDL2,
  tinyxml-2,
  tweeny,
}:

stdenv.mkDerivation rec {
  pname = "switchfin";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "dragonflylee";
    repo = "switchfin";
    rev = version;
    hash = "sha256-swNwaZg6W5Ox08poc3gC3MOsIHv08/Q9BOMwD9FNf3g=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    curl
    dbus
    ffmpeg
    fmt_11
    libwebp
    mpv
    SDL2
    tinyxml-2
    tweeny
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL=ON"

    "-DPLATFORM_DESKTOP=ON"
    "-DUSE_EGL=ON"
    "-DUSE_SDL2=ON"

    "-DUSE_SYSTEM_CURL=ON"
    "-DUSE_SYSTEM_FMT=ON"
    "-DUSE_SYSTEM_SDL2=ON"
    "-DUSE_SYSTEM_TINYXML2=ON"
    "-DUSE_SYSTEM_TWEENY=ON"
  ];

  meta = {
    description = "Third-party native Jellyfin client for PC/PS4/PSVita/Nintendo Switch";
    homepage = "https://github.com/dragonflylee/switchfin";
    changelog = "https://github.com/dragonflylee/switchfin/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.k900 ];
    mainProgram = "Switchfin";
    platforms = lib.platforms.all;
  };
}

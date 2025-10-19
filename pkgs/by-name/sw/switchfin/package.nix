{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  curl,
  dbus,
  ffmpeg,
  fmt,
  libwebp,
  mpv,
  SDL2,
  tinyxml-2,
  tweeny,
}:

stdenv.mkDerivation rec {
  pname = "switchfin";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "dragonflylee";
    repo = "switchfin";
    rev = version;
    hash = "sha256-vmf7urq3lnfvmdZUJ+G5zn4ZpNA2N4jlLo8D5ZG3tUQ=";
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
    fmt
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
    mainProgram = "switchfin";
    platforms = lib.platforms.all;
  };
}

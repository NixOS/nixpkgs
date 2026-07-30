{
  lib,
  autoreconfHook,
  bison,
  curl,
  fetchFromGitHub,
  ffmpeg-headless,
  flex,
  gperf,
  json_c,
  libconfuse,
  libevent,
  libgcrypt,
  libgpg-error,
  libplist,
  libsodium,
  libunistring,
  libuuid,
  libxml2,
  pkg-config,
  stdenv,
  zlib,
}:

stdenv.mkDerivation {
  pname = "cliairplay";
  # see the beginning of configure.ac for the upstream version number
  version = "1.5-unstable-2026-05-03";

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "cliairplay";
    # we try to closely match the commit used in the last music-assistant release from
    # https://github.com/music-assistant/server/tree/stable/music_assistant/providers/airplay/bin
    rev = "6aeceb49e4e37d044f09be9369b082fc26bcfa19";
    fetchSubmodules = true;
    hash = "sha256-Z2LzRhtQpuXPK6KibnxCqP0V6CulzkwNVHX1V7AFnDA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    gperf
    pkg-config
  ];

  buildInputs = [
    curl
    ffmpeg-headless
    json_c
    libconfuse
    libevent
    libgcrypt
    libgpg-error
    libplist
    libsodium
    libunistring
    libuuid
    libxml2
    zlib
  ];

  meta = {
    description = "Command line interface for audio streaming to AirPlay 2 devices";
    homepage = "https://github.com/music-assistant/cliairplay";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "cliap2";
    platforms = lib.platforms.unix;
  };
}

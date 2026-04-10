{
  lib,
  autoreconfHook,
  bison,
  curl,
  fetchFromGitHub,
  fetchpatch,
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
  version = "0.2-unstable-2025-12-30";

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "cliairplay";
    # we try to closely match the commit used in the last music-assistant release from
    # https://github.com/music-assistant/server/tree/stable/music_assistant/providers/airplay/bin
    rev = "4660d886585d6bf8f32e889feec2a0e8975c51dc";
    fetchSubmodules = true;
    hash = "sha256-oDStn9LdLYWKhZNm7Qfdibs4qsct8gE3RZbTKooQeOM=";
  };

  patches = [
    # Support gettext 0.25
    (fetchpatch {
      url = "https://github.com/music-assistant/cliairplay/commit/92a2445d64c476d740feba1f31c7e5bc768701b7.patch";
      hash = "sha256-/YnopvAGHHnQhfr2X1OenLMoF4ZlUq9x8tQZha/XfbQ=";
    })
  ];

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

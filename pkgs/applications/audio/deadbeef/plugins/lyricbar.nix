{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  deadbeef,
  gtkmm3,
  libxmlxx3,
}:

stdenv.mkDerivation {
  pname = "deadbeef-lyricbar-plugin";
  version = "0.1-unstable-2019-01-29";

  src = fetchFromGitHub {
    owner = "C0rn3j";
    repo = "deadbeef-lyricbar";
    rev = "8f99b92ef827c451c43fc7dff38ae4f15c355e8e";
    hash = "sha256-lM+yv6AGGi9Wr3s0lYZkcMqDbTpziZouqp04MErpEIE=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    deadbeef
    gtkmm3
    libxmlxx3
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-incompatible-pointer-types";

  buildFlags = [ "gtk3" ];

  meta = {
    description = "Plugin for DeaDBeeF audio player that fetches and shows the song’s lyrics";
    homepage = "https://github.com/C0rn3j/deadbeef-lyricbar";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jtojnar ];
    platforms = lib.platforms.linux;
  };
}

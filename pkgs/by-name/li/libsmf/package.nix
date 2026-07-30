{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  glib,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.3";
  pname = "libsmf";

  src = fetchFromGitHub {
    owner = "stump";
    repo = "libsmf";
    rev = "libsmf-${finalAttrs.version}";
    sha256 = "sha256-OJXJkXvbM2GQNInZXU2ldObquKHhqkdu1zqUDnVZN0Y=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [ glib ];

  meta = {
    description = "C library for reading and writing Standard MIDI Files";
    homepage = "https://github.com/stump/libsmf";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    mainProgram = "smfsh";
    platforms = lib.platforms.unix;
  };
})

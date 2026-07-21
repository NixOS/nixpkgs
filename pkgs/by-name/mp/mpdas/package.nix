{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libmpdclient,
  curl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mpdas";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "hrkfdn";
    repo = "mpdas";
    rev = finalAttrs.version;
    sha256 = "0fcqc4w6iwbi1n3cllcgj0k61zffhqkbr8668myxap21m35x8y1r";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libmpdclient
    curl
  ];

  makeFlags = [
    "CONFIG=/etc"
    "DESTDIR="
    "PREFIX=$(out)"
  ];

  meta = {
    description = "Music Player Daemon AudioScrobbler";
    homepage = "https://50hz.ws/mpdas/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.taketwo ];
    platforms = lib.platforms.all;
    mainProgram = "mpdas";
  };
})

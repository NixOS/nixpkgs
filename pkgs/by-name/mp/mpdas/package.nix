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
    hash = "sha256-OXjUy6hBXNV9RcagvCaGzv1gJpCPUcqGDXHxaDhhmDk=";
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

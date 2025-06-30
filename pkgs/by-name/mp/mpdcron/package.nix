{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  pkg-config,
  glib,
  libdaemon,
  libmpdclient,
  curl,
  sqlite,
  bundlerEnv,
  libnotify,
  pandoc,
  autoreconfHook,
  bundlerUpdateScript,
}:

let
  gemEnv = bundlerEnv {
    name = "mpdcron-bundle";
    gemdir = ./.;
  };
in
stdenv.mkDerivation {
  pname = "mpdcron";
  version = "20161228";

  src = fetchFromGitHub {
    owner = "alip";
    repo = "mpdcron";
    rev = "e49e6049b8693d31887c538ddc7b19f5e8ca476b";
    sha256 = "0vdksf6lcgmizqr5mqp0bbci259k0dj7gpmhx32md41jlmw5skaw";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libtool
    glib
    libdaemon
    pandoc
    libmpdclient
    curl
    sqlite
    gemEnv.wrappedRuby
    libnotify
  ];

  configureFlags = [
    "--enable-gmodule"
    "--with-standard-modules=all"
  ];

  passthru.updateScript = bundlerUpdateScript "mpdcron";

  meta = {
    description = "Cron like daemon for mpd";
    homepage = "http://alip.github.io/mpdcron/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      lovek323
      manveru
    ];
  };
}

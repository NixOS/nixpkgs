{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  wrapGAppsHook3,
  gtk3,
  intltool,
  libgcrypt,
  pilot-link,
  pkg-config,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "jpilot";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "juddmon";
    repo = "jpilot";
    rev = "v${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-ja/P6kq53C7drEPWemGMV5fB4BktHrbrxL39jLEGhRI=";
  };

  patches = [ ./darwin-build.patch ]; # https://github.com/juddmon/jpilot/pull/59

  nativeBuildInputs = [
    autoreconfHook
    intltool
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libgcrypt
    sqlite
  ];

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  configureFlags = [ "--with-pilot-prefix=${pilot-link}" ];

  meta = {
    description = "Desktop organizer software for the Palm Pilot";
    homepage = "https://www.jpilot.org/";
    license = lib.licenses.gpl2;
    mainProgram = "jpilot";
    maintainers = with lib.maintainers; [ PapayaJackal ];
  };
}

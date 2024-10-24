{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gtk3,
  intltool,
  libgcrypt,
  pilot-link,
  pkg-config,
  sqlite,
}:

stdenv.mkDerivation {
  pname = "jpilot";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "juddmon";
    repo = "jpilot";
    rev = "v2_0_2";
    hash = "sha256-ja/P6kq53C7drEPWemGMV5fB4BktHrbrxL39jLEGhRI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    intltool
    pkg-config
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
    maintainers = with lib.maintainers; [ PapayaJackal ];
  };
}

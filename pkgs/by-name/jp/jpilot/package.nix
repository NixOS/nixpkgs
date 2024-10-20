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
  slang,
}:

stdenv.mkDerivation {
  pname = "jpilot";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "juddmon";
    repo = "jpilot";
    rev = "v2_0_1";
    hash = "sha256-CHCNDoYPi+2zMKkI6JIecmiWMvMF6WsgBZ6Ubfl0RJU=";
  };

  patches = [ ./fix-broken-types.patch ];

  nativeBuildInputs = [
    autoreconfHook
    intltool
    pkg-config
  ];
  buildInputs = [
    gtk3
    libgcrypt
    pilot-link
    slang
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

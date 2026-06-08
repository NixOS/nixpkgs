{
  autoreconfHook,
  fetchFromGitHub,
  glib,
  intltool,
  lib,
  libappindicator-gtk2,
  libtool,
  pidgin,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "pidgin-indicator";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "philipl";
    repo = "pidgin-indicator";
    rev = version;
    sha256 = "sha256-CdA/aUu+CmCRbVBKpJGydicqFQa/rEsLWS3MBKlH2/M=";
  };

  nativeBuildInputs = [
    autoreconfHook
    intltool
  ];
  buildInputs = [
    glib
    libappindicator-gtk2
    libtool
    pidgin
  ];

  meta = {
    description = "AppIndicator and KStatusNotifierItem Plugin for Pidgin";
    homepage = "https://github.com/philipl/pidgin-indicator";
    maintainers = with lib.maintainers; [ imalison ];
    license = lib.licenses.gpl2;
    platforms = with lib.platforms; linux;
  };
}

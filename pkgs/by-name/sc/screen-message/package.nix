{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gtk3,
}:

stdenv.mkDerivation rec {
  pname = "screen-message";
  version = "0.29";

  src = fetchFromGitHub {
    owner = "nomeata";
    repo = "screen-message";
    rev = version;
    hash = "sha256-fwKle+aXZuiNo5ksrigj7BGLv2fUILN2GluHHZ6co6s=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [ gtk3 ];

  # screen-message installs its binary in $(prefix)/games per default
  makeFlags = [ "execgamesdir=$(out)/bin" ];

  meta = {
    homepage = "https://www.joachim-breitner.de/en/projects#screen-message";
    description = "Displays a short text fullscreen in an X11 window";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.fpletz ];
    mainProgram = "sm";
    platforms = lib.platforms.unix;
  };
}

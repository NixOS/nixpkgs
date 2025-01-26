{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  wrapGAppsHook3,
  gtk2,
  hamlib_4,
}:

stdenv.mkDerivation rec {
  pname = "grig";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "fillods";
    repo = "grig";
    rev = "GRIG-${lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "sha256-OgIgHW9NMW/xSSti3naIR8AQWUtNSv5bYdOcObStBlM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    wrapGAppsHook3
  ];
  buildInputs = [
    hamlib_4
    gtk2
  ];

  meta = with lib; {
    description = "Simple Ham Radio control (CAT) program based on Hamlib";
    mainProgram = "grig";
    longDescription = ''
      Grig is a graphical user interface for the Ham Radio Control Libraries.
      It is intended to be simple and generic, presenting the user with the
      same interface regardless of which radio they use.
    '';
    homepage = "https://groundstation.sourceforge.net/grig/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ melling ];
  };
}

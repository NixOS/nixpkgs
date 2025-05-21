{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  pkg-config,
  glib,
  libsigrok,
  libsigrokdecode,
}:

stdenv.mkDerivation {
  pname = "sigrok-cli";
  version = "0.7.2-unstable-2023-04-10";

  src = fetchgit {
    url = "git://sigrok.org/sigrok-cli";
    rev = "9d9f7b82008e3b3665bda12a63a3339e9f7aabc3";
    hash = "sha256-B2FJxRkfKELrtqxZDv5QTvntpu9zJnTK15CAUYbf+5M=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    glib
    libsigrok
    libsigrokdecode
  ];

  meta = with lib; {
    description = "Command-line frontend for the sigrok signal analysis software suite";
    mainProgram = "sigrok-cli";
    homepage = "https://sigrok.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [
      bjornfor
      vifino
    ];
  };
}

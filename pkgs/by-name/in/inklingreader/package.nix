{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
  librsvg,
  libusb1,
}:

stdenv.mkDerivation {
  pname = "inklingreader";
  version = "0.8-unstable-2026-05-06";

  src = fetchFromGitHub {
    owner = "roelj";
    repo = "inklingreader";
    rev = "44026d82e494b8068ebd8be377516053487cc2c6";
    hash = "sha256-NfjLzgFxo3h3gpPeQ+un5f8n1kIxUBQLLRV2CptuxzA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    wrapGAppsHook3
  ];
  buildInputs = [
    gtk3
    librsvg
    libusb1
  ];

  meta = {
    homepage = "https://github.com/roelj/inklingreader";
    description = "GNU/Linux-friendly version of the Wacom Inkling SketchManager";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ totoroot ];
    platforms = lib.platforms.linux;
    mainProgram = "inklingreader";
  };
}

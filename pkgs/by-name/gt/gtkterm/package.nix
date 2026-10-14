{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gtk3,
  vte,
  libgudev,
  wrapGAppsHook3,
  pcre2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtkterm";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "wvdakker";
    repo = "gtkterm";
    tag = finalAttrs.version;
    hash = "sha256-a1GRSSyUnBkAW0HAlmoFO2R193KWSlDm3cjIIhKuNWU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    vte
    libgudev
    pcre2
  ];

  meta = {
    description = "Simple, graphical serial port terminal emulator";
    homepage = "https://github.com/wvdakker/gtkterm";
    license = lib.licenses.gpl3Plus;
    longDescription = ''
      GTKTerm is a simple, graphical serial port terminal emulator for
      Linux and possibly other POSIX-compliant operating systems. It
      can be used to communicate with all kinds of devices with a
      serial interface, such as embedded computers, microcontrollers,
      modems, GPS receivers, CNC machines and more.
    '';
    maintainers = with lib.maintainers; [ wentasah ];
    platforms = lib.platforms.linux;
    mainProgram = "gtkterm";
  };
})

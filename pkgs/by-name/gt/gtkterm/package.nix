{ stdenv, lib, fetchFromGitHub, meson, ninja, pkg-config, gtk3, vte, libgudev, wrapGAppsHook3, pcre2 }:

stdenv.mkDerivation rec {
  pname = "gtkterm";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "wvdakker";
    repo = "gtkterm";
    rev = version;
    sha256 = "sha256-oGqOXIu5P3KfdV6Unm7Nz+BRhb5Z6rne0+e0wZ2EcAI=";
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

  meta = with lib; {
    description = "Simple, graphical serial port terminal emulator";
    homepage = "https://github.com/wvdakker/gtkterm";
    license = licenses.gpl3Plus;
    longDescription = ''
      GTKTerm is a simple, graphical serial port terminal emulator for
      Linux and possibly other POSIX-compliant operating systems. It
      can be used to communicate with all kinds of devices with a
      serial interface, such as embedded computers, microcontrollers,
      modems, GPS receivers, CNC machines and more.
    '';
    maintainers = with maintainers; [ wentasah ];
    platforms = platforms.linux;
    mainProgram = "gtkterm";
  };
}

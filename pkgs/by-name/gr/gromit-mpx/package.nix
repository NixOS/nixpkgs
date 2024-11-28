{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gtk3,
  glib,
  pcre,
  libappindicator-gtk3,
  libpthreadstubs,
  xorg,
  libxkbcommon,
  libepoxy,
  at-spi2-core,
  dbus,
  libdbusmenu,
  lz4,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gromit-mpx";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "bk138";
    repo = "gromit-mpx";
    rev = finalAttrs.version;
    hash = "sha256-jHw4V2ZvfpT3PUihe/O+9BPsv+udFg5seMbYmxOz8Yk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    glib
    pcre
    libappindicator-gtk3
    libpthreadstubs
    xorg.libXdmcp
    libxkbcommon
    libepoxy
    at-spi2-core
    dbus
    libdbusmenu
    lz4
  ];

  meta = with lib; {
    description = "Desktop annotation tool";
    longDescription = ''
      Gromit-MPX (GRaphics Over MIscellaneous Things) is a small tool
      to make annotations on the screen.
    '';
    homepage = "https://github.com/bk138/gromit-mpx";
    changelog = "https://github.com/bk138/gromit-mpx/blob/${finalAttrs.version}/NEWS.md";
    maintainers = with maintainers; [
      pjones
      gepbird
    ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    mainProgram = "gromit-mpx";
  };
})

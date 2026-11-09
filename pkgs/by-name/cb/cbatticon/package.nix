{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gettext,
  glib,
  gtk3,
  libnotify,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cbatticon";
  version = "1.6.13";

  src = fetchFromGitHub {
    owner = "valr";
    repo = "cbatticon";
    rev = finalAttrs.version;
    sha256 = "sha256-VQjJujF9lnVvQxV+0YqodLgnI9F90JKDAGBu5nM/Q/c=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    libnotify
  ];

  patchPhase = ''
    sed -i -e 's/ -Wno-format//g' Makefile
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Lightweight and fast battery icon that sits in the system tray";
    mainProgram = "cbatticon";
    homepage = "https://github.com/valr/cbatticon";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})

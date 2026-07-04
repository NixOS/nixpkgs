{
  lib,
  stdenv,
  fetchurl,
  glib,
  gtk4,
  libffcall,
  pkg-config,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtk-server";
  version = "2.4.7";

  src = fetchurl {
    url = "https://www.gtk-server.org/stable/gtk-server-${finalAttrs.version}.tar.gz";
    hash = "sha256-YRvnE4fH5jWITSiMUbtlaOJFKAW0/Alzo1YVDlm8CO8=";
  };

  preConfigure = ''
    cd src
  '';

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];
  buildInputs = [
    libffcall
    glib
    gtk4
  ];

  meta = {
    homepage = "https://www.gtk-server.org/";
    description = "Gtk-server for interpreted GUI programming";
    changelog = "https://www.gtk-server.org/notes.txt";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "gtk-server";
  };
})

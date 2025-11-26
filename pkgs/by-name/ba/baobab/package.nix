{
  stdenv,
  lib,
  gettext,
  fetchurl,
  vala,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  gtk4,
  libadwaita,
  glib,
  libxml2,
  wrapGAppsHook4,
  itstool,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "baobab";
  version = "49.1";

  src = fetchurl {
    url = "mirror://gnome/sources/baobab/${lib.versions.major version}/baobab-${version}.tar.xz";
    hash = "sha256-YkPJIAK+fpH13s0klhL6zipKEtN0Kv2IsIapS4dd/+A=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    glib
    itstool
    libxml2
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    glib
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "baobab";
    };
  };

  meta = with lib; {
    description = "Graphical application to analyse disk usage in any GNOME environment";
    mainProgram = "baobab";
    homepage = "https://apps.gnome.org/Baobab/";
    license = licenses.gpl2Plus;
    teams = [ teams.gnome ];
    platforms = platforms.unix;
  };
}

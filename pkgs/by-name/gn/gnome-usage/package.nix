{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  vala,
  gettext,
  libxml2,
  desktop-file-utils,
  wrapGAppsHook4,
  glib,
  gtk4,
  json-glib,
  libadwaita,
  libgee,
  libgtop,
  networkmanager,
  gnome,
  tinysparql,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-usage";
  version = "48.rc";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-usage/${lib.versions.major finalAttrs.version}/gnome-usage-${finalAttrs.version}.tar.xz";
    hash = "sha256-LUbc2QcKkY/sMUdxaaQDI2CdCFa5XHo3wBusqULTk+w=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    libxml2
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    json-glib
    libadwaita
    libgee
    libgtop
    networkmanager
    tinysparql
  ];

  postPatch = ''
    chmod +x build-aux/meson/postinstall.sh
    patchShebangs build-aux/meson/postinstall.sh
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-usage";
    };
  };

  meta = with lib; {
    description = "Nice way to view information about use of system resources, like memory and disk space";
    mainProgram = "gnome-usage";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-usage";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.gnome ];
  };
})

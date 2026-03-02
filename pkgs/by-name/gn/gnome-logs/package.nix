{
  stdenv,
  lib,
  fetchurl,
  appstream,
  meson,
  ninja,
  pkg-config,
  gnome,
  glib,
  gtk4,
  desktop-file-utils,
  wrapGAppsHook4,
  gettext,
  itstool,
  libadwaita,
  libxml2,
  libxslt,
  docbook-xsl-nons,
  docbook_xml_dtd_43,
  systemd,
  gsettings-desktop-schemas,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-logs";
  version = "49.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-logs/${lib.versions.major finalAttrs.version}/gnome-logs-${finalAttrs.version}.tar.xz";
    hash = "sha256-+PV56wu22ajWrl7hQj+UR6+RIAeFF4tQu63UrC0lXUU=";
  };

  nativeBuildInputs = [
    appstream
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    gettext
    itstool
    libxml2
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_43
    glib
    gtk4
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    systemd
    gsettings-desktop-schemas
  ];

  mesonFlags = [ "-Dman=true" ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-logs"; };
  };

  meta = {
    homepage = "https://apps.gnome.org/Logs/";
    description = "Log viewer for the systemd journal";
    mainProgram = "gnome-logs";
    teams = [ lib.teams.gnome ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})

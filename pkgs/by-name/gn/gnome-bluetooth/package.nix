{
  lib,
  stdenv,
  fetchurl,
  gnome,
  meson,
  mesonEmulatorHook,
  ninja,
  pkg-config,
  gtk4,
  libadwaita,
  gettext,
  glib,
  udev,
  upower,
  itstool,
  libxml2,
  wrapGAppsHook4,
  libnotify,
  gsound,
  gobject-introspection,
  gtk-doc,
  docbook-xsl-nons,
  docbook_xml_dtd_43,
  python3,
  gsettings-desktop-schemas,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-bluetooth";
  version = "46.1";

  # TODO: split out "lib"
  outputs = [
    "out"
    "dev"
    "devdoc"
    "man"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-bluetooth/${lib.versions.major finalAttrs.version}/gnome-bluetooth-${finalAttrs.version}.tar.xz";
    hash = "sha256-VsRKFwNFmOlgdFivrhvnXz3l798OYjVfCbpY/HvDEqw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    itstool
    pkg-config
    libxml2
    wrapGAppsHook4
    gobject-introspection
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
    python3
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [ mesonEmulatorHook ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    udev
    upower
    libnotify
    gsound
    gsettings-desktop-schemas
  ];

  mesonFlags = [ "-Dgtk_doc=true" ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-bluetooth";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-bluetooth";
    description = "Application that lets you manage Bluetooth in the GNOME desktop";
    mainProgram = "bluetooth-sendto";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
})

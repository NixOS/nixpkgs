{
  lib,
  stdenv,
  fetchurl,
  adwaita-icon-theme,
  desktop-file-utils,
  docbook-xsl-nons,
  gettext,
  glib,
  gnome,
  gnome-settings-daemon,
  gsettings-desktop-schemas,
  gtk3,
  itstool,
  libcanberra-gtk3,
  libdvdread,
  libhandy,
  libnotify,
  libpwquality,
  libsecret,
  libxml2,
  libxslt,
  meson,
  ninja,
  pkg-config,
  systemd,
  udisks,
  wrapGAppsHook3,
  xz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-disk-utility";
  version = "46.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-disk-utility/${lib.versions.major finalAttrs.version}/gnome-disk-utility-${finalAttrs.version}.tar.xz";
    hash = "sha256-wk6UOaBNcLz640nKE0xwBUNf4rb0UhFN+Hi/8Libv/4=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    docbook-xsl-nons
    gettext
    itstool
    libxml2
    libxslt
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    adwaita-icon-theme
    glib
    gnome-settings-daemon
    gsettings-desktop-schemas
    gtk3
    libcanberra-gtk3
    libdvdread
    libhandy
    libnotify
    libpwquality
    libsecret
    systemd
    udisks
    xz
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-disk-utility";
    };
  };

  meta = {
    homepage = "https://apps.gnome.org/DiskUtility/";
    description = "Udisks graphical front-end";
    teams = [ lib.teams.gnome ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "gnome-disks";
  };
})

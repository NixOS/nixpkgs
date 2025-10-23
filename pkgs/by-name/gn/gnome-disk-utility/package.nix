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
  udisks2,
  wrapGAppsHook3,
  xz,
}:

stdenv.mkDerivation rec {
  pname = "gnome-disk-utility";
  version = "46.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-disk-utility/${lib.versions.major version}/gnome-disk-utility-${version}.tar.xz";
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
    udisks2
    xz
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-disk-utility";
    };
  };

  meta = with lib; {
    homepage = "https://apps.gnome.org/DiskUtility/";
    description = "Udisks graphical front-end";
    teams = [ teams.gnome ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    mainProgram = "gnome-disks";
  };
}

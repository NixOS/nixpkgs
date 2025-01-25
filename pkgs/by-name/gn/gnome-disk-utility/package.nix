{
  lib,
  stdenv,
  gettext,
  fetchurl,
  pkg-config,
  udisks2,
  libhandy,
  libsecret,
  libdvdread,
  meson,
  ninja,
  gtk3,
  glib,
  wrapGAppsHook3,
  libnotify,
  itstool,
  gnome,
  gnome-settings-daemon,
  adwaita-icon-theme,
  libxml2,
  gsettings-desktop-schemas,
  libcanberra-gtk3,
  libxslt,
  docbook-xsl-nons,
  desktop-file-utils,
  libpwquality,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "gnome-disk-utility";
  version = "46.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-disk-utility/${lib.versions.major version}/gnome-disk-utility-${version}.tar.xz";
    hash = "sha256-wk6UOaBNcLz640nKE0xwBUNf4rb0UhFN+Hi/8Libv/4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    libxslt
    docbook-xsl-nons
    desktop-file-utils
    wrapGAppsHook3
    libxml2
  ];

  buildInputs = [
    gtk3
    glib
    libhandy
    libsecret
    libpwquality
    libnotify
    libdvdread
    libcanberra-gtk3
    udisks2
    adwaita-icon-theme
    systemd
    gnome-settings-daemon
    gsettings-desktop-schemas
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-disk-utility";
    };
  };

  meta = with lib; {
    homepage = "https://apps.gnome.org/DiskUtility/";
    description = "Udisks graphical front-end";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    mainProgram = "gnome-disks";
  };
}

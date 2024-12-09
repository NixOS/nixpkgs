{
  lib,
  stdenv,
  fetchurl,
  gettext,
  itstool,
  libxml2,
  pkg-config,
  gnome-panel,
  gtk3,
  glib,
  libwnck,
  libgtop,
  libnotify,
  upower,
  wirelesstools,
  linuxPackages,
  adwaita-icon-theme,
  libgweather,
  gucharmap,
  tinysparql,
  polkit,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-applets";
  version = "3.54.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-applets/${lib.versions.majorMinor finalAttrs.version}/gnome-applets-${finalAttrs.version}.tar.xz";
    hash = "sha256-FASM8amK2U4U715E/f6IVvo/KDZAHHkr/83mi4db2vk=";
  };

  nativeBuildInputs = [
    gettext
    itstool
    pkg-config
    libxml2
  ];

  buildInputs = [
    gnome-panel
    gtk3
    glib
    libxml2
    libwnck
    libgtop
    libnotify
    upower
    adwaita-icon-theme
    libgweather
    gucharmap
    tinysparql
    polkit
    wirelesstools
    linuxPackages.cpupower
  ];

  enableParallelBuilding = true;

  doCheck = true;

  # Don't try to install modules to gnome panel's directory, as it's read only
  PKG_CONFIG_LIBGNOME_PANEL_MODULESDIR = "${placeholder "out"}/lib/gnome-panel/modules";

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-applets";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Applets for use with the GNOME panel";
    mainProgram = "cpufreq-selector";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-applets";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-applets/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
})

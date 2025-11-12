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
  version = "3.58.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-applets/${lib.versions.majorMinor finalAttrs.version}/gnome-applets-${finalAttrs.version}.tar.xz";
    hash = "sha256-5h7bcTRNzV2qbnF137snSnWL6LWEUnc1abs1ZFuFojg=";
  };

  nativeBuildInputs = [
    gettext
    glib # glib-compile-resources
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
    teams = [ teams.gnome ];
    platforms = platforms.linux;
  };
})

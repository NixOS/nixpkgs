{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  itstool,
  dbus-glib,
  glib,
  gtk3,
  gucharmap,
  libmateweather,
  libnl,
  libwnck,
  libgtop,
  libxml2,
  libnotify,
  mate-desktop,
  mate-panel,
  polkit,
  upower,
  wirelesstools,
  hicolor-icon-theme,
  wrapGAppsHook3,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mate-applets";
  version = "1.28.1";
  outputs = [
    "out"
    "man"
  ];

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/mate-applets-${finalAttrs.version}.tar.xz";
    sha256 = "pZZxQVJ9xbFy0yKmADwjruwlMWD2ULs2QwoG3a76fi4=";
  };

  nativeBuildInputs = [
    gettext
    itstool
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    dbus-glib
    gtk3
    gucharmap
    hicolor-icon-theme
    libgtop
    libmateweather
    libnl
    libnotify
    libwnck
    libxml2
    mate-desktop # for org.mate.lockdown
    mate-panel
    polkit
    upower
    wirelesstools
  ];

  configureFlags = [
    "--enable-suid=no"
    "--enable-in-process"
  ];

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/mate-applets";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "Applets for use with the MATE panel";
    mainProgram = "mate-cpufreq-selector";
    homepage = "https://mate-desktop.org";
    license = with lib.licenses; [
      gpl2Plus
      lgpl2Plus
    ];
    platforms = lib.platforms.linux;
    teams = [ lib.teams.mate ];
  };
})

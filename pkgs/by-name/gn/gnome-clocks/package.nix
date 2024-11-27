{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  gettext,
  pkg-config,
  wrapGAppsHook4,
  itstool,
  desktop-file-utils,
  vala,
  libxml2,
  gtk4,
  glib,
  gsettings-desktop-schemas,
  gnome-desktop,
  geocode-glib_2,
  gnome,
  gdk-pixbuf,
  geoclue2,
  gst_all_1,
  libgweather,
  libadwaita,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-clocks";
  version = "47.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-clocks/${lib.versions.major finalAttrs.version}/gnome-clocks-${finalAttrs.version}.tar.xz";
    hash = "sha256-QovfS9F+Jt5s7wFM16fuvYkUPD8nMrJLfaaYErqlITE=";
  };

  nativeBuildInputs = [
    vala
    meson
    ninja
    pkg-config
    gettext
    itstool
    wrapGAppsHook4
    desktop-file-utils
    libxml2
  ];

  buildInputs =
    [
      gtk4
      glib
      gsettings-desktop-schemas
      gdk-pixbuf
      gnome-desktop
      geocode-glib_2
      geoclue2
      libgweather
      libadwaita
    ]
    ++ (with gst_all_1; [
      # GStreamer plugins needed for Alarms
      gstreamer
      gst-plugins-base
      gst-plugins-good
    ]);

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-clocks"; };
  };

  meta = {
    homepage = "https://apps.gnome.org/Clocks/";
    description = "A simple and elegant clock application for GNOME";
    longDescription = ''
      A simple and elegant clock application. It includes world clocks, alarms,
      a stopwatch, and timers.

      - Show the time in different cities around the world
      - Set alarms to wake you up
      - Measure elapsed time with an accurate stopwatch
      - Set timers to properly cook your food
    '';
    mainProgram = "gnome-clocks";
    maintainers = lib.teams.gnome.members;
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})

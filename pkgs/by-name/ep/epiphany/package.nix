{
  lib,
  stdenv,
  meson,
  ninja,
  gettext,
  fetchurl,
  pkg-config,
  gtk4,
  glib,
  icu,
  wrapGAppsHook4,
  gnome,
  libportal-gtk4,
  libxml2,
  itstool,
  webkitgtk_6_0,
  libsoup_3,
  glib-networking,
  libsecret,
  gnome-desktop,
  libarchive,
  p11-kit,
  sqlite,
  gcr_4,
  isocodes,
  desktop-file-utils,
  nettle,
  gdk-pixbuf,
  gst_all_1,
  json-glib,
  libadwaita,
  buildPackages,
  withPantheon ? false,
  pantheon,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "epiphany";
  version = "48.5";

  src = fetchurl {
    url = "mirror://gnome/sources/epiphany/${lib.versions.major finalAttrs.version}/epiphany-${finalAttrs.version}.tar.xz";
    hash = "sha256-D2ZVKtZZPHlSo93uW/UVZWyMQ0hxB22fGpGnr5NGsbQ=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    itstool
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    buildPackages.glib
    buildPackages.gtk4
  ];

  buildInputs =
    [
      gcr_4
      gdk-pixbuf
      glib
      glib-networking
      gnome-desktop
      gst_all_1.gst-libav
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-ugly
      gst_all_1.gstreamer
      gtk4
      icu
      isocodes
      json-glib
      libadwaita
      libportal-gtk4
      libarchive
      libsecret
      libsoup_3
      libxml2
      nettle
      p11-kit
      sqlite
      webkitgtk_6_0
    ]
    ++ lib.optionals withPantheon [
      pantheon.granite7
    ];

  # Tests need an X display
  mesonFlags =
    [
      "-Dunit_tests=disabled"
    ]
    ++ lib.optionals withPantheon [
      "-Dgranite=enabled"
    ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "epiphany";
    };
  };

  meta = with lib; {
    homepage = "https://apps.gnome.org/Epiphany/";
    description = "WebKit based web browser for GNOME";
    mainProgram = "epiphany";
    teams = [
      teams.gnome
      teams.pantheon
    ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
})

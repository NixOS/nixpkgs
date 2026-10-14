{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  intltool,
  meson,
  ninja,
  python3Packages,
  wrapGAppsHook4,
  dbus,
  desktop-file-utils,
  fribidi,
  glib,
  libadwaita,
  libxml2,
  libxslt,
  sqlite,
  libsoup_3,
  webkitgtk_6_0,
  json-glib,
  gst_all_1,
  libnotify,
  gtk4,
  gsettings-desktop-schemas,
  libpeas2,
  libsecret,
  gobject-introspection,
  glib-networking,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "liferea";
  version = "2.0.2";

  src = fetchurl {
    url = "https://github.com/lwindolf/${pname}/releases/download/v${version}/${pname}-${version}.tar.xz";
    hash = "sha256-M7/h326qU4daLW1oYyNz4y+pEWjckLkLGvQlu+805/E=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    wrapGAppsHook4
    python3Packages.wrapPython
    intltool
    meson
    ninja
    pkg-config
    gobject-introspection
  ];

  buildInputs = [
    dbus
    fribidi
    glib
    gtk4
    webkitgtk_6_0
    libadwaita
    libxml2
    libxslt
    sqlite
    libsoup_3
    libpeas2
    gsettings-desktop-schemas
    json-glib
    libsecret
    glib-networking
    libnotify
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
  ]);

  enableParallelBuilding = true;

  postFixup = ''
    buildPythonPath ${python3Packages.requests}
    patchPythonScript $out/lib/liferea/plugins/download-manager.py
  '';

  passthru.updateScript = gitUpdater {
    url = "https://github.com/lwindolf/${pname}";
    rev-prefix = "v";
  };

  meta = {
    description = "GTK-based news feed aggregator";
    homepage = "http://lzone.de/liferea/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      romildo
      yayayayaka
    ];
    platforms = lib.platforms.linux;

    longDescription = ''
      Liferea (Linux Feed Reader) is an RSS/RDF feed reader.
      It's intended to be a clone of the Windows-only FeedReader.
      It can be used to maintain a list of subscribed feeds,
      browse through their items, and show their contents.
    '';
  };
}

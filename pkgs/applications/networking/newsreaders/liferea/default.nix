{ lib, stdenv
, fetchurl
, fetchpatch
, pkg-config
, intltool
, python3Packages
, wrapGAppsHook
, glib
, libxml2
, libxslt
, sqlite
, libsoup
, webkitgtk
, json-glib
, gst_all_1
, libnotify
, gtk3
, gsettings-desktop-schemas
, libpeas
, libsecret
, gobject-introspection
, glib-networking
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "liferea";
  version = "1.15.5";

  src = fetchurl {
    url = "https://github.com/lwindolf/${pname}/releases/download/v${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-7lanrs63N6ZnqxvjcW/+cUZVDqUbML2gftQUc/sLr3Q=";
  };

  patches = [
    # Pull upstream fix for libxml2-2.12 compatibility:
    #   https://github.com/lwindolf/liferea/pull/1329
    (fetchpatch {
      name = "libxml2-2.12.patch";
      url = "https://github.com/lwindolf/liferea/commit/be8ef494586d9ef73c04ec4ca058a9a158ae3562.patch";
      hash = "sha256-K1R7dJMm7ui6QKQqAHCo/ZrLCW3PhPU1EKRPEICtCsQ=";
    })
  ];

  nativeBuildInputs = [
    wrapGAppsHook
    python3Packages.wrapPython
    intltool
    pkg-config
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk3
    webkitgtk
    libxml2
    libxslt
    sqlite
    libsoup
    libpeas
    gsettings-desktop-schemas
    json-glib
    libsecret
    glib-networking
    libnotify
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
  ]);

  enableParallelBuilding = true;

  postFixup = ''
    buildPythonPath ${python3Packages.pycairo}
    patchPythonScript $out/lib/liferea/plugins/trayicon.py
  '';

  passthru.updateScript = gitUpdater {
    url = "https://github.com/lwindolf/${pname}";
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "A GTK-based news feed aggregator";
    homepage = "http://lzone.de/liferea/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ romildo yayayayaka ];
    platforms = platforms.linux;

    longDescription = ''
      Liferea (Linux Feed Reader) is an RSS/RDF feed reader.
      It's intended to be a clone of the Windows-only FeedReader.
      It can be used to maintain a list of subscribed feeds,
      browse through their items, and show their contents.
    '';
  };
}

{ lib, stdenv
, fetchurl
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
}:

stdenv.mkDerivation rec {
  pname = "liferea";
  version = "1.12.9";

  src = fetchurl {
    url = "https://github.com/lwindolf/${pname}/releases/download/v${version}/${pname}-${version}.tar.bz2";
    sha256 = "06ybr1wjlfir8iqjx6x0v1knd4b2hsy30qmkk4kssy6ky2ahc66q";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    python3Packages.wrapPython
    intltool
    pkg-config
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
    gobject-introspection
    libsecret
    glib-networking
    libnotify
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
  ]);

  pythonPath = with python3Packages; [
    pygobject3
    pycairo
  ];

  preFixup = ''
    buildPythonPath "$out $pythonPath"
    gappsWrapperArgs+=(--prefix PYTHONPATH : "$program_PYTHONPATH")
  '';

  meta = with lib; {
    description = "A GTK-based news feed aggregator";
    homepage = "http://lzone.de/liferea/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ romildo ];
    platforms = platforms.linux;

    longDescription = ''
      Liferea (Linux Feed Reader) is an RSS/RDF feed reader.
      It's intended to be a clone of the Windows-only FeedReader.
      It can be used to maintain a list of subscribed feeds,
      browse through their items, and show their contents.
    '';
  };
}

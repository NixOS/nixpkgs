{ stdenv, fetchurl, pkgconfig, intltool, python3Packages, wrapGAppsHook
, glib, libxml2, libxslt, sqlite, libsoup , webkitgtk, json-glib, gst_all_1
, libnotify, gtk3, gsettings-desktop-schemas, libpeas, dconf, librsvg
, gobject-introspection, glib-networking, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "liferea";
  version = "1.12.6";

  src = fetchurl {
    url = "https://github.com/lwindolf/${pname}/releases/download/v${version}/${pname}-${version}b.tar.bz2";
    sha256 = "sha256:03pr1gmiv5y0i92bkhcxr8s311ll91chz19wb96jkixx32xav91d";
  };

  nativeBuildInputs = [ wrapGAppsHook python3Packages.wrapPython intltool pkgconfig ];

  buildInputs = [
    glib gtk3 webkitgtk libxml2 libxslt sqlite libsoup gsettings-desktop-schemas
    libpeas gsettings-desktop-schemas json-glib dconf gobject-introspection
    librsvg glib-networking libnotify hicolor-icon-theme
  ] ++ (with gst_all_1; [
    gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad
  ]);

  pythonPath = with python3Packages; [ pygobject3 pycairo ];

  preFixup = ''
    buildPythonPath "$out $pythonPath"
    gappsWrapperArgs+=(--prefix PYTHONPATH : "$program_PYTHONPATH")
  '';

  meta = with stdenv.lib; {
    description = "A GTK-based news feed aggregator";
    homepage = http://lzone.de/liferea/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ vcunat romildo ];
    platforms = platforms.linux;

    longDescription = ''
      Liferea (Linux Feed Reader) is an RSS/RDF feed reader.
      It's intended to be a clone of the Windows-only FeedReader.
      It can be used to maintain a list of subscribed feeds,
      browse through their items, and show their contents.
    '';
  };
}

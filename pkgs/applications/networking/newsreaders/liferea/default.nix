{ stdenv, fetchurl, pkgconfig, intltool, python3Packages, wrapGAppsHook
, glib, libxml2, libxslt, sqlite, libsoup , webkitgtk, json_glib, gst_all_1
, libnotify, gtk3, gsettings_desktop_schemas, libpeas, dconf, librsvg
, gobjectIntrospection, glib_networking
}:

let
  pname = "liferea";
  version = "1.12-rc3";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/lwindolf/${pname}/releases/download/v${version}/${name}.tar.bz2";
    sha256 = "0dd6hisqvc4ps6dx9ly34qx49ab1qa5h826b7dvf64mjqxa2v3kr";
  };

  nativeBuildInputs = [ wrapGAppsHook python3Packages.wrapPython intltool pkgconfig ];

  buildInputs = [
    glib gtk3 webkitgtk libxml2 libxslt sqlite libsoup gsettings_desktop_schemas
    libpeas gsettings_desktop_schemas json_glib dconf gobjectIntrospection
    librsvg glib_networking libnotify
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

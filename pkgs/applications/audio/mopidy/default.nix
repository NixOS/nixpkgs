{ stdenv, fetchFromGitHub, pythonPackages, wrapGAppsHook
, gst_all_1, glib-networking, gobject-introspection
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy";
    rev = "v${version}";
    sha256 = "01vl162c7ssf69b0m65ys9fxnsqnfa1whwbprnc063lkcnrnlkr1";
  };

  nativeBuildInputs = [ wrapGAppsHook ];

  buildInputs = with gst_all_1; [
    gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-bad
    glib-networking gobject-introspection
  ];

  propagatedBuildInputs = with pythonPackages; [
    gst-python pygobject3 pykka tornado_4 requests
  ] ++ stdenv.lib.optional (!stdenv.isDarwin) dbus-python;

  # There are no tests
  doCheck = false;

  preFixup = ''
    gappsWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH : "$GST_PLUGIN_SYSTEM_PATH")
  '';

  meta = with stdenv.lib; {
    homepage = https://www.mopidy.com/;
    description = ''
      An extensible music server that plays music from local disk, Spotify,
      SoundCloud, Google Play Music, and more
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ rickynils fpletz ];
    hydraPlatforms = [];
  };
}

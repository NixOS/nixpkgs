{ stdenv, fetchurl, pythonPackages, pygobject, gst_python, wrapGAppsHook
, glib_networking, gst_plugins_good, gst_plugins_base, gst_plugins_ugly
}:

pythonPackages.buildPythonApplication rec {
  name = "mopidy-${version}";

  version = "1.1.2";

  src = fetchurl {
    url = "https://github.com/mopidy/mopidy/archive/v${version}.tar.gz";
    sha256 = "1vn4knpmnp3krmn627iv1r7xa50zl816ac6b24b8ph50cq2sqjfv";
  };

  buildInputs = [
    wrapGAppsHook gst_plugins_base gst_plugins_good gst_plugins_ugly glib_networking
  ];

  propagatedBuildInputs = with pythonPackages; [
    gst_python pygobject pykka tornado requests2
  ];

  # There are no tests
  doCheck = false;

  preFixup = ''
    gappsWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH : "$GST_PLUGIN_SYSTEM_PATH")
  '';

  meta = with stdenv.lib; {
    homepage = http://www.mopidy.com/;
    description = ''
      An extensible music server that plays music from local disk, Spotify,
      SoundCloud, Google Play Music, and more
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ rickynils fpletz ];
    hydraPlatforms = [];
  };
}

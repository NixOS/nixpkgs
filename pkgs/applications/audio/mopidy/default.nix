{ stdenv, fetchurl, pythonPackages, pygobject, gst_python, wrapGAppsHook
, glib_networking, gst_plugins_good, gst_plugins_base, gst_plugins_ugly
}:

pythonPackages.buildPythonPackage rec {
  name = "mopidy-${version}";

  version = "1.1.1";

  src = fetchurl {
    url = "https://github.com/mopidy/mopidy/archive/v${version}.tar.gz";
    sha256 = "1xfyg8xqgnrb98wx7a4fzr4vlzkffjhkc1s36ka63rwmx86vqhyw";
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
    maintainers = [ maintainers.rickynils ];
    hydraPlatforms = [];
  };
}

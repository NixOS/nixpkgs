{ stdenv, fetchurl, pythonPackages, pygobject, gst_python
, gst_plugins_good, gst_plugins_base
}:

pythonPackages.buildPythonPackage rec {
  name = "mopidy-${version}";

  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/mopidy/mopidy/archive/v${version}.tar.gz";
    sha256 = "15cz6mqw8ihqxhlssnbbssl3bi1xxbmq7krf3hv0zmmdj73ilsd6";
  };

  propagatedBuildInputs = with pythonPackages; [
    gst_python pygobject pykka tornado gst_plugins_base gst_plugins_good
  ];

  # There are no tests
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/mopidy \
      --prefix GST_PLUGIN_SYSTEM_PATH : "$GST_PLUGIN_SYSTEM_PATH"
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

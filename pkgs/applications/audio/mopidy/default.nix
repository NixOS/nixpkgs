{ stdenv, fetchurl, pythonPackages, pygobject, gst_python
, gst_plugins_good, gst_plugins_base
}:

pythonPackages.buildPythonPackage rec {
  name = "mopidy-${version}";

  version = "0.15.0";

  src = fetchurl {
    url = "https://github.com/mopidy/mopidy/archive/v${version}.tar.gz";
    sha256 = "1fpnddcx6343wgxzh10s035w21g8jmfh2kzgx32w0xsshpra3gn1";
  };

  propagatedBuildInputs = with pythonPackages; [
   gst_python pygobject pykka pyspotify pylast cherrypy ws4py
  ];

  # python zip complains about old timestamps
  preConfigure = ''
    find -print0 | xargs -0 touch
  '';

  # There are no tests
  doCheck = false;

  postInstall = ''
    for p in $out/bin/mopidy $out/bin/mopidy-scan; do
      wrapProgram $p \
        --prefix GST_PLUGIN_PATH : ${gst_plugins_good}/lib/gstreamer-0.10 \
        --prefix GST_PLUGIN_PATH : ${gst_plugins_base}/lib/gstreamer-0.10
    done
  '';

  meta = {
    homepage = http://www.mopidy.com/;
    description = ''
      A music server which can play music from Spotify and from your
      local hard drive.
    '';
    maintainers = [ stdenv.lib.maintainers.rickynils ];
  };
}

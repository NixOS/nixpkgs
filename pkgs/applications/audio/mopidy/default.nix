{ stdenv, fetchgit, pythonPackages, pygobject, gst_python
, gst_plugins_good, gst_plugins_base
}:

pythonPackages.buildPythonPackage rec {
  name = "mopidy-${version}";

  version = "0.14.1";

  src = fetchgit {
    url = "https://github.com/mopidy/mopidy.git";
    rev = "refs/tags/v${version}";
    sha256 = "0lgd8dpiri9m6sigpf1g1qzvz25lkb38lskgwvb8j7x64y104z0v";
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

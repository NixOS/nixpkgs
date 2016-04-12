{ stdenv, fetchFromGitHub, pythonPackages, pygobject3, wrapGAppsHook
, gst_all_1, glib_networking, gobjectIntrospection
}:

pythonPackages.buildPythonApplication rec {
  name = "mopidy-${version}";

  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy";
    rev = "v${version}";
    sha256 = "06f1y87dqc7p6kq5npmg3ki8x4iacyjzd7nq7188x20y2zglrjbm";
  };

  nativeBuildInputs = [ wrapGAppsHook ];

  buildInputs = with gst_all_1; [
    gst-plugins-base gst-plugins-good gst-plugins-ugly
    glib_networking gobjectIntrospection
  ];

  propagatedBuildInputs = with pythonPackages; [
    gst-python pygobject3 pykka tornado requests2
  ];

  # There are no tests
  doCheck = false;

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

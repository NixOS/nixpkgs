{ stdenv, fetchFromGitHub, pythonPackages, wrapGAppsHook
, gst_all_1, glib-networking, gobject-introspection
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy";
    rev = "v${version}";
    sha256 = "14m80z9spi2vhfs2bbff7ky80mr6bksl4550y17hwd7zpkid60za";
  };

  nativeBuildInputs = [ wrapGAppsHook ];

  buildInputs = with gst_all_1; [
    glib-networking
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
  ];

  propagatedBuildInputs = [
    gobject-introspection
  ] ++ (with pythonPackages; [
      gst-python
      pygobject3
      pykka
      requests
      setuptools
      tornado
    ] ++ stdenv.lib.optional (!stdenv.isDarwin) dbus-python
  );

  # There are no tests
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://www.mopidy.com/";
    description = ''
      An extensible music server that plays music from local disk, Spotify,
      SoundCloud, Google Play Music, and more
    '';
    license = licenses.asl20;
    maintainers = [ maintainers.fpletz ];
    hydraPlatforms = [];
  };
}

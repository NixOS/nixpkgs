{ lib, stdenv, fetchFromGitHub, pythonPackages, wrapGAppsHook
, gst_all_1, glib-networking, gobject-introspection
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-IUQe5WH2vsrAOgokhTNVVM3lnJXphT2xNGu27hWBLSo=";
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
    ] ++ lib.optional (!stdenv.isDarwin) dbus-python
  );

  propagatedNativeBuildInputs = [
    gobject-introspection
  ];

  # There are no tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://www.mopidy.com/";
    description = ''
      An extensible music server that plays music from local disk, Spotify,
      SoundCloud, and more
    '';
    license = licenses.asl20;
    maintainers = [ maintainers.fpletz ];
    hydraPlatforms = [];
  };
}

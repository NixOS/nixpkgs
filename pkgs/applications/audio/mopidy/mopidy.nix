{ lib, stdenv, fetchFromGitHub, pythonPackages, wrapGAppsNoGuiHook
, gst_all_1, glib-networking, gobject-introspection
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy";
  version = "3.4.2";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-2OFav2HaQq/RphmZxLyL1n3suwzt1Y/d4h33EdbStjk=";
  };

  nativeBuildInputs = [ wrapGAppsNoGuiHook ];

  buildInputs = with gst_all_1; [
    glib-networking
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gst-plugins-rs
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
    ] ++ lib.optional (!stdenv.hostPlatform.isDarwin) dbus-python
  );

  propagatedNativeBuildInputs = [
    gobject-introspection
  ];

  # There are no tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://www.mopidy.com/";
    description = "Extensible music server that plays music from local disk, Spotify, SoundCloud, and more";
    mainProgram = "mopidy";
    license = licenses.asl20;
    maintainers = [ maintainers.fpletz ];
    hydraPlatforms = [];
  };
}

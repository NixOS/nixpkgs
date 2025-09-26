{
  lib,
  stdenv,
  fetchFromGitHub,
  pythonPackages,
  wrapGAppsNoGuiHook,
  gst_all_1,
  glib-networking,
  gobject-introspection,
  pipewire,
  nixosTests,
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy";
  version = "3.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy";
    tag = "v${version}";
    hash = "sha256-2OFav2HaQq/RphmZxLyL1n3suwzt1Y/d4h33EdbStjk=";
  };

  nativeBuildInputs = [ wrapGAppsNoGuiHook ];

  buildInputs =
    with gst_all_1;
    [
      glib-networking
      gst-plugins-bad
      gst-plugins-base
      gst-plugins-good
      gst-plugins-ugly
      gst-plugins-rs
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ pipewire ];

  propagatedNativeBuildInputs = [ gobject-introspection ];

  propagatedBuildInputs = [ gobject-introspection ];

  build-system = [ pythonPackages.setuptools ];

  dependencies =
    with pythonPackages;
    [
      gst-python
      pygobject3
      pykka
      requests
      setuptools
      tornado
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ dbus-python ];

  # There are no tests
  doCheck = false;

  passthru.tests = {
    inherit (nixosTests) mopidy;
  };

  meta = {
    homepage = "https://www.mopidy.com/";
    description = "Extensible music server that plays music from local disk, Spotify, SoundCloud, and more";
    mainProgram = "mopidy";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.fpletz ];
    hydraPlatforms = [ ];
  };
}

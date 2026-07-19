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

pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "mopidy";
  version = "4.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fSvUD+vDua3DCKx/CszjKEUuspD0FwROOksRD6K++L0=";
  };

  patches = [
    # Mopidy 3 skipped unavailable optional XDG paths instead of failing.
    ./fix-unexpanded-xdg-paths.patch
    # https://github.com/mopidy/mopidy/pull/2280
    ./fix-gst-structure-none-checks.patch
  ];

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
      gst-libav
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ pipewire ];

  propagatedNativeBuildInputs = [ gobject-introspection ];

  propagatedBuildInputs = [ gobject-introspection ];

  build-system = with pythonPackages; [
    setuptools
    setuptools-scm
  ];

  dependencies =
    with pythonPackages;
    [
      cyclopts
      gst-python
      httpx
      platformdirs
      pydantic
      pygobject3
      pykka
      rich
      tornado
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ dbus-python ];

  nativeCheckInputs = with pythonPackages; [
    dirty-equals
    polyfactory
    pytestCheckHook
    pytest-httpx
    pytest-mock
  ];

  disabledTests = [
    # GStreamer 1.28 does not report the duration of the WAV fixture.
    "test_lookup_converts_uri_metadata_to_track"
    # GStreamer 1.28.5 recognizes text/plain without the expected decodebin error.
    "test_text_plain"
  ];

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
})

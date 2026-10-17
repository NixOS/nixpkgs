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
  version = "4.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EmifQxL6HVZrBU1FXR8eMidllhK7Lt+pvfT0DrSP59U=";
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

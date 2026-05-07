{
  lib,
  stdenv,
  python312Packages,
  fetchFromGitHub,

  chromaprint,
  gettext,
  qt5,

  enablePlayback ? true,
  gst_all_1,

  writableTmpDirAsHomeHook,
}:

let
  pythonPackages = python312Packages;
  pyqt5 = if enablePlayback then pythonPackages.pyqt5-multimedia else pythonPackages.pyqt5;
in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "picard";
  # nix-update --commit picard --version-regex 'release-(.*)'
  version = "2.13.3";
  pyproject = true;
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = "picard";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-Q0W5Q1+PbN+yneh98jx0/UNHVfD6okX92hxNzCE+Ibc=";
  };

  nativeBuildInputs = [
    gettext
    qt5.wrapQtAppsHook
    pythonPackages.setuptools
  ];

  buildInputs = [
    qt5.qtbase
  ]
  ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform qt5.qtwayland) [
    qt5.qtwayland
  ]
  ++ lib.optionals (pyqt5.multimediaEnabled) (
    [
      qt5.qtmultimedia.bin
      gst_all_1.gst-libav
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
    ]
    ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform gst_all_1.gst-vaapi) [
      gst_all_1.gst-vaapi
    ]
  );

  pythonRelaxDeps = lib.optionals stdenv.hostPlatform.isDarwin [
    # Should be resolved in the next version
    "pyobjc-core"
    "pyobjc-framework-Cocoa"
  ];

  propagatedBuildInputs =
    with pythonPackages;
    [
      charset-normalizer
      chromaprint
      discid
      fasteners
      markdown
      mutagen
      pyjwt
      pyqt5
      python-dateutil
      pyyaml
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      pyobjc-core
      pyobjc-framework-Cocoa
    ];

  # Not reporting any of these issues because the next upstream version will
  # include many breaking changes and this might not be relevant.
  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    "test/test_const_appdirs.py::AppPathsTest::test_cache_folder_macos" # - AssertionError: '/nix/var/nix/builds/nix-54642-966088698/.h[33 chars]card' ...
    "test/test_const_appdirs.py::AppPathsTest::test_config_folder_macos" # - AssertionError: '/nix/var/nix/builds/nix-54642-966088698/.h[38 chars]card' ...
    "test/test_const_appdirs.py::AppPathsTest::test_plugin_folder_macos" # - AssertionError: '/nix/var/nix/builds/nix-54642-966088698/.h[46 chars]gins' ...
    "test/test_plugins.py" # Various PermissionError for /var/empty/Library - hopefully will be resolved in the next release.
    "test/test_utils.py::HiddenFileTest::test_macos" # - FileNotFoundError: [Errno 2] No such file or directory: 'SetFile'
  ];

  setupPyGlobalFlags = [
    "build"
    "--disable-autoupdate"
    "--localedir=${placeholder "out"}/share/locale"
  ];

  nativeCheckInputs = [
    pythonPackages.pytestCheckHook
    writableTmpDirAsHomeHook
  ];
  doCheck = true;

  # In order to spare double wrapping, we use:
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  ''
  + lib.optionalString (pyqt5.multimediaEnabled) ''
    makeWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = {
    homepage = "https://picard.musicbrainz.org";
    changelog = "https://picard.musicbrainz.org/changelog";
    description = "Official MusicBrainz tagger";
    mainProgram = "picard";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})

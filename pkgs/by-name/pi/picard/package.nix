{
  lib,
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
    qt5.qtwayland
  ]
  ++ lib.optionals (pyqt5.multimediaEnabled) [
    qt5.qtmultimedia.bin
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-vaapi
  ];

  propagatedBuildInputs = with pythonPackages; [
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

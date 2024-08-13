{
  lib,
  python3Packages,
  fetchFromGitHub,

  chromaprint,
  gettext,
  qt5,

  enablePlayback ? true,
  gst_all_1,
}:

let
  pythonPackages = python3Packages;
  pyqt5 = if enablePlayback then pythonPackages.pyqt5-multimedia else pythonPackages.pyqt5;
in
pythonPackages.buildPythonApplication rec {
  pname = "picard";
  # nix-update --commit picard --version-regex 'release-(.*)'
  version = "2.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = "picard";
    rev = "refs/tags/release-${version}";
    hash = "sha256-wKPE4lj3DIlY+X5A/MqhnwyrhPTXGjmUnLK1VWXUOas=";
  };

  build-system = [ pythonPackages.setuptools ];

  nativeBuildInputs =
    [
      gettext
      qt5.wrapQtAppsHook
    ]
    ++ lib.optionals (pyqt5.multimediaEnabled) [
      gst_all_1.gst-libav
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-vaapi
      gst_all_1.gstreamer
    ];

  buildInputs = [
    qt5.qtbase
    qt5.qtwayland
  ] ++ lib.optionals (pyqt5.multimediaEnabled) [ qt5.qtmultimedia.bin ];

  dependencies = with pythonPackages; [
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
    "--localedir=$out/share/locale"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # In order to spare double wrapping, we use:
  preFixup =
    ''
      makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    ''
    + lib.optionalString (pyqt5.multimediaEnabled) ''
      makeWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
    '';

  meta = with lib; {
    homepage = "https://picard.musicbrainz.org";
    changelog = "https://picard.musicbrainz.org/changelog";
    description = "Official MusicBrainz tagger";
    license = licenses.gpl2Plus;
    mainProgram = "picard";
    maintainers = with maintainers; [ paveloom ];
  };
}

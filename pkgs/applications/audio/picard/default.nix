{ lib
, python3Packages
, fetchFromGitHub

, chromaprint
, gettext
, qt5

, enablePlayback ? true
, gst_all_1
}:

let
  pythonPackages = python3Packages;
  pyqt5 =
    if enablePlayback then
      pythonPackages.pyqt5-multimedia
    else
      pythonPackages.pyqt5;
in
pythonPackages.buildPythonApplication rec {
  pname = "picard";
  version = "2.11";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = "picard";
    rev = "refs/tags/release-${version}";
    hash = "sha256-2RGKHJKJ/QXR6Rehch4r1UtI+frRXa4G+n0bUmCGSu8=";
  };

  nativeBuildInputs = [
    gettext
    qt5.wrapQtAppsHook
  ] ++ lib.optionals (pyqt5.multimediaEnabled) [
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-vaapi
    gst_all_1.gstreamer
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qtwayland
  ] ++ lib.optionals (pyqt5.multimediaEnabled) [
    qt5.qtmultimedia.bin
  ];

  propagatedBuildInputs = with pythonPackages; [
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

  setupPyGlobalFlags = [ "build" "--disable-autoupdate" "--localedir=$out/share/locale" ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # In order to spare double wrapping, we use:
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '' + lib.optionalString (pyqt5.multimediaEnabled) ''
    makeWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = with lib; {
    homepage = "https://picard.musicbrainz.org";
    changelog = "https://picard.musicbrainz.org/changelog";
    description = "The official MusicBrainz tagger";
    mainProgram = "picard";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}

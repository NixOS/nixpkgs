{ lib
, python3Packages
, fetchFromGitHub
, gettext
, chromaprint
, qt5
, enablePlayback ? true
, gst_all_1
}:

let
  pythonPackages = python3Packages;
  pyqt5 = if enablePlayback then
    pythonPackages.pyqt5_with_qtmultimedia
  else
    pythonPackages.pyqt5
  ;
in
pythonPackages.buildPythonApplication rec {
  pname = "picard";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = pname;
    rev = "refs/tags/release-${version}";
    sha256 = "sha256-KEKOouTNmmZiPyKo8xCQv6Zkreidtz2DaEbHjuwJJvY=";
  };

  nativeBuildInputs = [ gettext qt5.wrapQtAppsHook qt5.qtbase ]
  ++ lib.optionals (pyqt5.multimediaEnabled) [
    qt5.qtmultimedia.bin
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-vaapi
    gst_all_1.gstreamer
  ]
  ;

  propagatedBuildInputs = with pythonPackages; [
    chromaprint
    python-dateutil
    discid
    fasteners
    mutagen
    pyqt5
    markdown
    pyjwt
    pyyaml
  ];

  # In order to spare double wrapping, we use:
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  ''
  + lib.optionalString (pyqt5.multimediaEnabled) ''
    makeWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  ''
  ;

  meta = with lib; {
    homepage = "https://picard.musicbrainz.org/";
    description = "The official MusicBrainz tagger";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}

{ stdenv, python3Packages, fetchFromGitHub, gettext, chromaprint, qt5
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
in pythonPackages.buildPythonApplication rec {
  pname = "picard";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = pname;
    rev = "release-${version}";
    sha256 = "0xalg4dvaqb396h4s6gzxnplgv1lcvsczmmrlhyrj0kfj10amhsj";
  };

  nativeBuildInputs = [ gettext qt5.wrapQtAppsHook qt5.qtbase ]
    ++ stdenv.lib.optionals (pyqt5.multimediaEnabled) [
      qt5.qtmultimedia.bin
      gst_all_1.gstreamer
      gst_all_1.gst-vaapi
      gst_all_1.gst-libav
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
    ]
  ;

  propagatedBuildInputs = with pythonPackages; [
    pyqt5
    mutagen
    chromaprint
    discid
  ];

  prePatch = ''
    # Pesky unicode punctuation.
    substituteInPlace setup.cfg --replace "‘" "'"
  '';

  # In order to spare double wrapping, we use:
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  ''
    + stdenv.lib.optionalString (pyqt5.multimediaEnabled) ''
      makeWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
    ''
  ;

  meta = with stdenv.lib; {
    homepage = "https://picard.musicbrainz.org/";
    description = "The official MusicBrainz tagger";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}

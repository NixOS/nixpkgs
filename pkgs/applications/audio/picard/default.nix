{ lib
, python3Packages
, fetchFromGitHub
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, gettext
, chromaprint
, qt5
, enablePlayback ? true
, gst_all_1
}:

let
  pythonPackages = python3Packages;
<<<<<<< HEAD
  pyqt5 =
    if enablePlayback then
      pythonPackages.pyqt5_with_qtmultimedia
    else
      pythonPackages.pyqt5
=======
  pyqt5 = if enablePlayback then
    pythonPackages.pyqt5_with_qtmultimedia
  else
    pythonPackages.pyqt5
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ;
in
pythonPackages.buildPythonApplication rec {
  pname = "picard";
<<<<<<< HEAD
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = "picard";
    rev = "refs/tags/release-${version}";
    hash = "sha256-KCLva8pc+hyz+3MkPsghXrDYGVqP0aeffG9hOYJzI+Q=";
  };

  nativeBuildInputs = [
    gettext
    qt5.wrapQtAppsHook
  ] ++ lib.optionals (pyqt5.multimediaEnabled) [
=======
  version = "2.8.5";

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = pname;
    rev = "refs/tags/release-${version}";
    sha256 = "sha256-ukqlAXGaqX89U77cM9Ux0RYquT31Ho8ri1Ue7S3+MwQ=";
  };

  nativeBuildInputs = [ gettext qt5.wrapQtAppsHook qt5.qtbase ]
  ++ lib.optionals (pyqt5.multimediaEnabled) [
    qt5.qtmultimedia.bin
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-vaapi
    gst_all_1.gstreamer
<<<<<<< HEAD
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qtwayland
  ] ++ lib.optionals (pyqt5.multimediaEnabled) [
    qt5.qtmultimedia.bin
  ];
=======
  ]
  ;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

<<<<<<< HEAD
  setupPyGlobalFlags = [ "build" "--disable-autoupdate" ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # In order to spare double wrapping, we use:
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  ''
  + lib.optionalString (pyqt5.multimediaEnabled) ''
    makeWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
<<<<<<< HEAD
  '';
=======
  ''
  ;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://picard.musicbrainz.org/";
    changelog = "https://picard.musicbrainz.org/changelog/";
    description = "The official MusicBrainz tagger";
<<<<<<< HEAD
    maintainers = with maintainers; [ ehmry paveloom ];
=======
    maintainers = with maintainers; [ ehmry ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}

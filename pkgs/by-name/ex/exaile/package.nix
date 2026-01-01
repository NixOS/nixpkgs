{
  stdenv,
  lib,
  fetchFromGitHub,
  gobject-introspection,
  makeWrapper,
  wrapGAppsHook3,
  gtk3,
  gst_all_1,
  python3,
  gettext,
  adwaita-icon-theme,
  help2man,
  keybinder3,
  libnotify,
  librsvg,
  streamripper,
  udisks,
  webkitgtk_4_1,
  iconTheme ? adwaita-icon-theme,
  deviceDetectionSupport ? true,
  documentationSupport ? true,
  notificationSupport ? true,
  scalableIconSupport ? true,
  translationSupport ? true,
  ipythonSupport ? false,
  cdMetadataSupport ? false,
  lastfmSupport ? false,
  lyricsManiaSupport ? false,
  multimediaKeySupport ? false,
  musicBrainzSupport ? false,
  podcastSupport ? false,
  streamripperSupport ? false,
  wikipediaSupport ? false,
}:

stdenv.mkDerivation rec {
  pname = "exaile";
<<<<<<< HEAD
  version = "4.2.1";
=======
  version = "4.2.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "exaile";
    repo = "exaile";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-eH7JhoGd5jiaye8ZLx836tgEXsRpEd3D3z6gvnVrbIs=";
=======
    sha256 = "sha256-33lUlJ7H7lmty46GLzGkIUpgbWIv2EqEcPIzKt87dis=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    gobject-introspection
    makeWrapper
    wrapGAppsHook3
  ]
  ++ lib.optionals documentationSupport [
    help2man
    python3.pkgs.sphinx
    python3.pkgs.sphinx-rtd-theme
  ]
  ++ lib.optional translationSupport gettext;

  buildInputs = [
    iconTheme
    gtk3
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
  ])
  ++ (with python3.pkgs; [
    berkeleydb
    dbus-python
    mutagen
    pygobject3
    pycairo
    gst-python
  ])
  ++ lib.optional deviceDetectionSupport udisks
  ++ lib.optional notificationSupport libnotify
  ++ lib.optional scalableIconSupport librsvg
  ++ lib.optional ipythonSupport python3.pkgs.ipython
  ++ lib.optional cdMetadataSupport python3.pkgs.discid
  ++ lib.optional lastfmSupport python3.pkgs.pylast
  ++ lib.optional lyricsManiaSupport python3.pkgs.lxml
  ++ lib.optional multimediaKeySupport keybinder3
  ++ lib.optional (musicBrainzSupport || cdMetadataSupport) python3.pkgs.musicbrainzngs
  ++ lib.optional podcastSupport python3.pkgs.feedparser
  ++ lib.optional wikipediaSupport webkitgtk_4_1;

  nativeCheckInputs = with python3.pkgs; [
    pytest
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  doCheck = true;
  preCheck = ''
    substituteInPlace Makefile --replace "PYTHONPATH=$(shell pwd)" "PYTHONPATH=$PYTHONPATH:$(shell pwd)"
    export PYTEST="py.test"
    export XDG_CACHE_HOME=$(mktemp -d)
  '';

  postInstall = ''
    wrapProgram $out/bin/exaile \
      --set PYTHONPATH $PYTHONPATH \
      --prefix PATH : ${
        lib.makeBinPath ([ python3 ] ++ lib.optionals streamripperSupport [ streamripper ])
      }
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://www.exaile.org/";
    description = "Music player with a simple interface and powerful music management capabilities";
    mainProgram = "exaile";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ryneeverett ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    homepage = "https://www.exaile.org/";
    description = "Music player with a simple interface and powerful music management capabilities";
    mainProgram = "exaile";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ryneeverett ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

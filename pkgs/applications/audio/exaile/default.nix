{ stdenv, lib, fetchFromGitHub
, gobject-introspection, makeWrapper, wrapGAppsHook
, gtk3, gst_all_1, python3
, gettext, gnome, help2man, keybinder3, libnotify, librsvg, streamripper, udisks, webkitgtk
, iconTheme ? gnome.adwaita-icon-theme
, deviceDetectionSupport ? true
, documentationSupport ? true
, notificationSupport ? true
, scalableIconSupport ? true
, translationSupport ? true
, bpmCounterSupport ? false
, ipythonSupport ? false
, lastfmSupport ? false
, lyricsManiaSupport ? false
, lyricsWikiSupport ? false
, multimediaKeySupport ? false
, musicBrainzSupport ? false
, podcastSupport ? false
, streamripperSupport ? false
, wikipediaSupport ? false
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "exaile";
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "exaile";
    repo = pname;
    rev = version;
    sha256 = "sha256-GZyCuPy57NhGwgbLMrRKW5xmc1Udon7WtsrD4upviuQ=";
  };

  nativeBuildInputs = [
    gobject-introspection
    makeWrapper
    wrapGAppsHook
  ] ++ lib.optionals documentationSupport [
    help2man
    python3.pkgs.sphinx
    python3.pkgs.sphinx-rtd-theme
  ] ++ lib.optional translationSupport gettext;

  buildInputs = [
    iconTheme
    gtk3
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
  ]) ++ (with python3.pkgs; [
    bsddb3
    dbus-python
    mutagen
    pygobject3
    pycairo
    gst-python
  ]) ++ lib.optional deviceDetectionSupport udisks
  ++ lib.optional notificationSupport libnotify
  ++ lib.optional scalableIconSupport librsvg
  ++ lib.optional bpmCounterSupport gst_all_1.gst-plugins-bad
  ++ lib.optional ipythonSupport python3.pkgs.ipython
  ++ lib.optional lastfmSupport python3.pkgs.pylast
  ++ lib.optional (lyricsManiaSupport || lyricsWikiSupport) python3.pkgs.lxml
  ++ lib.optional lyricsWikiSupport python3.pkgs.beautifulsoup4
  ++ lib.optional multimediaKeySupport keybinder3
  ++ lib.optional musicBrainzSupport python3.pkgs.musicbrainzngs
  ++ lib.optional podcastSupport python3.pkgs.feedparser
  ++ lib.optional wikipediaSupport webkitgtk;

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
      --prefix PATH : ${lib.makeBinPath ([ python3 ] ++ lib.optionals streamripperSupport [ streamripper ]) }
  '';

  meta = with lib; {
    homepage = "https://www.exaile.org/";
    description = "A music player with a simple interface and powerful music management capabilities";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ryneeverett ];
    platforms = platforms.all;
  };
}

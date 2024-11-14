{ lib, fetchFromGitHub, wrapGAppsHook3, gettext
, python3Packages, adwaita-icon-theme, gtk3, glib, gdk-pixbuf, gsettings-desktop-schemas, gobject-introspection }:

let
  inherit (python3Packages) buildPythonApplication isPy3k dbus-python pygobject3 mpd2 setuptools;
in buildPythonApplication rec {
  pname = "sonata";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "multani";
    repo = "sonata";
    rev = "v${version}";
    sha256 = "0rl8w7s2asff626clzfvyz987l2k4ml5dg417mqp9v8a962q0v2x";
  };

  disabled = !isPy3k;

  nativeBuildInputs = [
    gettext
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    adwaita-icon-theme
    gsettings-desktop-schemas
    gtk3
    gdk-pixbuf
  ];

  # The optional tagpy dependency (for editing metadata) is not yet
  # included because it's difficult to build.
  pythonPath = [
    dbus-python
    mpd2
    pygobject3
    setuptools
  ];

  postPatch = ''
    # Remove "Local MPD" tab which is not suitable for NixOS.
    sed -i '/localmpd/d' sonata/consts.py
  '';

  meta = {
    description = "Elegant client for the Music Player Daemon";
    mainProgram = "sonata";
    longDescription = ''
      Sonata is an elegant client for the Music Player Daemon.

      Written in Python and using the GTK 3 widget set, its features
      include:

       - Expanded and collapsed views
       - Automatic remote and local album art
       - Library browsing by folders, or by genre/artist/album
       - User-configurable columns
       - Automatic fetching of lyrics
       - Playlist and stream support
       - Support for editing song tags (not in NixOS version)
       - Drag and drop to copy files
       - Popup notification
       - Library and playlist searching, filter as you type
       - Audioscrobbler (last.fm) 1.2 support
       - Multiple MPD profiles
       - Keyboard friendly
       - Support for multimedia keys
       - Commandline control
       - Available in 24 languages
    '';
    homepage = "https://www.nongnu.org/sonata/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}

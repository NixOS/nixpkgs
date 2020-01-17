{ stdenv, fetchFromGitHub, pkgconfig, gettext, intltool, wrapGAppsHook
, python3Packages, gnome3, gtk3, gsettings-desktop-schemas, gobject-introspection }:

let
  inherit (python3Packages) buildPythonApplication isPy3k dbus-python pygobject3 mpd2 setuptools;
in buildPythonApplication rec {
  pname = "sonata";
  version = "1.7b1";

  src = fetchFromGitHub {
    owner = "multani";
    repo = "sonata";
    rev = "v${version}";
    sha256 = "1npbxlrg6k154qybfd250nq2p96kxdsdkj9wwnp93gljnii3g8wh";
  };

  disabled = !isPy3k;

  nativeBuildInputs = [ pkgconfig gettext ];
  buildInputs = [
    intltool wrapGAppsHook
    gnome3.adwaita-icon-theme
    gsettings-desktop-schemas
  ];

  postPatch = ''
    # Remove "Local MPD" tab which is not suitable for NixOS.
    sed -i '/localmpd/d' sonata/consts.py
  '';

  propagatedBuildInputs = [
    gobject-introspection gtk3 pygobject3 setuptools
  ];

  # The optional tagpy dependency (for editing metadata) is not yet
  # included because it's difficult to build.
  pythonPath = [ dbus-python pygobject3 mpd2 ];

  meta = {
    description = "An elegant client for the Music Player Daemon";
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
    homepage = https://www.nongnu.org/sonata/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.rvl ];
  };
}

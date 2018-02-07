{ stdenv, fetchurl, python2Packages, wrapGAppsHook, gettext, intltool, libsoup, gnome3,
  tag ? "",
  gst_all_1, withGstPlugins ? true,
  xineBackend ? false, xineLib,
  withDbusPython ? false, withPyInotify ? false, withMusicBrainzNgs ? false, withPahoMqtt ? false,
  webkitgtk ? null,
  keybinder3 ? null, gtksourceview ? null, libmodplug ? null, kakasi ? null, libappindicator-gtk3 ? null }:

let optionals = stdenv.lib.optionals; in
python2Packages.buildPythonApplication rec {
  name = "quodlibet${tag}-${version}";
  version = "3.9.1";

  # XXX, tests fail
  doCheck = false;

  src = fetchurl {
    url = "https://github.com/quodlibet/quodlibet/releases/download/release-${version}/quodlibet-${version}.tar.gz";
    sha256 = "d2b42df5d439213973dc97149fddc779a6c90cec389c24baf1c0bdcc39ffe591";
  };

  nativeBuildInputs = [ wrapGAppsHook gettext intltool ];
  # ++ (with python2Packages; [ pytest pyflakes pycodestyle polib ]); # test deps

  buildInputs = [ gnome3.defaultIconTheme libsoup webkitgtk keybinder3 gtksourceview libmodplug libappindicator-gtk3 kakasi ]
    ++ (if xineBackend then [ xineLib ] else with gst_all_1;
    [ gstreamer gst-plugins-base ] ++ optionals withGstPlugins [ gst-plugins-good gst-plugins-ugly gst-plugins-bad ]);

  propagatedBuildInputs = with python2Packages;
    [ pygobject3 pycairo mutagen pygtk gst-python feedparser faulthandler futures ]
      ++ optionals withDbusPython [ dbus-python ]
      ++ optionals withPyInotify [ pyinotify ]
      ++ optionals withMusicBrainzNgs [ musicbrainzngs ]
      ++ optionals stdenv.isDarwin [ pyobjc ]
      ++ optionals withPahoMqtt [ paho-mqtt ];

  makeWrapperArgs = optionals (kakasi != null) [ "--prefix PATH : ${kakasi}/bin" ];

  meta = {
    description = "GTK+-based audio player written in Python, using the Mutagen tagging library";
    license = stdenv.lib.licenses.gpl2;

    longDescription = ''
      Quod Libet is a GTK+-based audio player written in Python, using
      the Mutagen tagging library. It's designed around the idea that
      you know how to organize your music better than we do. It lets
      you make playlists based on regular expressions (don't worry,
      regular searches work too). It lets you display and edit any
      tags you want in the file. And it lets you do this for all the
      file formats it supports. Quod Libet easily scales to libraries
      of thousands (or even tens of thousands) of songs. It also
      supports most of the features you expect from a modern media
      player, like Unicode support, tag editing, Replay Gain, podcasts
      & internet radio, and all major audio formats.
    '';

    maintainers = with stdenv.lib.maintainers; [ coroa sauyon ];
    homepage = https://quodlibet.readthedocs.io/en/latest/;
  };
}

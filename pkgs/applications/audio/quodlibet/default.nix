{ stdenv, fetchurl, python3, wrapGAppsHook, gettext, libsoup, gnome3, gtk3, gdk-pixbuf,
  tag ? "", xvfb_run, dbus, glibcLocales, glib, glib-networking, gobject-introspection,
  gst_all_1, withGstPlugins ? true,
  xineBackend ? false, xineLib,
  withDbusPython ? false, withPyInotify ? false, withMusicBrainzNgs ? false, withPahoMqtt ? false,
  webkitgtk ? null,
  keybinder3 ? null, gtksourceview ? null, libmodplug ? null, kakasi ? null, libappindicator-gtk3 ? null }:

let optionals = stdenv.lib.optionals; in
python3.pkgs.buildPythonApplication rec {
  pname = "quodlibet${tag}";
  version = "4.2.1";

  src = fetchurl {
    url = "https://github.com/quodlibet/quodlibet/releases/download/release-${version}/quodlibet-${version}.tar.gz";
    sha256 = "0b1rvr4hqs2bjmhayms7vxxkn3d92k9v7p1269rjhf11hpk122l7";
  };

  nativeBuildInputs = [ wrapGAppsHook gettext ];

  checkInputs = [ gdk-pixbuf ] ++ (with python3.pkgs; [ pytest pytest_xdist polib xvfb_run dbus.daemon glibcLocales ]);

  buildInputs = [ gnome3.adwaita-icon-theme libsoup glib glib-networking gtk3 webkitgtk gdk-pixbuf keybinder3 gtksourceview libmodplug libappindicator-gtk3 kakasi gobject-introspection ]
    ++ (if xineBackend then [ xineLib ] else with gst_all_1;
    [ gstreamer gst-plugins-base ] ++ optionals withGstPlugins [ gst-plugins-good gst-plugins-ugly gst-plugins-bad ]);

  propagatedBuildInputs = with python3.pkgs; [ pygobject3 pycairo mutagen gst-python feedparser ]
      ++ optionals withDbusPython [ dbus-python ]
      ++ optionals withPyInotify [ pyinotify ]
      ++ optionals withMusicBrainzNgs [ musicbrainzngs ]
      ++ optionals stdenv.isDarwin [ pyobjc ]
      ++ optionals withPahoMqtt [ paho-mqtt ];

  LC_ALL = "en_US.UTF-8";

  pytestFlags = stdenv.lib.optionals (xineBackend || !withGstPlugins) [
    "--ignore=tests/plugin/test_replaygain.py"
  ] ++ [
    # upstream does actually not enforce source code linting
    "--ignore=tests/quality"
    # build failure on Arch Linux
    # https://github.com/NixOS/nixpkgs/pull/77796#issuecomment-575841355
    "--ignore=tests/test_operon.py"
  ];

  checkPhase = ''
    runHook preCheck
    env XDG_DATA_DIRS="$out/share:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_ICON_DIRS:$XDG_DATA_DIRS" \
      HOME=$(mktemp -d) \
      xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
        --config-file=${dbus.daemon}/share/dbus-1/session.conf \
        py.test $pytestFlags
    runHook postCheck
  '';

  preFixup = stdenv.lib.optionalString (kakasi != null) "gappsWrapperArgs+=(--prefix PATH : ${kakasi}/bin)";

  meta = with stdenv.lib; {
    description = "GTK-based audio player written in Python, using the Mutagen tagging library";
    license = licenses.gpl2Plus;

    longDescription = ''
      Quod Libet is a GTK-based audio player written in Python, using
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

    maintainers = with maintainers; [ coroa sauyon ];
    homepage = https://quodlibet.readthedocs.io/en/latest/;
  };
}

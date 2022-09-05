{ lib, fetchurl, python3, wrapGAppsHook, gettext, libsoup, gnome, gtk3, gdk-pixbuf, librsvg,
  tag ? "", xvfb-run, dbus, glibcLocales, glib, glib-networking, gobject-introspection, hicolor-icon-theme,
  gst_all_1, withGstPlugins ? true,
  xineBackend ? false, xine-lib,
  withDbusPython ? false, withPyInotify ? false, withMusicBrainzNgs ? false, withPahoMqtt ? false,
  webkitgtk ? null,
  keybinder3 ? null, gtksourceview ? null, libmodplug ? null, kakasi ? null, libappindicator-gtk3 ? null }:

let optionals = lib.optionals; in
python3.pkgs.buildPythonApplication rec {
  pname = "quodlibet${tag}";
  version = "4.5.0";

  src = fetchurl {
    url = "https://github.com/quodlibet/quodlibet/releases/download/release-${version}/quodlibet-${version}.tar.gz";
    sha256 = "sha256-MBYVgp9lLLr+2zVTkjcWKli8HucaVn0kn3eJ2SaCRbw=";
  };

  nativeBuildInputs = [ wrapGAppsHook gettext ];

  checkInputs = [ gdk-pixbuf hicolor-icon-theme ] ++ (with python3.pkgs; [ pytest pytest-xdist polib xvfb-run dbus.daemon glibcLocales ]);

  buildInputs = [ gnome.adwaita-icon-theme libsoup glib glib-networking gtk3 webkitgtk gdk-pixbuf keybinder3 gtksourceview libmodplug libappindicator-gtk3 kakasi gobject-introspection ]
    ++ (if xineBackend then [ xine-lib ] else with gst_all_1;
    [ gstreamer gst-plugins-base ] ++ optionals withGstPlugins [ gst-plugins-good gst-plugins-ugly gst-plugins-bad ]);

  propagatedBuildInputs = with python3.pkgs; [ pygobject3 pycairo mutagen gst-python feedparser ]
      ++ optionals withDbusPython [ dbus-python ]
      ++ optionals withPyInotify [ pyinotify ]
      ++ optionals withMusicBrainzNgs [ musicbrainzngs ]
      ++ optionals withPahoMqtt [ paho-mqtt ];

  LC_ALL = "en_US.UTF-8";

  pytestFlags = lib.optionals (xineBackend || !withGstPlugins) [
    "--ignore=tests/plugin/test_replaygain.py"
  ] ++ [
    # requires networking
    "--ignore=tests/test_browsers_iradio.py"
    # the default theme doesn't have the required icons
    "--ignore=tests/plugin/test_trayicon.py"
    # upstream does actually not enforce source code linting
    "--ignore=tests/quality"
    # build failure on Arch Linux
    # https://github.com/NixOS/nixpkgs/pull/77796#issuecomment-575841355
    "--ignore=tests/test_operon.py"
  ];

  checkPhase = ''
    runHook preCheck
    # otherwise tests can't find the app icons; instead of creating index.theme from scratch
    # I re-used the one from hicolor-icon-theme which seems to work
    cp "${hicolor-icon-theme}/share/icons/hicolor/index.theme" quodlibet/images/hicolor
    env XDG_DATA_DIRS="$out/share:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_ICON_DIRS:$XDG_DATA_DIRS" \
      GDK_PIXBUF_MODULE_FILE=${librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache \
      HOME=$(mktemp -d) \
      xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
        --config-file=${dbus.daemon}/share/dbus-1/session.conf \
        py.test $pytestFlags
    runHook postCheck
  '';

  preFixup = lib.optionalString (kakasi != null) "gappsWrapperArgs+=(--prefix PATH : ${kakasi}/bin)";

  meta = with lib; {
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

    maintainers = with maintainers; [ coroa pbogdan ];
    homepage = "https://quodlibet.readthedocs.io/en/latest/";
  };
}

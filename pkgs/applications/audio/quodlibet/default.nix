{ lib
, fetchFromGitHub
, fetchpatch
, tag ? ""

# build time
, gettext
, gobject-introspection
, wrapGAppsHook

# runtime
, adwaita-icon-theme
, gdk-pixbuf
, glib
, glib-networking
, gtk3
, gtksourceview
, kakasi
, keybinder3
, libappindicator-gtk3
, libmodplug
, librsvg
, libsoup
, webkitgtk

# optional features
, withDbusPython ? false
, withPypresence ? false
, withPyInotify ? false
, withMusicBrainzNgs ? false
, withPahoMqtt ? false
, withSoco ? false

# backends
, withGstreamerBackend ? true, gst_all_1
, withGstPlugins ? withGstreamerBackend
, withXineBackend ? true, xine-lib

# tests
, dbus
, glibcLocales
, hicolor-icon-theme
, python3
, xvfb-run
}:

python3.pkgs.buildPythonApplication rec {
  pname = "quodlibet${tag}";
  version = "4.5.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "quodlibet";
    repo = "quodlibet";
    rev = "refs/tags/release-${version}";
    hash = "sha256-G6zcdnHkevbVCrMoseWoSia5ajEor8nZhee6NeZIs8Q=";
  };

  patches = [
    (fetchpatch {
      # Fixes cover globbing under python 3.10.5+
      url = "https://github.com/quodlibet/quodlibet/commit/5eb7c30766e1dcb30663907664855ee94a3accc0.patch";
      hash = "sha256-bDyEOE7Vs4df4BeN4QMvt6niisVEpvc1onmX5rtoAWc=";
    })
  ];

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    gettext
    gobject-introspection
    wrapGAppsHook
  ] ++ (with python3.pkgs; [
    sphinxHook
    sphinx-rtd-theme
  ]);

  buildInputs = [
    adwaita-icon-theme
    gdk-pixbuf
    glib
    glib-networking
    gtk3
    gtksourceview
    kakasi
    keybinder3
    libappindicator-gtk3
    libmodplug
    libsoup
    webkitgtk
  ] ++ lib.optionals (withXineBackend) [
    xine-lib
  ] ++ lib.optionals (withGstreamerBackend) (with gst_all_1; [
    gst-plugins-base
    gstreamer
  ] ++ lib.optionals (withGstPlugins) [
    gst-libav
    gst-plugins-bad
    gst-plugins-good
    gst-plugins-ugly
  ]);

  propagatedBuildInputs = with python3.pkgs; [
    feedparser
    gst-python
    mutagen
    pycairo
    pygobject3
  ]
  ++ lib.optionals withDbusPython [ dbus-python ]
  ++ lib.optionals withPypresence [ pypresence ]
  ++ lib.optionals withPyInotify [ pyinotify ]
  ++ lib.optionals withMusicBrainzNgs [ musicbrainzngs ]
  ++ lib.optionals withPahoMqtt [ paho-mqtt ]
  ++ lib.optionals withSoco [ soco ];

  LC_ALL = "en_US.UTF-8";

  checkInputs = [
    dbus
    gdk-pixbuf
    glibcLocales
    hicolor-icon-theme
    xvfb-run
  ] ++ (with python3.pkgs; [
    polib
    pytest
    pytest-xdist
  ]);

  pytestFlags = [
    # requires networking
    "--deselect=tests/test_browsers_iradio.py::TIRFile::test_download_tags"
    # missing translation strings in potfiles
    "--deselect=tests/test_po.py::TPOTFILESIN::test_missing"
    # upstream does actually not enforce source code linting
    "--ignore=tests/quality"
    # build failure on Arch Linux
    # https://github.com/NixOS/nixpkgs/pull/77796#issuecomment-575841355
    "--ignore=tests/test_operon.py"
  ] ++ lib.optionals (withXineBackend || !withGstPlugins) [
    "--ignore=tests/plugin/test_replaygain.py"
  ];

  preCheck = ''
    export XDG_DATA_DIRS="$out/share:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_ICON_DIRS:$XDG_DATA_DIRS"
    export GDK_PIXBUF_MODULE_FILE=${librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache
    export HOME=$(mktemp -d)
  '';

  checkPhase = ''
    runHook preCheck

    xvfb-run -s '-screen 0 1920x1080x24' \
      dbus-run-session --config-file=${dbus}/share/dbus-1/session.conf \
      pytest $pytestFlags

    runHook postCheck
  '';

  preFixup = lib.optionalString (kakasi != null) ''
    gappsWrapperArgs+=(--prefix PATH : ${kakasi}/bin)
  '';

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

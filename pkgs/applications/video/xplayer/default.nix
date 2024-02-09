{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, autoconf-archive
, clutter-gst
, clutter-gtk
, gettext
, glib
, gobject-introspection
, gst-plugins-bad
, gst-plugins-base
, gst-plugins-good
, gstreamer
, gtk-doc
, gtk3
, intltool
, itstool
, libpeas
, libxml2
, libxplayer-plparser
, pkg-config
, python3
, wrapGAppsHook
, xapp
, yelp-tools }:

stdenv.mkDerivation rec {
  pname = "xplayer";
  version = "2.4.4";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "sha256-o2vLNIELd1EYWG26t5gOpnamJrBJeg4P6fcLirkcmfM=";
  };

  # configure wants to find gst-inspect-1.0 via pkgconfig but
  # the gstreamer toolsdir points to the wrong derivation output
  postPatch = ''
    substituteInPlace configure.ac \
                      --replace '$gst10_toolsdir/gst-inspect-1.0' '${gstreamer}/bin/gst-inspect-1.0' \
  '';

  preBuild = ''
    makeFlagsArray+=(
      "INCLUDES=-I${glib.dev}/include/gio-unix-2.0"
      "CFLAGS=-Wno-error" # Otherwise a lot of deprecated warnings are treated as error
    )
  '';

  nativeBuildInputs = [
    autoreconfHook
    wrapGAppsHook
    autoconf-archive
    gettext
    gtk-doc
    intltool
    itstool
    pkg-config
    python3.pkgs.wrapPython
    yelp-tools
    gobject-introspection
  ];

  buildInputs = [
    clutter-gst
    clutter-gtk
    glib
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gstreamer
    gtk3
    libpeas
    libxml2
    libxplayer-plparser
    python3
    xapp
    # to satisfy configure script
    python3.pkgs.pygobject3
  ];

  postFixup = ''
    buildPythonPath ${python3.pkgs.dbus-python}
    patchPythonScript $out/lib/xplayer/plugins/dbus/dbusservice.py
  '';

  meta = with lib; {
    description = "A generic media player from Linux Mint";
    license = with licenses; [ gpl2Plus lgpl21Plus ];
    homepage = "https://github.com/linuxmint/xplayer";
    maintainers = with maintainers; [ tu-maurice bobby285271 ];
    platforms = platforms.linux;
  };
}

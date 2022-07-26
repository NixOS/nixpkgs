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
, xapps
, yelp-tools }:

let
  pythonenv = python3.withPackages (ps: [
    ps.pygobject3
    ps.dbus-python # For one plugin
  ]);
in

stdenv.mkDerivation rec {
  pname = "xplayer";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "sha256-qoBJKY0CZyhp9foUehq5hInEENRGZuy1D6jAMjbjYhA=";
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
    yelp-tools
  ];

  buildInputs = [
    clutter-gst
    clutter-gtk
    glib
    gobject-introspection
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gstreamer
    gtk3
    libpeas
    libxml2
    libxplayer-plparser
    pythonenv
    xapps
    # to satisfy configure script
    pythonenv.pkgs.pygobject3
  ];

  postInstall = ''
    wrapProgram $out/bin/xplayer \
                --prefix PATH : ${lib.makeBinPath [ pythonenv ]}
  '';

  meta = with lib; {
    description = "A generic media player from Linux Mint";
    license = with licenses; [ gpl2Plus lgpl21Plus ];
    homepage = "https://github.com/linuxmint/xplayer";
    maintainers = with maintainers; [ tu-maurice ];
    platforms = platforms.linux;
  };
}

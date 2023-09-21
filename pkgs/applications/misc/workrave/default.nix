{ lib
, stdenv
, fetchFromGitHub
, wrapGAppsHook
, autoconf
, autoconf-archive
, automake
, gettext
, intltool
, libtool
, pkg-config
, libICE
, libSM
, libXScrnSaver
, libXtst
, gobject-introspection
, glib
, glibmm
, gtkmm3
, atk
, pango
, pangomm
, cairo
, cairomm
, dbus
, dbus-glib
, gdome2
, gstreamer
, gst-plugins-base
, gst-plugins-good
, libsigcxx
, boost
, jinja2
}:

stdenv.mkDerivation rec {
  pname = "workrave";
  version = "1.10.51.1";

  src = fetchFromGitHub {
    repo = "workrave";
    owner = "rcaelers";
    rev = with lib;
      "v" + concatStringsSep "_" (splitVersion version);
    sha256 = "sha256-rx3k4U5igRYxzuVke+x926K1Pso32iGob4Ccp0jdKds=";
  };

  nativeBuildInputs = [
    autoconf
    autoconf-archive
    automake
    gettext
    intltool
    libtool
    pkg-config
    wrapGAppsHook
    jinja2
    gobject-introspection
  ];

  buildInputs = [
    libICE
    libSM
    libXScrnSaver
    libXtst
    glib
    glibmm
    gtkmm3
    atk
    pango
    pangomm
    cairo
    cairomm
    dbus
    dbus-glib
    gdome2
    gstreamer
    gst-plugins-base
    gst-plugins-good
    libsigcxx
    boost
  ];

  preConfigure = "./autogen.sh";

  enableParallelBuilding = true;

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "A program to help prevent Repetitive Strain Injury";
    longDescription = ''
      Workrave is a program that assists in the recovery and prevention of
      Repetitive Strain Injury (RSI). The program frequently alerts you to
      take micro-pauses, rest breaks and restricts you to your daily limit.
    '';
    homepage = "http://www.workrave.org/";
    downloadPage = "https://github.com/rcaelers/workrave/releases";
    license = licenses.gpl3;
    maintainers = with maintainers; [ prikhi ];
    platforms = platforms.linux;
  };
}

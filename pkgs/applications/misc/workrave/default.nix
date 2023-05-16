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
<<<<<<< HEAD
  version = "1.10.51.1";
=======
  version = "1.10.50";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    repo = "workrave";
    owner = "rcaelers";
    rev = with lib;
      "v" + concatStringsSep "_" (splitVersion version);
<<<<<<< HEAD
    sha256 = "sha256-rx3k4U5igRYxzuVke+x926K1Pso32iGob4Ccp0jdKds=";
=======
    sha256 = "sha256-fSUfgk0PmiteVQis+0NmMMZXBe/377X2k9oS2yp2Qzo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    gobject-introspection
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    libICE
    libSM
    libXScrnSaver
    libXtst
<<<<<<< HEAD
=======
    gobject-introspection
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, glib, dbus-glib
, desktopSupport, xlibs
, gtk2
, gtk3, gnome3, mate
, libxfce4util, xfce4-panel
}:

assert desktopSupport == "gnomeflashback" || desktopSupport == "mate"  || desktopSupport == "xfce4";

stdenv.mkDerivation rec {
  version = "unstable-2017-09-15";
  pname = "xmonad-log-applet";
  name = "${pname}-${desktopSupport}-${version}";

  src = fetchFromGitHub {
    owner = "kalj";
    repo = pname;
    rev = "a1b294cad2f266e4f18d9de34167fa96a0ffdba8";
    sha256 = "042307grf4zvn61gnflhsj5xsjykrk9sjjsprprm4iij0qpybxcw";
  };

  buildInputs = [ glib dbus-glib xlibs.xcbutilwm ]
    ++ stdenv.lib.optionals (desktopSupport == "gnomeflashback") [ gtk3 gnome3.gnome-panel ]
    ++ stdenv.lib.optionals (desktopSupport == "mate") [ gtk3 mate.mate-panel ]
    ++ stdenv.lib.optionals (desktopSupport == "xfce4") [ gtk2 libxfce4util xfce4-panel ]
  ;

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  configureFlags =  [ "--with-panel=${desktopSupport}" ];

  patches = [ ./fix-paths.patch ];

  # Setup hook replaces ${prefix} in pc files so we cannot use
  # --define-variable=prefix=$prefix
  PKG_CONFIG_LIBXFCE4PANEL_1_0_LIBDIR = "$(out)/lib";

  meta = with stdenv.lib; {
    homepage = https://github.com/kalj/xmonad-log-applet;
    license = licenses.bsd3;
    description = "An applet that will display XMonad log information (${desktopSupport} version)";
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}


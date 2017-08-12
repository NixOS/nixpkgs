{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, glib, dbus_glib
, desktopSupport
, gtk2, gnome2_panel, GConf2
, libxfce4util, xfce4panel
}:

assert desktopSupport == "gnome2" || desktopSupport == "gnome3" || desktopSupport == "xfce4";

stdenv.mkDerivation rec {
  version = "2.1.0";
  pname = "xmonad-log-applet";
  name = "${pname}-${version}-${desktopSupport}";

  src = fetchFromGitHub {
    owner = "alexkay";
    repo = pname;
    rev = "${version}";
    sha256 = "1g1fisyaw83v72b25fxfjln8f4wlw3rm6nyk27mrqlhsc1spnb5p";
  };

  buildInputs =  with stdenv.lib;
                 [ glib dbus_glib ]
              ++ optionals (desktopSupport == "gnome2") [ gtk2 gnome2_panel GConf2 ]
              # TODO: no idea where to find libpanelapplet-4.0
              ++ optionals (desktopSupport == "gnome3") [ ]
              ++ optionals (desktopSupport == "xfce4") [ gtk2 libxfce4util xfce4panel ]
              ;
  
  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  
  configureFlags =  [ "--with-panel=${desktopSupport}" ];
  
  patches = [ ./fix-paths.patch ];

  meta = with stdenv.lib; {
    homepage = http://github.com/alexkay/xmonad-log-applet;
    license = licenses.bsd3;
    description = "An applet that will display XMonad log information (${desktopSupport} version)";
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];

    broken = desktopSupport == "gnome3";
  };
}


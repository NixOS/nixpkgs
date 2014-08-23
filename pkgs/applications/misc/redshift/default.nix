{ fetchurl, stdenv, libX11, libXrandr, libXxf86vm, libxcb, pkgconfig, python
, randrproto, xcbutil, xf86vidmodeproto, autoconf, automake, gettext, glib
, GConf, dbus, dbus_glib, makeWrapper, gtk, pygtk, pyxdg, geoclue }:

stdenv.mkDerivation rec {
  version = "1.8";
  name = "redshift-${version}";
  src = fetchurl {
    url = "https://github.com/jonls/redshift/archive/v${version}.tar.gz";
    sha256 = "1srj2dwy32h71iqikb4ysv5ipclym80i9lys2ns8vjmclg7hj3vi";
  };

  buildInputs = [
    libX11 libXrandr libXxf86vm libxcb pkgconfig python randrproto xcbutil
    xf86vidmodeproto autoconf automake gettext glib GConf dbus dbus_glib
    makeWrapper gtk pygtk pyxdg geoclue
  ];

  preConfigure = ''
    ./bootstrap
  '';

  preInstall = ''
    substituteInPlace src/redshift-gtk/redshift-gtk python --replace "/usr/bin/env python" "${python}/bin/${python.executable}"
  '';

  postInstall = ''
    wrapProgram "$out/bin/redshift-gtk" --prefix PYTHONPATH : $PYTHONPATH:${pygtk}/lib/${python.libPrefix}/site-packages/gtk-2.0:${pyxdg}/lib/${python.libPrefix}/site-packages/pyxdg:$out/lib/${python.libPrefix}/site-packages
  '';

  meta = with stdenv.lib; {
    description = "changes the color temperature of your screen gradually";
    longDescription = ''
      The color temperature is set according to the position of the
      sun. A different color temperature is set during night and
      daytime. During twilight and early morning, the color
      temperature transitions smoothly from night to daytime
      temperature to allow your eyes to slowly adapt.
      '';
    license = stdenv.lib.licenses.gpl3Plus;
    homepage = "http://jonls.dk/redshift";
    platforms = platforms.linux;
    maintainers = maintainers.mornfall;
  }; 
}

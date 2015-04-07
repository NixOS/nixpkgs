{ fetchurl, stdenv, libX11, libXrandr, libXxf86vm, libxcb, pkgconfig, python3
, randrproto, xcbutil, xf86vidmodeproto, autoconf, automake, libtool, intltool, gettext
, glib, GConf, dbus, dbus_glib, makeWrapper, geoclue, pygobject3, pyxdg, gtk3 }:

stdenv.mkDerivation rec {
  version = "1.10";
  name = "redshift-${version}";
  src = fetchurl {
    url = "https://github.com/jonls/redshift/archive/v${version}.tar.gz";
    sha256 = "f7a1ca1eccf662995737e14f894c2b15193923fbbe378d151e346a8013644f16";
  };

  buildInputs = [
    libX11 libXrandr libXxf86vm libxcb pkgconfig python3 randrproto xcbutil
    xf86vidmodeproto autoconf automake libtool intltool gettext glib GConf dbus dbus_glib
    makeWrapper geoclue pygobject3 gtk3
  ];

  preConfigure = ''
    ./bootstrap
  '';

  configureFlags = ''--enable-gui=yes'';

  preInstall = ''
    substituteInPlace src/redshift-gtk/redshift-gtk python --replace "/usr/bin/env python3" "${python3}/bin/${python3.executable}"
  '';

  postInstall = ''
    wrapProgram "$out/bin/redshift-gtk" --prefix PYTHONPATH : $PYTHONPATH:${pygobject3}/lib/${python3.libPrefix}/site-packages/gi:${pyxdg}/lib/${python3.libPrefix}/site-packages/pyxdg:$out/lib/${python3.libPrefix}/site-packages
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
    homepage = http://jonls.dk/redshift;
    platforms = platforms.linux;
    maintainers = [ maintainers.mornfall ];
  }; 
}

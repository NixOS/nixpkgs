{stdenv, fetchurl, cmake, pkgconfig
, libXrender, renderproto, gtk, libwnck, pango, cairo
, GConf, libXdamage, damageproto, libxml2, libxslt, glibmm
, libstartup_notification, libpthreadstubs, libxcb, intltool
, ORBit2, libXau
, dbus, dbus_glib, librsvg, mesa
, libXdmcp, libnotify, python
, hicolor_icon_theme, libjpeg_turbo, libsigcxx, protobuf, pygtk, pythonDBus
, xdg_utils
, gettext, boost, pyrex
, makeWrapper
}:
let
  s = # Generated upstream information
  rec {
    baseName="compiz";
    version="0.9.8.6";
    name="compiz-0.9.8.6";
    hash="0agz5s11lwrkhk3svz3rwimlb6318ln3zcywlzczwks139svxnk6";
    url="https://launchpad.net/compiz/0.9.8/0.9.8.6/+download/compiz-0.9.8.6.tar.bz2";
    sha256="0agz5s11lwrkhk3svz3rwimlb6318ln3zcywlzczwks139svxnk6";
  };
  buildInputs = [cmake pkgconfig
    libXrender renderproto gtk libwnck pango cairo
    GConf libXdamage damageproto libxml2 libxslt glibmm libstartup_notification
    libpthreadstubs libxcb intltool
    ORBit2 libXau
    dbus dbus_glib librsvg mesa
    libXdmcp libnotify python
    hicolor_icon_theme libjpeg_turbo libsigcxx protobuf pygtk pythonDBus
    xdg_utils
    gettext boost pyrex
    makeWrapper 
    ];
  in
stdenv.mkDerivation rec {
  inherit (s) name version;
  src = fetchurl {
    inherit (s) url sha256;
  };
  inherit buildInputs;

  NIX_CFLAGS_COMPILE=" -Wno-error ";
  postInstall = ''
    wrapProgram "$out/bin/ccsm" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix PYTHONPATH : "$out/lib/${python.libPrefix}/site-packages"
  '';

  meta = {
    description = "Compoziting window manager";
    homepage = "http://launchpad.net/compiz/";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    inherit (s) version;
  };
}

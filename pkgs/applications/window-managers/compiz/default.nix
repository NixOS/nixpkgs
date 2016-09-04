{ stdenv, fetchurl, cmake, pkgconfig
, libXrender, renderproto, gtk, libwnck, pango, cairo
, GConf, libXdamage, damageproto, libxml2, libxslt, glibmm
, metacity
, libstartup_notification, libpthreadstubs, libxcb, intltool
, ORBit2, libXau, libICE, libSM
, dbus, dbus_glib, librsvg, mesa
, libXdmcp, libnotify, pythonPackages
, hicolor_icon_theme, libjpeg_turbo, libsigcxx, protobuf
, xdg_utils
, gettext, boost, pyrex
, makeWrapper
}:
let
  inherit (pythonPackages) python dbus-python pygtk;

  s = # Generated upstream information
  rec {
    baseName="compiz";
    version="0.9.13.0";
    name="${baseName}-${version}";
    hash="00m73im5kdpbfjg9ryzxnab5qvx5j51gxwr3wzimkrcbax6vb3ph";
    url="https://launchpad.net/compiz/0.9.13/0.9.13.0/+download/compiz-0.9.13.0.tar.bz2";
    sha256="00m73im5kdpbfjg9ryzxnab5qvx5j51gxwr3wzimkrcbax6vb3ph";
  };
  buildInputs = [cmake pkgconfig
    libXrender renderproto gtk libwnck pango cairo
    GConf libXdamage damageproto libxml2 libxslt glibmm libstartup_notification
    metacity
    libpthreadstubs libxcb intltool
    ORBit2 libXau libICE libSM
    dbus dbus_glib librsvg mesa
    libXdmcp libnotify python
    hicolor_icon_theme libjpeg_turbo libsigcxx protobuf pygtk dbus-python
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

  NIX_CFLAGS_COMPILE = " -Wno-error ";
  NIX_CFLAGS_LINK = "-lm -ldl -pthread -lutil";
  postInstall = ''
    wrapProgram "$out/bin/ccsm" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix PYTHONPATH : "$out/lib/${python.libPrefix}/site-packages"
  '';

  # automatic moving fails, perhaps due to having two $out/lib*/pkgconfig
  dontMoveLib64 = true;

  meta = {
    description = "Compoziting window manager";
    homepage = "http://launchpad.net/compiz/";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    inherit (s) version;
  };
}

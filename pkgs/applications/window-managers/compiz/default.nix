{ stdenv, fetchurl, cmake, pkgconfig
, libXrender, renderproto, gtk2, libwnck, pango, cairo
, GConf, libXdamage, damageproto, libxml2, libxslt, glibmm
, metacity
, libstartup_notification, libpthreadstubs, libxcb, intltool
, ORBit2, libXau, libICE, libSM
, dbus, dbus_glib, librsvg, mesa
, libXdmcp, libnotify, python2Packages
, hicolor_icon_theme, libjpeg_turbo, libsigcxx, protobuf
, xdg_utils
, gettext, boost, pyrex
, makeWrapper
}:
let
  # FIXME: Use python.withPackages so we can get rid of PYTHONPATH wrapper
  inherit (python2Packages) python dbus-python pygtk;

  s = # Generated upstream information
  rec {
    baseName="compiz";
    version="0.9.13.1";
    name="${baseName}-${version}";
    hash="1grc4a4gc662hjs5adzdd3zlgsg1rh1wqm9aanbs8wm0l8mq0m4q";
    url="https://launchpad.net/compiz/0.9.13/0.9.13.1/+download/compiz-0.9.13.1.tar.bz2";
    sha256="1grc4a4gc662hjs5adzdd3zlgsg1rh1wqm9aanbs8wm0l8mq0m4q";
  };
  buildInputs = [cmake pkgconfig
    libXrender renderproto gtk2 libwnck pango cairo
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
    homepage = https://launchpad.net/compiz/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    inherit (s) version;
  };
}

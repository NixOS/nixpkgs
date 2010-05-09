{stdenv, fetchurl, xz, cmake, gperf, imagemagick, pkgconfig, lua
, glib, cairo, pango, imlib2, libxcb, libxdg_basedir, xcbutil
, libstartup_notification, libev, asciidoc, xmlto, dbus, docbook_xsl
, docbook_xml_dtd_45, libxslt, coreutils}:

stdenv.mkDerivation rec {
  name = "awesome-3.4.4";
 
  src = fetchurl {
    url = http://awesome.naquadah.org/download/awesome-3.4.4.tar.xz;
    sha256 = "1d1ida8mznn02pzj2kfh6m59mwrz8vk1cy66npgyfpzyrv8a558y";
  };
 
  buildInputs = [ xz cmake gperf imagemagick pkgconfig lua glib cairo pango
    imlib2 libxcb libxdg_basedir xcbutil libstartup_notification libev
    asciidoc xmlto dbus docbook_xsl docbook_xml_dtd_45 libxslt ];

  # We use coreutils for 'env', that will allow then finding 'bash' or 'zsh' in
  # the awesome lua code. I prefered that instead of adding 'bash' or 'zsh' as
  # dependencies.
  patchPhase = ''
    # Fix the tab completion (supporting bash or zsh)
    sed s,/usr/bin/env,${coreutils}/bin/env, -i lib/awful/completion.lua.in
    # Remove the 'root' PATH override (I don't know why they have that)
    sed /WHOAMI/d -i utils/awsetbg
  '';

  # Somehow libev does not get into the rpath, although it should.
  # Something may be wrong in the gcc wrapper.
  preBuild = ''
    export NIX_LDFLAGS_BEFORE="-lev";
  '';

  # Cmake fails strangely at finding lua. Looks to me like a cmake 2.8 error.
  cmakeFlags = [ "-DLUA_LIBRARIES=${lua}/lib/liblua.a" ];
 
  meta = {
    homepage = http://awesome.naquadah.org/;
    description = "Highly configurable, dynamic window manager for X";
    license = "GPLv2+";
  };
}

{ stdenv, fetchurl, lua, cairo, cmake, imagemagick, pkgconfig, gdk_pixbuf
, xlibs, libstartup_notification, libxdg_basedir, libpthreadstubs
, xcb-util-cursor, lgi, makeWrapper, pango, gobjectIntrospection, unclutter
, compton, procps, iproute, coreutils, curl, alsaUtils, findutils, rxvt_unicode
, which, dbus, nettools, git, asciidoc, doxygen }:

let
  version = "3.5.2";
in

stdenv.mkDerivation rec {
  name = "awesome-${version}";
 
  src = fetchurl {
    url    = "http://awesome.naquadah.org/download/awesome-${version}.tar.xz";
    sha256 = "11iya03yzr8sa3snmywlw22ayg0d3dcy49pi8fz0bycf5aq6b38q";
  };

  meta = with stdenv.lib; {
    description = "Highly configurable, dynamic window manager for X";
    homepage    = http://awesome.naquadah.org/;
    license     = "GPLv2+";
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.linux;
  };
 
  buildInputs = [
    asciidoc
    cairo
    cmake
    dbus
    doxygen
    gdk_pixbuf
    git
    imagemagick
    lgi
    libpthreadstubs
    libstartup_notification
    libxdg_basedir
    lua
    makeWrapper
    nettools
    pango
    pkgconfig
    xcb-util-cursor
    xlibs.libXau
    xlibs.libXdmcp
    xlibs.libxcb
    xlibs.xcbutil
    xlibs.xcbutilimage
    xlibs.xcbutilkeysyms
    xlibs.xcbutilrenderutil
    xlibs.xcbutilwm
  ];

  AWESOME_IGNORE_LGI = 1;

  LUA_CPATH = "${lgi}/lib/lua/5.1/?.so";
  LUA_PATH  = "${lgi}/share/lua/5.1/?.lua;${lgi}/share/lua/5.1/lgi/?.lua";

  postInstall = ''
    wrapProgram $out/bin/awesome \
      --set LUA_CPATH '"${lgi}/lib/lua/5.1/?.so"' \
      --set LUA_PATH '"${lgi}/share/lua/5.1/?.lua;${lgi}/share/lua/5.1/lgi/?.lua"' \
      --set GI_TYPELIB_PATH "${pango}/lib/girepository-1.0" \
      --set LD_LIBRARY_PATH "${cairo}/lib:${pango}/lib:${gobjectIntrospection}/lib" \
      --prefix PATH : "${compton}/bin:${unclutter}/bin:${procps}/bin:${iproute}/sbin:${coreutils}/bin:${curl}/bin:${alsaUtils}/bin:${findutils}/bin:${rxvt_unicode}/bin"

    wrapProgram $out/bin/awesome-client \
      --prefix PATH : "${which}/bin"
  '';
}

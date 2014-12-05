{ stdenv, fetchurl, lua, cairo, cmake, imagemagick, pkgconfig, gdk_pixbuf
, xlibs, libstartup_notification, libxdg_basedir, libpthreadstubs
, xcb-util-cursor, lgi, makeWrapper, pango, gobjectIntrospection, unclutter
, compton, procps, iproute, coreutils, curl, alsaUtils, findutils, rxvt_unicode
, which, dbus, nettools, git, asciidoc, doxygen, xmlto, docbook_xml_dtd_45
, docbook_xsl }:

let
  version = "3.5.5";
in

stdenv.mkDerivation rec {
  name = "awesome-${version}";
 
  src = fetchurl {
    url    = "http://awesome.naquadah.org/download/awesome-${version}.tar.xz";
    sha256 = "0iwd4pjvq0akm9dbipbl4m4fm24m017l06arasr445v2qkbxnc5z";
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
    xlibs.libxshmfence
    xlibs.xcbutil
    xlibs.xcbutilimage
    xlibs.xcbutilkeysyms
    xlibs.xcbutilrenderutil
    xlibs.xcbutilwm
    xmlto docbook_xml_dtd_45 docbook_xsl
  ];

  cmakeFlags = "-DGENERATE_MANPAGES=ON";

  LD_LIBRARY_PATH = "${cairo}/lib:${pango}/lib:${gobjectIntrospection}/lib";
  GI_TYPELIB_PATH = "${pango}/lib/girepository-1.0";
  LUA_CPATH = "${lgi}/lib/lua/5.1/?.so";
  LUA_PATH  = "${lgi}/share/lua/5.1/?.lua;${lgi}/share/lua/5.1/lgi/?.lua";

  postInstall = ''
    wrapProgram $out/bin/awesome \
      --set LUA_CPATH '"${lgi}/lib/lua/5.1/?.so"' \
      --set LUA_PATH '"${lgi}/share/lua/5.1/?.lua;${lgi}/share/lua/5.1/lgi/?.lua"' \
      --set GI_TYPELIB_PATH "${pango}/lib/girepository-1.0" \
      --prefix LD_LIBRARY_PATH : "${cairo}/lib:${pango}/lib:${gobjectIntrospection}/lib" \
      --prefix PATH : "${compton}/bin:${unclutter}/bin:${procps}/bin:${iproute}/sbin:${coreutils}/bin:${curl}/bin:${alsaUtils}/bin:${findutils}/bin:${rxvt_unicode}/bin"

    wrapProgram $out/bin/awesome-client \
      --prefix PATH : "${which}/bin"
  '';
}

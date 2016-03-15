{ stdenv, fetchurl, luaPackages, cairo, cmake, imagemagick, pkgconfig, gdk_pixbuf
, xorg, libstartup_notification, libxdg_basedir, libpthreadstubs
, xcb-util-cursor, makeWrapper, pango, gobjectIntrospection, unclutter
, compton, procps, iproute, coreutils, curl, alsaUtils, findutils, xterm
, which, dbus, nettools, git, asciidoc, doxygen
#, xmlto, docbook_xml_dtd_45 , docbook_xsl
}:

let
  version = "3.5.9";
in with luaPackages;

stdenv.mkDerivation rec {
  name = "awesome-${version}";

  src = fetchurl {
    url    = "http://awesome.naquadah.org/download/awesome-${version}.tar.xz";
    sha256 = "0kynair1ykr74b39a4gcm2y24viial64337cf26nhlc7azjbby67";
  };

  meta = with stdenv.lib; {
    description = "Highly configurable, dynamic window manager for X";
    homepage    = http://awesome.naquadah.org/;
    license     = licenses.gpl2Plus;
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
    gobjectIntrospection
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
    xorg.libXau
    xorg.libXdmcp
    xorg.libxcb
    xorg.libxshmfence
    xorg.xcbutil
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.xcbutilwm
    #xmlto docbook_xml_dtd_45 docbook_xsl
  ];

  #cmakeFlags = "-DGENERATE_MANPAGES=ON";

  LD_LIBRARY_PATH = "${cairo}/lib:${pango}/lib:${gobjectIntrospection}/lib";
  GI_TYPELIB_PATH = "${pango}/lib/girepository-1.0";
  LUA_CPATH = "${lgi}/lib/lua/${lua.luaversion}/?.so";
  LUA_PATH  = "${lgi}/share/lua/${lua.luaversion}/?.lua;${lgi}/share/lua/${lua.luaversion}/lgi/?.lua";

  postInstall = ''
    wrapProgram $out/bin/awesome \
      --prefix LUA_CPATH ";" '"${lgi}/lib/lua/${lua.luaversion}/?.so"' \
      --prefix LUA_PATH ";" '"${lgi}/share/lua/${lua.luaversion}/?.lua;${lgi}/share/lua/${lua.luaversion}/lgi/?.lua"' \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix LD_LIBRARY_PATH : "${cairo}/lib:${pango}/lib:${gobjectIntrospection}/lib" \
      --prefix PATH : "${compton}/bin:${unclutter}/bin:${procps}/bin:${iproute}/sbin:${coreutils}/bin:${curl}/bin:${alsaUtils}/bin:${findutils}/bin:${xterm}/bin"

    wrapProgram $out/bin/awesome-client \
      --prefix PATH : "${which}/bin"
  '';

  passthru = {
    inherit lua;
  };
}

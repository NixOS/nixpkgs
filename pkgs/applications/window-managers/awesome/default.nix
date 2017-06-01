{ stdenv, fetchurl, fetchFromGitHub, luaPackages, cairo, librsvg, cmake, imagemagick, pkgconfig, gdk_pixbuf
, xorg, libstartup_notification, libxdg_basedir, libpthreadstubs
, xcb-util-cursor, makeWrapper, pango, gobjectIntrospection, unclutter
, compton, procps, iproute, coreutils, curl, alsaUtils, findutils, xterm
, which, dbus, nettools, git, asciidoc, doxygen
, xmlto, docbook_xml_dtd_45, docbook_xsl, findXMLCatalogs
, libxkbcommon, xcbutilxrm, hicolor_icon_theme
}:

with luaPackages; stdenv.mkDerivation rec {
  name = "awesome-${version}";
  version = "4.1";
  
  src = fetchFromGitHub {
    owner = "awesomewm";
    repo = "awesome";
    rev = "v${version}";
    sha256 = "1qik8h5nwjq4535lpdpal85vas1k7am3s6l5r763kpdzxhfcyyaj";
  };

  nativeBuildInputs = [
    asciidoc
    cmake
    doxygen
    imagemagick
    makeWrapper
    pkgconfig
    xmlto docbook_xml_dtd_45 
    docbook_xsl findXMLCatalogs
  ];
   
  propagatedUserEnvPkgs = [ hicolor_icon_theme ];
  buildInputs = [ cairo librsvg dbus gdk_pixbuf gobjectIntrospection
                  git lgi libpthreadstubs libstartup_notification
                  libxdg_basedir lua nettools pango xcb-util-cursor
                  xorg.libXau xorg.libXdmcp xorg.libxcb xorg.libxshmfence
                  xorg.xcbutil xorg.xcbutilimage xorg.xcbutilkeysyms
                  xorg.xcbutilrenderutil xorg.xcbutilwm libxkbcommon
                  xcbutilxrm ];

  patches = [
    (fetchurl {
      url = "https://patch-diff.githubusercontent.com/raw/awesomeWM/awesome/pull/1639.patch";
      sha256 = "00piynmbxajd2xbg960gmf0zlqn7m489f4ww482y49ravfy1jhsj";
    })
  ];

  #cmakeFlags = "-DGENERATE_MANPAGES=ON";

  LD_LIBRARY_PATH = "${stdenv.lib.makeLibraryPath [ cairo pango gobjectIntrospection ]}";
  GI_TYPELIB_PATH = "${pango.out}/lib/girepository-1.0";
  LUA_CPATH = "${lgi}/lib/lua/${lua.luaversion}/?.so";
  LUA_PATH  = "${lgi}/share/lua/${lua.luaversion}/?.lua;${lgi}/share/lua/${lua.luaversion}/lgi/?.lua";

  postInstall = ''
    wrapProgram $out/bin/awesome \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix LUA_CPATH ";" '"${lgi}/lib/lua/${lua.luaversion}/?.so"' \
      --prefix LUA_PATH ";" '"${lgi}/share/lua/${lua.luaversion}/?.lua;${lgi}/share/lua/${lua.luaversion}/lgi/?.lua"' \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix LD_LIBRARY_PATH : "$LD_LIBRARY_PATH" \
      --prefix PATH : "${stdenv.lib.makeBinPath [ compton unclutter procps iproute coreutils curl alsaUtils findutils xterm ]}"

    wrapProgram $out/bin/awesome-client \
      --prefix PATH : "${which}/bin"
  '';

  passthru = {
    inherit lua;
  };

  meta = with stdenv.lib; {
    description = "Highly configurable, dynamic window manager for X";
    homepage    = https://awesomewm.org/;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ lovek323 rasendubi ndowens ];
    platforms   = platforms.linux;
  };
}

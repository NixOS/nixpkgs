{ stdenv, fetchFromGitHub, luaPackages, cairo, librsvg, cmake, imagemagick, pkgconfig, gdk_pixbuf
, xorg, libstartup_notification, libxdg_basedir, libpthreadstubs
, xcb-util-cursor, makeWrapper, pango, gobject-introspection
, which, dbus, nettools, git, doxygen
, xmlto, docbook_xml_dtd_45, docbook_xsl, findXMLCatalogs
, libxkbcommon, xcbutilxrm, hicolor-icon-theme
, asciidoctor
, fontsConf
, gtk3Support ? false, gtk3 ? null
}:

# needed for beautiful.gtk to work
assert gtk3Support -> gtk3 != null;

with luaPackages; stdenv.mkDerivation rec {
  name = "awesome-${version}";
  version = "4.3";

  src = fetchFromGitHub {
    owner = "awesomewm";
    repo = "awesome";
    rev = "v${version}";
    sha256 = "1i7ajmgbsax4lzpgnmkyv35x8vxqi0j84a14k6zys4blx94m9yjf";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    imagemagick
    makeWrapper
    pkgconfig
    xmlto docbook_xml_dtd_45
    docbook_xsl findXMLCatalogs
    asciidoctor
    ldoc
  ];

  outputs = [ "out" "doc" ];

  FONTCONFIG_FILE = toString fontsConf;

  propagatedUserEnvPkgs = [ hicolor-icon-theme ];
  buildInputs = [ cairo librsvg dbus gdk_pixbuf gobject-introspection
                  git lgi libpthreadstubs libstartup_notification
                  libxdg_basedir lua nettools pango xcb-util-cursor
                  xorg.libXau xorg.libXdmcp xorg.libxcb xorg.libxshmfence
                  xorg.xcbutil xorg.xcbutilimage xorg.xcbutilkeysyms
                  xorg.xcbutilrenderutil xorg.xcbutilwm libxkbcommon
                  xcbutilxrm ]
                  ++ stdenv.lib.optional gtk3Support gtk3;

  #cmakeFlags = "-DGENERATE_MANPAGES=ON";
  cmakeFlags = "-DOVERRIDE_VERSION=${version}";

  GI_TYPELIB_PATH = "${pango.out}/lib/girepository-1.0";
  # LUA_CPATH and LUA_PATH are used only for *building*, see the --search flags
  # below for how awesome finds the libraries it needs at runtime.
  LUA_CPATH = "${lgi}/lib/lua/${lua.luaversion}/?.so";
  LUA_PATH  = "${lgi}/share/lua/${lua.luaversion}/?.lua;;";

  postInstall = ''
    # Don't use wrapProgram or the wrapper will duplicate the --search
    # arguments every restart
    mv "$out/bin/awesome" "$out/bin/.awesome-wrapped"
    makeWrapper "$out/bin/.awesome-wrapped" "$out/bin/awesome" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --add-flags '--search ${lgi}/lib/lua/${lua.luaversion}' \
      --add-flags '--search ${lgi}/share/lua/${lua.luaversion}' \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH"

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

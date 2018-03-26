{ stdenv, fetchFromGitHub, cairo, librsvg, cmake, imagemagick, pkgconfig, gdk_pixbuf
, xorg, libstartup_notification, libxdg_basedir, libpthreadstubs
, xcb-util-cursor, makeWrapper, pango, gobject-introspection, unclutter
, compton, procps, iproute, coreutils, curl, alsaUtils, findutils, xterm
, which, dbus, nettools, git, asciidoc, doxygen
, xmlto, docbook_xml_dtd_45, docbook_xsl, findXMLCatalogs
, libxkbcommon, xcbutilxrm, hicolor-icon-theme
, luaModules ? []
, lua
}:

let
  luaEnv = lua.withPackages(ps: with ps; [ lgi  ] ++ luaModules);
in
stdenv.mkDerivation rec {
  name = "awesome-${version}";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "awesomewm";
    repo = "awesome";
    rev = "v${version}";
    sha256 = "1pcgagcvm6rdky8p8dd810j3ywaz0ncyk5xgaykslaixzrq60kff";
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
    # luaEnv # not mandatory but lgi is advised
  ];

  propagatedUserEnvPkgs = [ hicolor-icon-theme ];
  buildInputs = [ cairo librsvg dbus gdk_pixbuf gobject-introspection
                  git libpthreadstubs libstartup_notification
                  libxdg_basedir luaEnv nettools pango xcb-util-cursor
                  xorg.libXau xorg.libXdmcp xorg.libxcb xorg.libxshmfence
                  xorg.xcbutil xorg.xcbutilimage xorg.xcbutilkeysyms
                  xorg.xcbutilrenderutil xorg.xcbutilwm libxkbcommon
                  xcbutilxrm ];

  #cmakeFlags = "-DGENERATE_MANPAGES=ON";
  cmakeFlags = "-DOVERRIDE_VERSION=${version}";

  GI_TYPELIB_PATH = "${pango.out}/lib/girepository-1.0";

  # TODO revisit
  postInstall = ''
    wrapProgram $out/bin/awesome \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --add-flags '--search ''${LUA_PATH}' \
      --add-flags '--search ''${LUA_CPATH}' \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
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

{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  lua,
  cairo,
  librsvg,
  cmake,
  imagemagick,
  pkg-config,
  gdk-pixbuf,
  xorg,
  libstartup_notification,
  libxdg_basedir,
  libpthreadstubs,
  xcb-util-cursor,
  makeWrapper,
  pango,
  gobject-introspection,
  which,
  dbus,
  net-tools,
  git,
  doxygen,
  xmlto,
  docbook_xml_dtd_45,
  docbook_xsl,
  findXMLCatalogs,
  libxkbcommon,
  xcbutilxrm,
  hicolor-icon-theme,
  asciidoctor,
  fontsConf,
  gtk3Support ? false,
  gtk3 ? null,
}:

# needed for beautiful.gtk to work
assert gtk3Support -> gtk3 != null;

let
  luaEnv = lua.withPackages (ps: [
    ps.lgi
    ps.ldoc
  ]);
in

stdenv.mkDerivation rec {
  pname = "awesome";
  version = "4.3";

  src = fetchFromGitHub {
    owner = "awesomewm";
    repo = "awesome";
    rev = "v${version}";
    sha256 = "1i7ajmgbsax4lzpgnmkyv35x8vxqi0j84a14k6zys4blx94m9yjf";
  };

  patches = [
    # Pull upstream fix for -fno-common toolchain support:
    #   https://github.com/awesomeWM/awesome/pull/3065
    (fetchpatch {
      name = "fno-common-prerequisite.patch";
      url = "https://github.com/awesomeWM/awesome/commit/c5202a48708585cc33528065af8d1b1d28b1a6e0.patch";
      sha256 = "0sv36xf0ibjcm63gn9k3bl039sqavb2b5i6d65il4bdclkc0n08b";
    })
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/awesomeWM/awesome/commit/d256d9055095f27a33696e0aeda4ee20ed4fb1a0.patch";
      sha256 = "1n3y4wnjra8blss7642jgpxnm9n92zhhjj541bb9i60m4b7bgfzz";
    })

    # lib, tests: use GioUnix to use platform-specific Gio classes
    # https://github.com/awesomeWM/awesome/pull/4022
    (fetchpatch {
      name = "glib-2.86.0.patch";
      url = "https://github.com/void-linux/void-packages/raw/933b305b313a2c7d971d746835deb9f49b652204/srcpkgs/awesome/patches/glib-2.86.0.patch";
      hash = "sha256-qVzD8O34sULcV6S4daDUBPnxVDd8T6ZyLOE+gYxCmf0=";
    })
  ];

  # Fix build with CMake 4
  # https://github.com/awesomeWM/awesome/pull/4030#issuecomment-3370822668
  postPatch = ''
    substituteInPlace {,tests/examples/}CMakeLists.txt \
      --replace-fail 'cmake_minimum_required(VERSION 3.0.0)' 'cmake_minimum_required(VERSION 3.10)' \
      --replace-warn 'cmake_policy(VERSION 2.6)' 'cmake_policy(VERSION 3.10)'
  '';

  nativeBuildInputs = [
    cmake
    doxygen
    imagemagick
    makeWrapper
    pkg-config
    xmlto
    docbook_xml_dtd_45
    docbook_xsl
    findXMLCatalogs
    asciidoctor
    gobject-introspection
  ];

  outputs = [
    "out"
    "doc"
  ];

  FONTCONFIG_FILE = toString fontsConf;

  propagatedUserEnvPkgs = [ hicolor-icon-theme ];
  buildInputs = [
    cairo
    librsvg
    dbus
    gdk-pixbuf
    git
    luaEnv
    libpthreadstubs
    libstartup_notification
    libxdg_basedir
    lua
    net-tools
    pango
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
    libxkbcommon
    xcbutilxrm
  ]
  ++ lib.optional gtk3Support gtk3;

  cmakeFlags = [
    #"-DGENERATE_MANPAGES=ON"
    "-DOVERRIDE_VERSION=${version}"
  ]
  ++ lib.optional lua.pkgs.isLuaJIT "-DLUA_LIBRARY=${lua}/lib/libluajit-5.1.so";

  GI_TYPELIB_PATH = "${pango.out}/lib/girepository-1.0";
  # LUA_CPATH and LUA_PATH are used only for *building*, see the --search flags
  # below for how awesome finds the libraries it needs at runtime.
  LUA_CPATH = "${luaEnv}/lib/lua/${lua.luaversion}/?.so";
  LUA_PATH = "${luaEnv}/share/lua/${lua.luaversion}/?.lua;;";

  postInstall = ''
    # Don't use wrapProgram or the wrapper will duplicate the --search
    # arguments every restart
    mv "$out/bin/awesome" "$out/bin/.awesome-wrapped"
    makeWrapper "$out/bin/.awesome-wrapped" "$out/bin/awesome" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --add-flags '--search ${luaEnv}/lib/lua/${lua.luaversion}' \
      --add-flags '--search ${luaEnv}/share/lua/${lua.luaversion}' \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH"

    wrapProgram $out/bin/awesome-client \
      --prefix PATH : "${which}/bin"
  '';

  passthru = {
    inherit lua;
  };

  meta = with lib; {
    description = "Highly configurable, dynamic window manager for X";
    homepage = "https://awesomewm.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      lovek323
    ];
    platforms = platforms.linux;
  };
}

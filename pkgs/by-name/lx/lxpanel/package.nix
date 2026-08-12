{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gettext,
  m4,
  intltool,
  libxmlxx,
  keybinder3,
  gtk3,
  libx11,
  libfm,
  libwnck,
  libxmu,
  libxpm,
  cairo,
  gdk-pixbuf,
  gdk-pixbuf-xlib,
  menu-cache,
  lxmenu-data,
  wirelesstools,
  curl,
  supportAlsa ? false,
  alsa-lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxpanel";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "lxpanel";
    tag = finalAttrs.version;
    hash = "sha256-jpe5AfRkyTVKQ9biOJiWKv0OVqP8gRCzfhSLDjnrEPc=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gettext
    m4
    intltool
    libxmlxx
  ];

  buildInputs = [
    libfm
    keybinder3
    gtk3
    libx11
    libwnck
    libxmu
    libxpm
    cairo
    gdk-pixbuf
    gdk-pixbuf-xlib.dev
    menu-cache
    lxmenu-data
    m4
    wirelesstools
    curl
  ]
  ++ lib.optional supportAlsa alsa-lib;

  configureFlags = [ "--enable-gtk3" ];

  meta = {
    description = "Lightweight X11 desktop panel for LXDE";
    homepage = "https://lxde.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.ryneeverett ];
    platforms = lib.platforms.linux;
    mainProgram = "lxpanel";
  };
})

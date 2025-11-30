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
  keybinder,
  keybinder3,
  gtk2-x11,
  gtk3,
  libX11,
  libfm,
  libwnck,
  libwnck2,
  libXmu,
  libXpm,
  cairo,
  gdk-pixbuf,
  gdk-pixbuf-xlib,
  menu-cache,
  lxmenu-data,
  wirelesstools,
  curl,
  supportAlsa ? false,
  alsa-lib,
  withGtk3 ? true,
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
    (if withGtk3 then keybinder3 else keybinder)
    (if withGtk3 then gtk3 else gtk2-x11)
    libX11
    (libfm.override { inherit withGtk3; })
    (if withGtk3 then libwnck else libwnck2)
    libXmu
    libXpm
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

  configureFlags = lib.optional withGtk3 "--enable-gtk3";

  meta = {
    description = "Lightweight X11 desktop panel for LXDE";
    homepage = "https://lxde.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.ryneeverett ];
    platforms = lib.platforms.linux;
    mainProgram = "lxpanel";
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoconf-archive,
  autoreconfHook,
  gettext,
  gtk-doc,
  itstool,
  glib,
  gtk-layer-shell,
  gtk3,
  libxml2,
  libgtop,
  libcanberra-gtk3,
  inkscape,
  udisks,
  mate-common,
  mate-desktop,
  mate-panel,
  hicolor-icon-theme,
  wayland,
  wrapGAppsHook3,
  yelp-tools,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mate-utils";
  version = "1.28.1";
  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "mate-utils";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-0G25g4vpfufbvUYjCRJVBv9r5t/gnkDzWGKTf8N5MFQ=";
  };

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    pkg-config
    gettext
    gtk-doc
    itstool
    inkscape
    mate-common # mate-common.m4 macros
    wrapGAppsHook3
    yelp-tools
  ];

  buildInputs = [
    gtk-layer-shell
    gtk3
    libgtop
    libcanberra-gtk3
    libxml2
    udisks
    mate-desktop
    mate-panel
    hicolor-icon-theme
    wayland
  ];

  postPatch = ''
    # Workaround undefined version requirements
    # https://github.com/mate-desktop/mate-utils/issues/361
    substituteInPlace configure.ac \
      --replace-fail '>= $GTK_LAYER_SHELL_REQUIRED_VERSION' "" \
      --replace-fail '>= $GDK_WAYLAND_REQUIRED_VERSION' ""

    # Do not build gsearchtool help translations
    # https://github.com/mate-desktop/mate-utils/issues/210
    substituteInPlace gsearchtool/help/Makefile.am \
      --replace 'if USE_NLS' 'if FALSE'
  '';

  configureFlags = [ "--enable-wayland" ];

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "Utilities for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = with lib.licenses; [
      gpl2Plus
      lgpl2Plus
    ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})

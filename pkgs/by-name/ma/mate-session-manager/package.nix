{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf-archive,
  autoreconfHook,
  pkg-config,
  gettext,
  docbook-xsl-nons,
  libxslt,
  xtrans,
  dbus-glib,
  systemdLibs,
  libsm,
  libxtst,
  glib,
  gtk3,
  libepoxy,
  polkit,
  hicolor-icon-theme,
  mate-common,
  mate-desktop,
  mate-screensaver,
  wrapGAppsHook3,
  fetchpatch,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mate-session-manager";
  version = "1.28.2";

  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "mate-session-manager";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-KoZ6HGw37JQ++QsFSJfYm5IwcYd5egUjKNGNpqX7N+4=";
  };

  patches = [
    # allow turning on debugging from environment variable
    (fetchpatch {
      url = "https://github.com/mate-desktop/mate-session-manager/commit/3ab6fbfc811d00100d7a2959f8bbb157b536690d.patch";
      sha256 = "0yjaklq0mp44clymyhy240kxlw95z3azmravh4f5pfm9dys33sg0";
    })
  ];

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    pkg-config
    gettext
    docbook-xsl-nons
    libxslt # xsltproc
    xtrans
    mate-common # mate-common.m4 macros
    wrapGAppsHook3
  ];

  buildInputs = [
    dbus-glib
    systemdLibs
    libsm
    libxtst
    gtk3
    mate-desktop
    mate-screensaver # for gsm_manager_init
    hicolor-icon-theme
    libepoxy
    polkit
  ];

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  postFixup = ''
    substituteInPlace $out/share/xsessions/mate.desktop \
      --replace-fail "Exec=mate-session" "Exec=$out/bin/mate-session"
  '';

  passthru.providedSessions = [ "mate" ];

  passthru.updateScript = gitUpdater {
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "MATE Desktop session manager";
    homepage = "https://github.com/mate-desktop/mate-session-manager";
    license = with lib.licenses; [
      gpl2Plus
      lgpl2Plus
    ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})

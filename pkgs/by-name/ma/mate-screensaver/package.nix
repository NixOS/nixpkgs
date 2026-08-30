{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf-archive,
  autoreconfHook,
  pkg-config,
  gettext,
  gtk3,
  dbus-glib,
  libxscrnsaver,
  libnotify,
  libxml2,
  mate-common,
  mate-desktop,
  mate-menus,
  mate-panel,
  pam,
  systemd,
  wrapGAppsHook3,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mate-screensaver";
  version = "1.28.1";

  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "mate-screensaver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MTu5W+JBBlFzsv/IbygaE3+i7Df1YRGGoeZNSSSwbXM=";
  };

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    pkg-config
    gettext
    libxml2 # provides xmllint
    mate-common # mate-common.m4 macros
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    dbus-glib
    libxscrnsaver
    libnotify
    mate-desktop
    mate-menus
    mate-panel
    pam
    systemd
  ];

  configureFlags = [ "--without-console-kit" ];

  makeFlags = [ "DBUS_SESSION_SERVICE_DIR=$(out)/etc" ];

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "Screen saver and locker for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = with lib.licenses; [
      gpl2Plus
      lgpl2Plus
    ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})

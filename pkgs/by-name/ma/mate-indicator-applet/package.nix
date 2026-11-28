{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf-archive,
  autoreconfHook,
  pkg-config,
  gettext,
  gtk3,
  libayatana-indicator,
  mate-common,
  mate-panel,
  hicolor-icon-theme,
  wrapGAppsHook3,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mate-indicator-applet";
  version = "1.28.1";

  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "mate-indicator-applet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lI4iiOUc7AZHGFH5Xp1UsAoT1U11WvSgVrSXFS29RNQ=";
  };

  postPatch = ''
    # Find installed Unity & Ayatana (new-style) indicators
    substituteInPlace src/applet-main.c \
      --replace-fail '/usr/share' '/run/current-system/sw/share'
  '';

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    pkg-config
    gettext
    mate-common
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libayatana-indicator
    mate-panel
    hicolor-icon-theme
  ];

  configureFlags = [ "--with-ayatana-indicators" ];

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    homepage = "https://github.com/mate-desktop/mate-indicator-applet";
    description = "MATE panel indicator applet";
    longDescription = ''
      A small applet to display information from various applications
      consistently in the panel.

      The indicator applet exposes Ayatana Indicators in the MATE Panel.
      Ayatana Indicators are an initiative by Canonical to provide crisp and
      clean system and application status indication. They take the form of
      an icon and associated menu, displayed (usually) in the desktop panel.
      Existing indicators include the Message Menu, Battery Menu and Sound
      menu.
    '';
    license = with lib.licenses; [
      gpl3Plus
      lgpl2Plus
    ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})

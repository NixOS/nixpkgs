{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gettext,
  mate-icon-theme,
  gtk3,
  gdk-pixbuf,
  librsvg,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mate-themes";
  version = "3.22.26-unstable-2026-06-25";

  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "mate-themes";
    # For `build: add --enable-gtk2 configure flag`
    # nixpkgs-update: no auto update
    rev = "3eba5d520b9ae1c64ef6c42ac442a7a97d38f7c7";
    hash = "sha256-IZc1LxjHnwmvUOqGGnfzFdNI8dfyB3juOgY28xrXf1c=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gettext
    gtk3
  ];

  buildInputs = [
    mate-icon-theme
    gdk-pixbuf
    librsvg
  ];

  configureFlags = [
    "--disable-gtk2"
  ];

  dontDropIconThemeCache = true;

  postInstall = ''
    gtk-update-icon-cache "$out"/share/icons/ContrastHigh
  '';

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "Set of themes from MATE";
    homepage = "https://mate-desktop.org";
    license = with lib.licenses; [
      lgpl21Plus
      lgpl3Only
      gpl3Plus
    ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})

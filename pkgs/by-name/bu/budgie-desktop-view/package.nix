{
  lib,
  stdenv,
  fetchFromGitHub,
  desktop-file-utils,
  glib,
  gtk3,
  gtk-layer-shell,
  intltool,
  libxfce4windowing,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  vala,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-desktop-view";
  version = "10.10.3";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-desktop-view";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DRN2a20EdfCFeSLE7tMfXH7mgwY5FayhkLWSxThPSFY=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    intltool
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    gtk-layer-shell
    libxfce4windowing
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Official Budgie desktop icons application/implementation";
    homepage = "https://github.com/BuddiesOfBudgie/budgie-desktop-view";
    changelog = "https://github.com/BuddiesOfBudgie/budgie-desktop-view/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.budgie ];
    mainProgram = "org.buddiesofbudgie.budgie-desktop-view";
    platforms = lib.platforms.linux;
  };
})

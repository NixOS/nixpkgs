{
  lib,
  stdenv,
  fetchFromGitHub,
  desktop-file-utils,
  glib,
  gtk3,
  intltool,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  vala,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-desktop-view";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-desktop-view";
    rev = "v${finalAttrs.version}";
    hash = "sha256-k6VfAGWvUarhBFnREasOvWH3M9uuT5SFUpMFmKo1fmE=";
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
  ];

  mesonFlags = [ (lib.mesonBool "werror" false) ];

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

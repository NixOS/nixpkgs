{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  cargo,
  rustc,
  meson,
  ninja,
  pkg-config,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  gettext,
  wrapGAppsHook4,
  libadwaita,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "keypunch";
  version = "6.3";

  src = fetchFromGitHub {
    owner = "bragefuglseth";
    repo = "keypunch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NjPC7WbzOk0tDjM8la+TKGy+U2NNT2kwcrSkaG7TylQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-gQg6CCb5OzK2fLWMtkRTv1hK642IezRN+5qLMGVV6s8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc

    meson
    ninja

    pkg-config
    appstream
    blueprint-compiler
    desktop-file-utils
    gettext

    wrapGAppsHook4
  ];

  buildInputs = [ libadwaita ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Practice your typing skills";
    homepage = "https://github.com/bragefuglseth/keypunch";
    changelog = "https://github.com/bragefuglseth/keypunch/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "keypunch";
    maintainers = with lib.maintainers; [
      tomasajt
      getchoo
    ];
    teams = [ lib.teams.gnome-circle ];
    platforms = lib.platforms.linux;
  };
})

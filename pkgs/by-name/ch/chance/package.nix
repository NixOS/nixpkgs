{
  lib,
  blueprint-compiler,
  cargo,
  desktop-file-utils,
  fetchFromGitLab,
  libadwaita,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  rustPlatform,
  rustc,
  stdenv,
  wrapGAppsHook4,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "chance";
  version = "4.0.0";

  src = fetchFromGitLab {
    owner = "zelikos";
    repo = "rollit";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-2lZ7iMHMFE1wTSlJj0mIUV62jO0NundYiOC8rdUJGkQ=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) pname version src;
    hash = "sha256-Q4CfDQxlhspjg7Et+0zHwZ/iSnp0CnwwpW/gT7htlL8=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dice roller built using GTK4 and libadwaita";
    homepage = "https://gitlab.com/zelikos/rollit";
    changelog = "https://gitlab.com/zelikos/rollit/-/releases/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Guanran928 ];
    mainProgram = "rollit";
    platforms = lib.platforms.linux;
  };
})

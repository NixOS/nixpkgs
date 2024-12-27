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
  version = "5.0";

  src = fetchFromGitHub {
    owner = "bragefuglseth";
    repo = "keypunch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oP/rbtX72Ng4GVsXl5s8eESrUlJiJ/n05KArZHVo00c=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) pname version src;
    hash = "sha256-Uz9YbD4k3o3WOXCoIW41eUdi+HIfZLZJNszr9y3qezI=";
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
    license = lib.licenses.gpl3Plus;
    mainProgram = "keypunch";
    maintainers = with lib.maintainers; [
      tomasajt
      getchoo
    ];
    platforms = lib.platforms.linux;
  };
})

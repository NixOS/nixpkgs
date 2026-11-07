{ rustPlatform, cosmic-ext-extra-sessions }:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-ext-sway-daemon";
  inherit (cosmic-ext-extra-sessions.sway) src version;

  sourceRoot = "${finalAttrs.src.name}/sway/cosmic-ext-sway-daemon";

  cargoHash = "sha256-JDZecMs9lfeRT0MA30CaHCJTEwdNM2jNR26VSPPnlQE=";

  meta = cosmic-ext-extra-sessions.sway.meta // {
    description = "Unofficial Sway alternative session daemon for COSMIC Desktop";
    mainProgram = "cosmic-ext-sway-daemon";
  };
})

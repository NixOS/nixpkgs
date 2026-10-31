{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sprout";
  version = "0.4";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "cerealdevv";
    repo = "sprout";
    tag = "v${finalAttrs.version}";
    hash = "sha256-thrh9ai1o9hT/QWea8SlxHq+O6Wvl6w8hTRaJHSp6bM=";
  };

  cargoHash = "sha256-lQKlKei7sREG/4BbpPojqznOMyVKvvZSPivd2mZ+TVU=";

  env.SPROUT_SOURCE = "nix";
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SPROUT - System Probing Output diagnostic tool for debugging";
    homepage = "https://codeberg.org/cerealdevv/sprout";
    changelog = "https://codeberg.org/cerealdevv/sprout/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "sprout";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ cereal ];
  };
})

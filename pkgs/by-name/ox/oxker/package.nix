{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxker";
  version = "0.10.3";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-2xLTR5+0xtyYhc5+gYG78EMP/B5Vk6ZqEGsZwM2bAok=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-d6jaOtB6S8R6cdqLUnuPhDP6q9Hl6FTieFEiBibiDDE=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple TUI to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siph ];
    mainProgram = "oxker";
  };
})

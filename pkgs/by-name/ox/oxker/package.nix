{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxker";
  version = "0.11.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-YJe1WiKlvExrcpB8LZSLzrLcMaw84oL4OoHSRo+lqRo=";
  };

  cargoHash = "sha256-V/9s5T+Ofkt22hmjxxFtgkDBdwfeyFUr98xXChrFKwM=";

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

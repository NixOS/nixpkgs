{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxker";
  version = "0.10.5";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-PRV++3s25xqrfVQ8stXBfc8fpAEzFNNeyJI2MrYbWy8=";
  };

  cargoHash = "sha256-V72uikTto8M9BM0qQINHQ4HGFhXIf+JvzArhM/wg1wc=";

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

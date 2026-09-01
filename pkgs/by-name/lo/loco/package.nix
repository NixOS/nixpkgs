{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "loco";
  version = "1.0.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-W1V1N+zTCtX15Te7XYRQRK2X39Ji2sl0rIgn5xvQTT0=";
  };

  cargoHash = "sha256-BjMxJenYQet9BxQ/bM5Ai8WEXYcf+sWTE/A9TKmY3Hc=";

  #Skip trycmd integration tests
  checkFlags = [ "--skip=cli_tests" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Loco CLI is a powerful command-line tool designed to streamline the process of generating Loco websites";
    homepage = "https://loco.rs";
    changelog = "https://github.com/loco-rs/loco/blob/master/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sebrut ];
    mainProgram = "loco";
  };
})

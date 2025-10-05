{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "loco";
  version = "0.16.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-yctOGUfKd1zaIArtHESYEr1q79ZrJqL7H6bvpAFrE+8=";
  };

  cargoHash = "sha256-IdYicJ7ZIoVOQU91S8yIPYGeY+DaeAMztGOmriTGW38=";

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
}

{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "loco";
  version = "0.16.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-5mg2caScI1sxKtadw8IP/yxDOdPN+RRqHXdsWr2R0FY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-SFNaTo6fV7xhmkqK8SuFOjXeDDYN4+KTbF9DfpEX+dI=";

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

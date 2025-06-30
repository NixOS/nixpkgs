{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "loco";
  version = "0.15.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-sTPFDdiYmw+ODAcuBh4XXpSXVZbbYxfjr+WiTGit18E=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-EsNFdk7bLRzyfncDRxqS0CQGdtPFdRRSlpTTxbQ8csI=";

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

{
  lib,
  stdenv,
  fetchCrate,
  rustPlatform,
  pkg-config,
  rustfmt,
  cacert,
  openssl,
  nix-update-script,
  testers,
  dioxus-cli,
}:
rustPlatform.buildRustPackage rec {
  pname = "dioxus-cli";
  version = "0.7.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-tPymoJJvz64G8QObLkiVhnW0pBV/ABskMdq7g7o9f1A=";
  };

  cargoHash = "sha256-mgscu6mJWinB8WXLnLNq/JQnRpHRJKMQXnMwECz1vwc=";

  buildFeatures = [ "no-downloads" ];

  nativeBuildInputs = [
    pkg-config
    cacert
  ];

  buildInputs = [ openssl ];

  OPENSSL_NO_VENDOR = 1;

  nativeCheckInputs = [ rustfmt ];

  checkFlags = [
    # requires network access
    "--skip=serve::proxy::test"
    "--skip=wasm_bindgen::test"
    # requires cli-harnesses directory
    "--skip=test_harnesses::run_harness"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = dioxus-cli; };
  };

  meta = with lib; {
    homepage = "https://dioxuslabs.com";
    description = "CLI tool for developing, testing, and publishing Dioxus apps";
    changelog = "https://github.com/DioxusLabs/dioxus/releases";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [
      xanderio
      cathalmullan
    ];
    mainProgram = "dx";
  };
}

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
  version = "0.6.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-mQnSduf8SHYyUs6gHfI+JAvpRxYQA1DiMlvNofImElU=";
  };

  cargoHash = "sha256-UDV9odeXVGxC27+2LN+amrDoxzTR4tkKfX92U62J5BI=";
  buildFeatures = [ "optimizations" ];

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

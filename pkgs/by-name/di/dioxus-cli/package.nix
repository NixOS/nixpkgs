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
  version = "0.6.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-0Kg2/+S8EuMYZQaK4Ao+mbS7K48VhVWjPL+LnoVJMSw=";
  };

  cargoHash = "sha256-RMo6q/GSAV1bCMWtR+wu9xGKCgz/Ie6t/8oirBly/LQ=";
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

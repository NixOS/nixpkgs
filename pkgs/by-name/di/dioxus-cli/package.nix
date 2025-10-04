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
  version = "0.6.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-wuIJq+UN1q5qYW4TXivq93C9kZiPHwBW5Ty2Vpik2oY=";
  };

  cargoHash = "sha256-L9r/nJj0Rz41mg952dOgKxbDS5u4zGEjSA3EhUHfGIk=";
  cargoPatches = [
    # TODO: Remove once https://github.com/DioxusLabs/dioxus/issues/3659 is fixed upstream.
    ./fix-wasm-opt-target-dir.patch
  ];

  buildFeatures = [
    "no-downloads"
    "optimizations"
  ];

  nativeBuildInputs = [
    pkg-config
    cacert
  ];

  buildInputs = [ openssl ];

  OPENSSL_NO_VENDOR = 1;

  # wasm-opt-sys build.rs tries to verify C++17 support, but the check appears to be faulty.
  postPatch = ''
    substituteInPlace $cargoDepsCopy/wasm-opt-sys-*/build.rs \
      --replace-fail 'check_cxx17_support()?;' '// check_cxx17_support()?;'
  '';

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

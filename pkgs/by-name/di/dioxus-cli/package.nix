{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  cacert,
  openssl,
  rustfmt,
  nix-update-script,
  testers,
  dioxus-cli,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dioxus-cli";
  version = "0.7.0-rc.0";

  src = fetchCrate {
    pname = "dioxus-cli";
    version = finalAttrs.version;
    hash = "sha256-xt/DJhcZz3TZLodfJTaFE2cBX3hedo+typHM5UezS94=";
  };

  cargoHash = "sha256-UVt4vZyh+w+8Z1Bp1emFOJqPXU1zzy7FzNcA5oQsM8U=";
  buildFeatures = [
    "no-downloads"
    # "disable-telemetry"
  ];

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  nativeBuildInputs = [
    pkg-config
    cacert
  ];

  buildInputs = [
    openssl
  ];

  nativeCheckInputs = [
    rustfmt
  ];

  checkFlags = [
    # requires network access
    "--skip=serve::proxy::test"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = dioxus-cli;
    };
  };

  meta = {
    description = "CLI for building fullstack web, desktop, and mobile apps with a single codebase.";
    homepage = "https://dioxus.dev";
    changelog = "https://github.com/DioxusLabs/dioxus/releases";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      xanderio
      cathalmullan
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
    ];
    platforms = lib.platforms.all;
    mainProgram = "dx";
  };
})

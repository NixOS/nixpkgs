{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  cacert,
  openssl,
  rustfmt,
  makeWrapper,
  esbuild,
  wasm-bindgen-cli_0_2_114,
  testers,
  dioxus-cli,
  withTelemetry ? false,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dioxus-cli";
  version = "0.7.5";

  src = fetchCrate {
    pname = "dioxus-cli";
    version = finalAttrs.version;
    hash = "sha256-iAwR43SwmOBvuHa9qZBJLCjyhQSj/XgDx0jkWR+lgrE=";
  };

  cargoHash = "sha256-JS5/7hQhgN2gbMmLY2zD2GE/Ony8AAHAzj7Ituj6l90=";
  buildFeatures = [
    "no-downloads"
  ]
  ++ lib.optional (!withTelemetry) "disable-telemetry";

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  nativeBuildInputs = [
    pkg-config
    cacert
    makeWrapper
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
    # requires monorepo structure and mobile toolchains
    "--skip=test_harnesses::run_harness"
  ];

  passthru = {
    tests = {
      version = testers.testVersion {
        package = dioxus-cli;
      };

      withTelemetry = dioxus-cli.override {
        withTelemetry = true;
      };
    };
  };

  postInstall = ''
    wrapProgram $out/bin/dx \
      --suffix PATH : ${
        lib.makeBinPath [
          esbuild
          wasm-bindgen-cli_0_2_114
        ]
      }
  '';

  meta = {
    description = "CLI for building fullstack web, desktop, and mobile apps with a single codebase.";
    homepage = "https://dioxus.dev";
    changelog = "https://github.com/DioxusLabs/dioxus/releases";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      cathalmullan
      anish
    ];
    platforms = lib.platforms.all;
    mainProgram = "dx";
  };
})

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
  version = "0.7.4";

  src = fetchCrate {
    pname = "dioxus-cli";
    version = finalAttrs.version;
    hash = "sha256-6ZKVnLMq2eB6kj2Ly3z0/dWpZ+x9bJwPtyxE8Ef6haI=";
  };

  cargoHash = "sha256-VrJuT3ori25joRe7kjSr6j8xfbKn5udETviV3id2mG4=";
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

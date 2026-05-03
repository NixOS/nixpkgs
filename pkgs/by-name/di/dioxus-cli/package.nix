{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  cacert,
  openssl,
  rustfmt,
  installShellFiles,
  makeWrapper,
  esbuild,
  wasm-bindgen-cli_0_2_118,
  testers,
  dioxus-cli,
  withTelemetry ? false,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dioxus-cli";
  version = "0.7.7";

  src = fetchCrate {
    pname = "dioxus-cli";
    version = finalAttrs.version;
    hash = "sha256-jMy2i19qyoMuIh/BJ1iJU78WNY+kWQC9xKTovLJvL2A=";
  };

  cargoHash = "sha256-qPxW3VzHUw+GBmHn9r77BcDw50AkCfAOa7JblpgYgls=";
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
    installShellFiles
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
    installShellCompletion --cmd dx \
      --bash <($out/bin/dx completions bash) \
      --fish <($out/bin/dx completions fish) \
      --zsh <($out/bin/dx completions zsh)
  '';

  postFixup = ''
    wrapProgram $out/bin/dx \
      --suffix PATH : ${
        lib.makeBinPath [
          esbuild
          wasm-bindgen-cli_0_2_118
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

{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  cacert,
  openssl,
  rustfmt,
  makeWrapper,
  wasm-bindgen-cli_0_2_108,
  testers,
  dioxus-cli,
  withTelemetry ? false,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dioxus-cli";
  version = "0.7.3";

  src = fetchCrate {
    pname = "dioxus-cli";
    version = finalAttrs.version;
    hash = "sha256-6uG737MNk+wTKqNWgFEd8MsOOvllZLDnIrJPAn5Wjuw=";
  };

  cargoHash = "sha256-BdPsdWah/f2pveQViPikIV2riSwjSo+qGOFoP+hHaiM=";
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
      --suffix PATH : ${lib.makeBinPath [ wasm-bindgen-cli_0_2_108 ]}
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

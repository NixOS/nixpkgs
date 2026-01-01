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
  withTelemetry ? false,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dioxus-cli";
<<<<<<< HEAD
  version = "0.7.2";
=======
  version = "0.7.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchCrate {
    pname = "dioxus-cli";
    version = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-VCoTxZKFYkGBCu1X/9US/OCFpp6zc5ojmXWJfzozCxc=";
  };

  cargoHash = "sha256-de8z68uXnrzyxTJY53saJ6hT7rvYbSdsSA/WWQa6nl4=";
=======
    hash = "sha256-tPymoJJvz64G8QObLkiVhnW0pBV/ABskMdq7g7o9f1A=";
  };

  cargoHash = "sha256-mgscu6mJWinB8WXLnLNq/JQnRpHRJKMQXnMwECz1vwc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion {
        package = dioxus-cli;
      };

      withTelemetry = dioxus-cli.override {
        withTelemetry = true;
      };
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
<<<<<<< HEAD
=======
      xanderio
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      cathalmullan
    ];
    platforms = lib.platforms.all;
    mainProgram = "dx";
  };
})

{
  lib,
  cacert,
  curl,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  openssl,
  stdenv,
  zig_0_13,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-lambda";
  version = "1.8.6";

  src = fetchFromGitHub {
    owner = "cargo-lambda";
    repo = "cargo-lambda";
    tag = "v${version}";
    hash = "sha256-ocFD2FK1nlEJ8xXhDSxpSKYU8oZk/QwfojveypVt1GU=";
  };

  cargoHash = "sha256-yE0pr7RZb015d51QtwVNfqXd8yEETvDdKJ5M7Oqc4Ds=";

  nativeCheckInputs = [ cacert ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    curl
  ];

  # Remove files that don't make builds reproducible:
  # - Remove build.rs file that adds the build date to the version.
  # - Remove cargo_lambda.rs that contains tests that reach the network.
  postPatch = ''
    rm crates/cargo-lambda-cli/build.rs
    rm crates/cargo-lambda-cli/tests/cargo_lambda.rs
  '';

  postInstall = ''
    wrapProgram $out/bin/cargo-lambda --prefix PATH : ${lib.makeBinPath [ zig_0_13 ]}
  '';

  CARGO_LAMBDA_BUILD_INFO = "(nixpkgs)";

  cargoBuildFlags = [ "--features=skip-build-banner" ];
  cargoCheckFlags = [ "--features=skip-build-banner" ];

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # Fails in darwin sandbox, first because of trying to listen to a port on
    # localhost. While this would be fixed by `__darwinAllowLocalNetworking = true;`,
    # they then fail with other I/O issues.
    "--skip=test::test_download_example"
    "--skip=test::test_download_example_with_cache"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cargo subcommand to help you work with AWS Lambda";
    mainProgram = "cargo-lambda";
    homepage = "https://cargo-lambda.info";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      taylor1791
      calavera
      matthiasbeyer
    ];
  };
}

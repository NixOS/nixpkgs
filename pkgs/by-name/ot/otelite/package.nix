{
  darwin,
  lib,
  fetchFromGitHub,
  fetchurl,
  lsof,
  nixosTests,
  openssl,
  pkg-config,
  procps,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "otelite";
  version = "0.1.105";

  src = fetchFromGitHub {
    owner = "planetf1";
    repo = "otelite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w3gIfNz+hXH2cu8Ckp9xcUtK3SrXUAu1vzhNCOZ5ewI=";
  };

  cargoHash = "sha256-HbTLG5Vk5zdNJTR5+kOKy2FhbLX0f2qh4RMN0AgWIZw=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  # Upstream service-discovery tests use lsof and ps to inspect running processes.
  nativeCheckInputs = [
    lsof
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ procps ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.ps ];

  cargoBuildFlags = [
    "-p"
    "otelite"
    "--bin"
    "otelite"
  ];

  checkFlags = [
    # The Nix build PTY is too narrow for these contiguous pretty-table assertions.
    "--skip=display_renders_correlation_provenance_counts"
    "--skip=display_reports_identity_and_counts"
    # Timing-sensitive assertion occasionally observes the log file before it is flushed.
    "--skip=test_serve_writes_rotating_log_file"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # These tests require launchctl, which is unavailable in the Darwin sandbox.
    "--skip=test_discovery_finds_serve_without_pid_file"
    "--skip=test_status_recovers_from_corrupt_pid_file"
  ];

  swaggerUi = fetchurl {
    url = "https://github.com/swagger-api/swagger-ui/archive/refs/tags/v5.17.12.zip";
    hash = "sha256-HK4z/JI+1yq8BTBJveYXv9bpN/sXru7bn/8g5mf2B/I=";
  };

  preBuild = ''
    install -m 0644 ${finalAttrs.swaggerUi} "$TMPDIR/swagger-ui.zip"
    export SWAGGER_UI_DOWNLOAD_URL="file:$TMPDIR/swagger-ui.zip"
  '';

  preCheck = ''
    install -m 0644 ${finalAttrs.swaggerUi} "$TMPDIR/swagger-ui.zip"
    export SWAGGER_UI_DOWNLOAD_URL="file:$TMPDIR/swagger-ui.zip"
    export HOME="$TMPDIR/home"
    mkdir -p "$HOME"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    "$out/bin/otelite" --help
    "$out/bin/otelite" --version
    runHook postInstallCheck
  '';

  passthru.tests.nixos = nixosTests.otelite;

  meta = {
    description = "Lightweight OpenTelemetry receiver and dashboard for local development";
    homepage = "https://github.com/planetf1/otelite";
    changelog = "https://github.com/planetf1/otelite/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ zatevakhin ];
    mainProgram = "otelite";
  };
})

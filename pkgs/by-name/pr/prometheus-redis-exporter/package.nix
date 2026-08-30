{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,

  # Test dependencies
  redisTestHook,

  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "redis_exporter";
  version = "1.90.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "oliver006";
    repo = "redis_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IZgFd6hlWVsUAx2sQsB8lTp7aZEGGmJ8BequT/TsZ+w=";
  };

  vendorHash = "sha256-+g1HSv+AxXsNzVr6QHpm2EJnRR80rPCtBnPgwq6aq5I=";

  ldflags = [
    "-X main.BuildVersion=${finalAttrs.version}"
    "-X main.BuildCommitSha=unknown"
    "-X main.BuildDate=unknown"
  ];

  nativeCheckInputs = [
    redisTestHook
  ];

  preCheck = ''
    export TEST_REDIS_URI="redis://localhost:6379"
  '';

  __darwinAllowLocalNetworking = true;

  checkFlags =
    let
      skippedTests = [
        "TestLatencySpike" # timing-sensitive

        # The following tests require ad-hoc generated TLS certificates in the source dir.
        # This is not possible in the read-only Nix store.
        "TestCreateClientTLSConfig"
        "TestValkeyTLSScheme"
        "TestCreateServerTLSConfig"
        "TestGetServerCertificateFunc"
        "TestGetConfigForClientFunc"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) redis; };

  meta = {
    description = "Prometheus exporter for Redis metrics";
    mainProgram = "redis_exporter";
    homepage = "https://github.com/oliver006/redis_exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      eskytthe
      srhb
      ma27
    ];
  };
})

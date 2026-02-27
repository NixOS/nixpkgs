{
  lib,
  buildGoModule,
  fetchFromGitHub,
  kvrocks,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kvrocks_exporter";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "RocksLabs";
    repo = "kvrocks_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nyNdQfSXD6mAusO5VCEfvKuyvNawH4C5xDGOZSnTn7A=";
  };

  vendorHash = "sha256-QVbcHQQr6o3jnF3CWw2NCCeRkGBDdA8OkmDd/GPfHuI=";

  __structuredAttrs = true;

  ldflags = [
    "-X main.BuildVersion=${finalAttrs.version}"
    "-X main.BuildCommitSha=unknown"
    "-X main.BuildDate=unknown"
  ];

  nativeCheckInputs = [ kvrocks.hook ];

  preCheck = ''
    export TEST_REDIS_URI="redis://127.0.0.1:6666"
  '';

  __darwinAllowLocalNetworking = true;

  checkFlags =
    let
      skippedTests = [
        # The following tests require a real Redis/Kvrocks instance with specific configuration
        # or multiple instances which are not easily provided by a single kvrocks.hook.
        "TestPasswordProtectedInstance" # Requires TEST_PWD_REDIS_URI and TEST_USER_PWD_REDIS_URI
        "TestPasswordInvalid" # Requires TEST_PWD_REDIS_URI
        "TestHTTPScrapeWithPasswordFile" # Requires specific redis instances from password file
        "TestSimultaneousMetricsHttpRequests" # Requires multiple redis instances
        "TestClusterMaster" # Requires TEST_REDIS_CLUSTER_MASTER_URI
        "TestClusterSlave" # Requires TEST_REDIS_CLUSTER_SLAVE_URI

        # The following tests fail due to "target" parameter requirement in kvrocks_exporter's /scrape endpoint
        # which is not satisfied in the test's HTTP requests in http_test.go.
        "TestHTTPScrapeMetricsEndpoints"

        # These tests require a running instance and are sensitive to the environment
        "TestIncludeSystemMemoryMetric"

        # These tests require valid JSON in password files or valid certs
        "TestLoadPwdFile"
        "TestPasswordMap"
        "TestCreateClientTLSConfig"
        "TestGetServerCertificateFunc"
      ];
    in
    [ "-skip=^(${builtins.concatStringsSep "|" skippedTests})$" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Prometheus exporter for Kvrocks metrics";
    homepage = "https://github.com/RocksLabs/kvrocks_exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xyenon ];
    mainProgram = "kvrocks_exporter";
  };
})

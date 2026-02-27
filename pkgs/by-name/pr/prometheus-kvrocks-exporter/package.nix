{
  lib,
  buildGoModule,
  fetchFromGitHub,
  kvrocksTestHook,
  nix-update-script,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "kvrocks_exporter";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "RocksLabs";
    repo = "kvrocks_exporter";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+o7DWxDtKYdcL+Fp1NHmQ/A82oFme/aRdNF9Av2SkcM=";
  };

  vendorHash = "sha256-QVbcHQQr6o3jnF3CWw2NCCeRkGBDdA8OkmDd/GPfHuI=";

  ldflags = [
    "-X main.BuildVersion=${finalAttrs.version}"
    "-X main.BuildCommitSha=unknown"
    "-X main.BuildDate=unknown"
  ];

  nativeCheckInputs = [ kvrocksTestHook ];

  preCheck = ''
    export TEST_REDIS_URI="redis://127.0.0.1:6666"
  '';

  __darwinAllowLocalNetworking = true;

  checkFlags =
    let
      skippedTests = [
        # The following tests require a real Redis/Kvrocks instance with specific configuration
        # or multiple instances which are not easily provided by a single kvrocksTestHook.
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
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  passthru = {
    updateScript = nix-update-script { };
    tests = { inherit (nixosTests.prometheus-exporters) kvrocks; };
  };

  meta = {
    description = "Prometheus exporter for Kvrocks metrics";
    homepage = "https://github.com/RocksLabs/kvrocks_exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xyenon ];
    mainProgram = "kvrocks_exporter";
  };
})

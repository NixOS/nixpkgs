{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "graphite-exporter";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "graphite_exporter";
    rev = "v${version}";
    hash = "sha256-JpehjKj2M+BShrd3OUWuxaznmyVTjvOp1oYt/kHCcaw=";
  };

  vendorHash = "sha256-Z5RrHSTJ4oy+Sa3pu0ADFnSWZSk6/OH3nDzmIU1p5/U=";

  checkFlags =
    let
      skippedTests = [
        "TestBacktracking"
        "TestInconsistentLabelsE2E"
        "TestIssue111"
        "TestIssue61"
        "TestIssue90"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) graphite; };

  meta = {
    description = "Exporter for metrics exported in the Graphite plaintext protocol";
    homepage = "https://github.com/prometheus/graphite_exporter";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.misterio77 ];
  };
}

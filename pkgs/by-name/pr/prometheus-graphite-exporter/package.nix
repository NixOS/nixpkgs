{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "graphite-exporter";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "graphite_exporter";
    rev = "v${version}";
    hash = "sha256-Dr7I4+gQXZYKUMnf/P9DgLYRb4SRaDnvqvDwHfMpAn0=";
  };

  vendorHash = "sha256-f/ZJi3C11O+xAfXo544tlJcAt0MnTknuRmw01JXj82k=";

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

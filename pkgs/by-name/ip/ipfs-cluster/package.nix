{
  lib,
  buildGo125Module,
  fetchFromGitHub,
}:

buildGo125Module (finalAttrs: {
  pname = "ipfs-cluster";
  version = "1.1.5";

  vendorHash = "sha256-ARzpn/LzFIA+3ghW+xdQvFFiFwxT79dk4vpgEKoEBzk=";

  src = fetchFromGitHub {
    owner = "ipfs-cluster";
    repo = "ipfs-cluster";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TOUntNZtTj6cS+6+MwIwKdUZ/gB5D63osn4+fpGGkDY=";
  };

  checkFlags =
    let
      skippedTests = [
        # Flaky test, sometimes fails with:
        # --- FAIL: TestClustersPeerAddInUnhealthyCluster (7.58s)
        #     peer_manager_test.go:247: failed to dial: failed to dial QmSookyjcPhxchnHeo2jtssHqe8zdmhgEQiY61yUcWjWp5: all dials failed
        #           * [/ip4/127.0.0.1/tcp/46571] dial backoff
        "TestClustersPeerAddInUnhealthyCluster"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  __darwinAllowLocalNetworking = true; # required for tests

  meta = {
    description = "Allocate, replicate, and track Pins across a cluster of IPFS daemons";
    homepage = "https://ipfscluster.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Luflosi
      jglukasik
    ];
  };
})

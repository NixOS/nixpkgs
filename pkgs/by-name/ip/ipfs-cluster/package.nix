{
  lib,
  buildGo124Module,
  fetchFromGitHub,
}:

buildGo124Module (finalAttrs: {
  pname = "ipfs-cluster";
  version = "1.1.4";

  vendorHash = "sha256-VVejr6B7eDNNQF34PS/PaQ50mBNZgzJS50aNzbLJgCg=";

  src = fetchFromGitHub {
    owner = "ipfs-cluster";
    repo = "ipfs-cluster";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mdLrLiRNudpQ8i0lvwoNAqhSWJ8VMEC1ZRxXHWHpqLY=";
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

  meta = with lib; {
    description = "Allocate, replicate, and track Pins across a cluster of IPFS daemons";
    homepage = "https://ipfscluster.io";
    license = licenses.mit;
    maintainers = with maintainers; [
      Luflosi
      jglukasik
    ];
  };
})

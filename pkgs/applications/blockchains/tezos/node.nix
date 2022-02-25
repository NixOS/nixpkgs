{ lib
, fetchFromGitLab
, ocamlPackages
, curl
, coreutils
, util-linux
, makeWrapper
, zcash
}:

ocamlPackages.buildDunePackage rec {
  pname = "tezos-node";
  inherit (ocamlPackages.tezos-stdlib) version useDune2;
  src = "${ocamlPackages.tezos-stdlib.base_src}/src/bin_node";

  propagatedBuildInputs = [ zcash ];

  buildInputs = with ocamlPackages; [
    tezos-base
    tezos-version
    tezos-rpc-http-server
    tezos-p2p
    tezos-shell
    tezos-workers
    tezos-protocol-updater
    tezos-validator
    tezos-genesis.embedded-protocol
    tezos-genesis-carthagenet.embedded-protocol
    tezos-demo-counter.embedded-protocol
    tezos-alpha.embedded-protocol
    tezos-demo-noops.embedded-protocol
    tezos-000-Ps9mPmXa.embedded-protocol
    tezos-001-PtCJ7pwo.embedded-protocol
    tezos-002-PsYLVpVv.embedded-protocol
    tezos-003-PsddFKi3.embedded-protocol
    tezos-004-Pt24m4xi.embedded-protocol
    tezos-005-PsBABY5H.embedded-protocol
    tezos-005-PsBabyM1.embedded-protocol
    tezos-006-PsCARTHA.embedded-protocol
    tezos-007-PsDELPH1.embedded-protocol
    tezos-008-PtEdo2Zk.embedded-protocol
    tezos-009-PsFLoren.embedded-protocol
    tezos-010-PtGRANAD.embedded-protocol
    tezos-011-PtHangz2.embedded-protocol
    tezos-008-PtEdo2Zk.protocol-plugin-registerer
    tezos-009-PsFLoren.protocol-plugin-registerer
    tezos-010-PtGRANAD.protocol-plugin-registerer
    tezos-011-PtHangz2.protocol-plugin-registerer
    tezos-alpha.protocol-plugin-registerer
    tezos-010-PtGRANAD.protocol-plugin
    tezos-011-PtHangz2.protocol-plugin
    cmdliner
    lwt-exit
    tls
    cstruct
  ];

  checkInputs = with ocamlPackages; [
    tezos-base-test-helpers
  ];

  postInstall = ''
    patchShebangs tezos-sandboxed-node.sh
  '';

  doCheck = true;
}

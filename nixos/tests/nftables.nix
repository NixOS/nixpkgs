import ./make-test-python.nix ({ pkgs, ... }:
  let
    inherit (pkgs) nftables runCommand writeShellScriptBin;

    patchBash = writeShellScriptBin "patchBash" ''
      sed -i '1s|.*|#!/usr/bin/env bash|' $1
    '';
    tests = runCommand "patched tests" { } ''
      cp -r ${nftables.src}/tests/shell ./tests

      find tests -not -name "*.*" \
        -exec chmod a+w '{}' \; \
        -exec ${patchBash}/bin/patchBash '{}' \;

      find tests -name "*.sh" \
        -exec chmod a+w '{}' \; \
        -exec ${patchBash}/bin/patchBash '{}' \;

      mkdir -p $out/
      cp -R tests/. $out
    '';
  in {
    name = "nftables";

    machine = { config, ... }: {

      /* 6 tests fail with the current kernel
         vm-test-run-nftables> machine # W: [FAILED]     ././testcases/maps/0011vmap_0: got 1
         vm-test-run-nftables> machine # W: [DUMP FAIL]  ././testcases/nft-f/0025empty_dynset_0: dump diff detected
         vm-test-run-nftables> machine # W: [FAILED]     ././testcases/sets/0059set_update_multistmt_0: got 1
         vm-test-run-nftables> machine # W: [FAILED]     ././testcases/sets/0060set_multistmt_0: got 1
         vm-test-run-nftables> machine # W: [FAILED]     ././testcases/sets/0063set_catchall_0: got 1
         vm-test-run-nftables> machine # W: [FAILED]     ././testcases/sets/0064map_catchall_0: got 1
      */
      boot.kernelPackages = pkgs.linuxPackages_latest;

      networking.firewall.enable = false;
      networking.nftables.enable = true;

      # This cannot be empty when enabling nftables but it has no effect on the tests
      networking.nftables.ruleset = "";

      environment.variables = { NFT = "${nftables}/bin/nft"; };

      boot.kernelModules = [ "br_netfilter" ];
    };

    testScript = ''
      machine.succeed("cp -r ${tests} ~/tests")
      machine.succeed("cd ~/tests && ./run-tests.sh -v")
    '';
  })

{ system ? builtins.currentSystem }:

let
  inherit (import ../lib/testing.nix { inherit system; }) makeTest pkgs;
in pkgs.lib.listToAttrs (pkgs.lib.crossLists (predictable: withNetworkd: stateV: {
  name = pkgs.lib.optionalString (!predictable) "un" + "predictable"
       + pkgs.lib.optionalString withNetworkd "Networkd"
       + builtins.replaceStrings ["."] [""] stateV;
  value = makeTest {
    name = "${if predictable then "" else "un"}predictableInterfaceNames${if withNetworkd then "-with-networkd" else ""}-${stateV}";
    meta = {};

    machine = { lib, ... }: {
      networking.usePredictableInterfaceNames = lib.mkForce predictable;
      networking.useNetworkd = withNetworkd;
      networking.dhcpcd.enable = !withNetworkd;
      # So we can see the initrd device names in the log
      # although we don't add an automated test here
      boot.initrd.network.enable = (stateV == "18.09");
      system.stateVersion = stateV;
    };

    testScript = ''
      print $machine->succeed("ip link");
      $machine->succeed("ip link show ${if predictable then "ens3" else "eth0"}");
      $machine->fail("ip link show ${if predictable then "eth0" else "ens3"}");
    '';
  };
}) [[true false] [true false] ["18.03" "18.09"]])

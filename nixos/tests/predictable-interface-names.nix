{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

let
  inherit (import ../lib/testing.nix { inherit system pkgs; }) makeTest;
in pkgs.lib.listToAttrs (pkgs.lib.crossLists (predictable: withNetworkd: {
  name = pkgs.lib.optionalString (!predictable) "un" + "predictable"
       + pkgs.lib.optionalString withNetworkd "Networkd";
  value = makeTest {
    name = "${if predictable then "" else "un"}predictableInterfaceNames${if withNetworkd then "-with-networkd" else ""}";
    meta = {};

    machine = { lib, ... }: {
      networking.usePredictableInterfaceNames = lib.mkForce predictable;
      networking.useNetworkd = withNetworkd;
      networking.dhcpcd.enable = !withNetworkd;
      networking.useDHCP = !withNetworkd;
    };

    testScript = ''
      print $machine->succeed("ip link");
      $machine->${if predictable then "fail" else "succeed"}("ip link show eth0 ");
    '';
  };
}) [[true false] [true false]])

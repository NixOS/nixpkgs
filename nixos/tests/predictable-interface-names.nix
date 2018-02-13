{ system ? builtins.currentSystem
, pkgs ? import ../.. { inherit system; }
}:
with import ../lib/testing.nix { inherit system; };
let boolToString = x: if x then "yes" else "no"; in
let testWhenSetTo = predictable: withNetworkd:
makeTest {
  name = "${if predictable then "" else "un"}predictableInterfaceNames${if withNetworkd then "-with-networkd" else ""}";
  meta = {};

  machine = { config, pkgs, ... }: {
    networking.usePredictableInterfaceNames = pkgs.stdenv.lib.mkForce predictable;
    networking.useNetworkd = withNetworkd;
    networking.dhcpcd.enable = !withNetworkd;
  };

  testScript = ''
    print $machine->succeed("ip link");
    $machine->succeed("ip link show ${if predictable then "ens3" else "eth0"}");
    $machine->fail("ip link show ${if predictable then "eth0" else "ens3"}");
  '';
}; in
with pkgs.stdenv.lib.lists;
with pkgs.stdenv.lib.attrsets;
listToAttrs (map (drv: nameValuePair drv.name drv) (
crossLists testWhenSetTo [[true false] [true false]]
))

{ system ? builtins.currentSystem }:
with import ../lib/testing.nix { inherit system; };
let boolToString = x: if x then "yes" else "no"; in
let testWhenSetTo = predictable: withNetworkd:
makeTest {
  name = "predictableInterfaceNames-${boolToString predictable}-with-networkd-${boolToString withNetworkd}";

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
map (f: map f [true false]) (map testWhenSetTo [ true false ])

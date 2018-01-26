{ system ? builtins.currentSystem }:
with import ../lib/testing.nix { inherit system; };
let testWhenSetTo = status:
makeTest {
  name = "predictableInterfaceNames-${if status then "true" else "false"}";

  machine = { config, pkgs, ... }: {
    networking.usePredictableInterfaceNames = pkgs.stdenv.lib.mkForce status;
  };

  testScript = ''
    print $machine->succeed("ip link show ${if status then "ens3" else "eth0"}");
    print $machine->fail("ip link show ${if status then "eth0" else "ens3"}");
  '';
}; in
map testWhenSetTo [ true false ]

{ system ? builtins.currentSystem }:

let
  inherit (import ../lib/testing.nix { inherit system; }) makeTest pkgs;
  inherit (pkgs) lib;
in lib.listToAttrs (map ({ predictable, withNetworkd ? false, withInitrdNetwork ? false }: rec {
  name = lib.optionalString (!predictable) "un" + "predictable"
       + lib.optionalString withNetworkd "Networkd"
       + lib.optionalString withInitrdNetwork "InitrdNetwork";

  value = makeTest {
    name = builtins.replaceStrings ["predictable"] ["predictableInterfaceNames"] name;
    meta = {};

    machine = { lib, ... }: {
      imports = [ ../modules/profiles/minimal.nix ];
      networking.usePredictableInterfaceNames = lib.mkForce predictable;
      networking.useNetworkd = withNetworkd;
      networking.dhcpcd.enable = !withNetworkd;
      boot.initrd.network.enable = withInitrdNetwork;

      # Ensure initrd DHCP works with predictable names.
      # Use the same method as in tests/initrd-network.nix
      boot.initrd.network.postCommands = lib.mkIf (predictable && !withNetworkd && withInitrdNetwork) ''
        ip addr | grep 10.0.2.15 || exit 1
        ping -c1 10.0.2.2 || exit 1
      '';
    };

    testScript = ''
      print $machine->succeed("ip link");
      $machine->succeed("ip link show ${if predictable then "ens3" else "eth0"}");
      $machine->fail("ip link show ${if predictable then "eth0" else "ens3"}");
    '';
  };
}) [
  { predictable = true; }
  { predictable = false; }

  { withNetworkd = true; predictable = true; }
  { withNetworkd = true; predictable = false; }

  { withInitrdNetwork = true; predictable = true; }
  { withInitrdNetwork = true; predictable = false; }
])

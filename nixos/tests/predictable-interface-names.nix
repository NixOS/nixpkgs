{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

let
  inherit (import ../lib/testing-python.nix { inherit system pkgs; }) makeTest;
  testCombinations = pkgs.lib.cartesianProductOfSets {
    predictable = [true false];
    withNetworkd = [true false];
    systemdStage1 = [true false];
  };
in pkgs.lib.listToAttrs (builtins.map ({ predictable, withNetworkd, systemdStage1 }: {
  name = pkgs.lib.optionalString (!predictable) "un" + "predictable"
       + pkgs.lib.optionalString withNetworkd "Networkd"
       + pkgs.lib.optionalString systemdStage1 "SystemdStage1";
  value = makeTest {
    name = pkgs.lib.optionalString (!predictable) "un" + "predictableInterfaceNames"
         + pkgs.lib.optionalString withNetworkd "-with-networkd"
         + pkgs.lib.optionalString systemdStage1 "-systemd-stage-1";
    meta = {};

    nodes.machine = { lib, ... }: let
      script = ''
        ip link
        if ${lib.optionalString predictable "!"} ip link show eth0; then
          echo Success
        else
          exit 1
        fi
      '';
    in {
      networking.usePredictableInterfaceNames = lib.mkForce predictable;
      networking.useNetworkd = withNetworkd;
      networking.dhcpcd.enable = !withNetworkd;
      networking.useDHCP = !withNetworkd;

      # Check if predictable interface names are working in stage-1
      boot.initrd.postDeviceCommands = script;

      boot.initrd.systemd = lib.mkIf systemdStage1 {
        enable = true;
        initrdBin = [ pkgs.iproute2 ];
        services.systemd-udev-settle.wantedBy = ["initrd.target"];
        services.check-interfaces = {
          requiredBy = ["initrd.target"];
          after = ["systemd-udev-settle.service"];
          serviceConfig.Type = "oneshot";
          path = [ pkgs.iproute2 ];
          inherit script;
        };
      };
    };

    testScript = ''
      print(machine.succeed("ip link"))
      machine.${if predictable then "fail" else "succeed"}("ip link show eth0")
    '';
  };
}) testCombinations)

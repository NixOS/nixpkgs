{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
}:

let
  inherit (import ../lib/testing-python.nix { inherit system pkgs; }) makeTest;
  testCombinations = pkgs.lib.cartesianProduct {
    predictable = [
      true
      false
    ];
    withNetworkd = [
      true
      false
    ];
  };
in
pkgs.lib.listToAttrs (
  map (
    {
      predictable,
      withNetworkd,
    }:
    {
      name =
        pkgs.lib.optionalString (!predictable) "un"
        + "predictable"
        + pkgs.lib.optionalString withNetworkd "Networkd";
      value = makeTest {
        name =
          pkgs.lib.optionalString (!predictable) "un"
          + "predictableInterfaceNames"
          + pkgs.lib.optionalString withNetworkd "-with-networkd";
        meta = { };

        nodes.machine =
          {
            config,
            pkgs,
            lib,
            ...
          }:
          let
            script = ''
              ${lib.getExe' config.boot.initrd.systemd.package "udevadm"} settle --timeout=180
              ip link
              if ${lib.optionalString predictable "!"} ip link show eth0; then
                echo Success
              else
                exit 1
              fi
            '';
          in
          {
            networking.usePredictableInterfaceNames = lib.mkForce predictable;
            networking.useNetworkd = withNetworkd;
            networking.dhcpcd.enable = !withNetworkd;
            networking.useDHCP = !withNetworkd;

            boot.initrd.systemd = {
              initrdBin = [ pkgs.iproute2 ];
              services.systemd-udev-settle.wantedBy = [ "initrd.target" ];
              services.check-interfaces = {
                requiredBy = [ "initrd.target" ];
                after = [ "systemd-udev-settle.service" ];
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
    }
  ) testCombinations
)

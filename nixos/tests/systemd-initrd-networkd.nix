{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
  lib ? pkgs.lib,
}:

with import ../lib/testing-python.nix { inherit system pkgs; };

let
  inherit (lib.maintainers) elvishjerricco;

  common = {
    boot.initrd.systemd = {
      enable = true;
      network.wait-online.timeout = 10;
      network.wait-online.anyInterface = true;
      targets.network-online.requiredBy = [ "initrd.target" ];
      services.systemd-networkd-wait-online.requiredBy = [ "network-online.target" ];
      initrdBin = [
        pkgs.iproute2
        pkgs.iputils
        pkgs.gnugrep
      ];
    };
    testing.initrdBackdoor = true;
    boot.initrd.network.enable = true;
  };

  mkFlushTest =
    flush: script:
    makeTest {
      name = "systemd-initrd-network-${lib.optionalString (!flush) "no-"}flush";
      meta.maintainers = [ elvishjerricco ];

      nodes.machine = {
        imports = [ common ];

        boot.initrd.network.flushBeforeStage2 = flush;
        systemd.services.check-flush = {
          requiredBy = [ "multi-user.target" ];
          before = [
            "network-pre.target"
            "multi-user.target"
            "shutdown.target"
          ];
          conflicts = [ "shutdown.target" ];
          wants = [ "network-pre.target" ];
          unitConfig.DefaultDependencies = false;
          serviceConfig.Type = "oneshot";
          path = [
            pkgs.iproute2
            pkgs.iputils
            pkgs.gnugrep
          ];
          inherit script;
        };
      };

      testScript = ''
        machine.wait_for_unit("network-online.target")
        machine.succeed(
            "ip addr | grep 10.0.2.15",
            "ping -c1 10.0.2.2",
        )
        machine.switch_root()

        machine.wait_for_unit("multi-user.target")
      '';
    };

in
{
  basic = makeTest {
    name = "systemd-initrd-network";
    meta.maintainers = [ elvishjerricco ];

    nodes.machine = common;

    testScript = ''
      machine.wait_for_unit("network-online.target")
      machine.succeed(
          "ip addr | grep 10.0.2.15",
          "ping -c1 10.0.2.2",
      )
      machine.switch_root()

      # Make sure the systemd-network user was set correctly in initrd
      machine.wait_for_unit("multi-user.target")
      machine.succeed("[ $(stat -c '%U,%G' /run/systemd/netif/links) = systemd-network,systemd-network ]")
      machine.succeed("ip addr show >&2")
      machine.succeed("ip route show >&2")
    '';
  };

  doFlush = mkFlushTest true ''
    if ip addr | grep 10.0.2.15; then
      echo "Network configuration survived switch-root; flushBeforeStage2 failed"
      exit 1
    fi
  '';

  dontFlush = mkFlushTest false ''
    if ! (ip addr | grep 10.0.2.15); then
      echo "Network configuration didn't survive switch-root"
      exit 1
    fi
  '';
}

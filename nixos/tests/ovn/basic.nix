{
  config,
  lib,
  ...
}:

let
  pkgs = config.node.pkgs;
  common = import ./common.nix { inherit lib pkgs; };
  certificates = common.mkCertificates {
    control-plane = [
      "server"
      "admin"
    ];
    chassis = [
      "relay"
      "chassis1"
      "chassis2"
    ];
  };
  serverTls = common.tlsFor "control-plane" "server";
  controllerTls = common.tlsFor "chassis";
in
{
  name = "ovn-basic";
  meta.maintainers = pkgs.ovn.meta.maintainers;

  nodes = {
    northbound = {
      imports = [ (common.node certificates "192.168.1.3") ];

      services.ovn.northbound = {
        enable = true;
        listeners.client.openFirewall = true;
        tls = serverTls;
      };
    };

    southbound = {
      imports = [ (common.node certificates "192.168.1.5") ];

      services.ovn = {
        southbound = {
          enable = true;
          tls = serverTls;
          listeners.administration = {
            openFirewall = true;
            port = 16642;
            role = null;
          };
          listeners.closed = {
            port = 17642;
            role = null;
          };
        };
        relay = {
          enable = true;
          tls = controllerTls "relay";
          listeners.controllers.openFirewall = true;
        };
      };
    };

    northd = {
      imports = [ (common.node certificates "192.168.1.4") ];

      services.ovn.northd = {
        enable = true;
        northbound = "ssl:192.168.1.3:6641";
        southbound = "ssl:192.168.1.5:16642";
        tls = common.tlsFor "control-plane" "admin";
      };
    };

    chassis1 = {
      imports = [ (common.node certificates "192.168.1.1") ];

      services.ovn.controller = {
        enable = true;
        openFirewall = true;
        instances.default = {
          chassisName = "chassis1";
          encapsulation = {
            ips = [ "192.168.1.1" ];
          };
          tls = controllerTls "chassis1";
          settings = {
            "ovn-remote" = "ssl:192.168.1.5:6642";
            "ovn-bridge-mappings" = "provider:br-provider";
          };
        };
      };
    };

    chassis2 = {
      imports = [ (common.node certificates "192.168.1.2") ];

      services.ovn.controller = {
        enable = true;
        openFirewall = true;
        instances.default = {
          chassisName = "chassis2";
          encapsulation = {
            ips = [ "192.168.1.2" ];
          };
          tls = controllerTls "chassis2";
          settings = {
            "ovn-remote" = "ssl:192.168.1.5:6642";
            "ovn-bridge-mappings" = "provider:br-provider";
          };
        };
      };
    };
  };

  testScript = # python
    ''
      start_all()

      northbound.wait_for_unit("ovn-northbound.service")
      southbound.wait_for_unit("ovn-southbound.service")
      southbound.wait_for_unit("ovn-relay.service")
      northd.wait_for_unit("ovn-northd.service")
      chassis1.wait_for_unit("ovn-controller-default.service")
      chassis2.wait_for_unit("ovn-controller-default.service")

      nb = "ovn-nbctl ${common.tlsFlags "control-plane" "admin"} --db=ssl:192.168.1.3:6641"
      sb_local = "ovn-sbctl --db=unix:/run/ovn/ovnsb_db.sock"
      admin_tls = "${common.tlsFlags "control-plane" "admin"}"
      chassis1_tls = "${common.tlsFlags "chassis" "chassis1"}"

      southbound.wait_until_succeeds(f"{sb_local} get Chassis chassis1 name | grep -qx chassis1")
      southbound.wait_until_succeeds(f"{sb_local} get Chassis chassis2 name | grep -qx chassis2")

      with subtest("overlay connectivity"):
          northbound.succeed(
              f"{nb} ls-add overlay",
              f"{nb} lsp-add overlay port1",
              f"{nb} lsp-set-addresses port1 '00:00:00:00:00:01 10.0.0.1'",
              f"{nb} lsp-add overlay port2",
              f"{nb} lsp-set-addresses port2 '00:00:00:00:00:02 10.0.0.2'",
          )
          chassis1.succeed(
              "ovs-vsctl --may-exist add-port br-int vif1 -- "
              "set Interface vif1 type=internal external_ids:iface-id=port1",
              "${pkgs.iproute2}/bin/ip link set vif1 address 00:00:00:00:00:01",
              "${pkgs.iproute2}/bin/ip addr add 10.0.0.1/24 dev vif1",
              "${pkgs.iproute2}/bin/ip link set vif1 up",
          )
          chassis2.succeed(
              "ovs-vsctl --may-exist add-port br-int vif2 -- "
              "set Interface vif2 type=internal external_ids:iface-id=port2",
              "${pkgs.iproute2}/bin/ip link set vif2 address 00:00:00:00:00:02",
              "${pkgs.iproute2}/bin/ip addr add 10.0.0.2/24 dev vif2",
              "${pkgs.iproute2}/bin/ip link set vif2 up",
          )
          chassis1.wait_until_succeeds("${pkgs.iputils}/bin/ping -I vif1 -c 1 10.0.0.2", timeout=60)
          chassis2.wait_until_succeeds("${pkgs.iputils}/bin/ping -I vif2 -c 1 10.0.0.1", timeout=60)

      with subtest("bridge mappings"):
          chassis1.succeed("ovs-vsctl --may-exist add-br br-provider")
          chassis2.succeed("ovs-vsctl --may-exist add-br br-provider")
          southbound.wait_until_succeeds(
              f"{sb_local} get Chassis chassis1 other_config:ovn-bridge-mappings "
              "| grep -q provider:br-provider"
          )
          southbound.wait_until_succeeds(
              f"{sb_local} get Chassis chassis2 other_config:ovn-bridge-mappings "
              "| grep -q provider:br-provider"
          )

      with subtest("southbound RBAC"):
          chassis1.succeed(
              f"ovn-sbctl --timeout=5 --no-leader-only {chassis1_tls} "
              "--db=ssl:192.168.1.5:6642 list Chassis"
          )
          restricted = (
              f"ovn-sbctl --timeout=5 --no-leader-only {chassis1_tls} "
              "--db=ssl:192.168.1.5:6642 "
              "chassis-add rogue geneve 192.0.2.1"
          )
          unrestricted = (
              f"ovn-sbctl {admin_tls} --db=ssl:192.168.1.5:16642 "
              "chassis-add rogue geneve 192.0.2.1"
          )
          chassis1.fail(restricted)
          northd.succeed(unrestricted)
          southbound.succeed(f"{sb_local} chassis-del rogue")

      with subtest("chassis credentials cannot authenticate to the database"):
          admin_endpoint = "--db=ssl:192.168.1.5:16642 list Chassis"
          chassis1.succeed(f"ovn-sbctl --timeout=5 {admin_tls} {admin_endpoint}")
          # Trust the database's server certificate so the failure tests the
          # database rejecting the client, not the client rejecting the server.
          chassis1.fail(
              f"ovn-sbctl --timeout=5 {chassis1_tls} "
              "--ca-cert=${serverTls.caCertificate} "
              f"{admin_endpoint}"
          )
          chassis1.succeed(f"{nb} --timeout=5 list NB_Global")
          chassis1.fail(
              f"ovn-nbctl --timeout=5 {chassis1_tls} "
              "--ca-cert=${serverTls.caCertificate} "
              "--db=ssl:192.168.1.3:6641 list NB_Global"
          )

      with subtest("only explicitly opened listeners are reachable"):
          southbound.succeed(
              f"ovn-sbctl --timeout=5 {admin_tls} "
              "--db=ssl:127.0.0.1:17642 list Chassis"
          )
          chassis1.fail(
              f"ovn-sbctl --timeout=5 {admin_tls} "
              "--db=ssl:192.168.1.5:17642 list Chassis"
          )

      with subtest("service restart"):
          northd.succeed("systemctl restart ovn-northd.service")
          southbound.succeed("systemctl restart ovn-relay.service")
          chassis1.succeed("systemctl restart ovs-vswitchd.service")
          chassis1.wait_for_unit("ovs-vswitchd.service")
          chassis1.succeed("systemctl restart ovn-controller-default.service")
          northd.wait_for_unit("ovn-northd.service")
          chassis1.wait_for_unit("ovn-controller-default.service")
          chassis1.wait_until_succeeds("${pkgs.iputils}/bin/ping -I vif1 -c 1 10.0.0.2", timeout=30)
    '';
}

{
  config,
  lib,
  ...
}:

let
  pkgs = config.node.pkgs;
  common = import ./common.nix { inherit lib pkgs; };
  certificates = common.mkCertificates [
    "server"
    "admin"
    "chassis1"
    "chassis2"
  ];
  serverTls = common.tlsFor "server";
  controllerTls = common.tlsFor;
in
{
  name = "ovn-basic";

  nodes = {
    northbound = {
      imports = [ (common.node certificates "192.168.1.3") ];

      services.ovn.northbound = {
        enable = true;
        openFirewall = true;
        listeners.client = { };
      };
    };

    southbound = {
      imports = [ (common.node certificates "192.168.1.5") ];

      services.ovn.southbound = {
        enable = true;
        openFirewall = true;
        tls = serverTls;
        listeners = {
          controllers = { };
          administration = {
            port = 16642;
            role = null;
          };
        };
      };
    };

    northd = {
      imports = [ (common.node certificates "192.168.1.4") ];

      services.ovn.northd = {
        enable = true;
        northbound = "tcp:192.168.1.3:6641";
        southbound = "ssl:192.168.1.5:16642";
        tls = controllerTls "admin";
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
      northd.wait_for_unit("ovn-northd.service")
      chassis1.wait_for_unit("ovn-controller-default.service")
      chassis2.wait_for_unit("ovn-controller-default.service")

      nb = "ovn-nbctl --db=tcp:192.168.1.3:6641"
      sb_local = "ovn-sbctl --db=unix:/run/ovn/ovnsb_db.sock"
      admin_tls = (
          "--private-key=${certificates}/admin.key "
          "--certificate=${certificates}/admin.crt "
          "--ca-cert=${certificates}/ca.crt"
      )
      chassis1_tls = (
          "--private-key=${certificates}/chassis1.key "
          "--certificate=${certificates}/chassis1.crt "
          "--ca-cert=${certificates}/ca.crt"
      )

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
          remotes = southbound.succeed(
              "ovn-appctl -t /run/ovn/ovnsb_db.ctl ovsdb-server/list-remotes"
          )
          assert "pssl:6642:0.0.0.0" in remotes
          assert "pssl:16642:0.0.0.0" in remotes

          restricted = (
              f"ovn-sbctl {chassis1_tls} --db=ssl:192.168.1.5:6642 "
              "chassis-add rogue geneve 192.0.2.1"
          )
          unrestricted = (
              f"ovn-sbctl {admin_tls} --db=ssl:192.168.1.5:16642 "
              "chassis-add rogue geneve 192.0.2.1"
          )
          chassis1.fail(restricted)
          northd.succeed(unrestricted)
          southbound.succeed(f"{sb_local} chassis-del rogue")

      with subtest("service restart"):
          northd.succeed("systemctl restart ovn-northd.service")
          chassis1.succeed("systemctl restart ovn-controller-default.service")
          northd.wait_for_unit("ovn-northd.service")
          chassis1.wait_for_unit("ovn-controller-default.service")
          chassis1.wait_until_succeeds("${pkgs.iputils}/bin/ping -I vif1 -c 1 10.0.0.2", timeout=30)
    '';
}

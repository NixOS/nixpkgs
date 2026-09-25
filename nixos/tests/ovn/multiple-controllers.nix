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
    "compute-blue"
    "compute-red"
  ];
in
{
  name = "ovn-multiple-controllers";

  nodes = {
    central = {
      imports = [ (common.node certificates "192.168.1.1") ];

      services.ovn = {
        northbound.enable = true;
        southbound = {
          enable = true;
          openFirewall = true;
          tls = common.tlsFor "server";
          listeners.controllers = { };
        };
        northd.enable = true;
      };
    };

    compute = {
      imports = [ (common.node certificates "192.168.1.2") ];

      networking.interfaces.eth1.ipv4.addresses = [
        {
          address = "192.168.1.22";
          prefixLength = 24;
        }
      ];

      services.ovn.controller = {
        enable = true;
        openFirewall = true;
        settings."ovn-test-global" = "external-id-value";
        instances = {
          blue = {
            chassisName = "compute-blue";
            encapsulation = {
              ips = [ "192.168.1.22" ];
            };
            tls = common.tlsFor "compute-blue";
            settings = {
              "ovn-remote" = "ssl:192.168.1.1:6642";
              "ovn-bridge" = "br-int-blue";
              "ct-zone-range" = "1-30000";
            };
          };
          red = {
            chassisName = "compute-red";
            encapsulation = {
              ips = [ "192.168.1.2" ];
            };
            tls = common.tlsFor "compute-red";
            settings = {
              "ovn-remote" = "ssl:192.168.1.1:6642";
              "ovn-bridge" = "br-int-red";
              "ct-zone-range" = "30001-60000";
            };
          };
        };
      };

      virtualisation.vswitch.externalIds."test-non-ovn" = "merged-value";
    };
  };

  testScript = # python
    ''
      import datetime
      import json


      def ovs_external_ids(machine):
          table = json.loads(
              machine.succeed(
                  "ovs-vsctl --format=json --columns=external_ids list Open_vSwitch"
              )
          )
          kind, entries = table["data"][0][0]
          assert kind == "map"
          return dict(entries)


      start_all()

      central.wait_for_unit("ovn-northd.service")
      compute.wait_for_unit("ovn-controller-blue.service")
      compute.wait_for_unit("ovn-controller-red.service")

      nb = "ovn-nbctl --db=unix:/run/ovn/ovnnb_db.sock"
      sb = "ovn-sbctl --db=unix:/run/ovn/ovnsb_db.sock"

      def sb_find(column, table, condition):
          return central.succeed(
              f"{sb} --bare --columns={column} find {table} {condition}"
          ).strip()


      def wait_for_port_binding(logical_port, chassis_name):
          def is_bound(_):
              chassis = sb_find("_uuid", "Chassis", f"name={chassis_name}")
              binding = sb_find(
                  "chassis",
                  "Port_Binding",
                  f"logical_port={logical_port}",
              )
              return bool(chassis) and binding == chassis

          retry(is_bound, timeout=datetime.timedelta(seconds=60))


      central.wait_until_succeeds(f"{sb} get Chassis compute-blue name | grep -qx compute-blue")
      central.wait_until_succeeds(f"{sb} get Chassis compute-red name | grep -qx compute-red")

      with subtest("per-controller configuration"):
          external_ids = ovs_external_ids(compute)
          for name, expected in {
              "ovn-test-global": "external-id-value",
              "test-non-ovn": "merged-value",
              "ovn-bridge-compute-blue": "br-int-blue",
              "ovn-bridge-compute-red": "br-int-red",
              "ovn-encap-type-compute-blue": "geneve",
              "ovn-encap-ip-compute-blue": "192.168.1.22",
              "ovn-encap-type-compute-red": "geneve",
              "ovn-encap-ip-compute-red": "192.168.1.2",
          }.items():
              actual = external_ids.get(name)
              assert actual == expected, f"{name}: expected {expected!r}, got {actual!r}"

          compute.succeed(
              "ovs-vsctl br-exists br-int-blue",
              "ovs-vsctl br-exists br-int-red",
              "test -S /run/ovn/ovn-controller-blue.ctl",
              "test -S /run/ovn/ovn-controller-red.ctl",
          )

      with subtest("logical ports bind to separate chassis"):
          central.succeed(
              f"{nb} ls-add blue-switch",
              f"{nb} lsp-add blue-switch blue-port",
              f"{nb} lsp-set-addresses blue-port '00:00:00:00:01:01 10.1.0.1'",
              f"{nb} ls-add red-switch",
              f"{nb} lsp-add red-switch red-port",
              f"{nb} lsp-set-addresses red-port '00:00:00:00:02:01 10.2.0.1'",
          )
          compute.succeed(
              "ovs-vsctl --may-exist add-port br-int-blue blue-vif -- "
              "set Interface blue-vif type=internal external_ids:iface-id=blue-port",
              "ovs-vsctl --may-exist add-port br-int-red red-vif -- "
              "set Interface red-vif type=internal external_ids:iface-id=red-port",
          )
          wait_for_port_binding("blue-port", "compute-blue")
          wait_for_port_binding("red-port", "compute-red")
    '';
}

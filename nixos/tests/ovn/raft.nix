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
    "node1"
    "node2"
    "node3"
  ];
  serverTls = common.tlsFor "server";
  northboundRemotes = lib.concatStringsSep "," [
    "tcp:192.168.1.1:6641"
    "tcp:192.168.1.2:6641"
    "tcp:192.168.1.3:6641"
  ];
  databaseRemotes = lib.concatStringsSep "," [
    "ssl:192.168.1.1:6642"
    "ssl:192.168.1.2:6642"
    "ssl:192.168.1.3:6642"
  ];
  northdSouthboundRemotes = lib.concatStringsSep "," [
    "ssl:192.168.1.1:16642"
    "ssl:192.168.1.2:16642"
    "ssl:192.168.1.3:16642"
  ];

  raftDatabase = address: bootstrap: {
    enable = true;
    openFirewall = true;
    mode = "raft";
    listeners.client = { };
    tls = serverTls;
    raft = {
      transport = "ssl";
      localAddress = address;
      bootstrap = bootstrap;
    };
  };

  node =
    {
      address,
      chassisName,
      bootstrap,
    }:
    {
      imports = [ (common.node certificates address) ];

      services.ovn = {
        northbound = raftDatabase address bootstrap;
        southbound = (raftDatabase address bootstrap) // {
          listeners = {
            client = { };
            administration = {
              port = 16642;
              role = null;
            };
          };
        };
        northd = {
          enable = true;
          northbound = northboundRemotes;
          southbound = northdSouthboundRemotes;
          tls = serverTls;
        };

        controller = {
          enable = true;
          openFirewall = true;
          instances.default = {
            inherit chassisName;
            encapsulation = {
              ips = [ address ];
            };
            tls = common.tlsFor chassisName;
            settings."ovn-remote" = databaseRemotes;
          };
        };
      };
    };
in
{
  name = "ovn-raft";

  nodes = {
    node1 = node {
      address = "192.168.1.1";
      chassisName = "node1";
      bootstrap.mode = "create";
    };
    node2 = node {
      address = "192.168.1.2";
      chassisName = "node2";
      bootstrap = {
        mode = "join";
        address = "192.168.1.1";
      };
    };
    node3 = node {
      address = "192.168.1.3";
      chassisName = "node3";
      bootstrap = {
        mode = "join";
        address = "192.168.1.1";
      };
    };
  };

  testScript = # python
    ''
      import time

      start_all()

      machines = [node1, node2, node3]
      for machine in machines:
          machine.wait_for_unit("ovn-northbound.service", timeout=120)
          machine.wait_for_unit("ovn-southbound.service", timeout=120)
          machine.wait_for_unit("ovn-northd.service", timeout=120)
          machine.wait_for_unit("ovn-controller-default.service", timeout=120)

      nb = (
          "ovn-nbctl --timeout=30 "
          "--db=tcp:192.168.1.1:6641,tcp:192.168.1.2:6641,tcp:192.168.1.3:6641"
      )
      sb_tls = (
          "ovn-sbctl --timeout=30 "
          "--private-key=${certificates}/node1.key "
          "--certificate=${certificates}/node1.crt "
          "--ca-cert=${certificates}/ca.crt "
          "--db=ssl:192.168.1.1:6642,ssl:192.168.1.2:6642,ssl:192.168.1.3:6642"
      )

      def cluster_status(machine, database):
          socket = "ovnnb_db.ctl" if database == "OVN_Northbound" else "ovnsb_db.ctl"
          return machine.execute(
              f"ovn-appctl -t /run/ovn/{socket} cluster/status {database}"
          )

      def wait_for_leader(database, excluded=None):
          for _ in range(60):
              for machine in machines:
                  if machine is excluded:
                      continue
                  status, output = cluster_status(machine, database)
                  if status == 0 and "Role: leader" in output:
                      return machine
              time.sleep(1)
          raise Exception(f"no leader elected for {database}")

      with subtest("cluster membership"):
          for machine in machines:
              for database, port in [("OVN_Northbound", 6643), ("OVN_Southbound", 6644)]:
                  status, output = cluster_status(machine, database)
                  assert status == 0, output
                  for address in ["192.168.1.1", "192.168.1.2", "192.168.1.3"]:
                      assert f"ssl:{address}:{port}" in output, output

      with subtest("overlay connectivity"):
          node1.succeed(
              f"{nb} ls-add overlay",
              f"{nb} lsp-add overlay port1",
              f"{nb} lsp-set-addresses port1 '00:00:00:00:00:01 10.0.0.1'",
              f"{nb} lsp-add overlay port2",
              f"{nb} lsp-set-addresses port2 '00:00:00:00:00:02 10.0.0.2'",
          )
          node1.succeed(
              "ovs-vsctl --may-exist add-port br-int vif1 -- "
              "set Interface vif1 type=internal external_ids:iface-id=port1",
              "${pkgs.iproute2}/bin/ip link set vif1 address 00:00:00:00:00:01",
              "${pkgs.iproute2}/bin/ip addr add 10.0.0.1/24 dev vif1",
              "${pkgs.iproute2}/bin/ip link set vif1 up",
          )
          node2.succeed(
              "ovs-vsctl --may-exist add-port br-int vif2 -- "
              "set Interface vif2 type=internal external_ids:iface-id=port2",
              "${pkgs.iproute2}/bin/ip link set vif2 address 00:00:00:00:00:02",
              "${pkgs.iproute2}/bin/ip addr add 10.0.0.2/24 dev vif2",
              "${pkgs.iproute2}/bin/ip link set vif2 up",
          )
          node1.wait_until_succeeds("${pkgs.iputils}/bin/ping -I vif1 -c 1 10.0.0.2", timeout=60)

      with subtest("northbound leader failover"):
          leader = wait_for_leader("OVN_Northbound")
          leader.succeed("systemctl stop ovn-northbound.service")
          leader.succeed("systemctl is-active ovn-northd.service")
          wait_for_leader("OVN_Northbound", excluded=leader)
          leader.wait_until_succeeds(
              "ovn-appctl -t /run/ovn/ovn-northd.ctl "
              "nb-connection-status | grep -qx connected",
              timeout=60,
          )
          node2.succeed(f"{nb} ls-add after-nb-failover")
          leader.succeed("systemctl start ovn-northbound.service")
          leader.wait_for_unit("ovn-northbound.service", timeout=60)
          node1.wait_until_succeeds(f"{nb} ls-list | grep -q after-nb-failover")

      with subtest("southbound leader failover"):
          leader = wait_for_leader("OVN_Southbound")
          leader.succeed("systemctl stop ovn-southbound.service")
          leader.succeed("systemctl is-active ovn-northd.service")
          wait_for_leader("OVN_Southbound", excluded=leader)
          leader.wait_until_succeeds(
              "ovn-appctl -t /run/ovn/ovn-northd.ctl "
              "sb-connection-status | grep -qx connected",
              timeout=60,
          )
          node3.succeed(f"{nb} ls-add after-sb-failover")
          node1.wait_until_succeeds(
              f"{sb_tls} --bare --columns=_uuid "
              "find Datapath_Binding external_ids:name=after-sb-failover | grep -q .",
              timeout=60,
          )
          node1.wait_until_succeeds("${pkgs.iputils}/bin/ping -I vif1 -c 1 10.0.0.2", timeout=30)
          leader.succeed("systemctl start ovn-southbound.service")
          leader.wait_for_unit("ovn-southbound.service", timeout=60)
    '';
}

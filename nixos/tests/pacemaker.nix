import ./make-test-python.nix  ({ pkgs, lib, ... }: rec {
  name = "pacemaker";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ astro ];
  };

  nodes =
    let
      node = i: {
        networking.interfaces.eth1.ipv4.addresses = [ {
          address = "192.168.0.${toString i}";
          prefixLength = 24;
        } ];

        services.corosync = {
          enable = true;
          clusterName = "zentralwerk-network";
          nodelist = lib.imap (i: name: {
            nodeid = i;
            inherit name;
            ring_addrs = [
              (builtins.head nodes.${name}.networking.interfaces.eth1.ipv4.addresses).address
            ];
          }) (builtins.attrNames nodes);
        };
        environment.etc."corosync/authkey" = {
          source = builtins.toFile "authkey"
            # minimum length: 128 bytes
            "testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest";
          mode = "0400";
        };

        services.pacemaker.enable = true;

        # used for pacemaker resource
        systemd.services.ha-cat = {
          description = "Highly available netcat";
          serviceConfig.ExecStart = "${pkgs.netcat}/bin/nc -l discard";
        };
      };
    in {
      node1 = node 1;
      node2 = node 2;
      node3 = node 3;
    };

  # sets up pacemaker with resources configuration, then crashes a
  # node and waits for service restart on another node
  testScript =
    let
      vip = "192.168.0.100";

      resources = builtins.toFile "cib-resources.xml" ''
        <resources>
          <primitive id="cat" class="systemd" type="ha-cat">
            <operations>
              <op id="stop-cat" name="start" interval="0" timeout="1s"/>
              <op id="start-cat" name="start" interval="0" timeout="1s"/>
              <op id="monitor-cat" name="monitor" interval="1s" timeout="1s"/>
            </operations>
          </primitive>
          <primitive class="ocf" id="vip" provider="heartbeat" type="IPaddr2">
            <instance_attributes id="vip-instance_attributes">
              <nvpair id="vip-instance_attributes-cidr_netmask" name="cidr_netmask" value="24"/>
              <nvpair id="vip-instance_attributes-ip" name="ip" value="${vip}"/>
              <nvpair id="vip-instance_attributes-nic" name="nic" value="eth1"/>
            </instance_attributes>
            <operations>
              <op id="vip-monitor-interval-30s" interval="30s" name="monitor"/>
              <op id="vip-start-interval-0s" interval="0s" name="start" timeout="20s"/>
              <op id="vip-stop-interval-0s" interval="0s" name="stop" timeout="20s"/>
            </operations>
          </primitive>
        </resources>
      '';
      pacemaker = "pacemaker.service";
    in ''
      import re
      import time

      start_all()

      ${lib.concatMapStrings (node: ''
        ${node}.wait_until_succeeds("corosync-quorumtool")
        ${node}.wait_for_unit("${pacemaker}")
      '') (builtins.attrNames nodes)}

      def running_node():
        for machine in machines:
          if machine.booted:
            return machine

      def find_node_for_service(service_name):
        node = running_node()
        while True:
          output = node.succeed("crm_resource --resource {} --locate".format(service_name))
          match = re.search("is running on: (.+)", output)
          if match:
            for machine in machines:
              if machine.name == match.group(1):
                return machine
          time.sleep(1)

      def ping_vip():
        node = running_node()
        node.succeed("ping -v -4 -c 10 -i 1 ${vip}")

      # No STONITH device
      node1.succeed("crm_attribute -t crm_config -n stonith-enabled -v false")

      # Configure the test resources
      node1.succeed("cibadmin --replace --scope resources --xml-file ${resources}")

      # Validate that restarting the pacemaker systemd unit and then crashing
      # the node itself still results in a working cluster eventually.
      for service in ["cat", "vip"]:
        # Make sure all 3 nodes are up before each resource test is ran from prior crashes
        start_all()

        current_node = find_node_for_service(service)

        current_node.succeed("systemctl restart pacemaker")
        current_node.wait_for_unit("${pacemaker}")
        time.sleep(3) # pacemaker twiddles thumbs after restart, give it some time
        current_node = find_node_for_service(service)
        current_node.log("Service {} running here after systemctl restart".format(service))

        if service == "vip":
          ping_vip()

        current_node.crash()
        time.sleep(10)
        current_node = find_node_for_service(service)
        current_node.log("Service {} running here after crash".format(service))
        current_node.wait_for_unit("${pacemaker}")

        if service == "vip":
          ping_vip()
  '';
})

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
      resources = builtins.toFile "cib-resources.xml" ''
        <resources>
          <primitive id="cat" class="systemd" type="ha-cat">
            <operations>
              <op id="stop-cat" name="start" interval="0" timeout="1s"/>
              <op id="start-cat" name="start" interval="0" timeout="1s"/>
              <op id="monitor-cat" name="monitor" interval="1s" timeout="1s"/>
            </operations>
          </primitive>
        </resources>
      '';
    in ''
      import re
      import time

      start_all()

      ${lib.concatMapStrings (node: ''
        ${node}.wait_until_succeeds("corosync-quorumtool")
        ${node}.wait_for_unit("pacemaker.service")
      '') (builtins.attrNames nodes)}

      # No STONITH device
      node1.succeed("crm_attribute -t crm_config -n stonith-enabled -v false")
      # Configure the cat resource
      node1.succeed("cibadmin --replace --scope resources --xml-file ${resources}")

      # wait until the service is started
      while True:
        output = node1.succeed("crm_resource -r cat --locate")
        match = re.search("is running on: (.+)", output)
        if match:
          for machine in machines:
            if machine.name == match.group(1):
              current_node = machine
          break
        time.sleep(1)

      current_node.log("Service running here!")
      current_node.crash()

      # pick another node that's still up
      for machine in machines:
        if machine.booted:
          check_node = machine
      # find where the service has been started next
      while True:
        output = check_node.succeed("crm_resource -r cat --locate")
        match = re.search("is running on: (.+)", output)
        # output will remain the old current_node until the crash is detected by pacemaker
        if match and match.group(1) != current_node.name:
          for machine in machines:
            if machine.name == match.group(1):
              next_node = machine
          break
        time.sleep(1)

      next_node.log("Service migrated here!")
  '';
})

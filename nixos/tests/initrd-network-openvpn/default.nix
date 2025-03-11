{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
  systemdStage1 ? false,
}:

import ../make-test-python.nix (
  { lib, ... }:

  {
    name = "initrd-network-openvpn";

    nodes =
      let

        # Inlining of the shared secret for the
        # OpenVPN server and client
        secretblock = ''
          secret [inline]
          <secret>
          ${lib.readFile ./shared.key}
          </secret>
        '';

      in
      {

        # Minimal test case to check a successful boot, even with invalid config
        minimalboot =
          { ... }:
          {
            boot.initrd.systemd.enable = systemdStage1;
            boot.initrd.network = {
              enable = true;
              openvpn = {
                enable = true;
                configuration = builtins.toFile "initrd.ovpn" "";
              };
            };
          };

        # initrd VPN client
        ovpnclient =
          { ... }:
          {
            virtualisation.useBootLoader = true;
            virtualisation.vlans = [ 1 ];

            boot.initrd = {
              systemd.enable = systemdStage1;
              systemd.extraBin.nc = "${pkgs.busybox}/bin/nc";
              systemd.services.nc = {
                requiredBy = [ "initrd.target" ];
                after = [ "network.target" ];
                serviceConfig = {
                  ExecStart = "/bin/nc -p 1234 -lke /bin/echo TESTVALUE";
                  Type = "oneshot";
                };
              };

              # This command does not fork to keep the VM in the state where
              # only the initramfs is loaded
              preLVMCommands = lib.mkIf (!systemdStage1) ''
                /bin/nc -p 1234 -lke /bin/echo TESTVALUE
              '';

              network = {
                enable = true;

                # Work around udhcpc only getting a lease on eth0
                postCommands = lib.mkIf (!systemdStage1) ''
                  /bin/ip addr add 192.168.1.2/24 dev eth1
                '';

                # Example configuration for OpenVPN
                # This is the main reason for this test
                openvpn = {
                  enable = true;
                  configuration = "${./initrd.ovpn}";
                };
              };
            };
          };

        # VPN server and gateway for ovpnclient between vlan 1 and 2
        ovpnserver =
          { ... }:
          {
            virtualisation.vlans = [
              1
              2
            ];

            # Enable NAT and forward port 12345 to port 1234
            networking.nat = {
              enable = true;
              internalInterfaces = [ "tun0" ];
              externalInterface = "eth2";
              forwardPorts = [
                {
                  destination = "10.8.0.2:1234";
                  sourcePort = 12345;
                }
              ];
            };

            # Trust tun0 and allow the VPN Server to be reached
            networking.firewall = {
              trustedInterfaces = [ "tun0" ];
              allowedUDPPorts = [ 1194 ];
            };

            # Minimal OpenVPN server configuration
            services.openvpn.servers.testserver = {
              config = ''
                dev tun0
                ifconfig 10.8.0.1 10.8.0.2
                cipher AES-256-CBC
                ${secretblock}
              '';
            };
          };

        # Client that resides in the "external" VLAN
        testclient =
          { ... }:
          {
            virtualisation.vlans = [ 2 ];
          };
      };

    testScript = ''
      # Minimal test case, checks whether enabling (with invalid config) harms
      # the boot process
      with subtest("Check for successful boot with broken openvpn config"):
          minimalboot.start()
          # If we get to multi-user.target, we booted successfully
          minimalboot.wait_for_unit("multi-user.target")
          minimalboot.shutdown()

      # Elaborated test case where the ovpnclient (where this module is used)
      # can be reached by testclient only over ovpnserver.
      # This is an indirect test for success.
      with subtest("Check for connection from initrd VPN client, config as file"):
          ovpnserver.start()
          testclient.start()
          ovpnclient.start()

          # Wait until the OpenVPN Server is available
          ovpnserver.wait_for_unit("openvpn-testserver.service")
          ovpnserver.succeed("ping -c 1 10.8.0.1")

          # Wait for the client to connect
          ovpnserver.wait_until_succeeds("ping -c 1 10.8.0.2")

          # Wait until the testclient has network
          testclient.wait_for_unit("network.target")

          # Check that ovpnclient is reachable over vlan 1
          ovpnserver.succeed("nc -w 2 192.168.1.2 1234 | grep -q TESTVALUE")

          # Check that ovpnclient is reachable over tun0
          ovpnserver.succeed("nc -w 2 10.8.0.2 1234 | grep -q TESTVALUE")

          # Check that ovpnclient is reachable from testclient over the gateway
          testclient.succeed("nc -w 2 192.168.2.3 12345 | grep -q TESTVALUE")
    '';
  }
)

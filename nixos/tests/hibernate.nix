# Test whether hibernation from partition works.

import ./make-test-python.nix (pkgs: {
  name = "hibernate";

  nodes = {
    machine = { config, lib, pkgs, ... }: with lib; {
      virtualisation.emptyDiskImages = [ config.virtualisation.memorySize ];

      systemd.services.backdoor.conflicts = [ "sleep.target" ];

      swapDevices = mkOverride 0 [ { device = "/dev/vdb"; } ];

      networking.firewall.allowedTCPPorts = [ 4444 ];

      systemd.services.listener.serviceConfig.ExecStart = "${pkgs.netcat}/bin/nc -l 4444 -k";
    };

    probe = { pkgs, ...}: {
      environment.systemPackages = [ pkgs.netcat ];
    };
  };

  # 9P doesn't support reconnection to virtio transport after a hibernation.
  # Therefore, machine just hangs on any Nix store access.
  # To work around it we run a daemon which listens to a TCP connection and
  # try to connect to it as a test.

  testScript =
    ''
      machine.start()
      machine.wait_for_unit("multi-user.target")
      machine.succeed("mkswap /dev/vdb")
      machine.succeed("swapon -a")
      machine.start_job("listener")
      machine.wait_for_open_port(4444)
      machine.succeed("systemctl hibernate &")
      machine.wait_for_shutdown()
      probe.wait_for_unit("multi-user.target")
      machine.start()
      probe.wait_until_succeeds("echo test | nc machine 4444 -N")
    '';

})

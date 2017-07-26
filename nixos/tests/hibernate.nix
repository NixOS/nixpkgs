# Test whether hibernation from partition works.

import ./make-test.nix (pkgs: {
  name = "hibernate";

  nodes = {
    machine = { config, lib, pkgs, ... }: with lib; {
      virtualisation.emptyDiskImages = [ config.virtualisation.memorySize ];

      systemd.services.backdoor.conflicts = [ "sleep.target" ];

      swapDevices = mkOverride 0 [ { device = "/dev/vdb"; } ];

      networking.firewall.allowedTCPPorts = [ 4444 ];

      systemd.services.listener.serviceConfig.ExecStart = "${pkgs.netcat}/bin/nc -l 4444 -k";
    };

    probe = { config, lib, pkgs, ...}: {
      environment.systemPackages = [ pkgs.netcat ];
    };
  };

  # 9P doesn't support reconnection to virtio transport after a hibernation.
  # Therefore, machine just hangs on any Nix store access.
  # To work around it we run a daemon which listens to a TCP connection and
  # try to connect to it as a test.

  testScript =
    ''
      $machine->waitForUnit("multi-user.target");
      $machine->succeed("mkswap /dev/vdb");
      $machine->succeed("swapon -a");
      $machine->startJob("listener");
      $machine->waitForOpenPort(4444);
      $machine->succeed("systemctl hibernate &");
      $machine->waitForShutdown;
      $machine->start;
      $probe->waitForUnit("network.target");
      $probe->waitUntilSucceeds("echo test | nc machine 4444");
    '';

})

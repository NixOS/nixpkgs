# Test for NixOS' container support.

import ./make-test.nix ({ pkgs, ...} : {
  name = "containers-hosts";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ montag451 ];
  };

  machine =
    { lib, ... }:
    {
      virtualisation.memorySize = 256;
      virtualisation.vlans = [];

      networking.bridges.br0.interfaces = [];
      networking.interfaces.br0.ipv4.addresses = [
        { address = "10.11.0.254"; prefixLength = 24; }
      ];

      # Force /etc/hosts to be the only source for host name resolution
      environment.etc."nsswitch.conf".text = lib.mkForce ''
        hosts: files
      '';

      containers.simple = {
        autoStart = true;
        privateNetwork = true;
        localAddress = "10.10.0.1";
        hostAddress = "10.10.0.254";

        config = {};
      };

      containers.netmask = {
        autoStart = true;
        privateNetwork = true;
        hostBridge = "br0";
        localAddress = "10.11.0.1/24";

        config = {};
      };
    };

  testScript = ''
    startAll;
    $machine->waitForUnit("default.target");

    # Ping the containers using the entries added in /etc/hosts
    $machine->succeed("ping -n -c 1 simple.containers");
    $machine->succeed("ping -n -c 1 netmask.containers");
  '';
})

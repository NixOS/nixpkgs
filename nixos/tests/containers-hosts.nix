{ pkgs, lib, ... }:
{
  name = "containers-hosts";
  meta = {
    maintainers = with lib.maintainers; [ montag451 ];
  };

  nodes.machine =
    { lib, ... }:
    {
      virtualisation.vlans = [ ];

      networking.bridges.br0.interfaces = [ ];
      networking.interfaces.br0.ipv4.addresses = [
        {
          address = "10.11.0.254";
          prefixLength = 24;
        }
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

        config = { };
      };

      containers.netmask = {
        autoStart = true;
        privateNetwork = true;
        hostBridge = "br0";
        localAddress = "10.11.0.1/24";

        config = { };
      };
    };

  testScript = ''
    start_all()
    machine.wait_for_unit("default.target")

    with subtest("Ping the containers using the entries added in /etc/hosts"):
        for host in "simple.containers", "netmask.containers":
            machine.succeed(f"ping -n -c 1 {host}")
  '';
}

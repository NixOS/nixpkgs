{ pkgs, ... }:
{
  name = "transmission";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ coconnor ];
  };

  nodes.machine =
    { ... }:
    {
      imports = [ ../modules/profiles/minimal.nix ];

      networking.firewall.allowedTCPPorts = [ 9091 ];

      security.apparmor.enable = true;

      services.transmission.enable = true;
    };

  testScript =
    { nodes, ... }:
    #python
    ''
      start_all()
      machine.wait_for_unit("transmission")
      machine.shutdown()
    '';
}

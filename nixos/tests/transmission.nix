import ./make-test-python.nix ({ pkgs, transmission, ... }: {
  name = "transmission";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ coconnor ];
  };

  nodes.machine = { ... }: {
    imports = [ ../modules/profiles/minimal.nix ];

    networking.firewall.allowedTCPPorts = [ 9091 ];

    security.apparmor.enable = true;

    services.transmission.enable = true;
    services.transmission.package = transmission;
  };

  testScript =
    ''
      start_all()
      machine.wait_for_unit("transmission")
      machine.shutdown()
    '';
})

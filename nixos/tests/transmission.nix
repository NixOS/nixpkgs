import ./make-test-python.nix ({ pkgs, ...} : {
  name = "transmission";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ coconnor ];
  };

  machine = { ... }: {
    imports = [ ../modules/profiles/minimal.nix ];

    networking.firewall.allowedTCPPorts = [ 9091 ];

    services.transmission.enable = true;
  };

  testScript =
    ''
      start_all()
      machine.wait_for_unit("transmission")
      machine.shutdown()
    '';
})

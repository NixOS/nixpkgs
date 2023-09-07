import ./make-test-python.nix ({ pkgs, ...} : {
  name = "transmission";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ coconnor ];
  };

  nodes.machine = { ... }: {
    imports = [ ../modules/profiles/minimal.nix ];

    networking.firewall.allowedTCPPorts = [ 9091 ];

    security.apparmor.enable = true;

    services.transmission = {
      enable = true;
      credentialsFile = pkgs.writeTextFile {
        name = "settings.json";
        text = ''
          { "rpc-password": "5up3r53cr37" }
        '';
      };
    };
  };

  testScript =
    ''
      start_all()
      machine.wait_for_unit("transmission")
      machine.shutdown()
    '';
})

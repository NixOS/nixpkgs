import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "linkwarden";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ ericthemagician ];
    };

    nodes.machine =
      { ... }:
      {
        imports = [ ../modules/profiles/minimal.nix ];
        services.linkwarden = {
          enable = true;
          nginx = { };
          secret = "secret";
          domain = "linkwarden.nix";
        };
        networking.extraHosts = ''
          127.0.0.1 linkwarden.nix
        '';
      };

    testScript = ''
      start_all()
      machine.wait_for_unit("multi-user.target")
      machine.wait_for_unit("linkwarden.service")
      # wait for the service to really start
      machine.sleep(10)
      machine.succeed("curl -s http://localhost:3000")
      machine.succeed("curl -s http://linkwarden.nix")
      machine.shutdown()
    '';
  }
)

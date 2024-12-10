import ./make-test-python.nix (
  { pkgs, ... }:

  {
    name = "mealie";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ litchipi ];
    };

    nodes = {
      server = {
        services.mealie = {
          enable = true;
          port = 9001;
        };
      };
    };

    testScript = ''
      start_all()
      server.wait_for_unit("mealie.service")
      server.wait_for_open_port(9001)
      server.succeed("curl --fail http://localhost:9001")
    '';
  }
)

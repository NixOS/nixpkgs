import ./make-test-python.nix (
  { pkgs, ... }:

  {
    name = "firefly-iii-data-importer";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ litchipi ];
    };

    nodes = {
      server = {
        services.firefly-iii.data-importer = {
          enable = true;
          port = 9001;
        };
      };
    };

    testScript = ''
      start_all()
      server.wait_for_unit("firefly-iii-data-importer.service")
      server.wait_for_open_port(9001)
      server.succeed("curl --fail http://localhost:9001")
    '';
  }
)

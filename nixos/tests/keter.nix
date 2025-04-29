import ./make-test-python.nix (
  { pkgs, ... }:
  let
    port = 81;
  in
  {
    name = "keter";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ jappie ];
    };

    nodes.machine =
      { config, pkgs, ... }:
      {
        services.keter = {
          enable = true;

          globalKeterConfig = {
            cli-port = 123; # just adding this to test the freeform
            listeners = [
              {
                host = "*4";
                inherit port;
              }
            ];
          };
          bundle = {
            appName = "test-bundle";
            domain = "localhost";
            executable = pkgs.writeShellScript "run" ''
              ${pkgs.python3}/bin/python -m http.server $PORT
            '';
          };
        };
      };

    testScript = ''
      machine.wait_for_unit("keter.service")

      machine.wait_for_open_port(${toString port})
      machine.wait_for_console_text("Activating app test-bundle with hosts: localhost")


      machine.succeed("curl --fail http://localhost:${toString port}/")
    '';
  }
)

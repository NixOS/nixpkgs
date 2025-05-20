{ lib, ... }:
let
  servicePort = 9090;
in
{
  name = "Basic Omnom Test";
  meta = {
    maintainers = lib.teams.ngi.members;
  };

  nodes = {
    server =
      { config, lib, ... }:
      {
        services.omnom = {
          enable = true;
          openFirewall = true;

          port = servicePort;

          settings = {
            app = {
              disable_signup = false; # restrict CLI user-creation
              results_per_page = 50;
            };
            server.address = "0.0.0.0:${toString servicePort}";
          };
        };
      };
  };

  # TODO: take a snapshot
  testScript =
    { nodes, ... }:
    # python
    ''
      server.start()
      server.wait_for_unit("omnom.service")
      server.wait_for_open_port(${toString servicePort})
      server.succeed("curl -sf http://localhost:${toString servicePort}")
    '';
}

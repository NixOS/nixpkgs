{ lib, ... }:

{
  name = "manyfold";
  meta.maintainers = with lib.maintainers; [ prince213 ];

  nodes = {
    machine =
      { ... }:
      {
        virtualisation.memorySize = 2048;

        services.manyfold = {
          enable = true;
          settings = {
            SECRET_KEY_BASE = "0123456789abcdef0123456789abcdef";
            DATABASE_ADAPTER = "sqlite3";
            DATABASE_NAME = "/var/lib/manyfold/manyfold.sqlite3";
          };
        };
      };
  };

  testScript =
    { nodes, ... }:
    let
      port = toString nodes.machine.services.manyfold.port;
    in
    ''
      start_all()

      machine.wait_for_unit("default.target")
      machine.wait_for_unit("manyfold.service")
      machine.wait_for_open_port(${port})
      machine.succeed("curl -fsS http://localhost:${port}")
    '';
}

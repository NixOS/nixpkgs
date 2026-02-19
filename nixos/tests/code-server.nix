{ pkgs, lib, ... }:
{
  name = "code-server";

  nodes = {
    machine =
      { pkgs, ... }:
      {
        services.code-server = {
          enable = true;
          auth = "none";
        };
      };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("code-server.service")
    machine.wait_for_open_port(4444)
    machine.succeed("curl -k --fail http://localhost:4444", timeout=10)
  '';

  meta.maintainers = [ ];
}

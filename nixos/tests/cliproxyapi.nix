{ lib, ... }:
{
  name = "cliproxyapi";

  nodes = {
    machine =
      { ... }:
      {
        services.cliproxyapi = {
          enable = true;
          localModel = true;
          settings = {
            api-keys = [ "test-secret-key" ];
          };
        };
      };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("cliproxyapi.service")
    machine.wait_for_open_port(8317)
    machine.succeed("curl -fsS -H 'Authorization: Bearer test-secret-key' http://127.0.0.1:8317/v1/models")
  '';

  meta.maintainers = with lib.maintainers; [ rachalaraj ];
}

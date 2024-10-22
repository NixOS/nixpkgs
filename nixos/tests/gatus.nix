{ pkgs, ... }:
{
  name = "gatus";
  meta.maintainers = with pkgs.lib.maintainers; [ pizzapim ];

  nodes.machine =
    { ... }:
    {
      services.gatus = {
        enable = true;

        settings = {
          web.port = 8080;
          metrics = true;

          endpoints = [
            {
              name = "metrics";
              url = "http://localhost:8080/metrics";
              interval = "1s";
              conditions = [
                "[STATUS] == 200"
              ];
            }
          ];
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("gatus.service")
    machine.succeed("curl -s http://localhost:8080/metrics | grep go_info")
  '';
}

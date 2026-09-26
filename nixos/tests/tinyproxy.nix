{ pkgs, ... }:
{
  name = "tinyproxy";

  nodes.machine =
    { config, pkgs, ... }:
    {
      services.tinyproxy = {
        enable = true;
        settings = {
          Listen = "127.0.0.1";
          Port = 8080;
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("tinyproxy.service")
    machine.wait_for_open_port(8080)

    machine.succeed('curl -s http://localhost:8080 |grep -i tinyproxy')
  '';
}

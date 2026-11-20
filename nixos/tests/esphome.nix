{ pkgs, lib, ... }:

let
  testPort = 6052;
  unixSocket = "/run/esphome/esphome.sock";
in
{
  name = "esphome";
  meta.maintainers = with lib.maintainers; [ oddlama ];

  nodes = {
    esphomeTcp =
      { ... }:
      {
        services.esphome = {
          enable = true;
          port = testPort;
          address = "0.0.0.0";
          openFirewall = true;
        };
      };

    esphomeUnix =
      { ... }:
      {
        services.esphome = {
          enable = true;
          enableUnixSocket = true;
        };
      };
  };

  testScript = ''
    esphomeTcp.wait_for_unit("esphome.service")
    esphomeTcp.wait_for_open_port(${toString testPort})
    esphomeTcp.succeed("curl --fail http://localhost:${toString testPort}/")

    esphomeUnix.wait_for_unit("esphome.service")
    esphomeUnix.wait_for_file("${unixSocket}")
    esphomeUnix.succeed("curl --fail --unix-socket ${unixSocket} http://localhost/")
  '';
}

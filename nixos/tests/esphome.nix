{ pkgs, lib, ... }:

let
  testPort = 6052;
  remoteBuildPort = 6055;
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

    esphomeRemoteBuild =
      { ... }:
      {
        services.esphome = {
          enable = true;
          remoteBuildOnly = true;
          inherit remoteBuildPort;
          openFirewall = true;
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

    esphomeRemoteBuild.wait_for_unit("esphome.service")
    esphomeRemoteBuild.wait_for_open_port(${toString remoteBuildPort})
  '';
}

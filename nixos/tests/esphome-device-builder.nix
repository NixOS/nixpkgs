{ pkgs, lib, ... }:

let
  testPort = 6052;
in
{
  name = "esphome-device-builder";
  meta.maintainers = with lib.maintainers; [ DavidvtWout ];

  nodes.machine =
    { ... }:
    {
      services.esphome-device-builder = {
        enable = true;
        port = testPort;
        address = "0.0.0.0";
        openFirewall = true;
      };
    };

  testScript = ''
    machine.wait_for_unit("esphome-device-builder.service")
    machine.wait_for_open_port(${toString testPort})
    machine.succeed("curl --fail http://localhost:${toString testPort}/")
  '';
}

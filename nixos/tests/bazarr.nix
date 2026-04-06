{ lib, ... }:

let
  port = 42069;
in
{
  name = "bazarr";

  nodes.machine =
    { pkgs, ... }:
    {
      services.bazarr = {
        enable = true;
        listenPort = port;
        settings.general.hostname = "localhost";
      };

      environment.systemPackages = [ pkgs.yq-go ];
    };

  testScript = ''
    machine.wait_for_unit("bazarr.service")
    machine.wait_for_open_port(${toString port})
    machine.succeed("test $(yq '.general.hostname' /var/lib/bazarr/config/config.yaml) = localhost")
    machine.succeed("test $(yq '.analytics.enabled' /var/lib/bazarr/config/config.yaml) = false")
    machine.succeed("curl --fail http://localhost:${toString port}/")
  '';
}

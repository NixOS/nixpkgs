{
  pkgs,
  lib,
  ...
}:
{
  name = "livekit";
  meta.maintainers = [ lib.maintainers.quadradical ];

  nodes.machine = {
    services.livekit = {
      enable = true;
      keyFile = pkgs.writers.writeYAML "keys.yaml" {
        key = "f6lQGaHtM5HfgZjIcec3cOCRfiDqIine4CpZZnqdT5cE";
      };
      settings.port = 8000;
    };
  };

  testScript = ''
    machine.wait_for_unit("livekit.service")
    machine.wait_for_open_port(8000)
    machine.succeed("curl 127.0.0.1:8000 -L --fail")
  '';
}

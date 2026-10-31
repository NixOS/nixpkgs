{
  pkgs,
  lib,
  ...
}:
{
  name = "lk-jwt-service";
  meta.maintainers = [ lib.maintainers.quadradical ];

  nodes.machine = { config, ... }: {
    services.lk-jwt-service = {
      enable = true;
      keyFile = pkgs.writers.writeYAML "keys.yaml" {
        key = "f6lQGaHtM5HfgZjIcec3cOCRfiDqIine4CpZZnqdT5cE";
      };
      fullAccessHomeservers = [ "*" ];
      livekitUrl = "wss://127.0.0.1:8100";
      port = 8000;
    };

    environment.systemPackages = [ config.services.lk-jwt-service.package ];
  };

  testScript = ''
    machine.wait_for_unit("lk-jwt-service.service")
    machine.wait_for_open_port(8000)
    machine.succeed('env LIVEKIT_JWT_BIND=:8000 healthcheck')
  '';
}

{
  pkgs,
  lib,
  ...
}:
{
  name = "lk-jwt-service";
  meta.maintainers = [ lib.maintainers.quadradical ];

  nodes.machine = {
    services.lk-jwt-service = {
      enable = true;
      keyFile = pkgs.writers.writeYAML "keys.yaml" {
        key = "f6lQGaHtM5HfgZjIcec3cOCRfiDqIine4CpZZnqdT5cE";
      };
      livekitUrl = "wss://127.0.0.1:8100";
      port = 8000;
    };
    systemd.services.lk-jwt-service.environment.LIVEKIT_FULL_ACCESS_HOMESERVERS = "*";
  };

  testScript = ''
    machine.wait_for_unit("lk-jwt-service.service")
    machine.wait_for_open_port(8000)
    machine.succeed('curl 127.0.0.1:8000/sfu/get -sLX POST -o /dev/null -w "%{http_code}" | grep -q "^400"')
  '';
}

{ lib, ... }:
{
  name = "gs1200-exporter";
  meta.maintainers = with lib.maintainers; [ DerGrumpf ];
  containers.machine = {
    services.gs1200-exporter = {
      enable = true;
      address = "192.168.2.4";
      passwordFile = "/run/secrets/gs1200-password";
    };
    systemd.tmpfiles.rules = [
      "f /run/secrets/gs1200-password 0400 root root - testpassword"
    ];
  };
  testScript = ''
    machine.wait_for_unit("gs1200-exporter.service")
    machine.wait_for_open_port(9934)
    machine.succeed("curl -f http://localhost:9934/metrics")
  '';
}

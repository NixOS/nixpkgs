{
  lib,
  pkgs,
  ...
}:
{
  name = "udp514-journal";
  meta.maintainers = with lib.maintainers; [ usovalx ];

  containers.machine = {
    services.udp514-journal.enable = true;
    environment.systemPackages = [ pkgs.netcat ];
  };

  testScript = ''
    import datetime
    start_all()

    machine.wait_for_unit("udp514-journal.socket");

    # send a test log entry via UDP, RFC 5424 format
    machine.execute('echo "<34>1 2026-08-01T00:24:15.123+01:00 router01 - testing" | nc -w1 -u localhost 514')

    machine.wait_until_succeeds('journalctl -u udp514-journal --grep "router01 - testing"', timeout = datetime.timedelta(seconds=60))
  '';
}

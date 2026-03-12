{
  lib,
  ...
}:
{
  name = "netbird-server-signal";

  meta.maintainers = with lib.maintainers; [
    shuuri-labs
  ];

  nodes = {
    signal = {
      services.netbird.server.signal = {
        enable = true;
        domain = "signal.test";
        port = 8012;
        metricsPort = 9091;
        logLevel = "DEBUG";
      };
    };
  };

  testScript = ''
    start_all()

    # Test basic signal server
    signal.wait_for_unit("netbird-signal.service")

    # Verify the service is running on the correct port
    signal.wait_for_open_port(8012)
    signal.wait_for_open_port(9091)

    # Verify state directory is correct (not netbird-mgmt)
    signal.succeed("test -d /var/lib/netbird-signal")

    # Verify working directory is correct
    signal.succeed("systemctl show netbird-signal -p WorkingDirectory | grep '/var/lib/netbird-signal'")
  '';
}

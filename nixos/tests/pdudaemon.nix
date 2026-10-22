{ pkgs, ... }:
{
  name = "PDUDaemon";
  meta.maintainers = with pkgs.lib.maintainers; [
    aiyion
    emantor
  ];

  nodes.pdudaemonhost =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.curl ];
      services.pdudaemon.enable = true;
      services.pdudaemon.openFirewall = true;
      services.pdudaemon.pdus = {
        testpduhost = {
          driver = "localcmdline";
          cmd_on = "echo '%s on' >> /tmp/pdu";
          cmd_off = "echo '%s off' >> /tmp/pdu";
        };
      };
    };

  nodes.clienthost =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.curl ];
    };

  testScript =
    { nodes, ... }:
    #python
    ''
      with subtest("Wait for pdudaemon startup"):
          pdudaemonhost.start()
          pdudaemonhost.wait_for_unit("pdudaemon.service")
          pdudaemonhost.wait_for_open_port(16421)
          print(pdudaemonhost.succeed("curl 'http://localhost:16421/power/control/on?hostname=testpduhost&port=1'"))

      with subtest("Connect from client"):
          clienthost.start()
          clienthost.wait_until_succeeds("curl 'http://pdudaemonhost:16421/power/control/off?hostname=testpduhost&port=1'")

      with subtest("Check systemd hardening does not degrade unnoticed"):
          exact_threshold = 15
          service_name = "pdudaemon"
          pdudaemonhost.fail(f"systemd-analyze security {service_name}.service --threshold={exact_threshold-1}")
          pdudaemonhost.succeed(f"systemd-analyze security {service_name}.service --threshold={exact_threshold}")
    '';
}

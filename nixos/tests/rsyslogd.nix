import ./make-test.nix ({ pkgs, lib, ... }:
{
  name = "rsyslogd";
  meta.maintainers = [ lib.maintainers.aanderse ];

  nodes = {
    machine1 =
      { config, pkgs, ... }:
      { services.rsyslogd.enable = true;
        services.journald.forwardToSyslog = false;
      };

    machine2 =
      { config, pkgs, ... }:
      { services.rsyslogd.enable = true;
      };
  };

  # ensure rsyslogd is receiving messages from journald if and only if setup to do so
  testScript = ''
    $machine1->waitForUnit("default.target");
    $machine1->fail("test -f /var/log/messages");

    $machine2->waitForUnit("default.target");
    $machine2->succeed("test -f /var/log/messages");
  '';
})

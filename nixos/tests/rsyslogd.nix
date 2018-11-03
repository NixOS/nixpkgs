{ system ? builtins.currentSystem }:

with import ../lib/testing.nix { inherit system; };
with pkgs.lib;
{
  test1 = makeTest {
    name = "rsyslogd-test1";
    meta.maintainers = [ maintainers.aanderse ];

    machine =
      { config, pkgs, ... }:
      { services.rsyslogd.enable = true;
        services.journald.forwardToSyslog = false;
      };

    # ensure rsyslogd isn't receiving messages from journald if explicitly disabled
    testScript = ''
      $machine->waitForUnit("default.target");
      $machine->fail("test -f /var/log/messages");
    '';
  };

  test2 = makeTest {
    name = "rsyslogd-test2";
    meta.maintainers = [ maintainers.aanderse ];

    machine =
      { config, pkgs, ... }:
      { services.rsyslogd.enable = true;
      };

    # ensure rsyslogd is receiving messages from journald
    testScript = ''
      $machine->waitForUnit("default.target");
      $machine->succeed("test -f /var/log/messages");
    '';
  };
}

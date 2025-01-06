{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

{
  test1 = makeTest {
    name = "rsyslogd-test1";
    meta.maintainers = [ pkgs.lib.maintainers.aanderse ];

    nodes.machine =
      { config, pkgs, ... }:
      {
        services.rsyslogd.enable = true;
        services.journald.forwardToSyslog = false;
      };

    # ensure rsyslogd isn't receiving messages from journald if explicitly disabled
    testScript = ''
      machine.wait_for_unit("default.target")
      machine.fail("test -f /var/log/messages")
    '';
  };

  test2 = makeTest {
    name = "rsyslogd-test2";
    meta.maintainers = [ pkgs.lib.maintainers.aanderse ];

    nodes.machine =
      { config, pkgs, ... }:
      {
        services.rsyslogd.enable = true;
      };

    # ensure rsyslogd is receiving messages from journald
    testScript = ''
      machine.wait_for_unit("default.target")
      machine.succeed("test -f /var/log/messages")
    '';
  };
}

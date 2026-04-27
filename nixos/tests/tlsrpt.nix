{
  pkgs,
  ...
}:

{
  name = "tlsrpt";

  meta = {
    inherit (pkgs.tlsrpt-reporter.meta) maintainers;
  };

  nodes.machine = {
    services.tlsrpt = {
      enable = true;
      reportd.settings = {
        organization_name = "NixOS Testers United";
        contact_info = "smtp-tls-report@localhost";
        sender_address = "noreply@localhost";
      };
    };

    # To test the postfix integration
    services.postfix.enable = true;
  };

  testScript = ''
    machine.wait_for_unit("tlsrpt-collectd.service")
    machine.wait_for_unit("tlsrpt-reportd.service")

    machine.wait_for_file("/run/tlsrpt/collectd.sock")
    machine.wait_until_succeeds("journalctl -o cat -u tlsrpt-collectd | grep -Pq 'Database .* setup finished'")
    machine.wait_until_succeeds("journalctl -o cat -u tlsrpt-reportd | grep -Pq 'Database .* setup finished'")
    machine.wait_until_succeeds("journalctl -o cat -u tlsrpt-reportd | grep -Pq 'Fetcher .* finished'")

    # Enabling postfix should put sendmail as the sendmail setting
    machine.succeed("grep -q sendmail_script=/run/wrappers/bin/sendmail /etc/tlsrpt/reportd.cfg")
    machine.succeed("getent group tlsrpt | grep -q postfix")

    machine.log(machine.succeed("systemd-analyze security tlsrpt-collectd.service tlsrpt-reportd.service | grep -v ✓"))
  '';
}

# Test logrotate service works and is enabled by default

import ./make-test-python.nix ({ pkgs, ...} : rec {
  name = "logrotate";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ martinetd ];
  };

  # default machine
  machine = { ... }: {
  };

  testScript =
    ''
      with subtest("whether logrotate works"):
          machine.succeed(
              # we must rotate once first to create logrotate stamp
              "systemctl start logrotate.service")
          # we need to wait for console text once here to
          # clear console buffer up to this point for next wait
          machine.wait_for_console_text('logrotate.service: Deactivated successfully')

          machine.succeed(
              # wtmp is present in default config.
              "rm -f /var/log/wtmp*",
              # we need to give it at least 1MB
              "dd if=/dev/zero of=/var/log/wtmp bs=2M count=1",

              # move into the future and check rotation.
              "date -s 'now + 1 month + 1 day'")
          machine.wait_for_console_text('logrotate.service: Deactivated successfully')
          machine.succeed(
              # check rotate worked
              "[ -e /var/log/wtmp.1 ]",
          )
    '';
})

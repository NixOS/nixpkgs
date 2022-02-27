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
              "systemctl start --wait logrotate.service",

              # wtmp is present in default config.
              "rm -f /var/log/wtmp*",
              # we need to give it at least 1MB
              "dd if=/dev/zero of=/var/log/wtmp bs=2M count=1",

              # move into the future and rotate
              "date -s 'now + 1 month + 1 day'",
              # systemd will run logrotate from logrotate.timer automatically
              # on date change, but if we want to wait for it to terminate
              # it's easier to run again...
              "systemctl start --wait logrotate.service",

              # check rotate worked
              "[ -e /var/log/wtmp.1 ]",
          )
    '';
})

# Test logrotate service works and is enabled by default

import ./make-test-python.nix ({ pkgs, ... }: rec {
  name = "logrotate";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ martinetd ];
  };

  nodes = {
    defaultMachine = { ... }: { };
    machine = { config, ... }: {
      services.logrotate.paths = {
        # using mail somewhere should add --mail to logrotate invokation
        sendmail = {
          extraConfig = "mail user@domain.tld";
        };
      };
    };
  };

  testScript =
    ''
      with subtest("whether logrotate works"):
          # we must rotate once first to create logrotate stamp
          defaultMachine.succeed("systemctl start logrotate.service")
          # we need to wait for console text once here to
          # clear console buffer up to this point for next wait
          defaultMachine.wait_for_console_text('logrotate.service: Deactivated successfully')

          defaultMachine.succeed(
              # wtmp is present in default config.
              "rm -f /var/log/wtmp*",
              # we need to give it at least 1MB
              "dd if=/dev/zero of=/var/log/wtmp bs=2M count=1",

              # move into the future and check rotation.
              "date -s 'now + 1 month + 1 day'")
          defaultMachine.wait_for_console_text('logrotate.service: Deactivated successfully')
          defaultMachine.succeed(
              # check rotate worked
              "[ -e /var/log/wtmp.1 ]",
          )
      with subtest("default config does not have mail"):
          defaultMachine.fail("systemctl cat logrotate.service | grep -- --mail")
      with subtest("using mails adds mail option"):
          machine.succeed("systemctl cat logrotate.service | grep -- --mail")
    '';
})

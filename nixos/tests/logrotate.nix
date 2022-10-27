# Test logrotate service works and is enabled by default

let
  importTest = { ... }: {
    services.logrotate.settings.import = {
      olddir = false;
    };
  };

in

import ./make-test-python.nix ({ pkgs, ... }: rec {
  name = "logrotate";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ martinetd ];
  };

  nodes = {
    defaultMachine = { ... }: { };
    failingMachine = { ... }: {
      services.logrotate.configFile = pkgs.writeText "logrotate.conf" ''
        # self-written config file
        su notarealuser notagroupeither
      '';
    };
    machine = { config, ... }: {
      imports = [ importTest ];

      services.logrotate.settings = {
        # remove default frequency header and add another
        header = {
          frequency = null;
          delaycompress = true;
        };
        # extra global setting... affecting nothing
        last_line = {
          global = true;
          priority = 2000;
          shred = true;
        };
        # using mail somewhere should add --mail to logrotate invokation
        sendmail = {
          mail = "user@domain.tld";
        };
        # postrotate should be suffixed by 'endscript'
        postrotate = {
          postrotate = "touch /dev/null";
        };
        # check checkConfig works as expected: there is nothing to check here
        # except that the file build passes
        checkConf = {
          su = "root utmp";
          createolddir = "0750 root utmp";
          create = "root utmp";
          "create " = "0750 root utmp";
        };
        # multiple paths should be aggregated
        multipath = {
          files = [ "file1" "file2" ];
        };
        # overriding imported path should keep existing attributes
        # (e.g. olddir is still set)
        import = {
          notifempty = true;
        };
      };
      # extraConfig compatibility - should be added to top level, early.
      services.logrotate.extraConfig = ''
        nomail
      '';
      # paths compatibility
      services.logrotate.paths = {
        compat_path = {
          path = "compat_test_path";
        };
        # user/group should be grouped as 'su user group'
        compat_user = {
          user = config.users.users.root.name;
          group = "root";
        };
        # extraConfig in path should be added to block
        compat_extraConfig = {
          extraConfig = "dateext";
        };
        # keep -> rotate
        compat_keep = {
          keep = 1;
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
      with subtest("check generated config matches expectation"):
          machine.succeed(
              # copy conf to /tmp/logrotate.conf for easy grep
              "conf=$(systemctl cat logrotate | grep -oE '/nix/store[^ ]*logrotate.conf'); cp $conf /tmp/logrotate.conf",
              "! grep weekly /tmp/logrotate.conf",
              "grep -E '^delaycompress' /tmp/logrotate.conf",
              "tail -n 1 /tmp/logrotate.conf | grep shred",
              "sed -ne '/\"sendmail\" {/,/}/p' /tmp/logrotate.conf | grep 'mail user@domain.tld'",
              "sed -ne '/\"postrotate\" {/,/}/p' /tmp/logrotate.conf | grep endscript",
              "grep '\"file1\"\n\"file2\" {' /tmp/logrotate.conf",
              "sed -ne '/\"import\" {/,/}/p' /tmp/logrotate.conf | grep noolddir",
              "sed -ne '1,/^\"/p' /tmp/logrotate.conf | grep nomail",
              "grep '\"compat_test_path\" {' /tmp/logrotate.conf",
              "sed -ne '/\"compat_user\" {/,/}/p' /tmp/logrotate.conf | grep 'su root root'",
              "sed -ne '/\"compat_extraConfig\" {/,/}/p' /tmp/logrotate.conf | grep dateext",
              "[[ $(sed -ne '/\"compat_keep\" {/,/}/p' /tmp/logrotate.conf | grep -w rotate) = \"  rotate 1\" ]]",
              "! sed -ne '/\"compat_keep\" {/,/}/p' /tmp/logrotate.conf | grep -w keep",
          )
          # also check configFile option
          failingMachine.succeed(
              "conf=$(systemctl cat logrotate | grep -oE '/nix/store[^ ]*logrotate.conf'); cp $conf /tmp/logrotate.conf",
              "grep 'self-written config' /tmp/logrotate.conf",
          )
      with subtest("Check logrotate-checkconf service"):
          machine.wait_for_unit("logrotate-checkconf.service")
          # wait_for_unit also asserts for success, so wait for
          # parent target instead and check manually.
          failingMachine.wait_for_unit("multi-user.target")
          info = failingMachine.get_unit_info("logrotate-checkconf.service")
          if info["ActiveState"] != "failed":
              raise Exception('logrotate-checkconf.service was not failed')

    '';
})

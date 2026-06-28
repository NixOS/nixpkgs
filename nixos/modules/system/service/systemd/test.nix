# Run:
#   nix-build -A nixosTests.modularService

{
  evalSystem,
  runCommand,
  hello,
  ...
}:

let
  machine = evalSystem (
    { lib, ... }:
    let
      hello' = lib.getExe hello;
    in
    {

      # Test input

      system.services.foo = {
        process = {
          argv = [
            hello'
            "--greeting"
            "hoi"
          ];
        };
      };
      system.services.bar = {
        process = {
          argv = [
            hello'
            "--greeting"
            "hoi"
          ];
        };
        systemd.service = {
          serviceConfig.X-Bar = "lol crossbar whatever";
        };
        services.db = {
          process = {
            argv = [
              hello'
              "--greeting"
              "Hi, I'm a database, would you believe it"
            ];
          };
          systemd.service = {
            serviceConfig.RestartSec = "42";
          };
        };
      };

      # Test that systemd.mainExecStart overrides process.argv
      # and allows systemd's specifier and variable substitution
      system.services.argv-with-subst = {
        process = {
          argv = [
            hello'
            "--greeting"
            "This should be ignored"
          ];
        };
        systemd.mainExecStart = ''/bin/sh -c "echo %n and ''${HOME}"'';
      };

      # Test that process.argv escapes % and $ by default
      system.services.argv-escaped = {
        process = {
          argv = [
            "/bin/sh"
            "-c"
            "echo %n and \${HOME}"
          ];
        };
      };

      # Test that `process.environment` becomes `Environment=` entries on the unit,
      # that null values are dropped from `Environment=` and wrapped with unexport
      # in `ExecStart`.
      system.services.envvars = {
        process = {
          argv = [ hello' ];
          environment = {
            FOO = "bar";
            BAZ = "qux";
            DROPPED = null;
          };
        };
      };

      # Test that an explicit `systemd.service.environment` override wins over
      # the portable default produced by `process.environment`.
      system.services.envvars-override = {
        process = {
          argv = [ hello' ];
          environment.FOO = "from-process";
        };
        systemd.service.environment.FOO = "from-systemd";
      };

      # Test that `process.environment` `null` unsets via wrapper even when the
      # systemd layer sets the same key (true unset, not just "skip setting").
      system.services.envvars-unset = {
        process = {
          argv = [ hello' ];
          environment.FOO = null;
        };
        systemd.service.environment.FOO = "leaked";
      };

      # Test extending process.argv with systemd specifiers
      system.services.argv-extended =
        { config, ... }:
        {
          process = {
            argv = [
              hello'
              "--greeting"
              "Fun $1 fact, remainder is often expressed as m%n"
            ];
          };
          systemd.mainExecStart =
            config.systemd.lib.escapeSystemdExecArgs config.process.argv + " --systemd-unit %n";
        };

      # irrelevant stuff
      system.stateVersion = "25.05";
      fileSystems."/" = {
        device = "/test/dummy";
        fsType = "auto";
      };
      boot.loader.grub.enable = false;
    }
  );

  inherit (machine.config.system.build) toplevel;
in
runCommand "test-modular-service-systemd-units"
  {
    passthru = {
      inherit
        machine
        toplevel
        ;
    };
  }
  ''
    echo ${toplevel}/etc/systemd/system/foo.service:
    cat -n ${toplevel}/etc/systemd/system/foo.service
    (
      set -x
      grep -F 'ExecStart="${hello}/bin/hello" "--greeting" "hoi"' ${toplevel}/etc/systemd/system/foo.service >/dev/null

      grep -F 'ExecStart="${hello}/bin/hello" "--greeting" "hoi"' ${toplevel}/etc/systemd/system/bar.service >/dev/null
      grep -F 'X-Bar=lol crossbar whatever' ${toplevel}/etc/systemd/system/bar.service >/dev/null

      grep    'ExecStart="${hello}/bin/hello" "--greeting" ".*database.*"' ${toplevel}/etc/systemd/system/bar-db.service >/dev/null
      grep -F 'RestartSec=42' ${toplevel}/etc/systemd/system/bar-db.service >/dev/null

      # Test that systemd.mainExecStart overrides process.argv
      # Note: %n and $HOME are NOT escaped, allowing systemd to substitute them
      grep -F 'ExecStart=/bin/sh -c "echo %n and ''${HOME}"' ${toplevel}/etc/systemd/system/argv-with-subst.service >/dev/null

      # Test that process.argv escapes % as %% and $ as $$
      # This prevents systemd from performing specifier/variable substitution
      grep -F 'ExecStart="/bin/sh" "-c" "echo %%n and $${HOME}"' ${toplevel}/etc/systemd/system/argv-escaped.service >/dev/null

      # Test extending process.argv with systemd specifiers
      # The base command should be escaped ($1 -> $$1, m%n -> m%%n), but the appended --systemd-unit %n should not be
      grep -F 'ExecStart="${hello}/bin/hello" "--greeting" "Fun $$1 fact, remainder is often expressed as m%%n" --systemd-unit %n' ${toplevel}/etc/systemd/system/argv-extended.service >/dev/null

      # process.environment becomes Environment= entries; null values are dropped
      # from Environment= and wrapped with unexport in ExecStart.
      grep -F 'Environment="FOO=bar"' ${toplevel}/etc/systemd/system/envvars.service >/dev/null
      grep -F 'Environment="BAZ=qux"' ${toplevel}/etc/systemd/system/envvars.service >/dev/null
      ! grep -F 'Environment=.*DROPPED' ${toplevel}/etc/systemd/system/envvars.service
      grep 'ExecStart=.*unexport.*DROPPED' ${toplevel}/etc/systemd/system/envvars.service >/dev/null

      # systemd.service.environment override wins over process.environment.
      grep -F 'Environment="FOO=from-systemd"' ${toplevel}/etc/systemd/system/envvars-override.service >/dev/null
      ! grep -F 'FOO=from-process' ${toplevel}/etc/systemd/system/envvars-override.service

      # process.environment null uses unexport wrapper for true unset, even when
      # the systemd layer has an Environment= entry for the same key.
      grep -F 'Environment="FOO=leaked"' ${toplevel}/etc/systemd/system/envvars-unset.service >/dev/null
      grep 'ExecStart=.*unexport.*FOO' ${toplevel}/etc/systemd/system/envvars-unset.service >/dev/null

      [[ ! -e ${toplevel}/etc/systemd/system/foo.socket ]]
      [[ ! -e ${toplevel}/etc/systemd/system/bar.socket ]]
      [[ ! -e ${toplevel}/etc/systemd/system/bar-db.socket ]]
    )
    echo 🐬👍
    touch $out
  ''

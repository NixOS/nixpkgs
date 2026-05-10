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

      # Test that configData sources are wired into restartTriggers on
      # the primary unit (no ExecReload), including for sub-services,
      # while disabled entries are excluded.
      system.services.cfgtest = {
        process.argv = [ hello' ];
        configData."app.conf".text = "hello = world\n";
        configData."disabled.conf" = {
          text = "should not appear\n";
          enable = false;
        };
        services.sub = {
          process.argv = [ hello' ];
          configData."sub.conf".text = "sub = yes\n";
        };
      };

      # Test that configData sources are wired into reloadTriggers when
      # ExecReload is declared.
      system.services.cfgtest-reload = {
        process.argv = [ hello' ];
        systemd.service.serviceConfig.ExecReload = "${hello}/bin/hello";
        configData."reload.conf".text = "reload = me\n";
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

      [[ ! -e ${toplevel}/etc/systemd/system/foo.socket ]]
      [[ ! -e ${toplevel}/etc/systemd/system/bar.socket ]]
      [[ ! -e ${toplevel}/etc/systemd/system/bar-db.socket ]]

      # cfgtest has no ExecReload, so configData sources go into restartTriggers
      # (X-Restart-Triggers), not reloadTriggers.
      grep -E '^X-Restart-Triggers=' ${toplevel}/etc/systemd/system/cfgtest.service >/dev/null
      cfgtest_trigger=$(grep -oP '^X-Restart-Triggers=\K\S+' ${toplevel}/etc/systemd/system/cfgtest.service)
      grep -F "service-configdata-app.conf" "$cfgtest_trigger" >/dev/null
      ! grep -F "service-configdata-disabled.conf" "$cfgtest_trigger" >/dev/null
      ! grep -E '^X-Reload-Triggers=' ${toplevel}/etc/systemd/system/cfgtest.service >/dev/null

      # Sub-service primary unit gets its own configData via restartTriggers, not the parent's.
      grep -E '^X-Restart-Triggers=' ${toplevel}/etc/systemd/system/cfgtest-sub.service >/dev/null
      cfgtest_sub_trigger=$(grep -oP '^X-Restart-Triggers=\K\S+' ${toplevel}/etc/systemd/system/cfgtest-sub.service)
      grep -F "service-configdata-sub.conf" "$cfgtest_sub_trigger" >/dev/null
      ! grep -F "service-configdata-app.conf" "$cfgtest_sub_trigger" >/dev/null
      ! grep -E '^X-Reload-Triggers=' ${toplevel}/etc/systemd/system/cfgtest-sub.service >/dev/null

      # cfgtest-reload declares ExecReload, so configData sources go into reloadTriggers.
      grep -E '^X-Reload-Triggers=' ${toplevel}/etc/systemd/system/cfgtest-reload.service >/dev/null
      cfgtest_reload_trigger=$(grep -oP '^X-Reload-Triggers=\K\S+' ${toplevel}/etc/systemd/system/cfgtest-reload.service)
      grep -F "service-configdata-reload.conf" "$cfgtest_reload_trigger" >/dev/null
      ! grep -E '^X-Restart-Triggers=' ${toplevel}/etc/systemd/system/cfgtest-reload.service >/dev/null

      # Services without configData should have neither X-Reload-Triggers nor X-Restart-Triggers.
      ! grep -E '^X-Reload-Triggers=' ${toplevel}/etc/systemd/system/bar.service >/dev/null
      ! grep -E '^X-Restart-Triggers=' ${toplevel}/etc/systemd/system/bar.service >/dev/null
      ! grep -E '^X-Reload-Triggers=' ${toplevel}/etc/systemd/system/bar-db.service >/dev/null
      ! grep -E '^X-Restart-Triggers=' ${toplevel}/etc/systemd/system/bar-db.service >/dev/null
      ! grep -E '^X-Reload-Triggers=' ${toplevel}/etc/systemd/system/foo.service >/dev/null
      ! grep -E '^X-Restart-Triggers=' ${toplevel}/etc/systemd/system/foo.service >/dev/null
    )
    echo 🐬👍
    touch $out
  ''

import ./make-test-python.nix {
  name = "systemd-confinement";

  machine = { pkgs, lib, ... }: let
    testServer = pkgs.writeScript "testserver.sh" ''
      #!${pkgs.runtimeShell}
      export PATH=${lib.escapeShellArg "${pkgs.coreutils}/bin"}
      ${lib.escapeShellArg pkgs.runtimeShell} 2>&1
      echo "exit-status:$?"
    '';

    testClient = pkgs.writeScriptBin "chroot-exec" ''
      #!${pkgs.runtimeShell} -e
      output="$(echo "$@" | nc -NU "/run/test$(< /teststep).sock")"
      ret="$(echo "$output" | sed -nre '$s/^exit-status:([0-9]+)$/\1/p')"
      echo "$output" | head -n -1
      exit "''${ret:-1}"
    '';

    mkTestStep = num: { config ? {}, testScript }: {
      systemd.sockets."test${toString num}" = {
        description = "Socket for Test Service ${toString num}";
        wantedBy = [ "sockets.target" ];
        socketConfig.ListenStream = "/run/test${toString num}.sock";
        socketConfig.Accept = true;
      };

      systemd.services."test${toString num}@" = {
        description = "Confined Test Service ${toString num}";
        confinement = (config.confinement or {}) // { enable = true; };
        serviceConfig = (config.serviceConfig or {}) // {
          ExecStart = testServer;
          StandardInput = "socket";
        };
      } // removeAttrs config [ "confinement" "serviceConfig" ];

      __testSteps = lib.mkOrder num (''
        machine.succeed("echo ${toString num} > /teststep")
      '' + testScript);
    };

  in {
    imports = lib.imap1 mkTestStep [
      { config.confinement.mode = "chroot-only";
        testScript = ''
          with subtest("chroot-only confinement"):
              machine.succeed(
                  'test "$(chroot-exec ls -1 / | paste -sd,)" = bin,nix',
                  'test "$(chroot-exec id -u)" = 0',
                  "chroot-exec chown 65534 /bin",
              )
        '';
      }
      { testScript = ''
          with subtest("full confinement with APIVFS"):
              machine.fail(
                  "chroot-exec ls -l /etc",
                  "chroot-exec ls -l /run",
                  "chroot-exec chown 65534 /bin",
              )
              machine.succeed(
                  'test "$(chroot-exec id -u)" = 0', "chroot-exec chown 0 /bin",
              )
        '';
      }
      { config.serviceConfig.BindReadOnlyPaths = [ "/etc" ];
        testScript = ''
          with subtest("check existence of bind-mounted /etc"):
              machine.succeed('test -n "$(chroot-exec cat /etc/passwd)"')
        '';
      }
      { config.serviceConfig.User = "chroot-testuser";
        config.serviceConfig.Group = "chroot-testgroup";
        testScript = ''
          with subtest("check if User/Group really runs as non-root"):
              machine.succeed("chroot-exec ls -l /dev")
              machine.succeed('test "$(chroot-exec id -u)" != 0')
              machine.fail("chroot-exec touch /bin/test")
        '';
      }
      (let
        symlink = pkgs.runCommand "symlink" {
          target = pkgs.writeText "symlink-target" "got me\n";
        } "ln -s \"$target\" \"$out\"";
      in {
        config.confinement.packages = lib.singleton symlink;
        testScript = ''
          with subtest("check if symlinks are properly bind-mounted"):
              machine.fail("chroot-exec test -e /etc")
              machine.succeed(
                  "chroot-exec cat ${symlink} >&2",
                  'test "$(chroot-exec cat ${symlink})" = "got me"',
              )
        '';
      })
      { config.serviceConfig.User = "chroot-testuser";
        config.serviceConfig.Group = "chroot-testgroup";
        config.serviceConfig.StateDirectory = "testme";
        testScript = ''
          with subtest("check if StateDirectory works"):
              machine.succeed("chroot-exec touch /tmp/canary")
              machine.succeed('chroot-exec "echo works > /var/lib/testme/foo"')
              machine.succeed('test "$(< /var/lib/testme/foo)" = works')
              machine.succeed("test ! -e /tmp/canary")
        '';
      }
      { testScript = ''
          with subtest("check if /bin/sh works"):
              machine.succeed(
                  "chroot-exec test -e /bin/sh",
                  'test "$(chroot-exec \'/bin/sh -c "echo bar"\')" = bar',
              )
        '';
      }
      { config.confinement.binSh = null;
        testScript = ''
          with subtest("check if suppressing /bin/sh works"):
              machine.succeed("chroot-exec test ! -e /bin/sh")
              machine.succeed('test "$(chroot-exec \'/bin/sh -c "echo foo"\')" != foo')
        '';
      }
      { config.confinement.binSh = "${pkgs.hello}/bin/hello";
        testScript = ''
          with subtest("check if we can set /bin/sh to something different"):
              machine.succeed("chroot-exec test -e /bin/sh")
              machine.succeed('test "$(chroot-exec /bin/sh -g foo)" = foo')
        '';
      }
      { config.environment.FOOBAR = pkgs.writeText "foobar" "eek\n";
        testScript = ''
          with subtest("check if only Exec* dependencies are included"):
              machine.succeed('test "$(chroot-exec \'cat "$FOOBAR"\')" != eek')
        '';
      }
      { config.environment.FOOBAR = pkgs.writeText "foobar" "eek\n";
        config.confinement.fullUnit = true;
        testScript = ''
          with subtest("check if all unit dependencies are included"):
              machine.succeed('test "$(chroot-exec \'cat "$FOOBAR"\')" = eek')
        '';
      }
    ];

    options.__testSteps = lib.mkOption {
      type = lib.types.lines;
      description = "All of the test steps combined as a single script.";
    };

    config.environment.systemPackages = lib.singleton testClient;

    config.users.groups.chroot-testgroup = {};
    config.users.users.chroot-testuser = {
      isSystemUser = true;
      description = "Chroot Test User";
      group = "chroot-testgroup";
    };
  };

  testScript = { nodes, ... }: ''
    machine.wait_for_unit("multi-user.target")
  '' + nodes.machine.config.__testSteps;
}

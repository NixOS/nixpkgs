import ./make-test-python.nix {
  name = "systemd-confinement";

  nodes.machine = { pkgs, lib, ... }: let
    testServer = pkgs.writeScript "testserver.sh" ''
      #!${pkgs.runtimeShell}
      export PATH=${lib.makeBinPath [ pkgs.coreutils pkgs.findutils ]}
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

    mkTestStep = num: {
      testScript,
      config ? {},
      serviceName ? "test${toString num}",
    }: {
      systemd.sockets.${serviceName} = {
        description = "Socket for Test Service ${toString num}";
        wantedBy = [ "sockets.target" ];
        socketConfig.ListenStream = "/run/test${toString num}.sock";
        socketConfig.Accept = true;
      };

      systemd.services."${serviceName}@" = {
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
              # chroot-exec starts a socket-activated service,
              # but, upon starting, a systemd system service
              # calls setup_namespace() which calls base_filesystem_create()
              # which creates some usual top level directories.
              # In chroot-only mode, without additional BindPaths= or the like,
              # they must be empty and thus removable by rmdir.
              paths = machine.succeed('chroot-exec rmdir /dev /etc /proc /root /sys /usr /var "&&" ls -Am /').strip()
              assert_eq(paths, "bin, nix, run")
              uid = machine.succeed('chroot-exec id -u').strip()
              assert_eq(uid, "0")
              machine.succeed("chroot-exec chown 65534 /bin")
        '';
      }
      { testScript = ''
          with subtest("full confinement with APIVFS"):
              machine.succeed('chroot-exec rmdir /etc')
              machine.fail("chroot-exec chown 65534 /bin")
              assert_eq(machine.succeed('chroot-exec id -u').strip(), "0")
              machine.succeed("chroot-exec chown 0 /bin")
        '';
      }
      { config.serviceConfig.BindReadOnlyPaths = [ "/etc" ];
        testScript = ''
          with subtest("check existence of bind-mounted /etc"):
              passwd = machine.succeed('chroot-exec cat /etc/passwd').strip()
              assert len(passwd) > 0, "/etc/passwd must not be empty"
        '';
      }
      { config.serviceConfig.User = "chroot-testuser";
        config.serviceConfig.Group = "chroot-testgroup";
        testScript = ''
          with subtest("check if User/Group really runs as non-root"):
              machine.succeed("chroot-exec ls -l /dev")
              uid = machine.succeed('chroot-exec id -u').strip()
              assert uid != "0", "UID of chroot-testuser shouldn't be 0"
              machine.fail("chroot-exec touch /bin/test")
        '';
      }
      { config.confinement.mode = "full-apivfs";
        config.serviceConfig.DynamicUser = true;
        testScript = ''
          with subtest("check if DynamicUser is working in full-apivfs mode"):
              machine.succeed("chroot-exec ls -l /dev")
              paths = machine.succeed('chroot-exec find / -path /dev/"\\*" -prune -o -path /nix/"\\*" -prune -o -path /proc/"\\*" -prune -o -path /sys/"\\*" -prune -o -print || test $? = 1')
              assert_eq(
                '\n'.join(sorted(paths.split('\n'))),
          """
          /
          /bin
          /bin/sh
          /dev
          /etc
          /nix
          /proc
          /root
          /run
          /run/host
          /run/host/.os-release-stage
          /run/host/.os-release-stage/os-release
          /run/host/os-release
          /run/systemd
          /run/systemd/incoming
          /sys
          /tmp
          /usr
          /var
          /var/tmp
          find: '/root': Permission denied
          find: '/run/systemd/incoming': Permission denied"""
              )
              uid = machine.succeed('chroot-exec id -u').strip()
              assert uid != "0", "UID of a DynamicUser shouldn't be 0"
              machine.fail("chroot-exec touch /bin/test")
              # DynamicUser=true implies ProtectSystem=strict
              machine.fail("chroot-exec touch /etc/test")
        '';
      }
      { config.confinement.mode = "full-apivfs";
        config.serviceConfig.DynamicUser = true;
        config.serviceConfig.PrivateTmp = false;
        testScript = ''
          with subtest("check if DynamicUser and PrivateTmp=false are working in full-apivfs mode"):
              machine.succeed("chroot-exec ls -l /dev")
              paths = machine.succeed('chroot-exec find / -path /dev/"\\*" -prune -o -path /nix/"\\*" -prune -o -path /proc/"\\*" -prune -o -path /sys/"\\*" -prune -o -print || test $? = 1')
              assert_eq(
                '\n'.join(sorted(paths.split('\n'))),
          """
          /
          /bin
          /bin/sh
          /dev
          /etc
          /nix
          /proc
          /root
          /run
          /run/host
          /run/host/.os-release-stage
          /run/host/.os-release-stage/os-release
          /run/host/os-release
          /run/systemd
          /run/systemd/incoming
          /sys
          /usr
          /var
          find: '/root': Permission denied
          find: '/run/systemd/incoming': Permission denied"""
              )
              uid = machine.succeed('chroot-exec id -u').strip()
              assert uid != "0", "UID of a DynamicUser shouldn't be 0"
              machine.fail("chroot-exec touch /bin/test")
              # DynamicUser=true implies ProtectSystem=strict
              machine.fail("chroot-exec touch /etc/test")
        '';
      }
      { config.confinement.mode = "chroot-only";
        config.serviceConfig.DynamicUser = true;
        testScript = ''
          with subtest("check if DynamicUser is working in chroot-only mode"):
              paths = machine.succeed('chroot-exec find / -path /nix/"\\*" -prune -o -print || test $? = 1')
              assert_eq(
                '\n'.join(sorted(paths.split('\n'))),
          """
          /
          /bin
          /bin/sh
          /dev
          /etc
          /nix
          /proc
          /root
          /run
          /run/systemd
          /run/systemd/incoming
          /sys
          /usr
          /var
          find: '/root': Permission denied
          find: '/run/systemd/incoming': Permission denied"""
              )
              uid = machine.succeed('chroot-exec id -u').strip()
              assert uid != "0", "UID of a DynamicUser shouldn't be 0"
              machine.fail("chroot-exec touch /bin/test")
        '';
      }
      { config.confinement.mode = "chroot-only";
        config.serviceConfig.DynamicUser = true;
        config.serviceConfig.PrivateTmp = true;
        testScript = ''
          with subtest("check if DynamicUser and PrivateTmp=true are working in chroot-only mode"):
              paths = machine.succeed('chroot-exec find / -path /nix/"\\*" -prune -o -print || test $? = 1')
              assert_eq(
                '\n'.join(sorted(paths.split('\n'))),
          """
          /
          /bin
          /bin/sh
          /dev
          /etc
          /nix
          /proc
          /root
          /run
          /run/systemd
          /run/systemd/incoming
          /sys
          /tmp
          /usr
          /var
          /var/tmp
          find: '/root': Permission denied
          find: '/run/systemd/incoming': Permission denied"""
              )
              uid = machine.succeed('chroot-exec id -u').strip()
              assert uid != "0", "UID of a DynamicUser shouldn't be 0"
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
              machine.succeed("chroot-exec rmdir /etc")
              text = machine.succeed('chroot-exec cat ${symlink}').strip()
              assert_eq(text, "got me")
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
      { serviceName = "shipped-unitfile";
        config.confinement.mode = "chroot-only";
        testScript = ''
          with subtest("check if shipped unit file still works"):
              machine.succeed(
                  'chroot-exec \'kill -9 $$ 2>&1 || :\' | '
                  'grep -q "Too many levels of symbolic links"'
              )
        '';
      }
    ];

    options.__testSteps = lib.mkOption {
      type = lib.types.lines;
      description = "All of the test steps combined as a single script.";
    };

    config.environment.systemPackages = lib.singleton testClient;
    config.systemd.packages = lib.singleton (pkgs.writeTextFile {
      name = "shipped-unitfile";
      destination = "/etc/systemd/system/shipped-unitfile@.service";
      text = ''
        [Service]
        SystemCallFilter=~kill
        SystemCallErrorNumber=ELOOP
      '';
    });

    config.users.groups.chroot-testgroup = {};
    config.users.users.chroot-testuser = {
      isSystemUser = true;
      description = "Chroot Test User";
      group = "chroot-testgroup";
    };
  };

  testScript = { nodes, ... }: ''
    import difflib
    def assert_eq(got, expected):
        if got != expected:
          diff = difflib.unified_diff(got.splitlines(keepends=True), expected.splitlines(keepends=True))
          print("".join(diff))
        assert got == expected, f"{got} != {expected}"

    machine.wait_for_unit("multi-user.target")
  '' + nodes.machine.__testSteps;
}

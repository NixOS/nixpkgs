import ./make-test-python.nix {
  name = "systemd-confinement";

  machine = { pkgs, lib, ... }: let
    testServer = pkgs.writeScript "testserver.sh" ''
      #!${pkgs.runtimeShell}
      export PATH=${lib.escapeShellArg (lib.makeBinPath [
        pkgs.coreutils pkgs.util-linux
      ])}
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

    mkTestStep = num: { description, config ? {}, testScript }: {
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
        with subtest('${lib.escape ["'" "\\"] description}'):
          machine.succeed("echo ${toString num} > /teststep")
      '' + testScript);
    };

  in {
    imports = lib.imap1 mkTestStep [
      { description = "chroot-only confinement";
        config.confinement.mode = "chroot-only";
        testScript = ''
          paths = machine.succeed('chroot-exec ls -1 / | paste -sd,').strip()
          assert_eq(paths, "bin,nix,run")
          uid = machine.succeed('chroot-exec id -u').strip()
          assert_eq(uid, "0")
          machine.succeed("chroot-exec chown 65534 /bin")
        '';
      }
      { description = "full confinement with APIVFS";
        testScript = ''
          machine.fail("chroot-exec ls -l /etc")
          machine.fail("chroot-exec chown 65534 /bin")
          assert_eq(machine.succeed('chroot-exec id -u').strip(), "0")
          machine.succeed("chroot-exec chown 0 /bin")
        '';
      }
      { description = "check existence of bind-mounted /etc";
        config.serviceConfig.BindReadOnlyPaths = [ "/etc" ];
        testScript = ''
          passwd = machine.succeed('chroot-exec cat /etc/passwd').strip()
          assert len(passwd) > 0, "/etc/passwd must not be empty"
        '';
      }
      { description = "check if User/Group really runs as non-root";
        config.serviceConfig.User = "chroot-testuser";
        config.serviceConfig.Group = "chroot-testgroup";
        testScript = ''
          machine.succeed("chroot-exec ls -l /dev")
          uid = machine.succeed('chroot-exec id -u').strip()
          assert uid != "0", "UID of chroot-testuser shouldn't be 0"
          machine.fail("chroot-exec touch /bin/test")
        '';
      }
      (let
        symlink = pkgs.runCommand "symlink" {
          target = pkgs.writeText "symlink-target" "got me\n";
        } "ln -s \"$target\" \"$out\"";
      in {
        description = "check if symlinks are properly bind-mounted";
        config.confinement.packages = lib.singleton symlink;
        testScript = ''
          machine.fail("chroot-exec test -e /etc")
          text = machine.succeed('chroot-exec cat ${symlink}').strip()
          assert_eq(text, "got me")
        '';
      })
      { description = "check if StateDirectory works";
        config.serviceConfig.User = "chroot-testuser";
        config.serviceConfig.Group = "chroot-testgroup";
        config.serviceConfig.StateDirectory = "testme";
        testScript = ''
          machine.succeed("chroot-exec touch /tmp/canary")
          machine.succeed('chroot-exec "echo works > /var/lib/testme/foo"')
          machine.succeed('test "$(< /var/lib/testme/foo)" = works')
          machine.succeed("test ! -e /tmp/canary")
        '';
      }
      { description = "check if /bin/sh works";
        testScript = ''
          machine.succeed(
            "chroot-exec test -e /bin/sh",
            'test "$(chroot-exec \'/bin/sh -c "echo bar"\')" = bar',
          )
        '';
      }
      { description = "check if suppressing /bin/sh works";
        config.confinement.binSh = null;
        testScript = ''
          machine.succeed("chroot-exec test ! -e /bin/sh")
          machine.succeed('test "$(chroot-exec \'/bin/sh -c "echo foo"\')" != foo')
        '';
      }
      { description = "check if we can set /bin/sh to something different";
        config.confinement.binSh = "${pkgs.hello}/bin/hello";
        testScript = ''
          machine.succeed("chroot-exec test -e /bin/sh")
          machine.succeed('test "$(chroot-exec /bin/sh -g foo)" = foo')
        '';
      }
      { description = "check if only Exec* dependencies are included";
        config.environment.FOOBAR = pkgs.writeText "foobar" "eek\n";
        testScript = ''
          machine.succeed('test "$(chroot-exec \'cat "$FOOBAR"\')" != eek')
        '';
      }
      { description = "check if all unit dependencies are included";
        config.environment.FOOBAR = pkgs.writeText "foobar" "eek\n";
        config.confinement.fullUnit = true;
        testScript = ''
          machine.succeed('test "$(chroot-exec \'cat "$FOOBAR"\')" = eek')
        '';
      }
      { description = "check if umask affects leading store directories";
        config.serviceConfig.UMask = "0077";
        config.serviceConfig.User = "chroot-testuser";
        config.serviceConfig.Group = "chroot-testgroup";
        config.confinement.mode = "chroot-only";
        testScript = ''
          machine.succeed('chroot-exec \'namei -m "$_"\' >&2')
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
    def assert_eq(a, b):
        assert a == b, f"{a} != {b}"

    machine.wait_for_unit("multi-user.target")
  '' + nodes.machine.config.__testSteps;
}

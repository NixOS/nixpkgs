import ../make-test-python.nix {
  name = "systemd-confinement";

  nodes.machine =
    { pkgs, lib, ... }:
    let
      testLib = pkgs.python3Packages.buildPythonPackage {
        name = "confinement-testlib";
        unpackPhase = ''
          cat > setup.py <<EOF
          from setuptools import setup
          setup(name='confinement-testlib', py_modules=["checkperms"])
          EOF
          cp ${./checkperms.py} checkperms.py
        '';
      };

      mkTest =
        name: testScript:
        pkgs.writers.writePython3 "${name}.py"
          {
            libraries = [
              pkgs.python3Packages.pytest
              testLib
            ];
          }
          ''
            # This runs our test script by using pytest's assertion rewriting, so
            # that whenever we use "assert <something>", the actual values are
            # printed rather than getting a generic AssertionError or the need to
            # pass an explicit assertion error message.
            import ast
            from pathlib import Path
            from _pytest.assertion.rewrite import rewrite_asserts

            script = Path('${pkgs.writeText "${name}-main.py" ''
              import errno, os, pytest, signal
              from subprocess import run
              from checkperms import Accessibility, assert_permissions

              ${testScript}
            ''}') # noqa
            filename = str(script)
            source = script.read_bytes()

            tree = ast.parse(source, filename=filename)
            rewrite_asserts(tree, source, filename)
            exec(compile(tree, filename, 'exec', dont_inherit=True))
          '';

      mkTestStep =
        num:
        {
          description,
          testScript,
          config ? { },
          serviceName ? "test${toString num}",
          rawUnit ? null,
        }:
        {
          systemd.packages = lib.optional (rawUnit != null) (
            pkgs.writeTextFile {
              name = serviceName;
              destination = "/etc/systemd/system/${serviceName}.service";
              text = rawUnit;
            }
          );

          systemd.services.${serviceName} =
            {
              inherit description;
              requiredBy = [ "multi-user.target" ];
              confinement = (config.confinement or { }) // {
                enable = true;
              };
              serviceConfig = (config.serviceConfig or { }) // {
                ExecStart = mkTest serviceName testScript;
                Type = "oneshot";
              };
            }
            // removeAttrs config [
              "confinement"
              "serviceConfig"
            ];
        };

      parametrisedTests =
        lib.concatMap
          (
            { user, privateTmp }:
            let
              withTmp = if privateTmp then "with PrivateTmp" else "without PrivateTmp";

              serviceConfig =
                if user == "static-user" then
                  {
                    User = "chroot-testuser";
                    Group = "chroot-testgroup";
                  }
                else if user == "dynamic-user" then
                  {
                    DynamicUser = true;
                  }
                else
                  { };

            in
            [
              {
                description = "${user}, chroot-only confinement ${withTmp}";
                config = {
                  confinement.mode = "chroot-only";
                  # Only set if privateTmp is true to ensure that the default is false.
                  serviceConfig =
                    serviceConfig
                    // lib.optionalAttrs privateTmp {
                      PrivateTmp = true;
                    };
                };
                testScript =
                  if user == "root" then
                    ''
                      assert os.getuid() == 0
                      assert os.getgid() == 0

                      assert_permissions({
                        'bin': Accessibility.READABLE,
                        'nix': Accessibility.READABLE,
                        'run': Accessibility.READABLE,
                        ${lib.optionalString privateTmp "'tmp': Accessibility.STICKY,"}
                        ${lib.optionalString privateTmp "'var': Accessibility.READABLE,"}
                        ${lib.optionalString privateTmp "'var/tmp': Accessibility.STICKY,"}
                      })
                    ''
                  else
                    ''
                      assert os.getuid() != 0
                      assert os.getgid() != 0

                      assert_permissions({
                        'bin': Accessibility.READABLE,
                        'nix': Accessibility.READABLE,
                        'run': Accessibility.READABLE,
                        ${lib.optionalString privateTmp "'tmp': Accessibility.STICKY,"}
                        ${lib.optionalString privateTmp "'var': Accessibility.READABLE,"}
                        ${lib.optionalString privateTmp "'var/tmp': Accessibility.STICKY,"}
                      })
                    '';
              }
              {
                description = "${user}, full APIVFS confinement ${withTmp}";
                config = {
                  # Only set if privateTmp is false to ensure that the default is true.
                  serviceConfig =
                    serviceConfig
                    // lib.optionalAttrs (!privateTmp) {
                      PrivateTmp = false;
                    };
                };
                testScript =
                  if user == "root" then
                    ''
                      assert os.getuid() == 0
                      assert os.getgid() == 0

                      assert_permissions({
                        'bin': Accessibility.READABLE,
                        'nix': Accessibility.READABLE,
                        ${lib.optionalString privateTmp "'tmp': Accessibility.STICKY,"}
                        'run': Accessibility.WRITABLE,

                        'proc': Accessibility.SPECIAL,
                        'sys': Accessibility.SPECIAL,
                        'dev': Accessibility.WRITABLE,

                        ${lib.optionalString privateTmp "'var': Accessibility.READABLE,"}
                        ${lib.optionalString privateTmp "'var/tmp': Accessibility.STICKY,"}
                      })
                    ''
                  else
                    ''
                      assert os.getuid() != 0
                      assert os.getgid() != 0

                      assert_permissions({
                        'bin': Accessibility.READABLE,
                        'nix': Accessibility.READABLE,
                        ${lib.optionalString privateTmp "'tmp': Accessibility.STICKY,"}
                        'run': Accessibility.STICKY,

                        'proc': Accessibility.SPECIAL,
                        'sys': Accessibility.SPECIAL,
                        'dev': Accessibility.SPECIAL,
                        'dev/shm': Accessibility.STICKY,
                        'dev/mqueue': Accessibility.STICKY,

                        ${lib.optionalString privateTmp "'var': Accessibility.READABLE,"}
                        ${lib.optionalString privateTmp "'var/tmp': Accessibility.STICKY,"}
                      })
                    '';
              }
            ]
          )
          (
            lib.cartesianProduct {
              user = [
                "root"
                "dynamic-user"
                "static-user"
              ];
              privateTmp = [
                true
                false
              ];
            }
          );

    in
    {
      imports = lib.imap1 mkTestStep (
        parametrisedTests
        ++ [
          {
            description = "existence of bind-mounted /etc";
            config.serviceConfig.BindReadOnlyPaths = [ "/etc" ];
            testScript = ''
              assert Path('/etc/passwd').read_text()
            '';
          }
          (
            let
              symlink = pkgs.runCommand "symlink" {
                target = pkgs.writeText "symlink-target" "got me";
              } "ln -s \"$target\" \"$out\"";
            in
            {
              description = "check if symlinks are properly bind-mounted";
              config.confinement.packages = lib.singleton symlink;
              testScript = ''
                assert Path('${symlink}').read_text() == 'got me'
              '';
            }
          )
          {
            description = "check if StateDirectory works";
            config.serviceConfig.User = "chroot-testuser";
            config.serviceConfig.Group = "chroot-testgroup";
            config.serviceConfig.StateDirectory = "testme";

            # We restart on purpose here since we want to check whether the state
            # directory actually persists.
            config.serviceConfig.Restart = "on-failure";
            config.serviceConfig.RestartMode = "direct";

            testScript = ''
              assert not Path('/tmp/canary').exists()
              Path('/tmp/canary').touch()

              if (foo := Path('/var/lib/testme/foo')).exists():
                assert Path('/var/lib/testme/foo').read_text() == 'works'
              else:
                Path('/var/lib/testme/foo').write_text('works')
                print('<4>Exiting with failure to check persistence on restart.')
                raise SystemExit(1)
            '';
          }
          {
            description = "check if /bin/sh works";
            testScript = ''
              assert Path('/bin/sh').exists()

              result = run(
                ['/bin/sh', '-c', 'echo -n bar'],
                capture_output=True,
                check=True,
              )
              assert result.stdout == b'bar'
            '';
          }
          {
            description = "check if suppressing /bin/sh works";
            config.confinement.binSh = null;
            testScript = ''
              assert not Path('/bin/sh').exists()
              with pytest.raises(FileNotFoundError):
                run(['/bin/sh', '-c', 'echo foo'])
            '';
          }
          {
            description = "check if we can set /bin/sh to something different";
            config.confinement.binSh = "${pkgs.hello}/bin/hello";
            testScript = ''
              assert Path('/bin/sh').exists()
              result = run(
                ['/bin/sh', '-g', 'foo'],
                capture_output=True,
                check=True,
              )
              assert result.stdout == b'foo\n'
            '';
          }
          {
            description = "check if only Exec* dependencies are included";
            config.environment.FOOBAR = pkgs.writeText "foobar" "eek";
            testScript = ''
              with pytest.raises(FileNotFoundError):
                Path(os.environ['FOOBAR']).read_text()
            '';
          }
          {
            description = "check if fullUnit includes all dependencies";
            config.environment.FOOBAR = pkgs.writeText "foobar" "eek";
            config.confinement.fullUnit = true;
            testScript = ''
              assert Path(os.environ['FOOBAR']).read_text() == 'eek'
            '';
          }
          {
            description = "check if shipped unit file still works";
            config.confinement.mode = "chroot-only";
            rawUnit = ''
              [Service]
              SystemCallFilter=~kill
              SystemCallErrorNumber=ELOOP
            '';
            testScript = ''
              with pytest.raises(OSError) as excinfo:
                os.kill(os.getpid(), signal.SIGKILL)
              assert excinfo.value.errno == errno.ELOOP
            '';
          }
        ]
      );

      config.users.groups.chroot-testgroup = { };
      config.users.users.chroot-testuser = {
        isSystemUser = true;
        description = "Chroot Test User";
        group = "chroot-testgroup";
      };
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
  '';
}

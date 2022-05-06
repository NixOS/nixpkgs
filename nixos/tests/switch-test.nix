# Test configuration switching.

import ./make-test-python.nix ({ pkgs, ...} : let

  # Simple service that can either be socket-activated or that will
  # listen on port 1234 if not socket-activated.
  # A connection to the socket causes 'hello' to be written to the client.
  socketTest = pkgs.writeScript "socket-test.py" /* python */ ''
    #!${pkgs.python3}/bin/python3

    from socketserver import TCPServer, StreamRequestHandler
    import socket
    import os


    class Handler(StreamRequestHandler):
        def handle(self):
            self.wfile.write("hello".encode("utf-8"))


    class Server(TCPServer):
        def __init__(self, server_address, handler_cls):
            listenFds = os.getenv('LISTEN_FDS')
            if listenFds is None or int(listenFds) < 1:
                print(f'Binding to {server_address}')
                TCPServer.__init__(
                        self, server_address, handler_cls, bind_and_activate=True)
            else:
                TCPServer.__init__(
                        self, server_address, handler_cls, bind_and_activate=False)
                # Override socket
                print(f'Got activated by {os.getenv("LISTEN_FDNAMES")} '
                      f'with {listenFds} FDs')
                self.socket = socket.fromfd(3, self.address_family,
                                            self.socket_type)


    if __name__ == "__main__":
        server = Server(("localhost", 1234), Handler)
        server.serve_forever()
  '';

in {
  name = "switch-test";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ gleber das_j ];
  };

  nodes = {
    machine = { pkgs, lib, ... }: {
      environment.systemPackages = [ pkgs.socat ]; # for the socket activation stuff
      users.mutableUsers = false;

      # For boot/switch testing
      system.build.installBootLoader = lib.mkForce (pkgs.writeShellScript "install-dummy-loader" ''
        echo "installing dummy bootloader"
        touch /tmp/bootloader-installed
      '');

      specialisation = rec {
        simpleService.configuration = {
          systemd.services.test = {
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${pkgs.coreutils}/bin/true";
              ExecReload = "${pkgs.coreutils}/bin/true";
            };
          };
        };

        simpleServiceDifferentDescription.configuration = {
          imports = [ simpleService.configuration ];
          systemd.services.test.description = "Test unit";
        };

        simpleServiceModified.configuration = {
          imports = [ simpleService.configuration ];
          systemd.services.test.serviceConfig.X-Test = true;
        };

        simpleServiceNostop.configuration = {
          imports = [ simpleService.configuration ];
          systemd.services.test.stopIfChanged = false;
        };

        simpleServiceReload.configuration = {
          imports = [ simpleService.configuration ];
          systemd.services.test = {
            reloadIfChanged = true;
            serviceConfig.ExecReload = "${pkgs.coreutils}/bin/true";
          };
        };

        simpleServiceNorestart.configuration = {
          imports = [ simpleService.configuration ];
          systemd.services.test.restartIfChanged = false;
        };

        simpleServiceFailing.configuration = {
          imports = [ simpleServiceModified.configuration ];
          systemd.services.test.serviceConfig.ExecStart = lib.mkForce "${pkgs.coreutils}/bin/false";
        };

        autorestartService.configuration = {
          # A service that immediately goes into restarting (but without failing)
          systemd.services.autorestart = {
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              Type = "simple";
              Restart = "always";
              RestartSec = "20y"; # Should be long enough
              ExecStart = "${pkgs.coreutils}/bin/true";
            };
          };
        };

        autorestartServiceFailing.configuration = {
          imports = [ autorestartService.configuration ];
          systemd.services.autorestart.serviceConfig = {
            ExecStart = lib.mkForce "${pkgs.coreutils}/bin/false";
          };
        };

        simpleServiceWithExtraSection.configuration = {
          imports = [ simpleServiceNostop.configuration ];
          systemd.packages = [ (pkgs.writeTextFile {
            name = "systemd-extra-section";
            destination = "/etc/systemd/system/test.service";
            text = ''
              [X-Test]
              X-Test-Value=a
            '';
          }) ];
        };

        simpleServiceWithExtraSectionOtherName.configuration = {
          imports = [ simpleServiceNostop.configuration ];
          systemd.packages = [ (pkgs.writeTextFile {
            name = "systemd-extra-section";
            destination = "/etc/systemd/system/test.service";
            text = ''
              [X-Test2]
              X-Test-Value=a
            '';
          }) ];
        };

        simpleServiceWithInstallSection.configuration = {
          imports = [ simpleServiceNostop.configuration ];
          systemd.packages = [ (pkgs.writeTextFile {
            name = "systemd-extra-section";
            destination = "/etc/systemd/system/test.service";
            text = ''
              [Install]
              WantedBy=multi-user.target
            '';
          }) ];
        };

        simpleServiceWithExtraKey.configuration = {
          imports = [ simpleServiceNostop.configuration ];
          systemd.services.test.serviceConfig."X-Test" = "test";
        };

        simpleServiceWithExtraKeyOtherValue.configuration = {
          imports = [ simpleServiceNostop.configuration ];
          systemd.services.test.serviceConfig."X-Test" = "test2";
        };

        simpleServiceWithExtraKeyOtherName.configuration = {
          imports = [ simpleServiceNostop.configuration ];
          systemd.services.test.serviceConfig."X-Test2" = "test";
        };

        simpleServiceReloadTrigger.configuration = {
          imports = [ simpleServiceNostop.configuration ];
          systemd.services.test.reloadTriggers = [ "/dev/null" ];
        };

        simpleServiceReloadTriggerModified.configuration = {
          imports = [ simpleServiceNostop.configuration ];
          systemd.services.test.reloadTriggers = [ "/dev/zero" ];
        };

        simpleServiceReloadTriggerModifiedAndSomethingElse.configuration = {
          imports = [ simpleServiceNostop.configuration ];
          systemd.services.test = {
            reloadTriggers = [ "/dev/zero" ];
            serviceConfig."X-Test" = "test";
          };
        };

        simpleServiceReloadTriggerModifiedSomethingElse.configuration = {
          imports = [ simpleServiceNostop.configuration ];
          systemd.services.test.serviceConfig."X-Test" = "test";
        };

        unitWithBackslash.configuration = {
          systemd.services."escaped\\x2ddash" = {
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${pkgs.coreutils}/bin/true";
              ExecReload = "${pkgs.coreutils}/bin/true";
            };
          };
        };

        unitWithBackslashModified.configuration = {
          imports = [ unitWithBackslash.configuration ];
          systemd.services."escaped\\x2ddash".serviceConfig.X-Test = "test";
        };

        unitWithRequirement.configuration = {
          systemd.services.required-service = {
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${pkgs.coreutils}/bin/true";
              ExecReload = "${pkgs.coreutils}/bin/true";
            };
          };
          systemd.services.test-service = {
            wantedBy = [ "multi-user.target" ];
            requires = [ "required-service.service" ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${pkgs.coreutils}/bin/true";
              ExecReload = "${pkgs.coreutils}/bin/true";
            };
          };
        };

        unitWithRequirementModified.configuration = {
          imports = [ unitWithRequirement.configuration ];
          systemd.services.required-service.serviceConfig.X-Test = "test";
          systemd.services.test-service.reloadTriggers = [ "test" ];
        };

        unitWithRequirementModifiedNostart.configuration = {
          imports = [ unitWithRequirement.configuration ];
          systemd.services.test-service.unitConfig.RefuseManualStart = true;
        };

        restart-and-reload-by-activation-script.configuration = {
          systemd.services = rec {
            simple-service = {
              # No wantedBy so we can check if the activation script restart triggers them
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
                ExecStart = "${pkgs.coreutils}/bin/true";
                ExecReload = "${pkgs.coreutils}/bin/true";
              };
            };

            simple-restart-service = simple-service // {
              stopIfChanged = false;
            };

            simple-reload-service = simple-service // {
              reloadIfChanged = true;
            };

            no-restart-service = simple-service // {
              restartIfChanged = false;
            };

            reload-triggers = simple-service // {
              wantedBy = [ "multi-user.target" ];
            };

            reload-triggers-and-restart-by-as = simple-service;

            reload-triggers-and-restart = simple-service // {
              stopIfChanged = false; # easier to check for this
              wantedBy = [ "multi-user.target" ];
            };
          };

          system.activationScripts.restart-and-reload-test = {
            supportsDryActivation = true;
            deps = [];
            text = ''
              if [ "$NIXOS_ACTION" = dry-activate ]; then
                f=/run/nixos/dry-activation-restart-list
                g=/run/nixos/dry-activation-reload-list
              else
                f=/run/nixos/activation-restart-list
                g=/run/nixos/activation-reload-list
              fi
              cat <<EOF >> "$f"
              simple-service.service
              simple-restart-service.service
              simple-reload-service.service
              no-restart-service.service
              reload-triggers-and-restart-by-as.service
              EOF

              cat <<EOF >> "$g"
              reload-triggers.service
              reload-triggers-and-restart-by-as.service
              reload-triggers-and-restart.service
              EOF
            '';
          };
        };

        restart-and-reload-by-activation-script-modified.configuration = {
          imports = [ restart-and-reload-by-activation-script.configuration ];
          systemd.services.reload-triggers-and-restart.serviceConfig.X-Modified = "test";
        };

        simple-socket.configuration = {
          systemd.services.socket-activated = {
            description = "A socket-activated service";
            stopIfChanged = lib.mkDefault false;
            serviceConfig = {
              ExecStart = socketTest;
              ExecReload = "${pkgs.coreutils}/bin/true";
            };
          };
          systemd.sockets.socket-activated = {
            wantedBy = [ "sockets.target" ];
            listenStreams = [ "/run/test.sock" ];
            socketConfig.SocketMode = lib.mkDefault "0777";
          };
        };

        simple-socket-service-modified.configuration = {
          imports = [ simple-socket.configuration ];
          systemd.services.socket-activated.serviceConfig.X-Test = "test";
        };

        simple-socket-stop-if-changed.configuration = {
          imports = [ simple-socket.configuration ];
          systemd.services.socket-activated.stopIfChanged = true;
        };

        simple-socket-stop-if-changed-and-reloadtrigger.configuration = {
          imports = [ simple-socket.configuration ];
          systemd.services.socket-activated = {
            stopIfChanged = true;
            reloadTriggers = [ "test" ];
          };
        };

        mount.configuration = {
          systemd.mounts = [
            {
              description = "Testmount";
              what = "tmpfs";
              type = "tmpfs";
              where = "/testmount";
              options = "size=1M";
              wantedBy = [ "local-fs.target" ];
            }
          ];
        };

        mountModified.configuration = {
          systemd.mounts = [
            {
              description = "Testmount";
              what = "tmpfs";
              type = "tmpfs";
              where = "/testmount";
              options = "size=10M";
              wantedBy = [ "local-fs.target" ];
            }
          ];
        };

        timer.configuration = {
          systemd.timers.test-timer = {
            wantedBy = [ "timers.target" ];
            timerConfig.OnCalendar = "@1395716396"; # chosen by fair dice roll
          };
          systemd.services.test-timer = {
            serviceConfig = {
              Type = "oneshot";
              ExecStart = "${pkgs.coreutils}/bin/true";
            };
          };
        };

        timerModified.configuration = {
          imports = [ timer.configuration ];
          systemd.timers.test-timer.timerConfig.OnCalendar = lib.mkForce "Fri 2012-11-23 16:00:00";
        };

        hybridSleepModified.configuration = {
          systemd.targets.hybrid-sleep.unitConfig.X-Test = true;
        };

        target.configuration = {
          systemd.targets.test-target.wantedBy = [ "multi-user.target" ];
          # We use this service to figure out whether the target was modified.
          # This is the only way because targets are filtered and therefore not
          # printed when they are started/stopped.
          systemd.services.test-service = {
            bindsTo = [ "test-target.target" ];
            serviceConfig.ExecStart = "${pkgs.coreutils}/bin/sleep infinity";
          };
        };

        targetModified.configuration = {
          imports = [ target.configuration ];
          systemd.targets.test-target.unitConfig.X-Test = true;
        };

        targetModifiedStopOnReconfig.configuration = {
          imports = [ target.configuration ];
          systemd.targets.test-target.unitConfig.X-StopOnReconfiguration = true;
        };

        path.configuration = {
          systemd.paths.test-watch = {
            wantedBy = [ "paths.target" ];
            pathConfig.PathExists = "/testpath";
          };
          systemd.services.test-watch = {
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${pkgs.coreutils}/bin/touch /testpath-modified";
            };
          };
        };

        pathModified.configuration = {
          imports = [ path.configuration ];
          systemd.paths.test-watch.pathConfig.PathExists = lib.mkForce "/testpath2";
        };

        slice.configuration = {
          systemd.slices.testslice.sliceConfig.MemoryMax = "1"; # don't allow memory allocation
          systemd.services.testservice = {
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${pkgs.coreutils}/bin/true";
              Slice = "testslice.slice";
            };
          };
        };

        sliceModified.configuration = {
          imports = [ slice.configuration ];
          systemd.slices.testslice.sliceConfig.MemoryMax = lib.mkForce null;
        };
      };
    };

    other = {
      users.mutableUsers = true;
    };
  };

  testScript = { nodes, ... }: let
    originalSystem = nodes.machine.config.system.build.toplevel;
    otherSystem = nodes.other.config.system.build.toplevel;
    machine = nodes.machine.config.system.build.toplevel;

    # Ensures failures pass through using pipefail, otherwise failing to
    # switch-to-configuration is hidden by the success of `tee`.
    stderrRunner = pkgs.writeScript "stderr-runner" ''
      #! ${pkgs.runtimeShell}
      set -e
      set -o pipefail
      exec env -i "$@" | tee /dev/stderr
    '';
  in /* python */ ''
    def switch_to_specialisation(system, name, action="test", fail=False):
        if name == "":
            stc = f"{system}/bin/switch-to-configuration"
        else:
            stc = f"{system}/specialisation/{name}/bin/switch-to-configuration"
        out = machine.fail(f"{stc} {action} 2>&1") if fail \
            else machine.succeed(f"{stc} {action} 2>&1")
        assert_lacks(out, "switch-to-configuration line")  # Perl warnings
        return out

    def assert_contains(haystack, needle):
        if needle not in haystack:
            print("The haystack that will cause the following exception is:")
            print("---")
            print(haystack)
            print("---")
            raise Exception(f"Expected string '{needle}' was not found")

    def assert_lacks(haystack, needle):
        if needle in haystack:
            print("The haystack that will cause the following exception is:")
            print("---")
            print(haystack, end="")
            print("---")
            raise Exception(f"Unexpected string '{needle}' was found")


    machine.wait_for_unit("multi-user.target")

    machine.succeed(
        "${stderrRunner} ${originalSystem}/bin/switch-to-configuration test"
    )
    # This tests whether the /etc/os-release parser works which is a fallback
    # when /etc/NIXOS is missing. If the parser does not work, switch-to-configuration
    # would fail.
    machine.succeed("rm /etc/NIXOS")
    machine.succeed(
        "${stderrRunner} ${otherSystem}/bin/switch-to-configuration test"
    )


    with subtest("actions"):
        # boot action
        machine.fail("test -f /tmp/bootloader-installed")
        out = switch_to_specialisation("${machine}", "simpleService", action="boot")
        assert_contains(out, "installing dummy bootloader")
        assert_lacks(out, "activating the configuration...")  # good indicator of a system activation
        machine.succeed("test -f /tmp/bootloader-installed")
        machine.succeed("rm /tmp/bootloader-installed")

        # switch action
        machine.fail("test -f /tmp/bootloader-installed")
        out = switch_to_specialisation("${machine}", "", action="switch")
        assert_contains(out, "installing dummy bootloader")
        assert_contains(out, "activating the configuration...")  # good indicator of a system activation
        machine.succeed("test -f /tmp/bootloader-installed")

        # test and dry-activate actions are tested further down below

    with subtest("services"):
        switch_to_specialisation("${machine}", "")
        # Nothing happens when nothing is changed
        out = switch_to_specialisation("${machine}", "")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")

        # Start a simple service
        out = switch_to_specialisation("${machine}", "simpleService")
        assert_lacks(out, "installing dummy bootloader")  # test does not install a bootloader
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_contains(out, "reloading the following units: dbus.service\n")  # huh
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_contains(out, "the following new units were started: test.service\n")

        # Not changing anything doesn't do anything
        out = switch_to_specialisation("${machine}", "simpleService")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")

        # Only changing the description does nothing
        out = switch_to_specialisation("${machine}", "simpleServiceDifferentDescription")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")

        # Restart the simple service
        out = switch_to_specialisation("${machine}", "simpleServiceModified")
        assert_contains(out, "stopping the following units: test.service\n")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_contains(out, "\nstarting the following units: test.service\n")
        assert_lacks(out, "the following new units were started:")

        # Restart the service with stopIfChanged=false
        out = switch_to_specialisation("${machine}", "simpleServiceNostop")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_contains(out, "\nrestarting the following units: test.service\n")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")

        # Reload the service with reloadIfChanged=true
        out = switch_to_specialisation("${machine}", "simpleServiceReload")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_contains(out, "reloading the following units: test.service\n")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")

        # Nothing happens when restartIfChanged=false
        out = switch_to_specialisation("${machine}", "simpleServiceNorestart")
        assert_lacks(out, "stopping the following units:")
        assert_contains(out, "NOT restarting the following changed units: test.service\n")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")

        # Dry mode shows different messages
        out = switch_to_specialisation("${machine}", "simpleService", action="dry-activate")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")
        assert_contains(out, "would start the following units: test.service\n")

        # Ensure \ works in unit names
        out = switch_to_specialisation("${machine}", "unitWithBackslash")
        assert_contains(out, "stopping the following units: test.service\n")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_contains(out, "the following new units were started: escaped\\x2ddash.service\n")

        out = switch_to_specialisation("${machine}", "unitWithBackslashModified")
        assert_contains(out, "stopping the following units: escaped\\x2ddash.service\n")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_contains(out, "\nstarting the following units: escaped\\x2ddash.service\n")
        assert_lacks(out, "the following new units were started:")

        # Ensure units that require changed units are properly reloaded
        out = switch_to_specialisation("${machine}", "unitWithRequirement")
        assert_contains(out, "stopping the following units: escaped\\x2ddash.service\n")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_contains(out, "the following new units were started: required-service.service, test-service.service\n")

        out = switch_to_specialisation("${machine}", "unitWithRequirementModified")
        assert_contains(out, "stopping the following units: required-service.service\n")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_contains(out, "\nstarting the following units: required-service.service, test-service.service\n")
        assert_lacks(out, "the following new units were started:")

        # Unless the unit asks to be not restarted
        out = switch_to_specialisation("${machine}", "unitWithRequirementModifiedNostart")
        assert_contains(out, "stopping the following units: required-service.service\n")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_contains(out, "\nstarting the following units: required-service.service\n")
        assert_lacks(out, "the following new units were started:")

    with subtest("failing units"):
        # Let the simple service fail
        switch_to_specialisation("${machine}", "simpleServiceModified")
        out = switch_to_specialisation("${machine}", "simpleServiceFailing", fail=True)
        assert_contains(out, "stopping the following units: test.service\n")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_contains(out, "\nstarting the following units: test.service\n")
        assert_lacks(out, "the following new units were started:")
        assert_contains(out, "warning: the following units failed: test.service\n")
        assert_contains(out, "Main PID:")  # output of systemctl

        # A unit that gets into autorestart without failing is not treated as failed
        out = switch_to_specialisation("${machine}", "autorestartService")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_contains(out, "the following new units were started: autorestart.service\n")
        machine.systemctl('stop autorestart.service')  # cancel the 20y timer

        # Switching to the same system should do nothing (especially not treat the unit as failed)
        out = switch_to_specialisation("${machine}", "autorestartService")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_contains(out, "the following new units were started: autorestart.service\n")
        machine.systemctl('stop autorestart.service')  # cancel the 20y timer

        # If systemd thinks the unit has failed and is in autorestart, we should show it as failed
        out = switch_to_specialisation("${machine}", "autorestartServiceFailing", fail=True)
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")
        assert_contains(out, "warning: the following units failed: autorestart.service\n")
        assert_contains(out, "Main PID:")  # output of systemctl

    with subtest("unit file parser"):
        # Switch to a well-known state
        switch_to_specialisation("${machine}", "simpleServiceNostop")

        # Add a section
        out = switch_to_specialisation("${machine}", "simpleServiceWithExtraSection")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_contains(out, "\nrestarting the following units: test.service\n")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")

        # Rename it
        out = switch_to_specialisation("${machine}", "simpleServiceWithExtraSectionOtherName")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_contains(out, "\nrestarting the following units: test.service\n")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")

        # Remove it
        out = switch_to_specialisation("${machine}", "simpleServiceNostop")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_contains(out, "\nrestarting the following units: test.service\n")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")

        # [Install] section is ignored
        out = switch_to_specialisation("${machine}", "simpleServiceWithInstallSection")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")

        # Add a key
        out = switch_to_specialisation("${machine}", "simpleServiceWithExtraKey")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_contains(out, "\nrestarting the following units: test.service\n")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")

        # Change its value
        out = switch_to_specialisation("${machine}", "simpleServiceWithExtraKeyOtherValue")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_contains(out, "\nrestarting the following units: test.service\n")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")

        # Rename it
        out = switch_to_specialisation("${machine}", "simpleServiceWithExtraKeyOtherName")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_contains(out, "\nrestarting the following units: test.service\n")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")

        # Remove it
        out = switch_to_specialisation("${machine}", "simpleServiceNostop")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_contains(out, "\nrestarting the following units: test.service\n")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")

        # Add a reload trigger
        out = switch_to_specialisation("${machine}", "simpleServiceReloadTrigger")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_contains(out, "reloading the following units: test.service\n")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")

        # Modify the reload trigger
        out = switch_to_specialisation("${machine}", "simpleServiceReloadTriggerModified")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_contains(out, "reloading the following units: test.service\n")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")

        # Modify the reload trigger and something else
        out = switch_to_specialisation("${machine}", "simpleServiceReloadTriggerModifiedAndSomethingElse")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_contains(out, "\nrestarting the following units: test.service\n")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")

        # Remove the reload trigger
        out = switch_to_specialisation("${machine}", "simpleServiceReloadTriggerModifiedSomethingElse")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")

    with subtest("restart and reload by activation script"):
        switch_to_specialisation("${machine}", "simpleServiceNorestart")
        out = switch_to_specialisation("${machine}", "restart-and-reload-by-activation-script")
        assert_contains(out, "stopping the following units: test.service\n")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "restarting the following units:")
        assert_contains(out, "\nstarting the following units: no-restart-service.service, reload-triggers-and-restart-by-as.service, simple-reload-service.service, simple-restart-service.service, simple-service.service\n")
        assert_contains(out, "the following new units were started: no-restart-service.service, reload-triggers-and-restart-by-as.service, reload-triggers-and-restart.service, reload-triggers.service, simple-reload-service.service, simple-restart-service.service, simple-service.service\n")
        # Switch to the same system where the example services get restarted
        # and reloaded by the activation script
        out = switch_to_specialisation("${machine}", "restart-and-reload-by-activation-script")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_contains(out, "reloading the following units: reload-triggers-and-restart.service, reload-triggers.service, simple-reload-service.service\n")
        assert_contains(out, "restarting the following units: reload-triggers-and-restart-by-as.service, simple-restart-service.service, simple-service.service\n")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")
        # Switch to the same system and see if the service gets restarted when it's modified
        # while the fact that it's supposed to be reloaded by the activation script is ignored.
        out = switch_to_specialisation("${machine}", "restart-and-reload-by-activation-script-modified")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_contains(out, "reloading the following units: reload-triggers.service, simple-reload-service.service\n")
        assert_contains(out, "restarting the following units: reload-triggers-and-restart-by-as.service, reload-triggers-and-restart.service, simple-restart-service.service, simple-service.service\n")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")
        # The same, but in dry mode
        out = switch_to_specialisation("${machine}", "restart-and-reload-by-activation-script", action="dry-activate")
        assert_lacks(out, "would stop the following units:")
        assert_lacks(out, "would NOT stop the following changed units:")
        assert_contains(out, "would reload the following units: reload-triggers.service, simple-reload-service.service\n")
        assert_contains(out, "would restart the following units: reload-triggers-and-restart-by-as.service, reload-triggers-and-restart.service, simple-restart-service.service, simple-service.service\n")
        assert_lacks(out, "\nwould start the following units:")

    with subtest("socket-activated services"):
        # Socket-activated services don't get started, just the socket
        machine.fail("[ -S /run/test.sock ]")
        out = switch_to_specialisation("${machine}", "simple-socket")
        # assert_lacks(out, "stopping the following units:") not relevant
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_contains(out, "the following new units were started: socket-activated.socket\n")
        machine.succeed("[ -S /run/test.sock ]")

        # Changing a non-activated service does nothing
        out = switch_to_specialisation("${machine}", "simple-socket-service-modified")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")
        machine.succeed("[ -S /run/test.sock ]")
        # The unit is properly activated when the socket is accessed
        if machine.succeed("socat - UNIX-CONNECT:/run/test.sock") != "hello":
            raise Exception("Socket was not properly activated")  # idk how that would happen tbh

        # Changing an activated service with stopIfChanged=false restarts the service
        out = switch_to_specialisation("${machine}", "simple-socket")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_contains(out, "\nrestarting the following units: socket-activated.service\n")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")
        machine.succeed("[ -S /run/test.sock ]")
        # Socket-activation of the unit still works
        if machine.succeed("socat - UNIX-CONNECT:/run/test.sock") != "hello":
            raise Exception("Socket was not properly activated after the service was restarted")

        # Changing an activated service with stopIfChanged=true stops the service and
        # socket and starts the socket
        out = switch_to_specialisation("${machine}", "simple-socket-stop-if-changed")
        assert_contains(out, "stopping the following units: socket-activated.service, socket-activated.socket\n")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_contains(out, "\nstarting the following units: socket-activated.socket\n")
        assert_lacks(out, "the following new units were started:")
        machine.succeed("[ -S /run/test.sock ]")
        # Socket-activation of the unit still works
        if machine.succeed("socat - UNIX-CONNECT:/run/test.sock") != "hello":
            raise Exception("Socket was not properly activated after the service was restarted")

        # Changing a reload trigger of a socket-activated unit only reloads it
        out = switch_to_specialisation("${machine}", "simple-socket-stop-if-changed-and-reloadtrigger")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_contains(out, "reloading the following units: socket-activated.service\n")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units: socket-activated.socket")
        assert_lacks(out, "the following new units were started:")
        machine.succeed("[ -S /run/test.sock ]")
        # Socket-activation of the unit still works
        if machine.succeed("socat - UNIX-CONNECT:/run/test.sock") != "hello":
            raise Exception("Socket was not properly activated after the service was restarted")

    with subtest("mounts"):
        switch_to_specialisation("${machine}", "mount")
        out = machine.succeed("mount | grep 'on /testmount'")
        assert_contains(out, "size=1024k")
        out = switch_to_specialisation("${machine}", "mountModified")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_contains(out, "reloading the following units: testmount.mount\n")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")
        # It changed
        out = machine.succeed("mount | grep 'on /testmount'")
        assert_contains(out, "size=10240k")

    with subtest("timers"):
        switch_to_specialisation("${machine}", "timer")
        out = machine.succeed("systemctl show test-timer.timer")
        assert_contains(out, "OnCalendar=2014-03-25 02:59:56 UTC")
        out = switch_to_specialisation("${machine}", "timerModified")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following units:")
        assert_lacks(out, "reloading the following units:")
        assert_contains(out, "\nrestarting the following units: test-timer.timer\n")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")
        # It changed
        out = machine.succeed("systemctl show test-timer.timer")
        assert_contains(out, "OnCalendar=Fri 2012-11-23 16:00:00")

    with subtest("targets"):
        # Modifying some special targets like hybrid-sleep.target does nothing
        out = switch_to_specialisation("${machine}", "hybridSleepModified")
        assert_contains(out, "stopping the following units: test-timer.timer\n")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")

        # Adding a new target starts it
        out = switch_to_specialisation("${machine}", "target")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_contains(out, "the following new units were started: test-target.target\n")

        # Changing a target doesn't print anything because the unit is filtered
        machine.systemctl("start test-service.service")
        out = switch_to_specialisation("${machine}", "targetModified")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")
        machine.succeed("systemctl is-active test-service.service")  # target was not restarted

        # With X-StopOnReconfiguration, the target gets stopped and started
        out = switch_to_specialisation("${machine}", "targetModifiedStopOnReconfig")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")
        machine.fail("systemctl is-active test-service.servce")  # target was restarted

        # Remove the target by switching to the old specialisation
        out = switch_to_specialisation("${machine}", "timerModified")
        assert_contains(out, "stopping the following units: test-target.target\n")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_contains(out, "the following new units were started: test-timer.timer\n")

    with subtest("paths"):
        out = switch_to_specialisation("${machine}", "path")
        assert_contains(out, "stopping the following units: test-timer.timer\n")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_contains(out, "the following new units were started: test-watch.path\n")
        machine.fail("test -f /testpath-modified")

        # touch the file, unit should be triggered
        machine.succeed("touch /testpath")
        machine.wait_until_succeeds("test -f /testpath-modified")
        machine.succeed("rm /testpath /testpath-modified")
        machine.systemctl("stop test-watch.service")
        switch_to_specialisation("${machine}", "pathModified")
        machine.succeed("touch /testpath")
        machine.fail("test -f /testpath-modified")
        machine.succeed("touch /testpath2")
        machine.wait_until_succeeds("test -f /testpath-modified")

    # This test ensures that changes to slice configuration get applied.
    # We test this by having a slice that allows no memory allocation at
    # all and starting a service within it. If the service crashes, the slice
    # is applied and if we modify the slice to allow memory allocation, the
    # service should successfully start.
    with subtest("slices"):
        machine.succeed("echo 0 > /proc/sys/vm/panic_on_oom")  # allow OOMing
        out = switch_to_specialisation("${machine}", "slice")
        # assert_lacks(out, "stopping the following units:") not relevant
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")
        machine.fail("systemctl start testservice.service")

        out = switch_to_specialisation("${machine}", "sliceModified")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "NOT restarting the following changed units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "\nrestarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")
        machine.succeed("systemctl start testservice.service")
        machine.succeed("echo 1 > /proc/sys/vm/panic_on_oom")  # disallow OOMing
  '';
})

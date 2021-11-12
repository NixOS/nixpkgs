# Test configuration switching.

import ./make-test-python.nix ({ pkgs, ...} : {
  name = "switch-test";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ gleber ];
  };

  nodes = {
    machine = { config, pkgs, lib, ... }: {
      environment.systemPackages = [ pkgs.socat ]; # for the socket activation stuff
      users.mutableUsers = false;

      specialisation = {
        # A system with a simple socket-activated unit
        simple-socket.configuration = {
          systemd.services.socket-activated.serviceConfig = {
            ExecStart = pkgs.writeScript "socket-test.py" /* python */ ''
              #!${pkgs.python3}/bin/python3

              from socketserver import TCPServer, StreamRequestHandler
              import socket

              class Handler(StreamRequestHandler):
                  def handle(self):
                      self.wfile.write("hello".encode("utf-8"))

              class Server(TCPServer):
                  def __init__(self, server_address, handler_cls):
                      # Invoke base but omit bind/listen steps (performed by systemd activation!)
                      TCPServer.__init__(
                          self, server_address, handler_cls, bind_and_activate=False)
                      # Override socket
                      self.socket = socket.fromfd(3, self.address_family, self.socket_type)

              if __name__ == "__main__":
                  server = Server(("localhost", 1234), Handler)
                  server.serve_forever()
            '';
          };
          systemd.sockets.socket-activated = {
            wantedBy = [ "sockets.target" ];
            listenStreams = [ "/run/test.sock" ];
            socketConfig.SocketMode = lib.mkDefault "0777";
          };
        };

        # The same system but the socket is modified
        modified-socket.configuration = {
          imports = [ config.specialisation.simple-socket.configuration ];
          systemd.sockets.socket-activated.socketConfig.SocketMode = "0666";
        };

        # The same system but the service is modified
        modified-service.configuration = {
          imports = [ config.specialisation.simple-socket.configuration ];
          systemd.services.socket-activated.serviceConfig.X-Test = "test";
        };

        # The same system but both service and socket are modified
        modified-service-and-socket.configuration = {
          imports = [ config.specialisation.simple-socket.configuration ];
          systemd.services.socket-activated.serviceConfig.X-Test = "some_value";
          systemd.sockets.socket-activated.socketConfig.SocketMode = "0444";
        };

        # A system with a socket-activated service and some simple services
        service-and-socket.configuration = {
          imports = [ config.specialisation.simple-socket.configuration ];
          systemd.services.simple-service = {
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${pkgs.coreutils}/bin/true";
            };
          };

          systemd.services.simple-restart-service = {
            stopIfChanged = false;
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${pkgs.coreutils}/bin/true";
            };
          };

          systemd.services.simple-reload-service = {
            reloadIfChanged = true;
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${pkgs.coreutils}/bin/true";
              ExecReload = "${pkgs.coreutils}/bin/true";
            };
          };

          systemd.services.no-restart-service = {
            restartIfChanged = false;
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${pkgs.coreutils}/bin/true";
            };
          };
        };

        # The same system but with an activation script that restarts all services
        restart-and-reload-by-activation-script.configuration = {
          imports = [ config.specialisation.service-and-socket.configuration ];
          system.activationScripts.restart-and-reload-test = {
            supportsDryActivation = true;
            deps = [];
            text = ''
              if [ "$NIXOS_ACTION" = dry-activate ]; then
                f=/run/nixos/dry-activation-restart-list
              else
                f=/run/nixos/activation-restart-list
              fi
              cat <<EOF >> "$f"
              simple-service.service
              simple-restart-service.service
              simple-reload-service.service
              no-restart-service.service
              socket-activated.service
              EOF
            '';
          };
        };

        # A system with a timer
        with-timer.configuration = {
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

        # The same system but with another time
        with-timer-modified.configuration = {
          imports = [ config.specialisation.with-timer.configuration ];
          systemd.timers.test-timer.timerConfig.OnCalendar = lib.mkForce "Fri 2012-11-23 16:00:00";
        };

        # A system with a systemd mount
        with-mount.configuration = {
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

        # The same system but with another time
        with-mount-modified.configuration = {
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

        # A system with a path unit
        with-path.configuration = {
          systemd.paths.test-watch = {
            wantedBy = [ "paths.target" ];
            pathConfig.PathExists = "/testpath";
          };
          systemd.services.test-watch = {
            serviceConfig = {
              Type = "oneshot";
              ExecStart = "${pkgs.coreutils}/bin/touch /testpath-modified";
            };
          };
        };

        # The same system but watching another file
        with-path-modified.configuration = {
          imports = [ config.specialisation.with-path.configuration ];
          systemd.paths.test-watch.pathConfig.PathExists = lib.mkForce "/testpath2";
        };

        # A system with a slice
        with-slice.configuration = {
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

        # The same system but the slice allows to allocate memory
        with-slice-non-crashing.configuration = {
          imports = [ config.specialisation.with-slice.configuration ];
          systemd.slices.testslice.sliceConfig.MemoryMax = lib.mkForce null;
        };
      };
    };
    other = { ... }: {
      users.mutableUsers = true;
    };
  };

  testScript = { nodes, ... }: let
    originalSystem = nodes.machine.config.system.build.toplevel;
    otherSystem = nodes.other.config.system.build.toplevel;

    # Ensures failures pass through using pipefail, otherwise failing to
    # switch-to-configuration is hidden by the success of `tee`.
    stderrRunner = pkgs.writeScript "stderr-runner" ''
      #! ${pkgs.runtimeShell}
      set -e
      set -o pipefail
      exec env -i "$@" | tee /dev/stderr
    '';
  in /* python */ ''
    def switch_to_specialisation(name, action="test"):
        out = machine.succeed(f"${originalSystem}/specialisation/{name}/bin/switch-to-configuration {action} 2>&1")
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


    machine.succeed(
        "${stderrRunner} ${originalSystem}/bin/switch-to-configuration test"
    )
    machine.succeed(
        "${stderrRunner} ${otherSystem}/bin/switch-to-configuration test"
    )

    with subtest("systemd sockets"):
        machine.succeed("${originalSystem}/bin/switch-to-configuration test")

        # Simple socket is created
        out = switch_to_specialisation("simple-socket")
        assert_lacks(out, "stopping the following units:")
        # not checking for reload because dbus gets reloaded
        assert_lacks(out, "restarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_contains(out, "the following new units were started: socket-activated.socket\n")
        assert_lacks(out, "as well:")
        machine.succeed("[ $(stat -c%a /run/test.sock) = 777 ]")

        # Changing the socket restarts it
        out = switch_to_specialisation("modified-socket")
        assert_lacks(out, "stopping the following units:")
        #assert_lacks(out, "reloading the following units:")
        assert_contains(out, "restarting the following units: socket-activated.socket\n")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")
        assert_lacks(out, "as well:")
        machine.succeed("[ $(stat -c%a /run/test.sock) = 666 ]")  # change was applied

        # The unit is properly activated when the socket is accessed
        if machine.succeed("socat - UNIX-CONNECT:/run/test.sock") != "hello":
            raise Exception("Socket was not properly activated")

        # Changing the socket restarts it and ignores the active service
        out = switch_to_specialisation("simple-socket")
        assert_contains(out, "stopping the following units: socket-activated.service\n")
        assert_lacks(out, "reloading the following units:")
        assert_contains(out, "restarting the following units: socket-activated.socket\n")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")
        assert_lacks(out, "as well:")
        machine.succeed("[ $(stat -c%a /run/test.sock) = 777 ]")  # change was applied

        # Changing the service does nothing when the service is not active
        out = switch_to_specialisation("modified-service")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "restarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")
        assert_lacks(out, "as well:")

        # Activating the service and modifying it stops it but leaves the socket untouched
        machine.succeed("socat - UNIX-CONNECT:/run/test.sock")
        out = switch_to_specialisation("simple-socket")
        assert_contains(out, "stopping the following units: socket-activated.service\n")
        assert_lacks(out, "reloading the following units:")
        assert_lacks(out, "restarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")
        assert_lacks(out, "as well:")

        # Activating the service and both the service and the socket stops the service and restarts the socket
        machine.succeed("socat - UNIX-CONNECT:/run/test.sock")
        out = switch_to_specialisation("modified-service-and-socket")
        assert_contains(out, "stopping the following units: socket-activated.service\n")
        assert_lacks(out, "reloading the following units:")
        assert_contains(out, "restarting the following units: socket-activated.socket\n")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")
        assert_lacks(out, "as well:")

    with subtest("restart and reload by activation file"):
        out = switch_to_specialisation("service-and-socket")
        # Switch to a system where the example services get restarted
        # by the activation script
        out = switch_to_specialisation("restart-and-reload-by-activation-script")
        assert_lacks(out, "stopping the following units:")
        assert_contains(out, "stopping the following units as well: simple-service.service, socket-activated.service\n")
        assert_contains(out, "reloading the following units: simple-reload-service.service\n")
        assert_contains(out, "restarting the following units: simple-restart-service.service\n")
        assert_contains(out, "\nstarting the following units: simple-service.service")

        # The same, but in dry mode
        switch_to_specialisation("service-and-socket")
        out = switch_to_specialisation("restart-and-reload-by-activation-script", action="dry-activate")
        assert_lacks(out, "would stop the following units:")
        assert_contains(out, "would stop the following units as well: simple-service.service, socket-activated.service\n")
        assert_contains(out, "would reload the following units: simple-reload-service.service\n")
        assert_contains(out, "would restart the following units: simple-restart-service.service\n")
        assert_contains(out, "\nwould start the following units: simple-service.service")

    with subtest("mounts"):
        switch_to_specialisation("with-mount")
        out = machine.succeed("mount | grep 'on /testmount'")
        assert_contains(out, "size=1024k")

        out = switch_to_specialisation("with-mount-modified")
        assert_lacks(out, "stopping the following units:")
        assert_contains(out, "reloading the following units: testmount.mount\n")
        assert_lacks(out, "restarting the following units:")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")
        assert_lacks(out, "as well:")
        # It changed
        out = machine.succeed("mount | grep 'on /testmount'")
        assert_contains(out, "size=10240k")

    with subtest("timers"):
        switch_to_specialisation("with-timer")
        out = machine.succeed("systemctl show test-timer.timer")
        assert_contains(out, "OnCalendar=2014-03-25 02:59:56 UTC")

        out = switch_to_specialisation("with-timer-modified")
        assert_lacks(out, "stopping the following units:")
        assert_lacks(out, "reloading the following units:")
        assert_contains(out, "restarting the following units: test-timer.timer\n")
        assert_lacks(out, "\nstarting the following units:")
        assert_lacks(out, "the following new units were started:")
        assert_lacks(out, "as well:")
        # It changed
        out = machine.succeed("systemctl show test-timer.timer")
        assert_contains(out, "OnCalendar=Fri 2012-11-23 16:00:00")

    with subtest("paths"):
        switch_to_specialisation("with-path")
        machine.fail("test -f /testpath-modified")

        # touch the file, unit should be triggered
        machine.succeed("touch /testpath")
        machine.wait_until_succeeds("test -f /testpath-modified")

        machine.succeed("rm /testpath")
        machine.succeed("rm /testpath-modified")
        switch_to_specialisation("with-path-modified")

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
        out = switch_to_specialisation("with-slice")
        machine.fail("systemctl start testservice.service")
        out = switch_to_specialisation("with-slice-non-crashing")
        machine.succeed("systemctl start testservice.service")
        machine.succeed("echo 1 > /proc/sys/vm/panic_on_oom")  # disallow OOMing

  '';
})

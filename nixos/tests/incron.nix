import ./make-test-python.nix (
  { pkgs, lib, ... }:

  {
    name = "incron";
    meta.maintainers = [ lib.maintainers.aanderse ];

    nodes.machine =
      { ... }:
      {
        services.incron.enable = true;
        services.incron.extraPackages = [ pkgs.coreutils ];
        services.incron.systab = ''
          /test IN_CREATE,IN_MODIFY,IN_CLOSE_WRITE,IN_MOVED_FROM,IN_MOVED_TO echo "$@/$# $%" >> /root/incron.log
        '';

        # ensure the directory to be monitored exists before incron is started
        systemd.tmpfiles.settings.incron-test = {
          "/test".d = { };
        };
      };

    testScript = ''
      start_all()

      machine.wait_for_unit("multi-user.target")
      machine.wait_for_unit("incron.service")

      machine.succeed("test -d /test")
      # create some activity for incron to monitor
      machine.succeed("touch /test/file")
      machine.succeed("echo foo >> /test/file")
      machine.succeed("mv /test/file /root")
      machine.succeed("mv /root/file /test")

      machine.sleep(1)

      # touch /test/file
      machine.succeed("grep '/test/file IN_CREATE' /root/incron.log")

      # echo foo >> /test/file
      machine.succeed("grep '/test/file IN_MODIFY' /root/incron.log")
      machine.succeed("grep '/test/file IN_CLOSE_WRITE' /root/incron.log")

      # mv /test/file /root
      machine.succeed("grep '/test/file IN_MOVED_FROM' /root/incron.log")

      # mv /root/file /test
      machine.succeed("grep '/test/file IN_MOVED_TO' /root/incron.log")

      # ensure something unexpected is not present
      machine.fail("grep 'IN_OPEN' /root/incron.log")
    '';
  }
)

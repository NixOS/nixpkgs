{ lib, ... }:
{
  name = "systemd-capsules";

  meta.maintainers = with lib.maintainers; [ fpletz ];

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.hello ];
      systemd.user.services.alice-sleep = {
        wantedBy = [ "capsule@alice.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.coreutils}/bin/sleep 999";
        };
      };
    };

  testScript = # python
    ''
      machine.wait_for_unit("multi-user.target")

      with subtest("capsule setup"):
        machine.succeed("systemctl start capsule@alice.service")

      with subtest("imperative user service in capsule"):
        machine.succeed("systemd-run --capsule=alice --unit=sleeptest.service /run/current-system/sw/bin/sleep 999")
        machine.succeed("systemctl --capsule=alice status sleeptest.service")

      with subtest("declarative user service in capsule"):
        machine.succeed("systemctl --capsule=alice status alice-sleep.service")
        machine.succeed("systemctl --capsule=alice stop alice-sleep.service")
        machine.fail("systemctl --capsule=alice status alice-sleep.service")
        machine.succeed("systemctl --capsule=alice start alice-sleep.service")
        machine.succeed("systemctl --capsule=alice status alice-sleep.service")

      with subtest("interactive shell with terminal in capsule"):
        hello_output = machine.succeed("systemd-run -t --capsule=alice /run/current-system/sw/bin/bash -i -c 'hello | tee ~/hello'")
        assert hello_output == "Hello, world!\r\n"
        machine.copy_from_vm("/var/lib/capsules/alice/hello")

      with subtest("capsule cleanup"):
        machine.succeed("systemctl --capsule=alice stop sleeptest.service")
        machine.succeed("systemctl stop capsule@alice.service")
        machine.succeed("systemctl clean --all capsule@alice.service")
    '';
}

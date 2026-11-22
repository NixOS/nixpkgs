{ lib, ... }:
{
  name = "bootvine";

  meta.maintainers = with lib.maintainers; [
    tfc
    wvhulle
  ];

  nodes.machine = {
    testing.initrdBackdoor = true;

    # Hold the initrd and stage 2 up until test script can look at it
    boot.initrd.systemd.services.hold-initrd = {
      wantedBy = [ "initrd.target" ];
      before = [ "initrd.target" ];
      unitConfig.DefaultDependencies = false;
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "script 'until [ -e /run/release-initrd ]; do sleep 0.1; done'";
      };
    };
    systemd.services = {
      hold-stage2 = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "script 'until [ -e /run/release-stage2 ]; do sleep 0.1; done'";
        };
      };
      # test script needs its shell while stage 2 is held
      backdoor.before = [ "hold-stage2.service" ];
    };

    services.bootvine = {
      enable = true;
      settings = {
        colors.tree.running-marker = "light-yellow";
        timing.keep-final-frame-for = "500ms";
      };
    };
  };

  testScript = /* python */ ''
    def foreground_terminal():
        return machine.succeed("cat /sys/class/tty/tty0/active").strip()

    def config_file():
        exec_start = machine.succeed("systemctl show -p ExecStart --value bootvine.service")
        t.assertIn("--config", exec_start)
        path = exec_start.split("--config ")[1].split()[0]
        return machine.succeed(f"cat {path}")

    machine.start()

    with subtest("bootvine draws the boot tree in the initrd"):
        machine.wait_for_unit("bootvine.service")
        t.assertIn("light-yellow", config_file())
        # The initrd has no grep, so compare in Python.
        retry(lambda _: foreground_terminal() == "tty12", timeout_seconds=30)
        retry(lambda _: "Initrd" in machine.succeed("cat /dev/vcs12"), timeout_seconds=30)
        machine.screenshot("1-initrd")

    machine.succeed("touch /run/release-initrd")
    machine.switch_root()

    with subtest("bootvine keeps drawing in stage 2"):
        retry(lambda _: "hold-stage2" in machine.succeed("cat /dev/vcs12"), timeout_seconds=30)
        t.assertEqual(foreground_terminal(), "tty12")
        machine.screenshot("2-stage2")

    machine.succeed("touch /run/release-stage2")

    with subtest("bootvine hands the console over in stage 2"):
        machine.wait_for_unit("multi-user.target")
        t.assertIn("light-yellow", config_file())
        machine.fail("test -e /etc/bootvine.toml")
        machine.wait_until_fails("systemctl is-active bootvine.service", timeout=60)
        journal = machine.succeed("journalctl -b -u bootvine -o cat")
        t.assertIn("handing the console over", journal)
        t.assertNotIn("ignoring", journal, "bootvine rejected its configuration")
        t.assertNotEqual(foreground_terminal(), "tty12", "bootvine kept the console")
        machine.wait_until_tty_matches("1", "login: ")
        machine.screenshot("3-handed-over")

    with subtest("bootvine is set up for shutdown"):
        wants = machine.succeed("systemctl show -p Wants --value shutdown.target")
        t.assertIn("bootvine-shutdown.service", wants)
  '';
}

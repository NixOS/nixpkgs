{ lib, ... }:
{
  name = "earlyoom-notify";
  meta = {
    maintainers = with lib.maintainers; [
      oxalica
    ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      # Automatically login on tty1 as a normal user:
      imports = [ ../common/user-account.nix ];
      services.getty.autologinUser = "alice";

      # Limit VM resource usage.
      virtualisation.memorySize = 1024;

      services.earlyoom = {
        enable = true;
        # Use SIGKILL, or `tail` will catch SIGTERM and exit successfully.
        freeMemKillThreshold = 90;
        enableNotifications = true;
      };

      systemd.services.testbloat = {
        description = "Create a lot of memory pressure";
        serviceConfig = {
          OOMScoreAdjust = 1000;
          ExecStart = "${pkgs.coreutils}/bin/tail /dev/zero";
        };
      };

      environment.systemPackages = [ pkgs.mako ];

      programs.sway.enable = true;
      # Automatically configure and start Sway when logging in on tty1:
      programs.bash.loginShellInit = ''
        if [ "$(tty)" = "/dev/tty1" ]; then
          set -e
          install -D /etc/sway/config ~/.config/sway/config
          sway --validate && sway
        fi
      '';

      environment.variables."WLR_RENDERER" = "pixman";
    };

  testScript =
    { nodes, ... }:
    let
      sudo = "sudo -u alice XDG_RUNTIME_DIR=/run/user/${toString nodes.machine.users.users.alice.uid} --";
    in
    ''
      import json

      machine.wait_for_unit("earlyoom.service")
      # NB. Don't use `wait_for_unit` because it will fail with no pending jobs
      # before sway starting the systemdtarget.
      machine.wait_until_succeeds("${sudo} systemctl --user is-active graphical-session.target")

      with subtest("should have plenty free memory before the test"):
        memoryStatStr = machine.succeed("cat /proc/meminfo")
        print(memoryStatStr)
        memoryStat = dict(line.split()[:2] for line in memoryStatStr.splitlines())
        assert float(memoryStat["MemFree:"]) / float(memoryStat["MemTotal:"]) > 0.5

      with subtest("earlyoom should kill the bad service"):
          machine.fail("systemctl start --wait testbloat.service")
          assert machine.get_unit_info("testbloat.service")["Result"] == "signal"
          output = machine.succeed('journalctl -u earlyoom.service -b0')
          assert 'low memory! at or below SIGKILL limits' in output

      with subtest("mako should get a notification"):
        def hasOOMNotification(_last_try):
          ret = json.loads(machine.succeed("${sudo} makoctl list"))
          return any(
            "Low memory! Killing process" in n["body"]["data"] \
            for ns in ret["data"] \
            for n in ns);
        retry(hasOOMNotification)

      machine.screenshot("got-oom-notification")
    '';
}

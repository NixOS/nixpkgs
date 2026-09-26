{ pkgs, lib, ... }:

{
  name = "lxqt";

  meta.maintainers = lib.teams.lxqt.members ++ [ lib.maintainers.bobby285271 ];

  nodes.machine =
    { ... }:

    {
      imports = [ ./common/user-account.nix ];

      services.xserver.enable = true;
      services.xserver.desktopManager.lxqt.enable = true;

      services.displayManager = {
        sddm.enable = true;
        defaultSession = "lxqt";
        autoLogin = {
          enable = true;
          user = "alice";
        };
      };
    };

  enableOCR = true;

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
    in
    ''
      machine.wait_for_unit("display-manager.service")

      with subtest("Wait for login"):
          machine.wait_for_x()
          machine.wait_for_file("/tmp/xauth_*")
          machine.wait_until_succeeds("test -s /tmp/xauth_*")
          machine.succeed("xauth merge /tmp/xauth_*")
          machine.succeed("su - ${user.name} -c 'xauth merge /tmp/xauth_*'")

      with subtest("Check that logging in has given the user ownership of devices"):
          # Change back to /dev/snd/timer after systemd-258.1
          machine.succeed("getfacl -p /dev/dri/card0 | grep -q ${user.name}")

      with subtest("Check if LXQt components actually start"):
          for i in ["openbox", "lxqt-session", "pcmanfm-qt", "lxqt-panel", "lxqt-runner"]:
              machine.wait_until_succeeds(f"pgrep {i}")
          machine.wait_for_window("pcmanfm-desktop0")
          machine.wait_for_window("lxqt-panel")
          machine.wait_for_text("(Computer|Network|Trash)")

      with subtest("Open QTerminal"):
          machine.succeed("su - ${user.name} -c 'DISPLAY=:0 qterminal >&2 &'")
          machine.wait_until_succeeds("pgrep qterminal")
          machine.wait_for_window("${user.name}@machine: ~")

      with subtest("Open PCManFM-Qt"):
          machine.succeed("mkdir -p /tmp/test/test")
          machine.succeed("su - ${user.name} -c 'DISPLAY=:0 QT_SCALE_FACTOR=2 pcmanfm-qt /tmp/test >&2 &'")
          machine.wait_for_window("test")
          machine.wait_for_text("(test|Bookmarks|Reload)")

      with subtest("Check if various environment variables are set"):
          cmd = "xargs --null --max-args=1 echo < /proc/$(pgrep -xf /run/current-system/sw/bin/lxqt-panel)/environ"
          machine.succeed(f"{cmd} | grep 'XDG_CURRENT_DESKTOP=LXQt'")
          machine.succeed(f"{cmd} | grep 'QT_PLATFORM_PLUGIN=lxqt'")
          # From login shell.
          machine.succeed(f"{cmd} | grep '__NIXOS_SET_ENVIRONMENT_DONE=1'")
          # See the nixos/lxqt module.
          machine.succeed(f"{cmd} | grep 'XDG_CONFIG_DIRS' | grep '${nodes.machine.system.path}'")

      with subtest("Check if any coredumps are found"):
          machine.succeed("(coredumpctl --json=short 2>&1 || true) | grep 'No coredumps found'")
          machine.sleep(10)
          machine.screenshot("screen")
    '';
}

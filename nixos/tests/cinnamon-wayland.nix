{ pkgs, lib, ... }:
{
  name = "cinnamon-wayland";

  meta.maintainers = lib.teams.cinnamon.members;

  nodes.machine =
    { nodes, ... }:
    {
      imports = [ ./common/user-account.nix ];
      services.xserver.enable = true;
      services.xserver.desktopManager.cinnamon.enable = true;
      services.displayManager = {
        autoLogin.enable = true;
        autoLogin.user = nodes.machine.users.users.alice.name;
        defaultSession = "cinnamon-wayland";
      };

      # For the sessionPath subtest.
      services.xserver.desktopManager.cinnamon.sessionPath = [ pkgs.gpaste ];
    };

  enableOCR = true;

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
      env = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${toString user.uid}/bus";
      su = command: "su - ${user.name} -c '${env} ${command}'";

      # Call javascript in cinnamon (the shell), returns a tuple (success, output),
      # where `success` is true if the dbus call was successful and `output` is what
      # the javascript evaluates to.
      eval =
        name: su "gdbus call --session -d org.Cinnamon -o /org/Cinnamon -m org.Cinnamon.Eval ${name}";
    in
    ''
      machine.wait_for_unit("display-manager.service")

      with subtest("Wait for wayland server"):
          machine.wait_for_file("/run/user/${toString user.uid}/wayland-0")

      with subtest("Check that logging in has given the user ownership of devices"):
          machine.succeed("getfacl -p /dev/snd/timer | grep -q ${user.name}")

      with subtest("Wait for the Cinnamon shell"):
          # Correct output should be (true, '2')
          # https://github.com/linuxmint/cinnamon/blob/5.4.0/js/ui/main.js#L183-L187
          machine.wait_until_succeeds("${eval "Main.runState"} | grep -q 'true,..2'")

      with subtest("Check if Cinnamon components actually start"):
          for i in ["csd-media-keys", "xapp-sn-watcher", "nemo-desktop"]:
            machine.wait_until_succeeds(f"pgrep -f {i}")
          machine.wait_until_succeeds("journalctl -b --grep 'Loaded applet menu@cinnamon.org'")
          machine.wait_until_succeeds("journalctl -b --grep 'calendar@cinnamon.org: Calendar events supported'")

      with subtest("Check if sessionPath option actually works"):
          machine.succeed("${eval "imports.gi.GIRepository.Repository.get_search_path\\(\\)"} | grep gpaste")

      with subtest("Check if various environment variables are set"):
          cmd = "xargs --null --max-args=1 echo < /proc/$(pgrep -xf /run/current-system/sw/bin/nemo-desktop)/environ"
          machine.succeed(f"{cmd} | grep 'XDG_SESSION_TYPE' | grep 'wayland'")
          machine.succeed(f"{cmd} | grep '__NIXOS_SET_ENVIRONMENT_DONE' | grep '1'")
          # From the nixos/cinnamon module
          machine.succeed(f"{cmd} | grep 'SSH_AUTH_SOCK' | grep 'gcr'")

      with subtest("Open Cinnamon Settings"):
          machine.succeed("${su "cinnamon-settings themes >&2 &"}")
          machine.wait_until_succeeds("${eval "global.display.focus_window.wm_class"} | grep -i 'cinnamon-settings'")
          machine.wait_for_text('(Style|Appearance|Color)')
          machine.sleep(2)
          machine.screenshot("cinnamon_settings")

      with subtest("Check if screensaver works"):
          # This is not supported at the moment.
          # https://trello.com/b/HHs01Pab/cinnamon-wayland
          machine.execute("${su "cinnamon-screensaver-command -l >&2 &"}")
          machine.wait_until_succeeds("journalctl -b --grep 'cinnamon-screensaver is disabled in wayland sessions'")

      with subtest("Open GNOME Terminal"):
          machine.succeed("${su "dbus-launch gnome-terminal"}")
          machine.wait_until_succeeds("${eval "global.display.focus_window.wm_class"} | grep -i 'gnome-terminal'")
          machine.sleep(2)

      with subtest("Check if Cinnamon has ever coredumped"):
          machine.fail("coredumpctl --json=short | grep -E 'cinnamon|nemo'")
    '';
}

{ pkgs, ... }:
{
  name = "display-managers";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [
        ./common/user-account.nix
      ];

      services = {
        xserver = {
          enable = true;
          windowManager.icewm.enable = true;
          displayManager.lightdm.enable = true;
        };
        displayManager = {
          enable = true;
          autoLogin.user = "alice";
          defaultSession = "none+icewm";
        };
      };

      systemd.services."give-alice-an-xprofile" = {
        description = "Write out Alice's .xprofile before x11 starts";
        wantedBy = [ "graphical.target" ];
        before = [ "display-manager.service" ];
        serviceConfig = {
          User = "alice";
          Type = "oneshot";
        };
        script = ''
          printf "%s\n" "echo xprofile has been executed once | ${pkgs.systemd}/bin/systemd-cat -p crit" > ~alice/.xprofile
        '';
      };
    };

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
    in
    ''
      start_all()
      machine.wait_for_x()

      machine.wait_for_file("${user.home}/.Xauthority")
      machine.succeed("xauth merge ${user.home}/.Xauthority")

      machine.wait_for_window("^IceWM ")

      # Look for our xprofile sentinel message in the logs
      our_sentinel = "xprofile has been executed once"
      log_contents = machine.succeed(f"journalctl --no-pager --boot --grep='{our_sentinel}'").strip()

      # Do we have multiple lines in here?
      num_lines = sum(1 for line in log_contents.split("\n")
                      if our_sentinel in line)

      assert num_lines != 0, "xprofile doesn't appear to have run"  # should result in command above failing anyway, but can't hurt to check
      assert num_lines == 1, "xprofile appears to have run multiple times"
    '';
}

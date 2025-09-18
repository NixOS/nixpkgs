{ pkgs, ... }:
{
  name = "wmderland";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ takagiy ];
  };

  nodes.machine =
    { lib, ... }:
    {
      imports = [
        ./common/x11.nix
        ./common/user-account.nix
      ];
      test-support.displayManager.auto.user = "alice";
      services.displayManager.defaultSession = lib.mkForce "none+wmderland";
      services.xserver.windowManager.wmderland.enable = true;

      systemd.services.setupWmderlandConfig = {
        wantedBy = [ "multi-user.target" ];
        before = [ "multi-user.target" ];
        environment = {
          HOME = "/home/alice";
        };
        unitConfig = {
          type = "oneshot";
          RemainAfterExit = true;
          user = "alice";
        };
        script =
          let
            config = pkgs.writeText "config" ''
              set $Mod = Mod1
              bindsym $Mod+Return exec ${pkgs.xterm}/bin/xterm -cm -pc
            '';
          in
          ''
            mkdir -p $HOME/.config/wmderland
            cp ${config} $HOME/.config/wmderland/config
          '';
      };
    };

  testScript =
    { ... }:
    ''
      with subtest("ensure x starts"):
          machine.wait_for_x()
          machine.wait_for_file("/home/alice/.Xauthority")
          machine.succeed("xauth merge ~alice/.Xauthority")

      with subtest("ensure we can open a new terminal"):
          machine.send_key("alt-ret")
          machine.wait_until_succeeds("pgrep xterm")
          machine.wait_for_window(r"alice.*?machine")
          machine.screenshot("terminal")

      with subtest("ensure we can communicate through ipc with wmderlandc"):
          # Kills the previously open xterm
          machine.succeed("pgrep xterm")
          machine.execute("DISPLAY=:0 wmderlandc kill")
          machine.fail("pgrep xterm")
    '';
}

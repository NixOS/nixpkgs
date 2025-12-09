{ pkgs, ... }:

{
  name = "retroarch";
  meta = with pkgs.lib; {
    maintainers = teams.libretro.members ++ [ maintainers.j0hax ];
  };

  nodes.machine =
    { ... }:

    {
      imports = [ ./common/user-account.nix ];
      services.xserver.enable = true;
      services.xserver.desktopManager.retroarch = {
        enable = true;
        package = pkgs.retroarch-bare;
      };
      services.displayManager = {
        sddm.enable = true;
        defaultSession = "RetroArch";
        autoLogin = {
          enable = true;
          user = "alice";
        };
      };
    };

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
      xdo = "${pkgs.xdotool}/bin/xdotool";
    in
    ''
      with subtest("Wait for login"):
          start_all()
          machine.wait_for_file("/run/sddm/xauth_*")
          machine.wait_until_succeeds("test -s /run/sddm/xauth_*")
          machine.succeed("xauth merge /run/sddm/xauth_*")

      with subtest("Check RetroArch started"):
          machine.wait_until_succeeds("pgrep retroarch")
          machine.wait_for_window("^RetroArch")

      with subtest("Check configuration created"):
          machine.wait_for_file("${user.home}/.config/retroarch/retroarch.cfg")

      with subtest("Wait to get a screenshot"):
          machine.execute(
              "${xdo} key Alt+F1 sleep 10"
          )
          machine.screenshot("screen")
    '';
}

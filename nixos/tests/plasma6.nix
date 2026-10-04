{ pkgs, ... }:

{
  name = "plasma6";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ k900 ];
  };

  nodes.machine =
    { ... }:

    {
      imports = [ ./common/user-account.nix ];
      services.xserver.enable = true;
      services.displayManager.plasma-login-manager.enable = true;
      services.desktopManager.plasma6.enable = true;
      environment.plasma6.excludePackages = [ pkgs.kdePackages.elisa ];
      services.displayManager.autoLogin = {
        enable = true;
        user = "alice";
      };
    };

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
    in
    ''
      with subtest("Wait for login"):
          start_all()

      with subtest("Check plasmashell started"):
          machine.wait_until_succeeds("pgrep plasmashell")

      with subtest("Check that KDED is running"):
          machine.succeed("pgrep kded6")

      with subtest("Ensure Elisa is not installed"):
          machine.fail("which elisa")

      with subtest("Run Dolphin"):
          machine.execute("su - ${user.name} -c 'WAYLAND_DISPLAY=/run/user/1000/wayland-0 dolphin >&2 &'")

      with subtest("Run Konsole"):
          machine.execute("su - ${user.name} -c 'WAYLAND_DISPLAY=/run/user/1000/wayland-0 konsole >&2 &'")

      with subtest("Run systemsettings"):
          machine.execute("su - ${user.name} -c 'WAYLAND_DISPLAY=/run/user/1000/wayland-0 systemsettings >&2 &'")

      with subtest("Wait to get a screenshot"):
          machine.screenshot("screen")
    '';
}

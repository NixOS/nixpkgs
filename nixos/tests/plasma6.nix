import ./make-test-python.nix ({ pkgs, ...} :

{
  name = "plasma6";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ k900 ];
  };

  nodes.machine = { ... }:

  {
    imports = [ ./common/user-account.nix ];
    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    # FIXME: this should be testing Wayland
    services.displayManager.defaultSession = "plasmax11";
    services.desktopManager.plasma6.enable = true;
    environment.plasma6.excludePackages = [ pkgs.kdePackages.elisa ];
    services.displayManager.autoLogin = {
      enable = true;
      user = "alice";
    };
  };

  testScript = { nodes, ... }: let
    user = nodes.machine.users.users.alice;
    xdo = "${pkgs.xdotool}/bin/xdotool";
  in ''
    with subtest("Wait for login"):
        start_all()
        machine.wait_for_file("/tmp/xauth_*")
        machine.succeed("xauth merge /tmp/xauth_*")

    with subtest("Check plasmashell started"):
        machine.wait_until_succeeds("pgrep plasmashell")
        machine.wait_for_window("^Desktop ")

    with subtest("Check that KDED is running"):
        machine.succeed("pgrep kded6")

    with subtest("Ensure Elisa is not installed"):
        machine.fail("which elisa")

    machine.succeed("su - ${user.name} -c 'xauth merge /tmp/xauth_*'")

    with subtest("Run Dolphin"):
        machine.execute("su - ${user.name} -c 'DISPLAY=:0.0 dolphin >&2 &'")
        machine.wait_for_window(" Dolphin")

    with subtest("Run Konsole"):
        machine.execute("su - ${user.name} -c 'DISPLAY=:0.0 konsole >&2 &'")
        machine.wait_for_window("Konsole")

    with subtest("Run systemsettings"):
        machine.execute("su - ${user.name} -c 'DISPLAY=:0.0 systemsettings >&2 &'")
        machine.wait_for_window("Settings")

    with subtest("Wait to get a screenshot"):
        machine.execute(
            "${xdo} key Alt+F1 sleep 10"
        )
        machine.screenshot("screen")
  '';
})

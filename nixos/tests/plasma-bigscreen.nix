import ./make-test-python.nix ({ pkgs, ...} :

{
  name = "plasma-bigscreen";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ttuegel k900 ];
  };

  nodes.machine = { ... }:

  {
    imports = [ ./common/user-account.nix ];
    services.xserver.enable = true;
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.displayManager.defaultSession = "plasma-bigscreen-x11";
    services.xserver.desktopManager.plasma5.bigscreen.enable = true;
    services.xserver.displayManager.autoLogin = {
      enable = true;
      user = "alice";
    };

    users.users.alice.extraGroups = ["uinput"];
  };

  testScript = { nodes, ... }: let
    user = nodes.machine.users.users.alice;
    xdo = "${pkgs.xdotool}/bin/xdotool";
  in ''
    with subtest("Wait for login"):
        start_all()
        machine.wait_for_file("${user.home}/.Xauthority")
        machine.succeed("xauth merge ${user.home}/.Xauthority")

    with subtest("Check plasmashell started"):
        machine.wait_until_succeeds("pgrep plasmashell")
        machine.wait_for_window("Plasma Big Screen")
  '';
})

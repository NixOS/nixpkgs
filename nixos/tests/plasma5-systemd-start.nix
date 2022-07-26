import ./make-test-python.nix ({ pkgs, ...} :

{
  name = "plasma5-systemd-start";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ oxalica ];
  };

  nodes.machine = { ... }:

  {
    imports = [ ./common/user-account.nix ];
    services.xserver = {
      enable = true;
      displayManager.sddm.enable = true;
      displayManager.defaultSession = "plasma";
      desktopManager.plasma5.enable = true;
      desktopManager.plasma5.runUsingSystemd = true;
      displayManager.autoLogin = {
        enable = true;
        user = "alice";
      };
    };
  };

  testScript = { nodes, ... }: let
    user = nodes.machine.config.users.users.alice;
  in ''
    with subtest("Wait for login"):
        start_all()
        machine.wait_for_file("${user.home}/.Xauthority")
        machine.succeed("xauth merge ${user.home}/.Xauthority")

    with subtest("Check plasmashell started"):
        machine.wait_until_succeeds("pgrep plasmashell")
        machine.wait_for_window("^Desktop ")

    status, result = machine.systemctl('--no-pager show plasma-plasmashell.service', user='alice')
    assert status == 0, 'Service not found'
    assert 'ActiveState=active' in result.split('\n'), 'Systemd service not active'
  '';
})

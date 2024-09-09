import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "deepin";

  meta.maintainers = lib.teams.deepin.members;

  nodes.machine = { ... }: {
    imports = [
      ./common/user-account.nix
    ];

    virtualisation.memorySize = 2048;

    services.xserver.enable = true;

    services.xserver.displayManager = {
      lightdm.enable = true;
      autoLogin = {
        enable = true;
        user = "alice";
      };
    };

    services.xserver.desktopManager.deepin.enable = true;
  };

  testScript = { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
    in
    ''
      with subtest("Wait for login"):
          machine.wait_for_x()
          machine.wait_for_file("${user.home}/.Xauthority")
          machine.succeed("xauth merge ${user.home}/.Xauthority")

      with subtest("Check that logging in has given the user ownership of devices"):
          machine.succeed("getfacl -p /dev/snd/timer | grep -q ${user.name}")

      with subtest("Check if Deepin session components actually start"):
          machine.wait_until_succeeds("pgrep -f dde-session-daemon")
          machine.wait_for_window("dde-session-daemon")
          machine.wait_until_succeeds("pgrep -f dde-desktop")
          machine.wait_for_window("dde-desktop")

      with subtest("Open deepin-terminal"):
          machine.succeed("su - ${user.name} -c 'DISPLAY=:0 deepin-terminal >&2 &'")
          machine.wait_for_window("deepin-terminal")
          machine.sleep(20)
          machine.screenshot("screen")
    '';
})

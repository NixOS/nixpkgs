import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "budgie";

  meta = with lib; {
    maintainers = [ maintainers.federicoschonborn ];
  };

  nodes.machine = { ... }: {
    imports = [
      ./common/user-account.nix
    ];

    services.xserver.enable = true;

    services.xserver.displayManager = {
      lightdm.enable = true;
      autoLogin = {
        enable = true;
        user = "alice";
      };
    };

    services.xserver.desktopManager.budgie = {
      enable = true;
      extraPlugins = [
        pkgs.budgie.budgie-analogue-clock-applet
      ];
    };
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

      with subtest("Check if Budgie session components actually start"):
          machine.wait_until_succeeds("pgrep budgie-daemon")
          machine.wait_for_window("budgie-daemon")
          machine.wait_until_succeeds("pgrep budgie-panel")
          machine.wait_for_window("budgie-panel")

      with subtest("Open MATE terminal"):
          machine.succeed("su - ${user.name} -c 'DISPLAY=:0 mate-terminal >&2 &'")
          machine.wait_for_window("Terminal")
          machine.sleep(20)
          machine.screenshot("screen")
    '';
})

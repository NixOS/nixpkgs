import ./make-test-python.nix ({ pkgs, ...} :

{
  name = "plasma5";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ ttuegel ];
  };

  machine = { ... }:

  {
    imports = [ ./common/user-account.nix ];
    services.xserver.enable = true;
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.displayManager.defaultSession = "plasma5";
    services.xserver.desktopManager.plasma5.enable = true;
    services.xserver.displayManager.sddm.autoLogin = {
      enable = true;
      user = "alice";
    };
    hardware.pulseaudio.enable = true; # needed for the factl test, /dev/snd/* exists without them but udev doesn't care then
    virtualisation.memorySize = 1024;
  };

  testScript = { nodes, ... }: let
    user = nodes.machine.config.users.users.alice;
    xdo = "${pkgs.xdotool}/bin/xdotool";
  in ''
    with subtest("Wait for login"):
        start_all()
        machine.wait_for_file("${user.home}/.Xauthority")
        machine.succeed("xauth merge ${user.home}/.Xauthority")

    with subtest("Check plasmashell started"):
        machine.wait_until_succeeds("pgrep plasmashell")
        machine.wait_for_window("^Desktop ")

    with subtest("Check that logging in has given the user ownership of devices"):
        machine.succeed("getfacl -p /dev/snd/timer | grep -q ${user.name}")

    with subtest("Run Dolphin"):
        machine.execute("su - ${user.name} -c 'DISPLAY=:0.0 dolphin &'")
        machine.wait_for_window(" Dolphin")

    with subtest("Run Konsole"):
        machine.execute("su - ${user.name} -c 'DISPLAY=:0.0 konsole &'")
        machine.wait_for_window("Konsole")

    with subtest("Run systemsettings"):
        machine.execute("su - ${user.name} -c 'DISPLAY=:0.0 systemsettings5 &'")
        machine.wait_for_window("Settings")

    with subtest("Wait to get a screenshot"):
        machine.execute(
            "${xdo} key Alt+F1 sleep 10"
        )
        machine.screenshot("screen")
  '';
})

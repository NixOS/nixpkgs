import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "mate";

  meta = {
    maintainers = lib.teams.mate.members;
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

    services.xserver.desktopManager.mate.enable = true;

    # Silence log spam due to no sound drivers loaded:
    # ALSA lib confmisc.c:855:(parse_card) cannot find card '0'
    hardware.pulseaudio.enable = true;
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

      with subtest("Check if MATE session components actually start"):
          machine.wait_until_succeeds("pgrep marco")
          machine.wait_for_window("marco")
          machine.wait_until_succeeds("pgrep mate-panel")
          machine.wait_for_window("Top Panel")
          machine.wait_for_window("Bottom Panel")
          machine.wait_until_succeeds("pgrep caja")
          machine.wait_for_window("Caja")

      with subtest("Open MATE terminal"):
          machine.succeed("su - ${user.name} -c 'DISPLAY=:0.0 mate-terminal >&2 &'")
          machine.wait_for_window("Terminal")
          machine.sleep(20)
          machine.screenshot("screen")
    '';
})

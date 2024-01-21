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

  enableOCR = true;

  testScript = { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
      env = "DISPLAY=:0.0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${toString user.uid}/bus";
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
          machine.wait_for_text('(Applications|Places|System)')
          machine.wait_for_text('(Computer|Home|Trash)')

      with subtest("Lock the screen"):
          machine.wait_until_succeeds("su - ${user.name} -c '${env} mate-screensaver-command -q' | grep 'The screensaver is inactive'")
          machine.succeed("su - ${user.name} -c '${env} mate-screensaver-command -l >&2 &'")
          machine.wait_until_succeeds("su - ${user.name} -c '${env} mate-screensaver-command -q' | grep 'The screensaver is active'")
          machine.sleep(2)
          machine.send_chars("${user.password}", delay=0.2)
          machine.wait_for_text("${user.description}")
          machine.screenshot("screensaver")
          machine.send_chars("\n")
          machine.wait_until_succeeds("su - ${user.name} -c '${env} mate-screensaver-command -q' | grep 'The screensaver is inactive'")

      with subtest("Open MATE control center"):
          machine.succeed("su - ${user.name} -c '${env} mate-control-center >&2 &'")
          machine.wait_for_window("Control Center")
          machine.wait_for_text('(Groups|Administration|Hardware)')

      with subtest("Open MATE terminal"):
          machine.succeed("su - ${user.name} -c '${env} mate-terminal >&2 &'")
          machine.wait_for_window("Terminal")

      with subtest("Check if MATE has ever coredumped"):
          machine.fail("coredumpctl --json=short | grep -E 'mate|marco|caja'")
          machine.screenshot("screen")
    '';
})

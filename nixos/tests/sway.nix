import ./make-test-python.nix ({ pkgs, lib, ...} :

{
  name = "sway";
  meta = {
    maintainers = with lib.maintainers; [ primeos synthetica ];
  };

  machine = { config, ... }: {
    # Automatically login on tty1 as a normal user:
    imports = [ ./common/user-account.nix ];
    services.getty.autologinUser = "alice";

    environment = {
      # For glinfo and wayland-info:
      systemPackages = with pkgs; [ mesa-demos wayland-utils ];
      # Use a fixed SWAYSOCK path (for swaymsg):
      variables = {
        "SWAYSOCK" = "/tmp/sway-ipc.sock";
        "WLR_RENDERER_ALLOW_SOFTWARE" = "1";
      };
      # For convenience:
      shellAliases = {
        test-x11 = "glinfo | head -n 3 | tee /tmp/test-x11.out && touch /tmp/test-x11-exit-ok";
        test-wayland = "wayland-info | tee /tmp/test-wayland.out && touch /tmp/test-wayland-exit-ok";
      };
    };

    # Automatically configure and start Sway when logging in on tty1:
    programs.bash.loginShellInit = ''
      if [ "$(tty)" = "/dev/tty1" ]; then
        set -e

        mkdir -p ~/.config/sway
        sed s/Mod4/Mod1/ /etc/sway/config > ~/.config/sway/config

        sway --validate
        sway && touch /tmp/sway-exit-ok
      fi
    '';

    programs.sway.enable = true;

    # To test pinentry via gpg-agent:
    programs.gnupg.agent.enable = true;

    virtualisation.memorySize = 1024;
    # Need to switch to a different GPU driver than the default one (-vga std) so that Sway can launch:
    virtualisation.qemu.options = [ "-vga none -device virtio-gpu-pci" ];
  };

  enableOCR = true;

  testScript = { nodes, ... }: ''
    start_all()
    machine.wait_for_unit("multi-user.target")

    # To check the version:
    print(machine.succeed("sway --version"))

    # Wait for Sway to complete startup:
    machine.wait_for_file("/run/user/1000/wayland-1")
    machine.wait_for_file("/tmp/sway-ipc.sock")

    # Test XWayland:
    machine.succeed(
        "su - alice -c 'swaymsg exec WINIT_UNIX_BACKEND=x11 WAYLAND_DISPLAY=invalid alacritty'"
    )
    machine.wait_for_text("alice@machine")
    machine.send_chars("test-x11\n")
    machine.wait_for_file("/tmp/test-x11-exit-ok")
    print(machine.succeed("cat /tmp/test-x11.out"))
    machine.screenshot("alacritty_glinfo")
    machine.succeed("pkill alacritty")

    # Start a terminal (Alacritty) on workspace 3:
    machine.send_key("alt-3")
    machine.succeed(
        "su - alice -c 'swaymsg exec WINIT_UNIX_BACKEND=wayland DISPLAY=invalid alacritty'"
    )
    machine.wait_for_text("alice@machine")
    machine.send_chars("test-wayland\n")
    machine.wait_for_file("/tmp/test-wayland-exit-ok")
    print(machine.succeed("cat /tmp/test-wayland.out"))
    machine.screenshot("alacritty_wayland_info")
    machine.send_key("alt-shift-q")
    machine.wait_until_fails("pgrep alacritty")

    # Test gpg-agent starting pinentry-gnome3 via D-Bus (tests if
    # $WAYLAND_DISPLAY is correctly imported into the D-Bus user env):
    machine.succeed(
        "su - alice -c 'swaymsg -- exec gpg --no-tty --yes --quick-generate-key test'"
    )
    machine.wait_until_succeeds("pgrep --exact gpg")
    machine.wait_for_text("Passphrase")
    machine.screenshot("gpg_pinentry")
    machine.send_key("alt-shift-q")
    machine.wait_until_fails("pgrep --exact gpg")

    # Test swaynag:
    machine.send_key("alt-shift-e")
    machine.wait_for_text("You pressed the exit shortcut.")
    machine.screenshot("sway_exit")

    # Exit Sway and verify process exit status 0:
    machine.succeed("su - alice -c 'swaymsg exit || true'")
    machine.wait_until_fails("pgrep -x sway")

    # TODO: Sway currently segfaults after "swaymsg exit" but only in this VM test:
    # machine # [  104.090032] sway[921]: segfault at 3f800008 ip 00007f7dbdc25f10 sp 00007ffe282182f8 error 4 in libwayland-server.so.0.1.0[7f7dbdc1f000+8000]
    # machine.wait_for_file("/tmp/sway-exit-ok")
  '';
})

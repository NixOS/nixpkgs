{ pkgs, lib, ... }:
{
  name = "scroll";
  meta = {
    maintainers = with lib.maintainers; [ olimoli ];
  };

  # testScriptWithTypes:49: error: Cannot call function of unknown type
  #           (machine.succeed if succeed else machine.execute)(
  #           ^
  # Found 1 error in 1 file (checked 1 source file)
  skipTypeCheck = true;

  nodes.machine =
    { config, ... }:
    {
      # Automatically login on tty1 as a normal user:
      imports = [ ./common/user-account.nix ];
      services.getty.autologinUser = "alice";

      environment = {
        # For glinfo and wayland-info:
        systemPackages = with pkgs; [
          mesa-demos
          wayland-utils
          alacritty
          foot
          swaylock
        ];
        # Use a fixed SWAYSOCK path (for swaymsg):
        variables = {
          "SWAYSOCK" = "/tmp/scroll-ipc.sock";
          "SCROLLSOCK" = "/tmp/scroll-ipc.sock";
          # TODO: Investigate if we can get hardware acceleration to work (via
          # virtio-gpu and Virgil). We currently have to use the Pixman software
          # renderer since the GLES2 renderer doesn't work inside the VM (even
          # with WLR_RENDERER_ALLOW_SOFTWARE):
          # "WLR_RENDERER_ALLOW_SOFTWARE" = "1";
          "WLR_RENDERER" = "pixman";
        };
        # For convenience:
        shellAliases = {
          test-x11 = "glinfo | tee /tmp/test-x11.out && touch /tmp/test-x11-exit-ok";
          test-wayland = "wayland-info | tee /tmp/test-wayland.out && touch /tmp/test-wayland-exit-ok";
        };

        # To help with OCR:
        etc."xdg/foot/foot.ini".text = lib.generators.toINI { } {
          main = {
            font = "inconsolata:size=14";
          };
          colors = rec {
            foreground = "000000";
            background = "ffffff";
            regular2 = foreground;
          };
        };

        etc."gpg-agent.conf".text = ''
          pinentry-timeout 86400
        '';
      };

      fonts.packages = [ pkgs.inconsolata ];

      # Automatically configure and start scroll when logging in on tty1:
      programs.bash.loginShellInit = ''
        if [ "$(tty)" = "/dev/tty1" ]; then
          set -e

          # Create custom minimal config to prevent conflicts
          # Heredocs wouldn't work for some reason
          mkdir -p ~/.config/scroll
          echo 'bindsym Mod1+3 workspace 3' > ~/.config/scroll/config
          echo 'bindsym Mod1+Return exec foot' >> ~/.config/scroll/config
          echo 'bindsym Mod1+Backspace kill' >> ~/.config/scroll/config
          echo 'bar position top' >> ~/.config/scroll/config
          echo 'include /etc/scroll/config.d/*.conf' >> ~/.config/scroll/config

          scroll --validate
          scroll && touch /tmp/scroll-exit-ok
        fi
      '';

      programs.scroll = {
        enable = true;
        extraPackages = [ ];
      };

      # To test pinentry via gpg-agent:
      programs.gnupg.agent.enable = true;

      # Need to switch to a different GPU driver than the default one (-vga std) so that scroll can launch:
      virtualisation.qemu.options = [ "-vga none -device virtio-gpu-pci" ];
    };

  testScript =
    { nodes, ... }:
    ''
      import shlex
      import json

      q = shlex.quote
      NODE_GROUPS = ["nodes", "floating_nodes"]


      def scrollmsg(command: str = "", succeed=True, type="command"):
          assert command != "" or type != "command", "Must specify command or type"
          shell = q(f"scrollmsg -t {q(type)} -- {q(command)}")
          with machine.nested(
              f"sending scrollmsg {shell!r}" + " (allowed to fail)" * (not succeed)
          ):
              ret = (machine.succeed if succeed else machine.execute)(
                  f"su - alice -c {shell}"
              )

          # execute also returns a status code, but disregard.
          if not succeed:
              _, ret = ret

          if not succeed and not ret:
              return None

          parsed = json.loads(ret)
          return parsed


      def walk(tree):
          yield tree
          for group in NODE_GROUPS:
              for node in tree.get(group, []):
                  yield from walk(node)


      def wait_for_window(pattern):
          def func(last_chance):
              nodes = (
                  node["name"]
                  for node in walk(scrollmsg(type="get_tree"))
                  if node.get("name") is not None
              )

              if last_chance:
                  nodes = list(nodes)
                  machine.log(f"Last call! Current list of windows: {nodes}")

              return any(pattern in name for name in nodes)

          retry(func)

      start_all()
      machine.wait_for_unit("multi-user.target")

      # To check the version:
      print(machine.succeed("scroll --version"))

      # Wait for scroll to complete startup:
      machine.wait_for_file("/run/user/1000/wayland-1")
      machine.wait_for_file("/tmp/scroll-ipc.sock")

      # Test XWayland (foot does not support X):
      scrollmsg("exec WINIT_UNIX_BACKEND=x11 WAYLAND_DISPLAY= alacritty")
      wait_for_window("alice@machine")
      machine.send_chars("test-x11\n")
      machine.wait_for_file("/tmp/test-x11-exit-ok")
      print(machine.succeed("cat /tmp/test-x11.out"))
      machine.copy_from_machine("/tmp/test-x11.out")
      machine.screenshot("alacritty_glinfo")
      machine.succeed("pkill alacritty")

      # Start a terminal (foot) on workspace 3:
      machine.send_key("alt-3")
      machine.sleep(3)
      machine.send_key("alt-ret")
      wait_for_window("alice@machine")
      machine.send_chars("test-wayland\n")
      machine.wait_for_file("/tmp/test-wayland-exit-ok")
      print(machine.succeed("cat /tmp/test-wayland.out"))
      machine.copy_from_machine("/tmp/test-wayland.out")
      machine.screenshot("foot_wayland_info")
      machine.send_key("alt-backspace")
      machine.wait_until_fails("pgrep foot")

      # Test gpg-agent starting pinentry-gnome3 via D-Bus (tests if
      # $WAYLAND_DISPLAY is correctly imported into the D-Bus user env):
      scrollmsg("exec mkdir -p ~/.gnupg")
      scrollmsg("exec cp /etc/gpg-agent.conf ~/.gnupg")

      scrollmsg("exec DISPLAY=INVALID gpg --no-tty --yes --quick-generate-key test", succeed=False)
      machine.wait_until_succeeds("pgrep --exact gpg")
      wait_for_window("gpg")
      machine.succeed("pgrep --exact gpg")
      machine.screenshot("gpg_pinentry")
      machine.send_key("alt-backspace")
      machine.wait_until_fails("pgrep --exact gpg")


      ${lib.optionalString pkgs.stdenv.hostPlatform.isx86_64 ''
        # Test scrollnag:
        # Broken on aarch64-linux, see https://github.com/NixOS/nixpkgs/issues/416217
        def get_height():
            return [node['rect']['height'] for node in walk(scrollmsg(type="get_tree")) if node['focused']][0]

        before = get_height()
        scrollmsg("exec scrollnag -m testing")
        retry(lambda _: get_height() < before)
        machine.screenshot("scroll_exit")
      ''}

      scrollmsg("exec swaylock")
      machine.wait_until_succeeds("pgrep -xf swaylock")
      machine.sleep(3)
      machine.send_chars("${nodes.machine.users.users.alice.password}")
      machine.send_key("ret")
      machine.wait_until_fails("pgrep -xf swaylock")

      # Exit scroll and verify process exit status 0:
      scrollmsg("exit", succeed=False)
      machine.wait_until_fails("pgrep -xf scroll")
      machine.wait_for_file("/tmp/scroll-exit-ok")
    '';
}

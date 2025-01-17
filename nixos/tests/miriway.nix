import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "miriway";

    meta = {
      maintainers = with lib.maintainers; [ OPNA2608 ];
    };

    nodes.machine =
      { config, ... }:
      {
        imports = [
          ./common/auto.nix
          ./common/user-account.nix
        ];

        # Seems to very rarely get interrupted by oom-killer
        virtualisation.memorySize = 2047;

        test-support.displayManager.auto = {
          enable = true;
          user = "alice";
        };

        services.xserver.enable = true;
        services.displayManager.defaultSession = lib.mkForce "miriway";

        programs.miriway = {
          enable = true;
          config = ''
            add-wayland-extensions=all
            enable-x11=

            ctrl-alt=t:foot --maximized
            ctrl-alt=a:env WINIT_UNIX_BACKEND=x11 WAYLAND_DISPLAY= alacritty --option window.startup_mode=\"maximized\"

            shell-component=dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY

            shell-component=foot --maximized
          '';
        };

        environment = {
          shellAliases = {
            test-wayland = "wayland-info | tee /tmp/test-wayland.out && touch /tmp/test-wayland-exit-ok";
            test-x11 = "glinfo | tee /tmp/test-x11.out && touch /tmp/test-x11-exit-ok";
          };

          systemPackages = with pkgs; [
            mesa-demos
            wayland-utils
            foot
            alacritty
          ];

          # To help with OCR
          etc."xdg/foot/foot.ini".text = lib.generators.toINI { } {
            main = {
              font = "inconsolata:size=16";
            };
            colors = rec {
              foreground = "000000";
              background = "ffffff";
              regular2 = foreground;
            };
          };
          etc."xdg/alacritty/alacritty.yml".text = lib.generators.toYAML { } {
            font = rec {
              normal.family = "Inconsolata";
              bold.family = normal.family;
              italic.family = normal.family;
              bold_italic.family = normal.family;
              size = 16;
            };
            colors = rec {
              primary = {
                foreground = "0x000000";
                background = "0xffffff";
              };
              normal = {
                green = primary.foreground;
              };
            };
          };
        };

        fonts.packages = [ pkgs.inconsolata ];
      };

    enableOCR = true;

    testScript =
      { nodes, ... }:
      ''
        start_all()
        machine.wait_for_unit("multi-user.target")

        # Wait for Miriway to complete startup
        machine.wait_for_file("/run/user/1000/wayland-0")
        machine.succeed("pgrep miriway-shell")
        machine.screenshot("miriway_launched")

        # Test Wayland
        # We let Miriway start the first terminal, as we might get stuck if it's not ready to process the first keybind
        # machine.send_key("ctrl-alt-t")
        machine.wait_for_text(r"(alice|machine)")
        machine.send_chars("test-wayland\n")
        machine.wait_for_file("/tmp/test-wayland-exit-ok")
        machine.copy_from_vm("/tmp/test-wayland.out")
        machine.screenshot("foot_wayland_info")
        # Only succeeds when a mouse is moved inside an interactive session?
        # machine.send_chars("exit\n")
        # machine.wait_until_fails("pgrep foot")
        machine.succeed("pkill foot")

        # Test XWayland
        machine.send_key("ctrl-alt-a")
        machine.wait_for_text(r"(alice|machine)")
        machine.send_chars("test-x11\n")
        machine.wait_for_file("/tmp/test-x11-exit-ok")
        machine.copy_from_vm("/tmp/test-x11.out")
        machine.screenshot("alacritty_glinfo")
        # Only succeeds when a mouse is moved inside an interactive session?
        # machine.send_chars("exit\n")
        # machine.wait_until_fails("pgrep alacritty")
        machine.succeed("pkill alacritty")
      '';
  }
)

{ lib, ... }:
{
  meta = {
    maintainers = with lib.maintainers; [ CompileTime ];
  };

  name = "tuxbox";
  enableOCR = true;

  nodes = {
    gui =
      { pkgs, ... }:
      {
        imports = [
          ./common/wayland-cage.nix
        ];

        services.cage.program = "${pkgs.tuxbox}/bin/tuxbox-gui";

        programs.tuxbox = {
          enable = true;
          users = [ "alice" ];
        };
      };
    sway =
      { ... }:
      {
        imports = [
          ./common/user-account.nix
        ];

        services.displayManager.sddm = {
          enable = true;
          wayland.enable = true;
        };
        services.displayManager = {
          defaultSession = "sway-uwsm";
          autoLogin = {
            enable = true;
            user = "alice";
          };
        };

        programs.sway = {
          enable = true;
        };

        programs.tuxbox = {
          enable = true;
          users = [ "alice" ];
        };

        programs.uwsm = {
          enable = true;
          waylandCompositors = {
            sway = {
              prettyName = "Sway";
              binPath = "/run/current-system/sw/bin/sway";
            };
          };
        };

        virtualisation = {
          qemu.options = [ "-vga virtio" ];
        };
      };
    niri =
      { ... }:
      {
        imports = [
          ./common/user-account.nix
        ];

        services.displayManager.sddm = {
          enable = true;
          wayland.enable = true;
        };
        services.displayManager = {
          defaultSession = "niri";
          autoLogin = {
            enable = true;
            user = "alice";
          };
        };

        programs.niri = {
          enable = true;
        };

        programs.tuxbox = {
          enable = true;
          users = [ "alice" ];
        };

        virtualisation = {
          qemu.options = [ "-vga virtio" ];
        };
      };
    hyprland =
      { ... }:
      {
        imports = [
          ./common/user-account.nix
        ];

        services.displayManager.sddm = {
          enable = true;
          wayland.enable = true;
        };
        services.displayManager = {
          defaultSession = "hyprland-uwsm";
          autoLogin = {
            enable = true;
            user = "alice";
          };
        };

        programs.hyprland = {
          enable = true;
          withUWSM = true;
        };

        programs.tuxbox = {
          enable = true;
          users = [ "alice" ];
        };

        virtualisation = {
          qemu.options = [ "-vga virtio" ];
        };
      };
    gdm =
      { ... }:
      {
        imports = [
          ./common/user-account.nix
        ];

        services.displayManager.gdm = {
          enable = true;
          wayland = true;
        };
        services.desktopManager.gnome.enable = true;

        services.displayManager = {
          autoLogin = {
            enable = true;
            user = "alice";
          };
        };

        programs.tuxbox = {
          enable = true;
          users = [ "alice" ];
        };

        virtualisation = {
          qemu.options = [ "-vga virtio" ];
        };
      };
    kde =
      { ... }:
      {
        imports = [
          ./common/user-account.nix
        ];

        services.desktopManager.plasma6.enable = true;
        services.displayManager.sddm.enable = true;
        services.displayManager.sddm.wayland.enable = true;

        services.displayManager = {
          autoLogin = {
            enable = true;
            user = "alice";
          };
        };

        programs.tuxbox = {
          enable = true;
          users = [ "alice" ];
        };

        virtualisation = {
          qemu.options = [ "-vga virtio" ];
        };
      };
    # Note: Profile switching is not tested for this node.
    # It was attempted to test this with KDE (X11) and Xfce but neither setups
    # produced a valid value for XDG_SESSION_TYPE which is needed for TuxBox
    # to setup profile switching for X11. Therefore, profile switching assertions
    # are missing in the test suite.
    # Feel free to provide insights/suggestions on how to properly set this up.
    xfce =
      { ... }:
      {
        imports = [
          ./common/user-account.nix
        ];

        services.xserver = {
          enable = true;
          desktopManager = {
            xterm.enable = false;
            xfce.enable = true;
          };
        };

        services.displayManager = {
          defaultSession = "xfce";
          autoLogin = {
            enable = true;
            user = "alice";
          };
        };

        programs.tuxbox = {
          enable = true;
          users = [ "alice" ];
        };

        virtualisation = {
          qemu.options = [ "-vga virtio" ];
        };
      };
  };

  testScript = ''
    start_all()

    with subtest("GUI should show up in kiosk"):
        gui.wait_for_text("TuxBox Configuration")
        gui.shutdown()

    with subtest("sway: TuxBox service unit should start"):
        sway.wait_for_unit("graphical.target", timeout=60)
        sway.wait_for_console_text("Started TuxBox Driver for TourBox Devices.")

    with subtest("sway: Window manager should be detected"):
        sway.wait_for_console_text("tuxbox.window_monitor - INFO - Detected window manager: sway")

    with subtest("sway: Virtual input device should be created"):
        sway.wait_for_console_text("tuxbox.device_base - INFO - Creating virtual input device...")

    with subtest("sway: Window monitor should be started"):
        sway.wait_for_console_text("tuxbox.window_monitor - INFO - Starting window monitor \(compositor: sway, interval: .+s\)")

    with subtest("sway: Driver binary should be in PATH"):
        sway.succeed("tuxbox --version")

    with subtest("sway: GUI application should be in PATH"):
        sway.succeed("which tuxbox-gui")
        sway.shutdown()

    with subtest("niri: TuxBox service unit should start"):
        niri.wait_for_unit("graphical.target", timeout=60)
        niri.wait_for_console_text("Started TuxBox Driver for TourBox Devices.")

    with subtest("niri: Window manager should be detected"):
        niri.wait_for_console_text("tuxbox.window_monitor - INFO - Detected window manager: niri")

    with subtest("niri: Virtual input device should be created"):
        niri.wait_for_console_text("tuxbox.device_base - INFO - Creating virtual input device...")

    with subtest("niri: Window monitor should be started"):
        niri.wait_for_console_text("tuxbox.window_monitor - INFO - Starting window monitor \(compositor: niri, interval: .+s\)")

    with subtest("niri: Driver binary should be in PATH"):
        niri.succeed("tuxbox --version")

    with subtest("niri: GUI application should be in PATH"):
        niri.succeed("which tuxbox-gui")
        niri.shutdown()

    with subtest("hyprland: TuxBox service unit should start"):
        hyprland.wait_for_unit("graphical.target", timeout=60)
        hyprland.wait_for_console_text("Started TuxBox Driver for TourBox Devices.")

    with subtest("hyprland: Window manager should be detected"):
        hyprland.wait_for_console_text("tuxbox.window_monitor - INFO - Detected window manager: hyprland")

    with subtest("hyprland: Virtual input device should be created"):
        hyprland.wait_for_console_text("tuxbox.device_base - INFO - Creating virtual input device...")

    with subtest("hyprland: Window monitor should be started"):
        hyprland.wait_for_console_text("tuxbox.window_monitor - INFO - Starting window monitor \(compositor: hyprland, interval: .+s\)")

    with subtest("hyprland: Driver binary should be in PATH"):
        hyprland.succeed("tuxbox --version")

    with subtest("hyprland: GUI application should be in PATH"):
        hyprland.succeed("which tuxbox-gui")
        hyprland.shutdown()

    with subtest("Gnome (Wayland): TuxBox service unit should start"):
        gdm.wait_for_unit("graphical.target", timeout=60)
        gdm.wait_for_console_text("Started TuxBox Driver for TourBox Devices.")

    with subtest("Gnome (Wayland): Window manager should be detected"):
        gdm.wait_for_console_text("tuxbox.window_monitor - INFO - Detected window manager: gnome")

    with subtest("Gnome (Wayland): Virtual input device should be created"):
        gdm.wait_for_console_text("tuxbox.device_base - INFO - Creating virtual input device...")

    with subtest("Gnome (Wayland): Window monitor should be started"):
        gdm.wait_for_console_text("tuxbox.window_monitor - INFO - Starting window monitor \(compositor: gnome, interval: .+s\)")

    with subtest("Gnome (Wayland): Driver binary should be in PATH"):
        gdm.succeed("tuxbox --version")

    with subtest("Gnome (Wayland): GUI application should be in PATH"):
        gdm.succeed("which tuxbox-gui")
        gdm.shutdown()

    with subtest("KDE (Wayland): TuxBox service unit should start"):
        kde.wait_for_unit("graphical.target", timeout=60)
        kde.wait_for_console_text("Started TuxBox Driver for TourBox Devices.")

    with subtest("KDE (Wayland): Window manager should be detected"):
        kde.wait_for_console_text("tuxbox.window_monitor - INFO - Detected window manager: kde")

    with subtest("KDE (Wayland): Virtual input device should be created"):
        kde.wait_for_console_text("tuxbox.device_base - INFO - Creating virtual input device...")

    with subtest("KDE (Wayland): Window monitor should be started"):
        kde.wait_for_console_text("tuxbox.window_monitor - INFO - Starting window monitor \(compositor: kde, interval: .+s\)")

    with subtest("KDE (Wayland): Driver binary should be in PATH"):
        kde.succeed("tuxbox --version")

    with subtest("KDE (Wayland): GUI application should be in PATH"):
        kde.succeed("which tuxbox-gui")
        kde.shutdown()

    with subtest("Xfce: TuxBox service unit should start"):
        xfce.wait_for_unit("graphical.target", timeout=60)
        xfce.wait_for_console_text("Started TuxBox Driver for TourBox Devices.")

    with subtest("Xfce: Virtual input device should be created"):
        xfce.wait_for_console_text("tuxbox.device_base - INFO - Creating virtual input device...")

    with subtest("Xfce: Driver binary should be in PATH"):
        xfce.succeed("tuxbox --version")

    with subtest("Xfce: GUI application should be in PATH"):
        xfce.succeed("which tuxbox-gui")
        xfce.shutdown()
  '';
}

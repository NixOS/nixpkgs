{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.instantview;

  enabled = cfg.enable || lib.elem "instantview" config.services.xserver.videoDrivers;

  evdi = config.boot.kernelPackages.evdi;

  instantview = pkgs.instantview.override {
    inherit evdi;
  };
in
{
  options.hardware.instantview.enable = lib.mkEnableOption ''
    Silicon Motion SM76x InstantView USB display support (EVDI + SMIUSBDisplayManager).
    Works at the DRM layer for Wayland and X11; compositor support for EVDI
    connectors varies (niri is known to pick them up; some KWin versions do not)
  '';

  config = lib.mkIf enabled {
    boot.extraModulePackages = [ evdi ];
    boot.kernelModules = [ "evdi" ];
    boot.extraModprobeConfig = ''
      options evdi initial_device_count=4
    '';

    services.udev.packages = [ instantview ];

    # Proprietary manager hardcodes /opt/siliconmotion for firmware and debug
    # dumps; keep that tree writable and symlink firmware from the store.
    systemd.tmpfiles.rules =
      let
        fw = "${instantview}/lib/instantview";
      in
      [
        "d /opt 0755 root root -"
        "d /opt/siliconmotion 0755 root root -"
        "d /opt/siliconmotion/pic 0755 root root -"
        "L+ /opt/siliconmotion/Bootloader0.bin - - - - ${fw}/Bootloader0.bin"
        "L+ /opt/siliconmotion/Bootloader1.bin - - - - ${fw}/Bootloader1.bin"
        "L+ /opt/siliconmotion/firmware0.bin - - - - ${fw}/firmware0.bin"
        "L+ /opt/siliconmotion/USBDisplay.bin - - - - ${fw}/USBDisplay.bin"
        "L+ /opt/siliconmotion/USBDisplay770.bin - - - - ${fw}/USBDisplay770.bin"
      ];

    # Optional X11 helper (not required for Wayland). Gated so Wayland-only
    # sessions are not forced into xrandr sessionCommands.
    services.xserver.externallyConfiguredDrivers = lib.mkIf config.services.xserver.enable [
      "instantview"
    ];

    environment.etc."X11/xorg.conf.d/40-instantview.conf" = lib.mkIf config.services.xserver.enable {
      text = ''
        Section "OutputClass"
          Identifier  "InstantView"
          MatchDriver "evdi"
          Driver      "modesetting"
          Option      "TearFree" "true"
          Option      "AccelMethod" "none"
        EndSection
      '';
    };

    systemd.services.instantview = {
      description = "Silicon Motion InstantView USB Display Manager";
      after = [
        "systemd-tmpfiles-setup.service"
        "systemd-udev-settle.service"
        "modprobe@evdi.service"
      ];
      wants = [ "modprobe@evdi.service" ];
      # Udev SYSTEMD_WANTS starts this on device add; also allow manual enable.
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        # Prefer current-system so a switch without reboot can still load
        # newly added out-of-tree modules (booted-system lags until reboot).
        ExecStartPre = "${pkgs.kmod}/bin/modprobe -d /run/current-system/kernel-modules evdi";
        ExecStart = "${instantview}/bin/SMIUSBDisplayManager";
        # Matches vendor/AUR layout; absolute firmware paths use /opt/siliconmotion.
        WorkingDirectory = "/opt/siliconmotion";
        Restart = "always";
        RestartSec = 5;
        LogsDirectory = "instantview";
      };
    };
  };
}

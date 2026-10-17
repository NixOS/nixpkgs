{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.brltty;

  targets = [
    "default.target"
    "multi-user.target"
    "rescue.target"
    "emergency.target"
  ];

  genApiKey = pkgs.writers.writeDash "generate-brlapi-key" ''
    if ! test -f /etc/brlapi.key; then
      echo -n generating brlapi key...
      ${pkgs.brltty}/bin/brltty-genkey -f /etc/brlapi.key
      echo done
    fi
  '';

in
{

  options = {

    services.brltty.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable the BRLTTY daemon.";
    };

    services.brltty.initrd = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable && config.boot.initrd.systemd.enable;
        defaultText = lib.literalExpression "config.services.brltty.enable && config.boot.initrd.systemd.enable";
        description = ''
          Whether to run BRLTTY in the initrd, so that a braille display is
          usable during early boot and in the initrd emergency shell.

          Defaults to enabled whenever BRLTTY and systemd-in-initrd
          ([](#opt-boot.initrd.systemd.enable), on by default) are both enabled,
          since a braille user almost always wants access as early as possible.
          Setting it explicitly requires systemd in the initrd.
        '';
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.brltty.override {
          alsaSupport = false;
          bluetoothSupport = false;
          polkitSupport = false;
          pythonSupport = false;
          systemdSupport = false;
          tclSupport = false;
        };
        defaultText = lib.literalExpression ''
          pkgs.brltty.override {
            alsaSupport = false;
            bluetoothSupport = false;
            polkitSupport = false;
            pythonSupport = false;
            systemdSupport = false;
            tclSupport = false;
          }
        '';
        description = ''
          The BRLTTY package to use in the initrd.

          The default disables everything that is not needed to drive a display
          there. Only `bin/brltty`, the drivers and the tables are copied into
          the initrd, and with these options those reference nothing but glibc,
          so the initrd grows by a few megabytes rather than by BRLTTY's full
          closure.

          Note that Bluetooth is disabled: supporting it in the initrd would
          require copying the link keys of all paired devices into the image.
        '';
      };

      kernelModules = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "hid_generic"
          "uinput"
          "usbhid"
        ];
        example = [
          "ftdi_sio"
          "cp210x"
        ];
        description = ''
          Kernel modules to load in the initrd.

          `uinput` is what BRLTTY uses to inject keystrokes, so it is required
          for typing on the braille display's own keyboard. `usbhid` and
          `hid_generic` bind USB HID displays, which are what most current
          displays are.

          These cannot be left to [](#opt-boot.initrd.availableKernelModules):
          `nixos-generate-config` only adds a USB device's driver there if it is
          mass storage or a HID *boot keyboard*, and a braille display is
          neither, so its module is generally not detected at install time.

          A **USB-serial display** (still common) instead needs its USB-serial
          converter's driver, and it must be added here explicitly — the same
          detection gap applies. Which driver depends on the converter, e.g.
          `ftdi_sio`, `cp210x`, `ch341` or `pl2303`; `lsusb`/`dmesg` with the
          display plugged in on a running system will show which one binds. Old
          real RS-232 (`/dev/ttyS*`) displays need no extra module.

          `pcspkr` is not included by default because it only provides BRLTTY's
          alert tones and many machines have no PC speaker; add it here if you
          want them.
        '';
      };

    };

  };

  config = lib.mkMerge [

    (lib.mkIf cfg.enable {
      users.users.brltty = {
        description = "BRLTTY daemon user";
        group = "brltty";
        isSystemUser = true;
      };
      users.groups = {
        brltty = { };
        brlapi = { };
      };

      systemd.services."brltty@".serviceConfig = {
        ExecStartPre = "!${genApiKey}";
      };

      # Install all upstream-provided files
      systemd.packages = [ pkgs.brltty ];
      systemd.tmpfiles.packages = [ pkgs.brltty ];
      services.udev.packages = [ pkgs.brltty ];
      environment.systemPackages = [ pkgs.brltty ];

      # Add missing WantedBys (see issue #81138)
      systemd.paths.brltty.wantedBy = targets;
      systemd.paths."brltty@".wantedBy = targets;
    })

    (lib.mkIf cfg.initrd.enable {
      assertions = [
        {
          assertion = config.boot.initrd.systemd.enable;
          message = ''
            services.brltty.initrd.enable requires boot.initrd.systemd.enable.
          '';
        }
      ];

      boot.initrd.kernelModules = cfg.initrd.kernelModules;

      boot.initrd.systemd.storePaths = [
        "${cfg.initrd.package}/bin/brltty"
        "${cfg.initrd.package}/lib/brltty"
        "${cfg.initrd.package}/etc/brltty"
      ];

      # /dev/bus/usb is not populated this early, so BRLTTY falls back to
      # mounting its own usbfs and needs somewhere it is allowed to create
      # device nodes. /run is mounted nodev, but a submount need not be.
      boot.initrd.systemd.mounts = [
        {
          what = "tmpfs";
          where = "/run/brltty";
          type = "tmpfs";
          options = "dev,mode=755";
          unitConfig.DefaultDependencies = false;
        }
      ];

      boot.initrd.systemd.services.brltty = {
        description = "Braille Device Support (initrd)";
        # Also emergency and rescue: initrd.target is never reached when
        # booting into those, which are precisely the situations where a
        # braille display is needed most.
        wantedBy = [
          "initrd.target"
          "emergency.target"
          "rescue.target"
        ];
        after = [
          "systemd-udevd.service"
          "run-brltty.mount"
        ];
        requires = [ "run-brltty.mount" ];
        unitConfig.DefaultDependencies = false;
        environment = {
          # The Linux console screen driver; nothing else is usable here.
          BRLTTY_SCREEN_DRIVER = "lx";
          # Speech drivers behave poorly in an initrd, and this build has no
          # sound support anyway.
          BRLTTY_SPEECH_DRIVER = "no";
          # Allow typing on the display's own keyboard, so the initrd
          # emergency shell can actually be used.
          BRLTTY_OVERRIDE_PREFERENCE = "braille-keyboard-enabled=yes,braille-input-mode=text";
          BRLTTY_WRITABLE_DIRECTORY = "/run/brltty";
          BRLTTY_PID_FILE = "/run/brltty/brltty.pid";
        };
        serviceConfig = {
          Type = "simple";
          # -E: honour the environment above. -n: stay in the foreground.
          ExecStart = "${cfg.initrd.package}/bin/brltty -E -n";
          # Release the display before switch-root so that the BRLTTY instance
          # of the booted system can claim it.
          ExecStop = "${cfg.initrd.package}/bin/brltty -E -C";
          Restart = "no";
        };
      };
    })

  ];

}

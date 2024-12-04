{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.boot.initrd.unl0kr;
  settingsFormat = pkgs.formats.ini { };
in
{
  options.boot.initrd.unl0kr = {
    enable = lib.mkEnableOption "unl0kr in initrd" // {
      description = ''Whether to enable the unl0kr on-screen keyboard in initrd to unlock LUKS.'';
    };

    package = lib.mkPackageOption pkgs "unl0kr" { };

    allowVendorDrivers = lib.mkEnableOption "load optional drivers" // {
      description = ''Whether to load additional drivers for certain vendors (I.E: Wacom, Intel, etc.)'';
    };

    settings = lib.mkOption {
      description = ''
        Configuration for `unl0kr`.

        See `unl0kr.conf(5)` for supported values.

        Alternatively, visit `https://gitlab.com/postmarketOS/buffybox/-/blob/unl0kr-2.0.0/unl0kr.conf`
      '';

      example = lib.literalExpression ''
        {
          general.animations = true;
          theme = {
            default = "pmos-dark";
            alternate = "pmos-light";
          };
        }
      '';
      default = { };
      type = lib.types.submodule { freeformType = settingsFormat.type; };
    };
  };

  config = lib.mkIf cfg.enable {
    meta.maintainers = with lib.maintainers; [ hustlerone ];
    assertions = [
      {
        assertion = cfg.enable -> config.boot.initrd.systemd.enable;
        message = "boot.initrd.unl0kr is only supported with boot.initrd.systemd.";
      }
      {
        assertion = !config.boot.plymouth.enable;
        message = "unl0kr will not work if plymouth is enabled.";
      }
      {
        assertion = !config.hardware.amdgpu.initrd.enable;
        message = "unl0kr has issues with video drivers that are loaded on stage 1.";
      }
    ];

    boot.initrd.availableKernelModules =
      lib.optionals cfg.enable [
        "hid-multitouch"
        "hid-generic"
        "usbhid"

        "i2c-designware-core"
        "i2c-designware-platform"
        "i2c-hid-acpi"

        "usbtouchscreen"
        "evdev"
      ]
      ++ lib.optionals cfg.allowVendorDrivers [
        "intel_lpss_pci"
        "elo"
        "wacom"
      ];

    boot.initrd.systemd = {
      contents."/etc/unl0kr.conf".source = settingsFormat.generate "unl0kr.conf" cfg.settings;
      storePaths = with pkgs; [
        "${pkgs.gnugrep}/bin/grep"
        libinput
        xkeyboard_config
        "${config.boot.initrd.systemd.package}/lib/systemd/systemd-reply-password"
        (lib.getExe' cfg.package "unl0kr")
      ];
      services = {
        unl0kr-ask-password = {
          description = "Forward Password Requests to unl0kr";
          conflicts = [
            "emergency.service"
            "initrd-switch-root.target"
            "shutdown.target"
          ];
          unitConfig.DefaultDependencies = false;
          after = [
            "systemd-vconsole-setup.service"
            "udev.service"
          ];
          before = [ "shutdown.target" ];
          script = ''
            # This script acts as a Password Agent: https://systemd.io/PASSWORD_AGENTS/

            DIR=/run/systemd/ask-password/
            # If a user has multiple encrypted disks, the requests might come in different times,
            # so make sure to answer as many requests as we can. Once boot succeeds, other
            # password agents will be responsible for watching for requests.
            while [ -d $DIR ] && [ "$(ls -A $DIR/ask.*)" ];
            do
              for file in `ls $DIR/ask.*`; do
                socket="$(cat "$file" | ${pkgs.gnugrep}/bin/grep "Socket=" | cut -d= -f2)"
                ${lib.getExe' cfg.package "unl0kr"} -v -C "/etc/unl0kr.conf" | ${config.boot.initrd.systemd.package}/lib/systemd/systemd-reply-password 1 "$socket"
              done
            done
          '';
        };
      };

      paths = {
        unl0kr-ask-password = {
          description = "Forward Password Requests to unl0kr";
          conflicts = [
            "emergency.service"
            "initrd-switch-root.target"
            "shutdown.target"
          ];
          unitConfig.DefaultDependencies = false;
          before = [
            "shutdown.target"
            "paths.target"
            "cryptsetup.target"
          ];
          wantedBy = [ "sysinit.target" ];
          pathConfig = {
            DirectoryNotEmpty = "/run/systemd/ask-password";
            MakeDirectory = true;
          };
        };
      };
    };
  };
}

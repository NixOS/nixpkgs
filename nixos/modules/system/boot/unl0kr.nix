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

    package = lib.mkPackageOption pkgs "buffybox" { };

    allowVendorDrivers = lib.mkEnableOption "load optional drivers" // {
      description = ''Whether to load additional drivers for certain vendors (I.E: Wacom, Intel, etc.)'';
    };

    settings = lib.mkOption {
      description = ''
        Configuration for `unl0kr`.

        See `unl0kr.conf(5)` for supported values.

        Alternatively, visit `https://gitlab.postmarketos.org/postmarketOS/buffybox/-/blob/3.2.0/unl0kr/unl0kr.conf`
      '';

      example = lib.literalExpression ''
        {
          general.animations = true;
          general.backend = "drm";
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
    ];

    warnings = lib.mkMerge [
      (lib.mkIf (config.hardware.amdgpu.initrd.enable) [
        ''Use early video loading at your risk. It's not guaranteed to work with unl0kr.''
      ])
      (lib.mkIf (config.boot.plymouth.enable) [
        ''Upstream clearly intends unl0kr to not run with Plymouth. Good luck''
      ])
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
        "psmouse"
      ]
      ++ lib.optionals cfg.allowVendorDrivers [
        "intel_lpss_pci"
        "elo"
        "wacom"
      ];

    boot.initrd.systemd = {
      contents."/etc/unl0kr.conf".source = settingsFormat.generate "unl0kr.conf" cfg.settings;
      storePaths = with pkgs; [
        libinput
        libinput.out
        xkeyboard_config
        (lib.getExe' cfg.package "unl0kr")
        "${cfg.package}/libexec/unl0kr-agent"
      ];

      packages = [
        pkgs.buffybox
      ];

      paths.unl0kr-agent.wantedBy = [ "local-fs-pre.target" ];
    };
  };
}

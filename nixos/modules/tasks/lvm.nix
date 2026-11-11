{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.services.lvm;
in
{
  options.services.lvm = {
    enable = mkEnableOption "lvm2" // {
      default = true;
      description = ''
        Whether to enable lvm2.

        :::{.note}
        The lvm2 package contains device-mapper udev rules and without those tools like cryptsetup do not fully function!
        :::
      '';
    };

    resizeHelper.enable = mkEnableOption "lvresize_fs_helper" // {
      default = true;
    };

    package = mkOption {
      type = types.package;
      default = pkgs.lvm2;
      internal = true;
      defaultText = literalExpression "pkgs.lvm2";
      description = ''
        This option allows you to override the LVM package that's used on the system
        (udev rules, tmpfiles, systemd services).
        Defaults to pkgs.lvm2, pkgs.lvm2_dmeventd if dmeventd or pkgs.lvm2_vdo if vdo is enabled.
      '';
    };
    dmeventd.enable = mkEnableOption "the LVM dmevent daemon";
    boot.thin.enable = mkEnableOption "support for booting from ThinLVs";
    boot.vdo.enable = mkEnableOption "support for booting from VDOLVs";
  };

  options.boot.initrd.services.lvm.enable = mkEnableOption "booting from LVM2 in the initrd" // {
    default = config.services.lvm.enable;
    defaultText = lib.literalExpression "config.services.lvm.enable";
  };

  config = mkMerge [
    {
      # minimal configuration file to make lvmconfig/lvm2-activation-generator happy
      environment.etc."lvm/lvm.conf".text = lib.mkBefore "config {}";
    }
    (mkIf cfg.enable {
      systemd.tmpfiles.packages = [ cfg.package.out ];
      environment.systemPackages = [ cfg.package ];
      systemd.packages = [ cfg.package ];

      services.udev.packages = [ cfg.package.out ];
      environment.etc."lvm/lvm.conf".text =
        mkIf cfg.resizeHelper.enable "global/lvresize_fs_helper_executable = ${pkgs.lvm2.scripts}/libexec/lvresize_fs_helper";
    })
    (mkIf config.boot.initrd.services.lvm.enable {
      # We need lvm2 for the device-mapper rules
      boot.initrd.services.udev.packages = [ cfg.package ];
      # The device-mapper rules want to call tools from lvm2
      boot.initrd.systemd.initrdBin = [ cfg.package ];
      boot.initrd.services.udev.binPackages = [ cfg.package ];
    })
    (mkIf cfg.dmeventd.enable {
      systemd.sockets."dm-event".wantedBy = [ "sockets.target" ];
      systemd.services."lvm2-monitor".wantedBy = [ "sysinit.target" ];

      environment.etc."lvm/lvm.conf".text = "dmeventd/executable = ${cfg.package}/bin/dmeventd";
      services.lvm.package = mkDefault pkgs.lvm2_dmeventd;
    })
    (mkIf cfg.boot.thin.enable {
      boot.initrd = {
        kernelModules = [
          "dm-snapshot"
          "dm-thin-pool"
        ];

        systemd.initrdBin = lib.mkIf config.boot.initrd.services.lvm.enable [
          pkgs.thin-provisioning-tools
        ];
      };

      environment.etc."lvm/lvm.conf".text =
        concatMapStringsSep "\n"
          (bin: "global/${bin}_executable = ${pkgs.thin-provisioning-tools}/bin/${bin}")
          [
            "thin_check"
            "thin_dump"
            "thin_repair"
            "cache_check"
            "cache_dump"
            "cache_repair"
          ];

      environment.systemPackages = [ pkgs.thin-provisioning-tools ];
    })
    (mkIf cfg.boot.vdo.enable {
      assertions = [
        {
          assertion = lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.9";
          message = "boot.vdo.enable requires at least kernel version 6.9";
        }
      ];

      boot = {
        initrd = {
          kernelModules = [ "dm-vdo" ];

          systemd.initrdBin = lib.mkIf config.boot.initrd.services.lvm.enable [ pkgs.vdo ];
        };
      };

      services.lvm.package = mkOverride 999 pkgs.lvm2_vdo; # this overrides mkDefault

      environment.systemPackages = [ pkgs.vdo ];
    })
    (mkIf (cfg.dmeventd.enable || cfg.boot.thin.enable) {
      boot.initrd.systemd.contents."/etc/lvm/lvm.conf".text =
        optionalString (config.boot.initrd.services.lvm.enable && cfg.boot.thin.enable) (
          concatMapStringsSep "\n" (bin: "global/${bin}_executable = /bin/${bin}") [
            "thin_check"
            "thin_dump"
            "thin_repair"
            "cache_check"
            "cache_dump"
            "cache_repair"
          ]
        )
        + "\n"
        + optionalString cfg.dmeventd.enable ''
          dmeventd/executable = /bin/false
          activation/monitoring = 0
        '';
    })
  ];

}

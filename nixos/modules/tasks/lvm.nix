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
    description = ''
      *This will only be used when systemd is used in stage 1.*

      Whether to enable booting from LVM2 in the initrd.
    '';
  };

  config = mkMerge [
    ({
      # minimal configuration file to make lvmconfig/lvm2-activation-generator happy
      environment.etc."lvm/lvm.conf".text = "config {}";
    })
    (mkIf cfg.enable {
      systemd.tmpfiles.packages = [ cfg.package.out ];
      environment.systemPackages = [ cfg.package ];
      systemd.packages = [ cfg.package ];

      services.udev.packages = [ cfg.package.out ];
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

      environment.etc."lvm/lvm.conf".text = ''
        dmeventd/executable = "${cfg.package}/bin/dmeventd"
      '';
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

        extraUtilsCommands = mkIf (!config.boot.initrd.systemd.enable) ''
          for BIN in ${pkgs.thin-provisioning-tools}/bin/*; do
            copy_bin_and_libs $BIN
          done
        '';

        extraUtilsCommandsTest = mkIf (!config.boot.initrd.systemd.enable) ''
          ls ${pkgs.thin-provisioning-tools}/bin/ | grep -v pdata_tools | while read BIN; do
            $out/bin/$(basename $BIN) --help > /dev/null
          done
        '';
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
      boot = {
        initrd = {
          kernelModules = [ "kvdo" ];

          systemd.initrdBin = lib.mkIf config.boot.initrd.services.lvm.enable [ pkgs.vdo ];

          extraUtilsCommands = mkIf (!config.boot.initrd.systemd.enable) ''
            ls ${pkgs.vdo}/bin/ | while read BIN; do
              copy_bin_and_libs ${pkgs.vdo}/bin/$BIN
            done
            substituteInPlace $out/bin/vdorecover --replace "${pkgs.bash}/bin/bash" "/bin/sh"
            substituteInPlace $out/bin/adaptLVMVDO.sh --replace "${pkgs.bash}/bin/bash" "/bin/sh"
          '';

          extraUtilsCommandsTest = mkIf (!config.boot.initrd.systemd.enable) ''
            ls ${pkgs.vdo}/bin/ | grep -vE '(adaptLVMVDO|vdorecover)' | while read BIN; do
              $out/bin/$(basename $BIN) --help > /dev/null
            done
          '';
        };
        extraModulePackages = [ config.boot.kernelPackages.kvdo ];
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

      boot.initrd.preLVMCommands = mkIf (!config.boot.initrd.systemd.enable) ''
        mkdir -p /etc/lvm
        cat << EOF >> /etc/lvm/lvm.conf
        ${optionalString cfg.boot.thin.enable (
          concatMapStringsSep "\n" (bin: "global/${bin}_executable = $(command -v ${bin})") [
            "thin_check"
            "thin_dump"
            "thin_repair"
            "cache_check"
            "cache_dump"
            "cache_repair"
          ]
        )}
        ${optionalString cfg.dmeventd.enable ''
          dmeventd/executable = "$(command -v false)"
          activation/monitoring = 0
        ''}
        EOF
      '';
    })
  ];

}

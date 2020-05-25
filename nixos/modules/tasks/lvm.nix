{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.lvm;
in {

  options.services.lvm = {
    dmeventd = {
      enable = mkEnableOption "the LVM dmevent daemon";
    };
    boot.thin = {
      enable = mkEnableOption "support for booting from ThinLVs";
    };
  };


  config = mkMerge [
    (mkIf (!config.boot.isContainer) {
      environment.systemPackages = [ pkgs.lvm2 ];
      services.udev.packages = [ pkgs.lvm2 ];
      systemd.packages = [ pkgs.lvm2 ];
    })
    (mkIf cfg.dmeventd.enable {
      systemd.sockets."dm-event".wantedBy = [ "sockets.target" ];
      systemd.services."lvm2-monitor".wantedBy = [ "sysinit.target" ];

      environment.etc."lvm/lvm.conf".text = ''
        dmeventd/executable = "${pkgs.lvm2}/bin/dmeventd"
      '';
    })
    (mkIf cfg.boot.thin.enable {
      boot.initrd = {
        kernelModules = [ "dm-snapshot" "dm-thin-pool" ];

        extraUtilsCommands = ''
          copy_bin_and_libs ${pkgs.thin-provisioning-tools}/bin/pdata_tools
          copy_bin_and_libs ${pkgs.thin-provisioning-tools}/bin/thin_check
        '';
      };

      environment.etc."lvm/lvm.conf".text = ''
        global/thin_check_executable = "${pkgs.thin-provisioning-tools}/bin/thin_check"
      '';
    })
    (mkIf (cfg.dmeventd.enable || cfg.boot.thin.enable) {
      boot.initrd.preLVMCommands = ''
          mkdir -p /etc/lvm
          cat << EOF >> /etc/lvm/lvm.conf
          ${optionalString cfg.thin.enable ''
            global/thin_check_executable = "$(which thin_check)
          ''}
          ${optionalString cfg.dmeventd.enable ''
            dmeventd/executable = "$(which false)"
            activation/monitoring = 0
          ''}
          EOF
      '';
    })
  ];

}

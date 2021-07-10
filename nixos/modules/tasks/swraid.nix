{ pkgs, lib, config, ... }:

with lib;
let cfg = config.services.mdadm;
in
{

  options = {

    services.mdadm = {

      monitor = {
        enable = mkEnableOption "Enable the mdadm monitoring daemon";
      };

      adminAddr = mkOption {
        type = types.str;
        example = "admin@example.org";
        description = "E-mail address of the server administrator.";
      };
    };
  };

  config = mkMerge [
    {
      environment.systemPackages = [ pkgs.mdadm ];

      services.udev.packages = [ pkgs.mdadm ];

      systemd.packages = [ pkgs.mdadm ];

      boot.initrd.availableKernelModules = [ "md_mod" "raid0" "raid1" "raid10" "raid456" ];

      boot.initrd.extraUdevRulesCommands = ''
        cp -v ${pkgs.mdadm}/lib/udev/rules.d/*.rules $out/
      '';
    }

    (mkIf cfg.monitor.enable
        {
          systemd.services.mdadm-monitor = {
            description = "Monitor RAID disks";
            wantedBy = [ "multi-user.target" ];
            script = "${pkgs.mdadm}/bin/mdadm --monitor -m ${assert cfg.adminAddr != null; cfg.adminAddr} --scan";
          };
        }
    )
  ];

}

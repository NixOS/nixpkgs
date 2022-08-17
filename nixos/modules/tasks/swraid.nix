{ config, pkgs, lib, ... }: let

  cfg = config.boot.initrd.services.swraid;

in {

  options.boot.initrd.services.swraid = {
    enable = (lib.mkEnableOption "swraid support using mdadm") // {
      visible = false; # only has effect when the new stage 1 is in place
    };

    mdadmConf = lib.mkOption {
      description = lib.mdDoc "Contents of {file}`/etc/mdadm.conf` in initrd.";
      type = lib.types.lines;
      default = "";
    };
  };

  config = {
    environment.systemPackages = [ pkgs.mdadm ];

    services.udev.packages = [ pkgs.mdadm ];

    systemd.packages = [ pkgs.mdadm ];

    boot.initrd.availableKernelModules = lib.mkIf (config.boot.initrd.systemd.enable -> cfg.enable) [ "md_mod" "raid0" "raid1" "raid10" "raid456" ];

    boot.initrd.extraUdevRulesCommands = lib.mkIf (!config.boot.initrd.systemd.enable) ''
      cp -v ${pkgs.mdadm}/lib/udev/rules.d/*.rules $out/
    '';

    boot.initrd.systemd = lib.mkIf cfg.enable {
      contents."/etc/mdadm.conf" = lib.mkIf (cfg.mdadmConf != "") {
        text = cfg.mdadmConf;
      };

      packages = [ pkgs.mdadm ];
      initrdBin = [ pkgs.mdadm ];
    };

    boot.initrd.services.udev.packages = lib.mkIf cfg.enable [ pkgs.mdadm ];
  };
}

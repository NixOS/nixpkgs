{ config, pkgs, lib, ... }: let

  cfg = config.boot.initrd.services.swraid;

in {

  options.boot.initrd.services.swraid = {
    enable = lib.mkEnableOption (lib.mdDoc "swraid support using mdadm") // {
      description = lib.mdDoc ''
        Whether to enable swraid support using mdadm.
      '';
      default = lib.versionOlder config.system.stateVersion "23.11";
      defaultText = lib.mdDoc "`true` if stateVersion is older than 23.11";
    };

    mdadmConf = lib.mkOption {
      description = lib.mdDoc "Contents of {file}`/etc/mdadm.conf` in initrd.";
      type = lib.types.lines;
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.mdadm ];

    services.udev.packages = [ pkgs.mdadm ];

    systemd.packages = [ pkgs.mdadm ];

    boot.initrd.availableKernelModules = [ "md_mod" "raid0" "raid1" "raid10" "raid456" ];

    boot.initrd.extraUdevRulesCommands = lib.mkIf (!config.boot.initrd.systemd.enable) ''
      cp -v ${pkgs.mdadm}/lib/udev/rules.d/*.rules $out/
    '';

    boot.initrd.systemd = {
      contents."/etc/mdadm.conf" = lib.mkIf (cfg.mdadmConf != "") {
        text = cfg.mdadmConf;
      };

      packages = [ pkgs.mdadm ];
      initrdBin = [ pkgs.mdadm ];
    };

    boot.initrd.services.udev.packages = [ pkgs.mdadm ];
  };
}

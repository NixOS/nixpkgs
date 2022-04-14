{ config, pkgs, lib, ... }: let

  cfg = config.boot.initrd.services.mdraid;

in {
  options.boot.initrd.services.mdraid = {
    enable = (lib.mkEnableOption "mdraid support in initrd") // {
      visible = false;
    };

    mdadmConf = lib.mkOption {
      description = "Contents of <filename>/etc/mdadm.conf</filename> in initrd.";
      type = lib.types.lines;
      default = "";
    };
  };

  config = lib.mkIf (config.boot.initrd.systemd.enable && cfg.enable) {
    boot.initrd.systemd = {
      contents."/etc/mdadm.conf" = lib.mkIf (cfg.mdadmConf != "") {
        text = cfg.mdadmConf;
      };

      initrdBin = [ pkgs.mdadm ];
    };

    boot.initrd.services.udev.packages = [ pkgs.mdadm ];
    boot.initrd.systemd.packages = [ pkgs.mdadm ];

    boot.kernelModules = [ "dm-raid" ];
  };
}

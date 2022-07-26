{ config, lib, pkgs, ... }:

{
  options.boot.initrd.services.bcache.enable = (lib.mkEnableOption "bcache support in the initrd") // {
    visible = false; # only works with systemd stage 1
  };

  config = {

    environment.systemPackages = [ pkgs.bcache-tools ];

    services.udev.packages = [ pkgs.bcache-tools ];

    boot.initrd.extraUdevRulesCommands = lib.mkIf (!config.boot.initrd.systemd.enable) ''
      cp -v ${pkgs.bcache-tools}/lib/udev/rules.d/*.rules $out/
    '';

    boot.initrd.services.udev = lib.mkIf config.boot.initrd.services.bcache.enable {
      packages = [ pkgs.bcache-tools ];
      binPackages = [ pkgs.bcache-tools ];
    };
  };
}

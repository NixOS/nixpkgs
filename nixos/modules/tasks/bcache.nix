<<<<<<< HEAD
{ config, lib, pkgs, ... }: let
  cfg = config.boot.bcache;
in {
  options.boot.bcache.enable = lib.mkEnableOption (lib.mdDoc "bcache mount support") // {
    default = true;
    example = false;
  };
  options.boot.initrd.services.bcache.enable = lib.mkEnableOption (lib.mdDoc "bcache support in the initrd") // {
    description = lib.mdDoc ''
      *This will only be used when systemd is used in stage 1.*

      Whether to enable bcache support in the initrd.
    '';
  };

  config = lib.mkIf cfg.enable {
=======
{ config, lib, pkgs, ... }:

{
  options.boot.initrd.services.bcache.enable = (lib.mkEnableOption (lib.mdDoc "bcache support in the initrd")) // {
    visible = false; # only works with systemd stage 1
  };

  config = {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

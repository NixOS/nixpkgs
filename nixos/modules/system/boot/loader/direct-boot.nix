{ config, lib, utils, ... }:

with lib;

let
  cfg = config.boot.loader.directBoot;
in
{
  meta = {
    maintainers = with maintainers; [ raitobezarius ];
  };

  options.boot.loader.directBoot = utils.mkBootLoaderOption {
    enable = mkEnableOption (lib.mdDoc "a direct boot 'fake bootloader'");
  };

  config = mkIf cfg.enable {
    boot.loader.directBoot = {
      id = "direct-boot";
      installHook = "${pkgs.coreutils}/bin/true";
      supportsInitrdSecrets = mkForce false;
    };
  };
}

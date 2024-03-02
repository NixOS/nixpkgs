{ config, pkgs, lib, ... }:
{
  options.programs.bcc.enable = lib.mkEnableOption (lib.mdDoc "bcc");

  config = lib.mkIf config.programs.bcc.enable {
    environment.systemPackages = [ pkgs.bcc ];
    boot.extraModulePackages = [ pkgs.bcc ];
  };
}

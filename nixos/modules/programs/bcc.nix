{ config, lib, ... }:
{
  options.programs.bcc.enable = lib.mkEnableOption "bcc";

  config = lib.mkIf config.programs.bcc.enable {
    environment.systemPackages = [ config.boot.kernelPackages.bcc ];
    boot.extraModulePackages = [ config.boot.kernelPackages.bcc ];
  };
}

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.nbd;
in
{
  options = {
    programs.nbd = {
      enable = mkEnableOption "Network Block Device (nbd) support";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ nbd ];
    boot.kernelModules = [ "nbd" ];
  };
}

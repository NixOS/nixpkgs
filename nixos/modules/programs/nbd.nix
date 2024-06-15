{ config, lib, pkgs, ... }:

let
  cfg = config.programs.nbd;
in
{
  options = {
    programs.nbd = {
      enable = lib.mkEnableOption "Network Block Device (nbd) support";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ nbd ];
    boot.kernelModules = [ "nbd" ];
  };
}

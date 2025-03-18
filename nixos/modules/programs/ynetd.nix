{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ynetd;
in
{
  options = {
    programs.ynetd = {
      enable = mkEnableOption "Small server for binding programs to TCP ports";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = pkgs.ynetd;
  };
}

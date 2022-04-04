{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.programs.yottadb;
in {
  options.programs.yottadb = {
    enable = mkEnableOption "YottaDB";
  };

  config = mkIf cfg.enable {
      environment.systemPackages = [ pkgs.yottadb ];
      security.wrappers.gtmsecshr = {
        setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.yottadb}/dist/gtmsecshr.nosuid";
      };
  };
}

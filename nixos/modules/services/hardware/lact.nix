{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.lact;
in {
  options = {
    services.lact.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the LACT daemon.";
    };

  };

  config = mkIf cfg.enable {
    systemd.packages = [ pkgs.lact ];
    environment.systemPackages = [ pkgs.lact ];
  };

}

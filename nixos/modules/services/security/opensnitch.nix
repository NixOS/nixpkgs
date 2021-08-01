{ config, lib, pkgs, ... }:

with lib;

let
  name = "opensnitch";
  cfg = config.services.opensnitch;
in {
  options = {
    services.opensnitch = {
      enable = mkEnableOption "Opensnitch application firewall";
    };
  };

  config = mkIf cfg.enable {

    systemd = {
      packages = [ pkgs.opensnitch ];
      services.opensnitchd.wantedBy = [ "multi-user.target" ];
    };

  };
}


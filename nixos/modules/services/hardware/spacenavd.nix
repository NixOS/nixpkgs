{ config, lib, pkgs, ... }:

with lib;

let cfg = config.hardware.spacenavd;

in {

  options = {
    hardware.spacenavd = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable spacenavd to support 3DConnexion devices
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.spacenavd = {
      description = "spacenavd";
      after = [ "basic.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.spacenavd}/bin/spacenavd";
      };
    };
  };
}

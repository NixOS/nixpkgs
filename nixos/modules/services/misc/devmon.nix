{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.services.devmon;

in {
  options = {
    services.devmon = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable devmon, an automatic device mounting daemon.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.devmon = {
      description = "devmon automatic device mounting daemon";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.udevil ];
      serviceConfig.ExecStart = "${pkgs.udevil}/bin/devmon";
    };
  };
}

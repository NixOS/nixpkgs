{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.services.devmon;

in {
  options = {
    services.devmon = {
      enable = mkEnableOption "devmon, an automatic device mounting daemon";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.devmon = {
      description = "devmon automatic device mounting daemon";
      wantedBy = [ "default.target" ];
      path = [ pkgs.udevil pkgs.procps pkgs.udisks2 pkgs.which ];
      serviceConfig.ExecStart = "${pkgs.udevil}/bin/devmon";
    };

    services.udisks2.enable = true;
  };
}

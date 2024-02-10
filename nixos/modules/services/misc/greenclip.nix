{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.greenclip;
in {

  options.services.greenclip = {
    enable = mkEnableOption (lib.mdDoc "Greenclip daemon");

    package = mkPackageOption pkgs [ "haskellPackages" "greenclip" ] { };
  };

  config = mkIf cfg.enable {
    systemd.user.services.greenclip = {
      enable      = true;
      description = "greenclip daemon";
      wantedBy = [ "graphical-session.target" ];
      after    = [ "graphical-session.target" ];
      serviceConfig.ExecStart = "${cfg.package}/bin/greenclip daemon";
    };

    environment.systemPackages = [ cfg.package ];
  };
}

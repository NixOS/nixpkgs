{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.playerctld;
in
{
  options.services.playerctld = {
    enable = mkEnableOption (lib.mdDoc "the playerctld daemon");

    package = mkPackageOption pkgs "playerctl" { };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.user.services.playerctld = {
      description = "Playerctld daemon to track media player activity";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "exec";
        ExecStart = "${cfg.package}/bin/playerctld";
      };
    };
  };

  meta = { maintainers = with lib.maintainers; [ aacebedo ]; };
}

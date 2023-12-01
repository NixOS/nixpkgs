{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.jmusicbot;
in
{
  options = {
    services.jmusicbot = {
      enable = mkEnableOption (lib.mdDoc "jmusicbot, a Discord music bot that's easy to set up and run yourself");

      package = mkPackageOption pkgs "jmusicbot" { };

      stateDir = mkOption {
        type = types.path;
        description = lib.mdDoc ''
          The directory where config.txt and serversettings.json is saved.
          If left as the default value this directory will automatically be created before JMusicBot starts, otherwise the sysadmin is responsible for ensuring the directory exists with appropriate ownership and permissions.
          Untouched by the value of this option config.txt needs to be placed manually into this directory.
        '';
        default = "/var/lib/jmusicbot/";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.jmusicbot = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      description = "Discord music bot that's easy to set up and run yourself!";
      serviceConfig = mkMerge [{
        ExecStart = "${cfg.package}/bin/JMusicBot";
        WorkingDirectory = cfg.stateDir;
        Restart = "always";
        RestartSec = 20;
        DynamicUser = true;
      }
        (mkIf (cfg.stateDir == "/var/lib/jmusicbot") { StateDirectory = "jmusicbot"; })];
    };
  };

  meta.maintainers = with maintainers; [ ];
}

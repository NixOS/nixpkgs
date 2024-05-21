{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.replay-sorcery;
  configFile = generators.toKeyValue {} cfg.settings;
in
{
  options = with types; {
    services.replay-sorcery = {
      enable = mkEnableOption "the ReplaySorcery service for instant-replays";

      enableSysAdminCapability = mkEnableOption ''
        the system admin capability to support hardware accelerated
        video capture. This is equivalent to running ReplaySorcery as
        root, so use with caution'';

      autoStart = mkOption {
        type = bool;
        default = false;
        description = "Automatically start ReplaySorcery when graphical-session.target starts.";
      };

      settings = mkOption {
        type = attrsOf (oneOf [ str int ]);
        default = {};
        description = "System-wide configuration for ReplaySorcery (/etc/replay-sorcery.conf).";
        example = literalExpression ''
          {
            videoInput = "hwaccel"; # requires `services.replay-sorcery.enableSysAdminCapability = true`
            videoFramerate = 60;
          }
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ pkgs.replay-sorcery ];
      etc."replay-sorcery.conf".text = configFile;
    };

    security.wrappers = mkIf cfg.enableSysAdminCapability {
      replay-sorcery = {
        owner = "root";
        group = "root";
        capabilities = "cap_sys_admin+ep";
        source = "${pkgs.replay-sorcery}/bin/replay-sorcery";
      };
    };

    systemd = {
      packages = [ pkgs.replay-sorcery ];
      user.services.replay-sorcery = {
        wantedBy = mkIf cfg.autoStart [ "graphical-session.target" ];
        partOf = mkIf cfg.autoStart [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = mkIf cfg.enableSysAdminCapability [
            "" # Tell systemd to clear the existing ExecStart list, to prevent appending to it.
            "${config.security.wrapperDir}/replay-sorcery"
          ];
        };
      };
    };
  };

  meta = {
    maintainers = with maintainers; [ kira-bruneau ];
  };
}

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.stash;
in
{
  options = {
    services.stash = {
      enable = mkEnableOption "An organizer for your porn, written in Go.";

      package = mkPackageOption pkgs "stash" { };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/stash";
        description = "The state directory where stash stores its metadata, cache and generated files.";
      };

      user = mkOption {
        type = types.str;
        default = "stash";
        description = "User account under which stash runs.";
      };

      group = mkOption {
        type = types.str;
        default = "stash";
        description = "Group under which stash runs.";
      };

      ip = mkOption {
        type = types.str;
        default = "0.0.0.0";
        example = "::1";
        description = "The ip that the server should bind to.";
      };

      port = mkOption {
        type = types.port;
        default = 9999;
        description = "The port that the server should listen on.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Open ports in the firewall for the stash web interface";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.stash = {
      description = "Stash";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        STASH_HOST = cfg.ip;
        STASH_PORT = toString cfg.port;
        STASH_GENERATED = "${cfg.dataDir}/generated";
        STASH_METADATA = "${cfg.dataDir}/metadata";
        STASH_CACHE = "${cfg.dataDir}/cache";
      };
      preStart = ''
        touch ${cfg.dataDir}/config.yml
      '';
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
        WorkingDirectory = cfg.dataDir;
        ExecStart = "${cfg.package}/bin/stash";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    users.users = mkIf (cfg.user == "stash") {
      stash = {
        group = cfg.group;
        home = cfg.dataDir;
        createHome = true;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "stash") {
      stash = { };
    };
  };
}

{ config, lib, pkgs, ... }:

let cfg = config.services.hydron;
in with lib; {
  options.services.hydron = {
    enable = mkEnableOption "hydron";

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/hydron";
      example = "/home/okina/hydron";
      description = "Location where hydron runs and stores data.";
    };

    interval = mkOption {
      type = types.str;
      default = "hourly";
      example = "06:00";
      description = ''
        How often we run hydron import and possibly fetch tags. Runs by default every hour.

        The format is described in
        <citerefentry><refentrytitle>systemd.time</refentrytitle>
        <manvolnum>7</manvolnum></citerefentry>.
      '';
    };

    listenAddress = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "127.0.0.1:8010";
      description = "Listen on a specific IP address and port.";
    };

    importPaths = mkOption {
      type = types.listOf types.path;
      default = [];
      example = [ "/home/okina/Pictures" ];
      description = "Paths that hydron will recursively import.";
    };

    fetchTags = mkOption {
      type = types.bool;
      default = true;
      description = "Fetch tags for imported images and webm from gelbooru.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.hydron = {
      description = "hydron";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        # Ensure folder exists and permissions are correct
        mkdir -p ${escapeShellArg cfg.dataDir}/images
        chmod 750 ${escapeShellArg cfg.dataDir}
        chown -R hydron:hydron ${escapeShellArg cfg.dataDir}
      '';

      serviceConfig = {
        PermissionsStartOnly = true;
        User = "hydron";
        Group = "hydron";
        ExecStart = "${pkgs.hydron}/bin/hydron serve"
        + optionalString (cfg.listenAddress != null) " -a ${cfg.listenAddress}";
      };
    };

    systemd.services.hydron-fetch = {
      description = "Import paths into hydron and possibly fetch tags";

      serviceConfig = {
        Type = "oneshot";
        User = "hydron";
        Group = "hydron";
        ExecStart = "${pkgs.hydron}/bin/hydron import "
        + optionalString cfg.fetchTags "-f "
        + (escapeShellArg cfg.dataDir) + "/images " + (escapeShellArgs cfg.importPaths);
      };
    };

    systemd.timers.hydron-fetch = {
      description = "Automatically import paths into hydron and possibly fetch tags";
      after = [ "network.target" ];
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = cfg.interval;
    };

    users = {
      groups.hydron.gid = config.ids.gids.hydron;
      
      users.hydron = {
        description = "hydron server service user";
        home = cfg.dataDir;
        createHome = true;
        group = "hydron";
        uid = config.ids.uids.hydron;
      };
    };
  };

  meta.maintainers = with maintainers; [ chiiruno ];
}

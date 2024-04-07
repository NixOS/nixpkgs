{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tvheadend;
  dataDir = "/var/lib/tvheadend";
  pidFile = "${dataDir}/tvheadend.pid";

in {
  options = {
    services.tvheadend = {
      enable = mkEnableOption "Tvheadend";

      package = mkPackageOption pkgs "tvheadend" { };

      user = mkOption {
        default = "tvheadend";
        type = types.str;
        description = ''
          User account under which Tvheadend runs.

          ::: {.note}
          If left as the default value this user will automatically be created
          on system activation, otherwise you are responsible for
          ensuring the user exists before the Tvheadend service starts.
          :::
        '';
      };

      group = mkOption {
        default = "tvheadend";
        type = types.str;
        description = ''
          Group under which Tvheadend runs.

          ::: {.note}
          If left as the default value this group will automatically be created
          on system activation, otherwise you are responsible for
          ensuring the user exists before the Tvheadend service starts.
          :::
        '';
      };

      httpPort = mkOption {
        type = types.int;
        default = 9981;
        description = "Port to bind HTTP to.";
      };

      htspPort = mkOption {
        type = types.int;
        default = 9982;
        description = "Port to bind HTSP to.";
      };

      ipv6 = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Listen on IPv6.";
      };

      bindAddr = mkOption {
        type = with types; nullOr str;
        default = null;
        description = "Specify bind address.";
        example = "127.0.0.1";
      };
    };
  };

  config = mkIf cfg.enable {
    environment = { systemPackages = [ cfg.package ]; };

    users.groups.tvheadend = mkIf (cfg.group == "tvheadend") { };

    users.users.tvheadend = mkIf (cfg.user == "tvheadend") {
      description = "Tvheadend Service user";
      home = dataDir;
      createHome = true;
      isSystemUser = true;
      group = cfg.group;
      extraGroups = [ "video" ]; # In order to access tuner adapters.
    };

    systemd.services.tvheadend = {
      description = "Tvheadend TV streaming server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        Type = "forking";
        PIDFile = pidFile;
        Restart = "always";
        RestartSec = 5;
        User = cfg.user;
        Group = cfg.group;
        # CLI options reference -
        # https://github.com/tvheadend/tvheadend/blob/ab6ea89b11b1f1a8dcbfd7cfc29d65b3013f2702/src/main.c#L878
        ExecStart = "${cfg.package}/bin/tvheadend " +
          # Specify alternative http port
          "--http_port ${toString cfg.httpPort} " +
          # Specify alternative htsp port
          "--htsp_port ${toString cfg.htspPort} " +
          # Fork and run as daemon
          "-f " +
          # First run.
          "-C " +
          # Alternate PID path
          "-p ${pidFile} " +
          # Run as user
          "-u ${cfg.user} " +
          # Run as group
          "-g ${cfg.group} " +
          # Specify bind address
          optionalString (cfg.bindAddr != null) "--bindaddr ${cfg.bindAddr} " +
          # Listen on IPv6
          optionalString (cfg.ipv6) "--ipv6 ";
        ExecStop = "${pkgs.coreutils}/bin/rm ${pidFile}";
      };
    };
  };
}

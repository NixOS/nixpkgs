{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.caddy;
  configFile = pkgs.writeText "Caddyfile" cfg.config;
in {
  options.services.caddy = {
    enable = mkEnableOption "Caddy web server";

    config = mkOption {
      default = "";
      example = ''
        example.com {
        gzip
        minify
        log syslog

        root /srv/http
        }
      '';
      type = types.lines;
      description = "Verbatim Caddyfile to use";
    };

    ca = mkOption {
      default = "https://acme-v02.api.letsencrypt.org/directory";
      example = "https://acme-staging-v02.api.letsencrypt.org/directory";
      type = types.str;
      description = "Certificate authority ACME server. The default (Let's Encrypt production server) should be fine for most people.";
    };

    email = mkOption {
      default = "";
      type = types.str;
      description = "Email address (for Let's Encrypt certificate)";
    };

    agree = mkOption {
      default = false;
      type = types.bool;
      description = "Agree to Let's Encrypt Subscriber Agreement";
    };

    dataDir = mkOption {
      default = "/var/lib/caddy";
      type = types.path;
      description = ''
        The data directory, for storing certificates. Before 17.09, this
        would create a .caddy directory. With 17.09 the contents of the
        .caddy directory are in the specified data directory instead.
      '';
    };

    package = mkOption {
      default = pkgs.caddy;
      defaultText = "pkgs.caddy";
      type = types.package;
      description = "Caddy package to use.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.caddy = {
      description = "Caddy web server";
      # upstream unit: https://github.com/caddyserver/caddy/blob/master/dist/init/linux-systemd/caddy.service
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ]; # systemd-networkd-wait-online.service
      wantedBy = [ "multi-user.target" ];
      environment = mkIf (versionAtLeast config.system.stateVersion "17.09")
        { CADDYPATH = cfg.dataDir; };
      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/caddy -log stdout -log-timestamps=false \
            -root=/var/tmp -conf=${configFile} \
            -ca=${cfg.ca} -email=${cfg.email} ${optionalString cfg.agree "-agree"}
        '';
        ExecReload = "${pkgs.coreutils}/bin/kill -USR1 $MAINPID";
        Type = "simple";
        User = "caddy";
        Group = "caddy";
        Restart = "on-abnormal";
        StartLimitIntervalSec = 14400;
        StartLimitBurst = 10;
        AmbientCapabilities = "cap_net_bind_service";
        CapabilityBoundingSet = "cap_net_bind_service";
        NoNewPrivileges = true;
        LimitNPROC = 512;
        LimitNOFILE = 1048576;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHome = true;
        ProtectSystem = "full";
        ReadWriteDirectories = cfg.dataDir;
        KillMode = "mixed";
        KillSignal = "SIGQUIT";
        TimeoutStopSec = "5s";
      };
    };

    users.users.caddy = {
      group = "caddy";
      uid = config.ids.uids.caddy;
      home = cfg.dataDir;
      createHome = true;
    };

    users.groups.caddy.gid = config.ids.uids.caddy;
  };
}

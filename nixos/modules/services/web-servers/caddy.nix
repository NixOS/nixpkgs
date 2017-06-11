{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.caddy;
  configFile = pkgs.writeText "Caddyfile" cfg.config;
in
{
  options.services.caddy = {
    enable = mkEnableOption "Caddy web server";

    config = mkOption {
      description = "Verbatim Caddyfile to use";
    };

    ca = mkOption {
      default = "https://acme-v01.api.letsencrypt.org/directory";
      example = "https://acme-staging.api.letsencrypt.org/directory";
      type = types.string;
      description = "Certificate authority ACME server. The default (Let's Encrypt production server) should be fine for most people.";
    };

    email = mkOption {
      default = "";
      type = types.string;
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
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = mkIf (versionAtLeast config.system.stateVersion "17.09")
        { CADDYPATH = cfg.dataDir; };
      serviceConfig = {
        ExecStart = ''
          ${cfg.package.bin}/bin/caddy -root=/var/tmp -conf=${configFile} \
            -ca=${cfg.ca} -email=${cfg.email} ${optionalString cfg.agree "-agree"}
        '';
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        Type = "simple";
        User = "caddy";
        Group = "caddy";
        Restart = "on-failure";
        StartLimitInterval = 86400;
        StartLimitBurst = 5;
        AmbientCapabilities = "cap_net_bind_service";
        CapabilityBoundingSet = "cap_net_bind_service";
        NoNewPrivileges = true;
        LimitNPROC = 64;
        LimitNOFILE = 1048576;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHome = true;
        ProtectSystem = "full";
        ReadWriteDirectories = cfg.dataDir;
      };
    };

    users.extraUsers.caddy = {
      group = "caddy";
      uid = config.ids.uids.caddy;
      home = cfg.dataDir;
      createHome = true;
    };

    users.extraGroups.caddy.gid = config.ids.uids.caddy;
  };
}

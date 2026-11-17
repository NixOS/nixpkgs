{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.remark42;
  siteList = lib.concatStringsSep "," cfg.sites;
in
{
  options.services.remark42 = {
    enable = lib.mkEnableOption "Remark42 commenting server";

    package = lib.mkPackageOption pkgs "remark42" { };

    remarkUrl = lib.mkOption {
      type = lib.types.str;
      example = "https://comments.example.com";
      description = ''
        Public URL of this Remark42 instance. This is passed to the backend as
        `REMARK_URL` and should match the frontend embed config `host`.
      '';
    };

    sites = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "remark" ];
      example = [
        "blog"
        "docs"
      ];
      description = ''
        Site IDs served by this instance (passed as `SITE`, comma-separated).
        The frontend embed config `site_id` must match one of these values.
      '';
    };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = "Bind address (`REMARK_ADDRESS`).";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Listen port (`REMARK_PORT`).";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/remark42";
      description = ''
        Working directory for Remark42. Data files are stored here and
        automatic backups will be created in this directory by default.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/remark42.env";
      description = ''
        Optional environment file in systemd `EnvironmentFile=` format.
        Use this for secrets to avoid storing them in the Nix store.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        AUTH_ANON = "true";
      };
      description = "Extra environment variables passed to Remark42.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for `port`.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.sites != [ ];
        message = "services.remark42.sites must contain at least one site ID.";
      }
      {
        assertion = cfg.environmentFile != null || (cfg.settings ? SECRET);
        message = ''
          Remark42 requires SECRET.
          Provide it via services.remark42.environmentFile (recommended),
          or via services.remark42.settings.SECRET (not recommended).
        '';
      }
    ];

    users.groups.remark42 = { };
    users.users.remark42 = {
      isSystemUser = true;
      group = "remark42";
      home = cfg.dataDir;
      createHome = true;
      description = "Remark42 service user";
    };

    systemd.services.remark42 = {
      description = "Remark42 commenting server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = cfg.settings // {
        REMARK_URL = cfg.remarkUrl;
        SITE = siteList;
        REMARK_ADDRESS = cfg.listenAddress;
        REMARK_PORT = toString cfg.port;
      };

      serviceConfig = {
        Type = "simple";
        User = "remark42";
        Group = "remark42";

        WorkingDirectory = cfg.dataDir;
        ExecStart = "${cfg.package}/bin/remark42 server";

        Restart = "on-failure";
        RestartSec = "2s";
      }
      // lib.optionalAttrs (cfg.environmentFile != null) {
        EnvironmentFile = cfg.environmentFile;
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };
}

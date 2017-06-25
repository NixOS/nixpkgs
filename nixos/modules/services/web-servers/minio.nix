{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.minio;
in
{
  meta.maintainers = [ maintainers.bachp ];

  options.services.minio = {
    enable = mkEnableOption "Minio Object Storage";

    listenAddress = mkOption {
      default = ":9000";
      type = types.str;
      description = "Listen on a specific IP address and port.";
    };

    dataDir = mkOption {
      default = "/var/lib/minio/data";
      type = types.path;
      description = "The data directory, for storing the objects.";
    };

    configDir = mkOption {
      default = "/var/lib/minio/config";
      type = types.path;
      description = "The config directory, for the access keys and other settings.";
    };

    package = mkOption {
      default = pkgs.minio;
      defaultText = "pkgs.minio";
      type = types.package;
      description = "Minio package to use.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.minio = {
      description = "Minio Object Storage";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        # Make sure directories exist with correct owner
        mkdir -p ${cfg.configDir}
        chown -R minio:minio ${cfg.configDir}
        mkdir -p ${cfg.dataDir}
        chown minio:minio ${cfg.dataDir}
      '';
      serviceConfig = {
        PermissionsStartOnly = true;
        ExecStart = "${cfg.package}/bin/minio server --address ${cfg.listenAddress} --config-dir=${cfg.configDir} ${cfg.dataDir}";
        Type = "simple";
        User = "minio";
        Group = "minio";
        LimitNOFILE = 65536;
      };
    };

    users.extraUsers.minio = {
      group = "minio";
      uid = config.ids.uids.minio;
    };

    users.extraGroups.minio.gid = config.ids.uids.minio;
  };
}

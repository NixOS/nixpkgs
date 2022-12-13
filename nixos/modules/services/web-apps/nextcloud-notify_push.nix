{ config, lib, pkgs, ... }:

let
  cfg = config.services.nextcloud.notify_push;
in
{
  options.services.nextcloud.notify_push = {
    enable = lib.mkEnableOption (lib.mdDoc "Notify push");
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nextcloud-notify_push;
      defaultText = lib.literalMD "pkgs.nextcloud-notify_push";
      description = lib.mdDoc "Which package to use for notify_push";
    };
    socketPath = lib.mkOption {
      type = lib.types.str;
      default = "/run/nextcloud-notify_push/sock";
      description = lib.mdDoc "Socket path to use for notify_push";
    };
    logLevel = lib.mkOption {
      type = lib.types.enum [ "error" "warn" "info" "debug" "trace" ];
      default = "error";
      description = lib.mdDoc "Log level";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.nextcloud-notify_push = let
      nextcloudUrl = "http${lib.optionalString config.services.nextcloud.https "s"}://${config.services.nextcloud.hostName}";
    in {
      description = "Push daemon for Nextcloud clients";
      documentation = [ "https://github.com/nextcloud/notify_push" ];
      after = [ "phpfpm-nextcloud.service" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        NEXTCLOUD_URL = nextcloudUrl;
        SOCKET_PATH = cfg.socketPath;
        LOG = cfg.logLevel;
      };
      postStart = ''
        ${config.services.nextcloud.occ}/bin/nextcloud-occ notify_push:setup ${nextcloudUrl}/push
      '';
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/notify_push --glob-config ${config.services.nextcloud.datadir}/config/config.php";
        User = "nextcloud";
        Group = "nextcloud";
        RuntimeDirectory = [ "nextcloud-notify_push" ];
      };
    };

    services.nginx.virtualHosts.${config.services.nextcloud.hostName}.locations."^~ /push/" = {
      proxyPass = "http://unix:${cfg.socketPath}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
  };
}

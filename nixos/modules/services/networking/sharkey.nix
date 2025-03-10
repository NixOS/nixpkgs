{ config, lib, pkgs, ... }:

let
  cfg = config.services.sharkey;

  settingsFormat = pkgs.formats.yaml {};
  configFile = settingsFormat.generate "sharkey-config.yml" cfg.settings;
in {
  options = {
    services.sharkey = with lib; {
      enable = mkEnableOption "sharkey";

      settings = mkOption {
        type = settingsFormat.type;
        default = {};
        description = ''
          Configuration for Sharkey, see
          <link xlink:href="https://activitypub.software/TransFem-org/Sharkey/-/blob/develop/.config/example.yml"/>
          for supported settings.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    documentation.enable = false;

    systemd.services.sharkey = {
      after = [ "network-online.target" "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        ${pkgs.envsubst}/bin/envsubst -i "${configFile}" > /run/sharkey/default.yml
        cd ${pkgs.sharkey}/data
      '';
      serviceConfig = {
        StateDirectory = "sharkey";
        StateDirectoryMode = "700";
        RuntimeDirectory = "sharkey";
        RuntimeDirectoryMode = "700";
        ExecStart = "${pkgs.sharkey}/bin/sharkey";
        TimeoutSec = 60;

        # implies RemoveIPC=, PrivateTmp=, NoNewPrivileges=, RestrictSUIDSGID=,
        # ProtectSystem=strict, ProtectHome=read-only
        DynamicUser = true;
        LockPersonality = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectProc = "invisible";
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX AF_NETLINK";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service";
        UMask = "0077";
      };
      environment.NODE_ENV = "production";
    };
  };
  meta.maintainers = with lib.maintainers; [ aprl ];
  meta.doc = ./sharkey.md;
}


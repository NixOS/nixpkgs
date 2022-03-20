{ config, lib, pkgs, ... }:

let
  cfg = config.services.misskey;

  settingsFormat = pkgs.formats.yaml {};
  configFile = settingsFormat.generate "misskey-config.yml" cfg.settings;
in {
  options = {
    services.misskey = with lib; {
      enable = mkEnableOption "misskey";

      settings = mkOption {
        type = settingsFormat.type;
        default = {};
        description = ''
          Configuration for Misskey, see
          <link xlink:href="https://github.com/misskey-dev/misskey/blob/develop/.config/example.yml"/>
          for supported settings.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    documentation.enable = false;

    systemd.services.misskey = {
      after = [ "network-online.target" "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        ${pkgs.envsubst}/bin/envsubst -i "${configFile}" > /run/misskey/default.yml
        cd ${pkgs.misskey}/packages/backend
        ./node_modules/.bin/typeorm migration:run
      '';
      serviceConfig = {
        StateDirectory = "misskey";
        StateDirectoryMode = "700";
        RuntimeDirectory = "misskey";
        RuntimeDirectoryMode = "700";
        ExecStart = "${pkgs.nodejs}/bin/node --experimental-json-modules ${pkgs.misskey}/packages/backend/built/index.js";
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
  meta.maintainers = with lib.maintainers; [ yuka ];
  meta.doc = ./misskey.xml;
}

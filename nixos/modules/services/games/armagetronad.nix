{
  config,
  lib,
  pkgs,
  ...
}:
let

  mkValueStringArmagetron =
    v:
    if lib.isInt v then
      toString v
    else if lib.isFloat v then
      toString v
    else if lib.isString v then
      v
    else if true == v then
      "1"
    else if false == v then
      "0"
    else if null == v then
      ""
    else
      throw "unsupported type: ${builtins.typeOf v}: ${(lib.generators.toPretty { } v)}";

  settingsFormat = pkgs.formats.keyValue {
    mkKeyValue = lib.generators.mkKeyValueDefault {
      mkValueString = mkValueStringArmagetron;
    } " ";
    listsAsDuplicateKeys = true;
  };

  cfg = config.services.armagetronad;
  enabledServers = lib.filterAttrs (n: v: v.enable) cfg.servers;
  nameToId = serverName: "armagetronad-${serverName}";
  getStateDirectory = serverName: "armagetronad/${serverName}";
  getServerRoot = serverName: "/var/lib/${getStateDirectory serverName}";
in
{
  options = {
    services.armagetronad = {
      servers = lib.mkOption {
        description = "Armagetron server definitions.";
        default = { };
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              enable = lib.mkEnableOption "armagetronad";

              package = lib.mkPackageOption pkgs "armagetronad-dedicated" {
                example = ''
                  pkgs.armagetronad."0.2.9-sty+ct+ap".dedicated
                '';
                extraDescription = ''
                  Ensure that you use a derivation which contains the path `bin/armagetronad-dedicated`.
                '';
              };

              host = lib.mkOption {
                type = lib.types.str;
                default = "0.0.0.0";
                description = "Host to listen on. Used for SERVER_IP.";
              };

              port = lib.mkOption {
                type = lib.types.port;
                default = 4534;
                description = "Port to listen on. Used for SERVER_PORT.";
              };

              dns = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "DNS address to use for this server. Optional.";
              };

              openFirewall = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Set to true to open the configured UDP port for Armagetron Advanced.";
              };

              name = lib.mkOption {
                type = lib.types.str;
                description = "The name of this server.";
              };

              settings = lib.mkOption {
                type = settingsFormat.type;
                default = { };
                description = ''
                  Armagetron Advanced server rules configuration. Refer to:
                  <https://wiki.armagetronad.org/index.php?title=Console_Commands>
                  or `armagetronad-dedicated --doc` for a list.

                  This attrset is used to populate `settings_custom.cfg`; see:
                  <https://wiki.armagetronad.org/index.php/Configuration_Files>
                '';
                example = lib.literalExpression ''
                  {
                    CYCLE_RUBBER = 40;
                  }
                '';
              };

              roundSettings = lib.mkOption {
                type = settingsFormat.type;
                default = { };
                description = ''
                  Armagetron Advanced server per-round configuration. Refer to:
                  <https://wiki.armagetronad.org/index.php?title=Console_Commands>
                  or `armagetronad-dedicated --doc` for a list.

                  This attrset is used to populate `everytime.cfg`; see:
                  <https://wiki.armagetronad.org/index.php/Configuration_Files>
                '';
                example = lib.literalExpression ''
                  {
                    SAY = [
                      "Hosted on NixOS"
                      "https://nixos.org"
                      "iD Tech High Rubber rul3z!! Happy New Year 2008!!1"
                    ];
                  }
                '';
              };
            };
          }
        );
      };
    };
  };

  config = lib.mkIf (enabledServers != { }) {
    systemd.tmpfiles.settings = lib.mkMerge (
      lib.mapAttrsToList (
        serverName: serverCfg:
        let
          serverId = nameToId serverName;
          serverRoot = getServerRoot serverName;
          serverInfo = (
            {
              SERVER_IP = serverCfg.host;
              SERVER_PORT = serverCfg.port;
              SERVER_NAME = serverCfg.name;
            }
            // (lib.optionalAttrs (serverCfg.dns != null) { SERVER_DNS = serverCfg.dns; })
          );
          customSettings = serverCfg.settings;
          everytimeSettings = serverCfg.roundSettings;

          serverInfoCfg = settingsFormat.generate "server_info.${serverName}.cfg" serverInfo;
          customSettingsCfg = settingsFormat.generate "settings_custom.${serverName}.cfg" customSettings;
          everytimeSettingsCfg = settingsFormat.generate "everytime.${serverName}.cfg" everytimeSettings;
        in
        {
          "10-armagetronad-${serverId}" = {
            "${serverRoot}/data" = {
              d = {
                group = serverId;
                user = serverId;
                mode = "0750";
              };
            };
            "${serverRoot}/settings" = {
              d = {
                group = serverId;
                user = serverId;
                mode = "0750";
              };
            };
            "${serverRoot}/var" = {
              d = {
                group = serverId;
                user = serverId;
                mode = "0750";
              };
            };
            "${serverRoot}/resource" = {
              d = {
                group = serverId;
                user = serverId;
                mode = "0750";
              };
            };
            "${serverRoot}/input" = {
              "f+" = {
                group = serverId;
                user = serverId;
                mode = "0640";
              };
            };
            "${serverRoot}/settings/server_info.cfg" = {
              "L+" = {
                argument = "${serverInfoCfg}";
              };
            };
            "${serverRoot}/settings/settings_custom.cfg" = {
              "L+" = {
                argument = "${customSettingsCfg}";
              };
            };
            "${serverRoot}/settings/everytime.cfg" = {
              "L+" = {
                argument = "${everytimeSettingsCfg}";
              };
            };
          };
        }
      ) enabledServers
    );

    systemd.services = lib.mkMerge (
      lib.mapAttrsToList (
        serverName: serverCfg:
        let
          serverId = nameToId serverName;
        in
        {
          "armagetronad-${serverName}" = {
            description = "Armagetron Advanced Dedicated Server for ${serverName}";
            wants = [ "basic.target" ];
            after = [
              "basic.target"
              "network.target"
              "multi-user.target"
            ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig =
              let
                serverRoot = getServerRoot serverName;
              in
              {
                Type = "simple";
                StateDirectory = getStateDirectory serverName;
                ExecStart = "${lib.getExe serverCfg.package} --daemon --input ${serverRoot}/input --userdatadir ${serverRoot}/data --userconfigdir ${serverRoot}/settings --vardir ${serverRoot}/var --autoresourcedir ${serverRoot}/resource";
                Restart = "on-failure";
                CapabilityBoundingSet = "";
                LockPersonality = true;
                NoNewPrivileges = true;
                PrivateDevices = true;
                PrivateTmp = true;
                PrivateUsers = true;
                ProtectClock = true;
                ProtectControlGroups = true;
                ProtectHome = true;
                ProtectHostname = true;
                ProtectKernelLogs = true;
                ProtectKernelModules = true;
                ProtectKernelTunables = true;
                ProtectProc = "invisible";
                ProtectSystem = "strict";
                RestrictNamespaces = true;
                RestrictSUIDSGID = true;
                User = serverId;
                Group = serverId;
              };
          };
        }
      ) enabledServers
    );

    networking.firewall.allowedUDPPorts = lib.unique (
      lib.mapAttrsToList (serverName: serverCfg: serverCfg.port) (
        lib.filterAttrs (serverName: serverCfg: serverCfg.openFirewall) enabledServers
      )
    );

    users.users = lib.mkMerge (
      lib.mapAttrsToList (serverName: serverCfg: {
        ${nameToId serverName} = {
          group = nameToId serverName;
          description = "Armagetron Advanced dedicated user for server ${serverName}";
          isSystemUser = true;
        };
      }) enabledServers
    );

    users.groups = lib.mkMerge (
      lib.mapAttrsToList (serverName: serverCfg: {
        ${nameToId serverName} = { };
      }) enabledServers
    );
  };
}

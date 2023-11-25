{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption mkMerge literalExpression;
  inherit (lib) mapAttrsToList filterAttrs unique recursiveUpdate types;

  mkValueStringArmagetron = with lib; v:
    if isInt v then toString v
    else if isFloat v then toString v
    else if isString v then v
    else if true == v then "1"
    else if false == v then "0"
    else if null == v then ""
    else throw "unsupported type: ${builtins.typeOf v}: ${(lib.generators.toPretty {} v)}";

  settingsFormat = pkgs.formats.keyValue {
    mkKeyValue = lib.generators.mkKeyValueDefault
      {
        mkValueString = mkValueStringArmagetron;
      } " ";
    listsAsDuplicateKeys = true;
  };

  cfg = config.services.armagetronad;
  enabledServers = lib.filterAttrs (n: v: v.enable) cfg.servers;
  nameToId = serverName: "armagetronad-${serverName}";
in
{
  options = {
    services.armagetronad = {
      servers = mkOption {
        description = lib.mdDoc "Armagetron server definitions.";
        default = { };
        type = types.attrsOf (types.submodule {
          options = {
            enable = mkEnableOption (lib.mdDoc "armagetronad");
            package = lib.mkPackageOptionMD pkgs "armagetronad-dedicated" {
              example = ''
                pkgs.armagetronad."0.2.9-sty+ct+ap".dedicated
              '';
              extraDescription = ''
                Ensure that you use a derivation whose evaluation contains the path `bin/armagetronad-dedicated`.
              '';
            };
            host = mkOption {
              type = types.str;
              default = "0.0.0.0";
              description = lib.mdDoc "Host to listen on. Used for SERVER_IP.";
            };
            port = mkOption {
              type = types.port;
              default = 4534;
              description = lib.mdDoc "Port to listen on. Used for SERVER_PORT.";
            };
            dns = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = lib.mdDoc "DNS address to use for this server. Optional.";
            };
            openFirewall = mkOption {
              type = types.bool;
              default = true;
              description = lib.mdDoc "Set to true to open a UDP port for Armagetron Advanced.";
            };
            name = mkOption {
              type = types.str;
              description = "The name of this server.";
            };
            settings = mkOption {
              type = settingsFormat.type;
              default = { };
              description = lib.mdDoc ''
                Armagetron Advanced server rules configuration. Refer to:
                <https://wiki.armagetronad.org/index.php?title=Console_Commands>
                or `armagetronad-dedicated --doc` for a list.

                This attrset is used to populate `settings_custom.cfg`; see:
                <https://wiki.armagetronad.org/index.php/Configuration_Files>
              '';
              example = literalExpression ''
                {
                  CYCLE_RUBBER = 40;
                }
              '';
            };
            roundSettings = mkOption {
              type = settingsFormat.type;
              default = { };
              description = lib.mdDoc ''
                Armagetron Advanced server per-round configuration. Refer to:
                <https://wiki.armagetronad.org/index.php?title=Console_Commands>
                or `armagetronad-dedicated --doc` for a list.

                This attrset is used to populate `everytime.cfg`; see:
                <https://wiki.armagetronad.org/index.php/Configuration_Files>
              '';
              example = literalExpression ''
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
        });
      };
    };
  };

  config = mkIf (enabledServers != { }) {
    systemd.services = mkMerge (mapAttrsToList
      (serverName: serverCfg:
        let
          serverId = nameToId serverName;
          serverInfo = (
            {
              SERVER_IP = serverCfg.host;
              SERVER_PORT = serverCfg.port;
              SERVER_NAME = serverCfg.name;
            } // (
              if serverCfg.dns != null then { SERVER_DNS = serverCfg.dns; }
              else { }
            )
          );
          customSettings = serverCfg.settings;
          everytimeSettings = serverCfg.roundSettings;

          serverInfoCfg = settingsFormat.generate "server_info.${serverName}.cfg" serverInfo;
          customSettingsCfg = settingsFormat.generate "settings_custom.${serverName}.cfg" customSettings;
          everytimeSettingsCfg = settingsFormat.generate "everytime.${serverName}.cfg" everytimeSettings;
        in
        {
          "armagetronad@${serverName}" = {
            description = "Armagetron Advanced Dedicated Server for ${serverName}";
            wants = [ "basic.target" ];
            after = [ "basic.target" "network.target" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig =
              let
                stateDirectory = "armagetronad/${serverName}";
                serverRoot = "/var/lib/${stateDirectory}";
                preStart = pkgs.writeShellScript "armagetronad-${serverName}-prestart.sh" ''
                  owner="${serverId}:${serverId}"

                  # Create the config directories.
                  for dirname in data settings var resource; do
                    dir="${serverRoot}/$dirname"
                    mkdir -p "$dir"
                    chmod u+rwx,g+rx,o-rwx "$dir"
                    chown "$owner" "$dir"
                  done

                  # Link in the config files if present and non-trivial.
                  ln -sf ${serverInfoCfg}        "${serverRoot}/settings/server_info.cfg"
                  ln -sf ${customSettingsCfg}    "${serverRoot}/settings/settings_custom.cfg"
                  ln -sf ${everytimeSettingsCfg} "${serverRoot}/settings/everytime.cfg"

                  # Create an input file for sending commands to the server.
                  input="${serverRoot}/input"
                  truncate -s0 "$input"
                  chmod u+rw,g+r,o-rwx "$input"
                  chown "$owner" "$input"
                '';
              in
              {
                Type = "simple";
                StateDirectory = stateDirectory;
                ExecStartPre = preStart;
                ExecStart = "${serverCfg.package}/bin/armagetronad-dedicated --daemon --input ${serverRoot}/input --userdatadir ${serverRoot}/data --userconfigdir ${serverRoot}/settings --vardir ${serverRoot}/var --autoresourcedir ${serverRoot}/resource";
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
        })
      enabledServers
    );

    networking.firewall.allowedUDPPorts =
      unique (mapAttrsToList (serverName: serverCfg: serverCfg.port) (filterAttrs (serverName: serverCfg: serverCfg.openFirewall) enabledServers));

    users.users = mkMerge (mapAttrsToList
      (serverName: serverCfg:
        {
          ${nameToId serverName} = {
            group = nameToId serverName;
            description = "Armagetron Advanced dedicated user for server ${serverName}";
            isSystemUser = true;
          };
        })
      enabledServers
    );

    users.groups = mkMerge (mapAttrsToList
      (serverName: serverCfg:
        {
          ${nameToId serverName} = { };
        })
      enabledServers
    );
  };
}

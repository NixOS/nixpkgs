{
  pkgs,
  lib,
  config,
  options,
  ...
}:

with lib;

let
  cfg = config.services.perses;
  opt = options.services.perses;

  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "config.yaml" cfg.settings;

  mkSchemaPathOption =
    element:
    mkOption {
      type = types.path;
      description = ''
        Path to the Cue schemas of the ${element}.
      '';
      default = "${cfg.package}/cue/schemas/${element}/";
      defaultText = literalExpression ''"''${config.${opt.package}}/cue/${element}/"'';
    };

in
{
  options.services.perses = {
    enable = mkEnableOption "perses";

    dataDir = mkOption {
      description = ''
        The state directory for perses.
      '';
      default = "/var/lib/perses";
      type = types.path;
    };

    package = mkPackageOption pkgs "perses" { };

    port = mkOption {
      type = types.port;
      default = 8080;
      description = ''
        Perses Web interface port.
      '';
    };

    listenAddress = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = ''
        Address to listen on.
      '';
    };

    settings = lib.mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;

        options = {
          database.file = {
            folder = mkOption {
              type = types.path;
              description = ''
                The path to the folder containing the database.
              '';
              default = "${cfg.dataDir}/data/";
              defaultText = literalExpression ''"''${config.${opt.dataDir}}/data/"'';
            };
            extension = mkOption {
              type = types.enum [
                "json"
                "yaml"
              ];
              description = ''
                The file extension and so the file format used when storing and reading data from/to the database.
              '';
              default = "json";
            };
          };

          schemas = {
            panels_path = mkSchemaPathOption "panels";
            queries_path = mkSchemaPathOption "queries";
            datasources_path = mkSchemaPathOption "datasources";
            variables_path = mkSchemaPathOption "variables";
          };
        };
      };
      description = ''
        Perses settings. See <https://perses.dev/perses/docs/configuration/configuration/> for available options.
      '';
      default = { };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.perses = {
      description = "Preses Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];

      script = ''
        exec ${cfg.package}/bin/perses -config '${configFile}' -web.listen-address '${cfg.listenAddress}:${toString cfg.port}'
      '';

      serviceConfig = {
        WorkingDirectory = cfg.dataDir;
        User = "perses";
        Restart = "on-failure";
        RuntimeDirectory = "perses";
        RuntimeDirectoryMode = "0755";

        # Hardening
        AmbientCapabilities = lib.mkIf (cfg.port < 1024) [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = if (cfg.port < 1024) then [ "CAP_NET_BIND_SERVICE" ] else [ "" ];
        DeviceAllow = [ "" ];
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "full";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        UMask = "0027";
      };
    };

    environment.systemPackages = [ cfg.package ];

    users.users.perses = {
      uid = config.ids.uids.perses;
      isSystemUser = true;
      description = "Perses user";
      home = cfg.dataDir;
      createHome = true;
      group = "perses";
    };

    users.groups.perses = {
      gid = config.ids.gids.perses;
    };
  };
}

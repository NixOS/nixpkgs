{
  config,
  lib,
  utils,
  pkgs,
  ...
}:
let
  cfg = config.services.amule;

  settingsFormat = pkgs.formats.ini { };

  inherit (lib)
    mkOption
    mkEnableOption
    mkPackageOption
    types
    optionalAttrs
    mkIf
    mkMerge
    literalExpression
    optionalString
    optionals
    getExe
    ;

  settingsOptions = {
    eMule = {
      Port = mkOption {
        type = types.port;
        default = 4662;
        description = ''
          TCP port for eD2k connections.
          Required for connecting to servers and achieving a High ID.
        '';
      };
      UDPPort = mkOption {
        type = types.port;
        default = 4672;
        description = ''
          UDP port for eD2k traffic (searches, source exchange) and all Kad network communication.
          Essential for a High ID on both networks and proper Kad functioning.
        '';
      };
      TempDir = mkOption {
        type = types.path;
        default = "${cfg.dataDir}/Temp";
        defaultText = literalExpression "\${config.services.amule.dataDir}/Temp";
        description = ''
          Directory where aMule stores incomplete downloads (.part/.part.met files).
        '';
      };
      IncomingDir = mkOption {
        type = types.path;
        default = "${cfg.dataDir}/Incoming";
        defaultText = literalExpression "\${config.services.amule.dataDir}/Incoming";
        description = ''
          Directory where aMule moves completed downloads.
          Files in this directory are automatically shared.
          Ensure the aMule service has write permissions
        '';
      };
      OSDirectory = mkOption {
        type = types.path;
        default = cfg.dataDir;
        defaultText = literalExpression "\${config.services.amule.dataDir}";
        description = "On-disk state directory, probably you don't want to change this";
        internal = true;
      };
    };
    ExternalConnect = {
      AcceptExternalConnections = mkOption {
        type = types.enum [
          0
          1
        ];
        default = 1;
        description = "Whether to accept external connections, if disabled amuled refuses to start";
        internal = true;
      };
      ECPort = mkOption {
        type = types.port;
        default = 4712;
        description = "TCP port for external connections, like remote control via amule-gui";
      };
      ECPassword = mkOption {
        type = types.str;
        default = "";
        description = ''
          MD5 hash of the password, obtainaible with `echo "<password>" | md5sum | cut -d ' ' -f 1`
        '';
      };
    };
    WebServer = {
      Enabled = lib.mkOption {
        type = types.enum [
          0
          1
        ];
        default = 0;
        description = "Set to 1 to enable the web server";
      };
      Password = mkOption {
        type = types.str;
        default = "";
        description = ''
          MD5 hash of the password, obtainaible with `echo "<password>" | md5sum | cut -d ' ' -f 1`
        '';
      };
      Port = mkOption {
        type = types.port;
        default = 4711;
        description = "Web server port";
      };
    };
  };

  webServerEnabled = cfg.settings.WebServer.Enabled == 1;
in
{
  options.services.amule = {
    enable = mkEnableOption "aMule daemon";

    package = mkPackageOption pkgs "amule-daemon" { };

    amuleWebPackage = mkPackageOption pkgs "amule-web" { };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Additional passed arguments";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/amuled";
      description = "Directory holding configuration and by default also incoming and temporary files";
    };

    user = mkOption {
      type = types.str;
      default = "amule";
      description = "The user the aMule daemon should run as";
    };

    group = mkOption {
      type = types.str;
      default = "amule";
      description = "Group under which amule runs";
    };

    openPeerPorts = mkEnableOption "open the peer port(s) in the firewall";

    openExternalConnectPort = mkEnableOption "open the external connect port";

    openWebServerPort = mkEnableOption "open the web server port";

    ExternalConnectPasswordFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        File containing the password for connecting with amule-gui,
        set this only if you didn't set `settings.ExternalConnect.ECPassword`
      '';
    };

    WebServerPasswordFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        File containing the password for connecting to the web server,
        set this only if you didn't set `settings.ExternalConnect.ECPassword`
      '';
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
        options = settingsOptions;
      };
      description = ''
        Free form attribute set for aMule settings.
        The final configuration file is generated merging the default settings with these options.
      '';
      example = literalExpression ''
        {
          eMule = {
            IncomingDir = "/mnt/hd/amule/Incoming";
            TempDir = "/mnt/hd/amule/Temp";
          };
          WebServer.Enabled = 1;
        }
      '';
      default = { };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = isNull cfg.ExternalConnectPasswordFile -> cfg.settings.ExternalConnect.ECPassword != "";
        message = "Set only one between `ExternalConnectPasswordFile` and `settings.ExternalConnect.ECPassword`";
      }
    ]
    ++ optionals webServerEnabled [
      {
        assertion = isNull cfg.WebServerPasswordFile -> cfg.settings.WebServer.Password != "";
        message = "Set only one between `ExternalWebServerFile` `settings.WebServer.Password`";
      }
    ];

    users.users = optionalAttrs (cfg.user == "amule") {
      amule = {
        group = cfg.group;
        description = "aMule user";
        isSystemUser = true;
        uid = config.ids.uids.amule;
      };
    };

    users.groups = optionalAttrs (cfg.group == "amule") {
      amule.gid = config.ids.gids.amule;
    };

    systemd.tmpfiles.settings."10-amuled".${cfg.dataDir}.d = {
      inherit (cfg) user group;
      mode = "0755";
    };

    services.amule.settings = {
      eMule.AppVersion = lib.getVersion cfg.package;
    };

    systemd.services.amuled = {
      description = "AMule daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.crudini ];

      preStart = ''
        AMULE_CONF="${cfg.dataDir}/amule.conf"

        if [ ! -f "$AMULE_CONF" ]; then
          echo "First run detected: starting aMule to generate default configuration..."
          echo "aMule will fail with an error - this is expected and normal"
          rm -f ${cfg.dataDir}/lastversion
          set +e
          ${getExe cfg.package} --config-dir ${cfg.dataDir}
          set -e
        fi
      ''
      + (lib.concatMapAttrsStringSep "" (
        section:
        lib.concatMapAttrsStringSep "" (
          param: value: ''
            crudini --inplace --set "$AMULE_CONF" "${section}" "${param}" "${builtins.toString value}"
          ''
        )
      ) cfg.settings)
      + optionalString (!isNull cfg.ExternalConnectPasswordFile) ''
        EC_PASSWORD=$(cat ${cfg.ExternalConnectPasswordFile} | md5sum | cut -d ' ' -f 1)
        crudini --inplace --set "$AMULE_CONF" "ExternalConnect" "ECPassword" "$EC_PASSWORD"
      ''
      + optionalString (!isNull cfg.WebServerPasswordFile) ''
        WEB_PASSWORD=$(cat ${cfg.WebServerPasswordFile} | md5sum | cut -d ' ' -f 1)
        crudini --inplace --set "$AMULE_CONF" "WebServer" "Password" "$WEB_PASSWORD"
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;

        ExecStart = utils.escapeSystemdExecArgs (
          [
            (getExe cfg.package)
            "--config-dir"
            cfg.dataDir
          ]
          ++ optionals webServerEnabled [ "--use-amuleweb=${getExe cfg.amuleWebPackage}" ]
          ++ cfg.extraArgs
        );

        Restart = "on-failure";
        RestartSec = "5s";

        # Hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        DevicePolicy = "closed";
        ProtectSystem = "strict";
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ReadWritePaths = [
          cfg.dataDir
          cfg.settings.eMule.TempDir
          cfg.settings.eMule.IncomingDir
        ];
        RestrictAddressFamilies = "AF_INET";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        LockPersonality = true;
      };
    };

    networking.firewall = mkMerge [
      (mkIf cfg.openPeerPorts {
        allowedTCPPorts = [ cfg.settings.eMule.Port ];
        allowedUDPPorts = [ cfg.settings.eMule.UDPPort ];
      })
      (mkIf cfg.openWebServerPort {
        allowedTCPPorts = [ cfg.settings.WebServer.Port ];
      })
    ];
  };

  meta = {
    maintainers = with lib.maintainers; [ aciceri ];
    doc = ./amuled.md;
  };
}

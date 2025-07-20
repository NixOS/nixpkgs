{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.paisa;
  settingsFormat = pkgs.formats.yaml { };

  args = lib.concatStringsSep " " [
    "--config /var/lib/paisa/paisa.yaml"
  ];

  settings =
    if (cfg.settings != null) then
      builtins.removeAttrs
        (
          cfg.settings
          // {
            journal_path = cfg.settings.dataDir + cfg.settings.journalFile;
            db_path = cfg.settings.dataDir + cfg.settings.dbFile;
          }
        )
        [
          "dataDir"
          "journalFile"
          "dbFile"
        ]
    else
      null;

  configFile = (settingsFormat.generate "paisa.yaml" settings).overrideAttrs (_: {
    checkPhase = "";
  });
in
{
  options.services.paisa = with lib.types; {
    enable = lib.mkEnableOption "Paisa personal finance manager";

    package = lib.mkPackageOption pkgs "paisa" { };

    openFirewall = lib.mkOption {
      default = false;
      type = bool;
      description = "Open ports in the firewall for the Paisa web server.";
    };

    mutableSettings = lib.mkOption {
      default = true;
      type = bool;
      description = ''
        Allow changes made on the web interface to persist between service
        restarts.
      '';
    };

    host = lib.mkOption {
      type = str;
      default = "0.0.0.0";
      description = "Host bind IP address.";
    };

    port = lib.mkOption {
      type = port;
      default = 7500;
      description = "Port to serve Paisa on.";
    };

    settings = lib.mkOption {
      default = null;
      type = nullOr (submodule {
        freeformType = settingsFormat.type;
        options = {
          dataDir = lib.mkOption {
            type = lib.types.str;
            default = "/var/lib/paisa/";
            description = "Path to paisa data directory.";
          };

          journalFile = lib.mkOption {
            type = lib.types.str;
            default = "main.ledger";
            description = "Filename of the main journal / ledger file.";
          };

          dbFile = lib.mkOption {
            type = lib.types.str;
            default = "paisa.sqlite3";
            description = "Filename of the Paisa database.";
          };

        };
      });
      description = ''
        Paisa configuration. Please refer to
        <https://paisa.fyi/reference/config/> for details.

        On start and if `mutableSettings` is `true`, these options are merged
        into the configuration file on start, taking precedence over
        configuration changes made on the web interface.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    assertions = [ ];

    systemd.services.paisa = {
      description = "Paisa: Web Application";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      unitConfig = {
        StartLimitIntervalSec = 5;
        StartLimitBurst = 10;
      };

      preStart = lib.optionalString (settings != null) ''
        if [ -e "$STATE_DIRECTORY/paisa.yaml" ] && [ "${toString cfg.mutableSettings}" = "1" ]; then
          # do not write directly to the config file
          ${lib.getExe pkgs.yaml-merge} "$STATE_DIRECTORY/paisa.yaml" "${configFile}" > "$STATE_DIRECTORY/paisa.yaml.tmp"
          mv "$STATE_DIRECTORY/paisa.yaml.tmp" "$STATE_DIRECTORY/paisa.yaml"
        else
          cp --force "${configFile}" "$STATE_DIRECTORY/paisa.yaml"
          chmod 600 "$STATE_DIRECTORY/paisa.yaml"
        fi
      '';

      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${lib.getExe cfg.package} serve ${args}";
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        Restart = "always";
        RestartSec = 5;
        RuntimeDirectory = "paisa";
        StateDirectory = "paisa";
      };
    };
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };

  meta = {
    maintainers = with lib.maintainers; [ skowalak ];
    doc = ./paisa.md;
  };
}

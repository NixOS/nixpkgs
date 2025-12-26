{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.gokapi;
  settingsFormat = pkgs.formats.json { };
  userSettingsFile = settingsFormat.generate "generated-config.json" cfg.settings;
in
{
  options.services.gokapi = {
    enable = lib.mkEnableOption "Lightweight selfhosted Firefox Send alternative without public upload";

    mutableSettings = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Allow changes to the program config made by the program to persist between restarts.
        If disabled all required values must be set using nix, and all changes to config format over application updates must be resolved by user.
      '';
    };

    package = lib.mkPackageOption pkgs "gokapi" { };

    environment = lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf (lib.types.either lib.types.str lib.types.int);
        options = {
          GOKAPI_CONFIG_DIR = lib.mkOption {
            type = lib.types.str;
            default = "%S/gokapi/config";
            description = "Sets the directory for the config file.";
          };
          GOKAPI_CONFIG_FILE = lib.mkOption {
            type = lib.types.str;
            default = "config.json";
            description = "Sets the filename for the config file.";
          };
          GOKAPI_DATA_DIR = lib.mkOption {
            type = lib.types.str;
            default = "%S/gokapi/data";
            description = "Sets the directory for the data.";
          };
          GOKAPI_PORT = lib.mkOption {
            type = lib.types.port;
            default = 53842;
            description = "Sets the port of the service.";
          };
        };
      };
      default = { };
      description = ''
        Environment variables to be set for the gokapi service. Can use systemd specifiers.
        For full list see <https://gokapi.readthedocs.io/en/latest/advanced.html#environment-variables>.
      '';
    };
    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options = { };
      };
      default = { };
      description = ''
        Configuration settings for the generated config json file.
        See <https://gokapi.readthedocs.io/en/latest/advanced.html#config-json> for more information
      '';
    };
    settingsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Path to config file to parse and append to settings.
        Largely useful for loading secrets from a file not in the nix store. Can use systemd specifiers.
        See <https://gokapi.readthedocs.io/en/latest/advanced.html#config-json> for more information
      '';
    };

  };

  config = lib.mkIf cfg.enable {
    systemd.services.gokapi = {
      wantedBy = [ "default.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      environment = lib.mapAttrs (_: value: toString value) cfg.environment;
      unitConfig = {
        Description = "gokapi service";
      };
      serviceConfig = {
        ExecStartPre =
          let
            updateScript = lib.getExe (
              pkgs.writeShellApplication {
                name = "merge-config";
                runtimeInputs = with pkgs; [ jq ];
                text = ''
                  echo "Running merge-config"
                  mutableSettings="$1"
                  statefulSettingsFile="$2"
                  settingsFile="$3"
                  if [[ "$mutableSettings" == true ]]; then
                    if [[ -f "$statefulSettingsFile" ]]; then
                      echo "Updating stateful config file"
                      merged="$(jq -s '.[0] * .[1]' "$statefulSettingsFile" ${userSettingsFile})"
                      echo "$merged" > "$statefulSettingsFile"
                    fi
                  else
                    echo "Overwriting stateful config file"
                    mkdir -p "$(dirname "$statefulSettingsFile")"
                    cat ${userSettingsFile} > "$statefulSettingsFile"
                  fi
                  if [ "$settingsFile" != "null" ]; then
                    echo "Merging settings file into current stateful settings file"
                    merged="$(jq -s '.[0] * .[1]' "$statefulSettingsFile" "$settingsFile")"
                    echo "$merged" > "$statefulSettingsFile"
                  fi
                '';
              }
            );
          in
          lib.strings.concatStringsSep " " [
            updateScript
            (lib.boolToString cfg.mutableSettings)
            "${cfg.environment.GOKAPI_CONFIG_DIR}/${cfg.environment.GOKAPI_CONFIG_FILE}"
            (if (cfg.settingsFile == null) then "null" else cfg.settingsFile)
          ];
        ExecStart = lib.getExe cfg.package;
        RestartSec = 30;
        DynamicUser = true;
        PrivateTmp = true;
        StateDirectory = "gokapi";
        CacheDirectory = "gokapi";
        Restart = "on-failure";
      };
    };
  };
  meta.maintainers = with lib.maintainers; [
    delliott
  ];
}

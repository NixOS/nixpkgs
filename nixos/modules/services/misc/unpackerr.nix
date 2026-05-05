{
  config,
  pkgs,
  lib,
  utils,
  ...
}:

let
  cfg = config.services.unpackerr;
  configFormat = pkgs.formats.toml { };
  configFile = configFormat.generate "unpackerr.conf" cfg.settings;
  inherit (lib)
    mkEnableOption
    mkOption
    mkPackageOption
    mkIf
    getExe
    ;
  inherit (lib.types) types;
in
{
  options = {
    services.unpackerr = {
      enable = mkEnableOption "Unpackerr";

      settings = mkOption {
        type = configFormat.type;
        default = {
          # Config needs to be non-empty, otherwise unpackerr
          # crashes. debug=false is the default value.
          debug = false;
        };
        example = {
          radarr = [
            {
              url = "http://127.0.0.1:8989";
              api_key = "0123456789abcdef0123456789abcdef";
            }
          ];
          sonarr = [
            {
              url = "http://127.0.0.1:7878";
              api_key = "0123456789abcdef0123456789abcdef";
            }
          ];
        };
        description = ''
          Unpackerr TOML configuration as a Nix attribute set.
          Refer to [Unpackerr docs](https://unpackerr.zip/docs/install/configuration) for details.
          For setting secrets refer to this [section](https://unpackerr.zip/docs/install/configuration/#secrets-and-passwords).
        '';
      };

      environmentFiles = mkOption {
        type = types.listOf types.path;
        default = [ ];
        example = [ "/run/secrets/unpackerr.env" ];
        description = ''
          Environment file to pass secret configuration values.
          Refer to [Unpackerr docs](https://unpackerr.zip/docs/install/configuration) for details.
          For setting secrets refer to this [section](https://unpackerr.zip/docs/install/configuration/#secrets-and-passwords).
        '';
      };

      user = mkOption {
        type = types.str;
        default = "unpackerr";
        description = "User account under which Unpackerr runs.";
      };

      group = mkOption {
        type = types.str;
        default = "unpackerr";
        description = "Group under which Unpackerr runs.";
      };

      package = mkPackageOption pkgs "unpackerr" { };
    };
  };

  config = mkIf cfg.enable {
    # Upstream service: https://github.com/Unpackerr/unpackerr/blob/main/init/systemd/unpackerr.service
    systemd = {
      tmpfiles.settings."10-unpackerr"."/var/lib/unpackerr/unpackerr.conf"."L+" = {
        argument = "${configFile}";
      };
      services.unpackerr = {
        description = "Unpackerr - archive extraction daemon";
        wants = [ "network.target" ];
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        restartTriggers = [ configFile ];
        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          StateDirectory = "unpackerr";
          EnvironmentFile = cfg.environmentFiles;
          ExecStart = utils.escapeSystemdExecArgs [
            (getExe cfg.package)
            "-c"
            "/var/lib/unpackerr/unpackerr.conf"
          ];
          Restart = "always";
          RestartSec = 10;
          UMask = "0002";
          WorkingDirectory = "/tmp";
        };
      };
    };

    users.users = mkIf (cfg.user == "unpackerr") {
      unpackerr = {
        inherit (cfg) group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "unpackerr") {
      unpackerr = { };
    };
  };

  meta = with lib; {
    maintainers = with maintainers; [ Wekuz ];
  };
}

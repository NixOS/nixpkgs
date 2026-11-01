{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  inherit (lib)
    getExe
    getExe'
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    ;
  inherit (lib.types) passwdEntry str;

  cfg = config.services.unpackerr;
  configFormat = pkgs.formats.toml { };
  configFile = configFormat.generate "unpackerr.conf" cfg.settings;
in
{
  options = {
    services.unpackerr = {
      enable = mkEnableOption "Unpackerr";

      settings = mkOption {
        type = configFormat.type;
        default = { };
        example = {
          radarr.main = {
            api_key = "filepath:/run/secrets/radarr/api-key";
            url = "http://127.0.0.1:7878";
          };
          sonarr.main = {
            api_key = "0123456789abcdef0123456789abcdef";
            url = "http://127.0.0.1:8989";
          };
        };
        description = ''
          Unpackerr TOML configuration as a Nix attribute set.
          Refer to [Unpackerr docs](https://unpackerr.zip/docs/install/configuration) for details.
          For setting secrets refer to this [section](https://unpackerr.zip/docs/install/configuration/#secrets-and-passwords).
        '';
      };

      user = mkOption {
        type = passwdEntry str;
        default = "unpackerr";
        description = "User account under which Unpackerr runs.";
      };

      group = mkOption {
        type = passwdEntry str;
        default = "unpackerr";
        description = "Group under which Unpackerr runs.";
      };

      package = mkPackageOption pkgs "unpackerr" { };
    };
  };

  config = mkIf cfg.enable {
    systemd = {
      services.unpackerr = {
        description = "Unpackerr Archive Extractor";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "exec";
          User = cfg.user;
          Group = cfg.group;
          ExecReload = "${getExe' pkgs.coreutils "kill"} -HUP $MAINPID";
          ExecStart = utils.escapeSystemdExecArgs [
            (getExe cfg.package)
            "--config=${configFile}"
          ];
          Restart = "always";
        };
      };
    };

    users = {
      groups = mkIf (cfg.group == "unpackerr") { unpackerr = { }; };
      users = mkIf (cfg.user == "unpackerr") {
        unpackerr = {
          inherit (cfg) group;
          isSystemUser = true;
        };
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    connor-grady
    Wekuz
  ];
}

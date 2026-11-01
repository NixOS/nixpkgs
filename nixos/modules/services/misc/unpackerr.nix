{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    concatMapAttrs
    elem
    getExe
    getExe'
    imap0
    isAttrs
    isList
    literalMD
    mergeAttrsList
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optional
    optionalAttrs
    toUpper
    ;
  inherit (lib.cli) toCommandLineShellGNU;
  inherit (lib.generators) mkValueStringDefault;
  inherit (lib.types)
    attrsOf
    bool
    externalPath
    float
    int
    listOf
    nullOr
    oneOf
    passwdEntry
    str
    submodule
    ;

  cfg = config.services.unpackerr;

  settingsType =
    oneOf [
      bool
      int
      float
      str
      (attrsOf settingsType)
      (listOf settingsType)
    ]
    // {
      description = "Unpackerr setting value";
    };

  mapSettings = [
    "cmdhook"
    "custom_ids"
    "folder"
    "headers"
    "lidarr"
    "radarr"
    "readarr"
    "roles"
    "sonarr"
    "webhook"
  ];
  toEnv =
    keepCase: name: value:
    if isAttrs value then
      concatMapAttrs (
        key: toEnv (!keepCase && elem key mapSettings) "${name}_${if keepCase then key else toUpper key}"
      ) value
    else if isList value then
      mergeAttrsList (imap0 (index: toEnv false "${name}_${toString index}") value)
    else
      optionalAttrs (!isNull value) { ${name} = mkValueStringDefault { } value; };
in
{
  options = {
    services.unpackerr = {
      enable = mkEnableOption "Unpackerr";

      settings = mkOption {
        type = submodule {
          freeformType = settingsType;
          options = {
            log_file = mkOption {
              default = if isNull cfg.logDir then null else "%L/%N/unpackerr.log";
              defaultText = literalMD "`/var/log/unpackerr/unpackerr.log` if [](#opt-services.unpackerr.logDir) is set, otherwise `null`";
              description = "Path of Unpackerr's log file, derived from [](#opt-services.unpackerr.logDir).";
              readOnly = true;
              type = nullOr str;
            };
            webserver.log_file = mkOption {
              default = if isNull cfg.logDir then null else "%L/%N/http.log";
              defaultText = literalMD "`/var/log/unpackerr/http.log` if [](#opt-services.unpackerr.logDir) is set, otherwise `null`";
              description = "Path of Unpackerr's HTTP log file, derived from [](#opt-services.unpackerr.logDir).";
              readOnly = true;
              type = nullOr str;
            };
          };
        };
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
          Unpackerr [settings](https://unpackerr.zip/docs/install/configuration),
          passed as `UN_*` environment variables that override the config file saved by its web UI.
          Names are a variable's segments with field names in lowercase,
          e.g. `sonarr.main.paths = [ "/downloads" ]` sets `UN_SONARR_main_PATHS_0`.
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

      dataDir = mkOption {
        default = "/var/lib/unpackerr";
        description = ''
          Directory for the config file saved by the web UI,
          and for the history if [](#opt-services.unpackerr.logDir) is `null`.
          If not `/var/lib/unpackerr`, it is bind-mounted there.
        '';
        type = externalPath;
      };

      logDir = mkOption {
        default = null;
        description = ''
          Directory for the log files and the history,
          or `null` to log only to the journal.
          If not `/var/log/unpackerr`, it is bind-mounted there.
        '';
        example = "/var/log/unpackerr";
        type = nullOr externalPath;
      };

      package = mkPackageOption pkgs "unpackerr" { };
    };
  };

  config = mkIf cfg.enable {
    systemd = {
      mounts =
        optional (cfg.dataDir != "/var/lib/unpackerr") {
          options = "bind";
          wantedBy = [ "local-fs.target" ];
          what = cfg.dataDir;
          where = "/var/lib/unpackerr";
        }
        ++ optional (!isNull cfg.logDir && cfg.logDir != "/var/log/unpackerr") {
          options = "bind";
          wantedBy = [ "local-fs.target" ];
          what = cfg.logDir;
          where = "/var/log/unpackerr";
        };

      services.unpackerr = {
        description = "Unpackerr Archive Extractor";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        environment = toEnv false "UN" cfg.settings;
        serviceConfig = {
          Type = "exec";
          User = cfg.user;
          Group = cfg.group;
          ExecReload = "${getExe' pkgs.coreutils "kill"} -HUP $MAINPID";
          ExecStart = "${getExe cfg.package} ${
            toCommandLineShellGNU { } { config = "%S/%N/unpackerr.toml"; }
          }";
          LogsDirectory = mkIf (!isNull cfg.logDir) "%N";
          StateDirectory = "%N";
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

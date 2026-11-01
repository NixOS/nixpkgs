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
    mergeAttrsList
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optionalAttrs
    toUpper
    ;
  inherit (lib.cli) toCommandLineShellGNU;
  inherit (lib.generators) mkValueStringDefault;
  inherit (lib.types)
    attrsOf
    bool
    float
    int
    listOf
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
        type = submodule { freeformType = settingsType; };
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

      package = mkPackageOption pkgs "unpackerr" { };
    };
  };

  config = mkIf cfg.enable {
    systemd = {
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

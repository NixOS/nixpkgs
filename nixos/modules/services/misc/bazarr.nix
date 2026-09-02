{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.bazarr;

  secretType = lib.types.attrTag { _secret = lib.mkOption { type = lib.types.externalPath; }; };
  settingsFormat = pkgs.formats.yaml { };
  settingsType =
    lib.types.oneOf [
      secretType
      (lib.types.attrsOf settingsType)
      settingsFormat.type
    ]
    // {
      description = ''${settingsFormat.type.description} or a `{ _secret = "<path>"; }` marker'';
    };

  settings = lib.mapAttrsToListRecursiveCond (
    _: as: !secretType.check as
  ) lib.nameValuePair cfg.settings;
  secretSettings = lib.filter ({ value, ... }: secretType.check value) settings;
  publicSettings = lib.filter ({ value, ... }: !secretType.check value) settings;

  credId = lib.join ".";
  toCredentials = map ({ name, value }: "${credId name}:${value._secret}");

  envName = name: "DYNACONF_${lib.join "__" name}";
  envValue =
    name: value:
    if lib.isBool value then
      "@bool ${lib.boolToString value}"
    else if lib.isFloat value then
      "@float ${toString value}"
    else if lib.isInt value then
      "@int ${toString value}"
    else if lib.isList value then
      "@json ${lib.toJSON value}"
    else if isNull value then
      "@none"
    else if lib.isString value then
      "@str ${value}"
    else
      throw "services.bazarr.settings: unsupported value type ${lib.typeOf value} at ${lib.showAttrPath name}";
  toEnvironment = lib.flip lib.pipe [
    (map ({ name, value }: lib.nameValuePair (envName name) (envValue name value)))
    lib.listToAttrs
  ];

  toScript = lib.flip lib.pipe [
    (map ({ name, ... }: ''export ${envName name}="@str $(<$CREDENTIALS_DIRECTORY/${credId name})"''))
    lib.concatLines
  ];
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "bazarr" "listenPort" ]
      [ "services" "bazarr" "settings" "general" "port" ]
    )
  ];

  options = {
    services.bazarr = {
      enable = lib.mkEnableOption "bazarr, a subtitle manager for Sonarr and Radarr";

      package = lib.mkPackageOption pkgs "bazarr" { };

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/bazarr";
        description = "The directory where Bazarr stores its data files.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports in the firewall for the bazarr web interface.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "bazarr";
        description = "User account under which bazarr runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "bazarr";
        description = "Group under which bazarr runs.";
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsType;
          options = {
            analytics.enabled = lib.mkEnableOption "sending anonymous usage statistics to Bazarr's developers";

            general = {
              auto_update = lib.mkOption {
                type = lib.types.bool;
                default = false;
                readOnly = true;
                description = ''
                  Bazarr's in-app updater is locked off on NixOS.
                  The package is managed by Nix, so any self-update would fight the store.
                  This option is emitted as `DYNACONF_general__auto_update=@bool false` so the in-memory settings agree,
                  but the actual suppression is enforced unconditionally by the `--no-update` CLI flag,
                  which also hides the entire Updates section from the web UI.
                '';
              };

              port = lib.mkOption {
                type = lib.types.port;
                default = 6767;
                description = "Port on which the Bazarr web interface listens.";
              };
            };
          };
        };
        default = { };
        description = ''
          Bazarr configuration.
          Settings are emitted as `DYNACONF_*` environment variables at startup,
          overriding any value previously written by Bazarr's web UI to `config.yaml`.

          Use `_secret` to load values from files via systemd's `LoadCredential=`.
          Secret contents are exported into bazarr's environment at service start,
          always as strings.
        '';
        example = {
          general = {
            instance_name = "NixOS Bazarr";
            port = 12345;
          };
          auth.apikey._secret = "/run/secrets/bazarr-apikey";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.settings."10-bazarr".${cfg.dataDir}.d = {
      inherit (cfg) user group;
      mode = "0700";
    };

    systemd.services.bazarr = {
      description = "Bazarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = toEnvironment publicSettings;
      script = ''
        ${toScript secretSettings}
        exec ${lib.getExe cfg.package} ${
          lib.cli.toCommandLineShellGNU { } {
            config = cfg.dataDir;
            no-update = true;
          }
        }
      '';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        SyslogIdentifier = "bazarr";
        Restart = "on-failure";
        KillSignal = "SIGINT";
        SuccessExitStatus = "0 156";
        LoadCredential = toCredentials secretSettings;
      };
      unitConfig.RequiresMountsFor = [ cfg.dataDir ];
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.general.port ];
    };

    users.users = lib.mkIf (cfg.user == "bazarr") {
      bazarr = {
        inherit (cfg) group;
        isSystemUser = true;
        home = cfg.dataDir;
      };
    };

    users.groups = lib.mkIf (cfg.group == "bazarr") {
      bazarr = { };
    };
  };

  meta.maintainers = with lib.maintainers; [
    connor-grady
    diogotcorreia
  ];
}

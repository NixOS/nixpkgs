{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.bazarr;
  settingsFormat = pkgs.formats.yaml { };

  settings = lib.mapAttrsToListRecursiveCond (_: as: !(as ? _secret)) lib.nameValuePair cfg.settings;
  secrets = lib.filter ({ value, ... }: value ? _secret) settings;

  secretPlaceholder = lib.hashString "sha256";
  secretType = lib.types.addCheck (lib.types.attrTag {
    _secret = lib.mkOption { type = lib.types.externalPath; };
  }) (x: lib.types.externalPath.check x._secret);

  credentialId = lib.join ".";
  credentialDirectives = map ({ name, value }: "${credentialId name}:${value._secret}") secrets;

  envName = name: "DYNACONF_${lib.join "__" name}";
  envValue =
    name: value:
    if value ? _secret then
      "@str ${secretPlaceholder value._secret}"
    else if lib.isBool value then
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
  envAssignments = map ({ name, value }: "${envName name}=${envValue name value}") settings;

  envFileTemplate = pkgs.writeText "bazarr-dynaconf.env" (lib.concatLines envAssignments);
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
          freeformType = settingsFormat.type;
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
                  but the actual suppression is enforced unconditionally by `--no-update True` CLI flag,
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
          Secret contents are substituted into `$RUNTIME_DIRECTORY/dynaconf.env` (mode 0600) at startup and wiped on service stop.
          Always emitted as strings.
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
    assertions = map (
      { name, value }:
      {
        assertion = secretType.check value;
        message = "`services.bazarr.settings`: secret declaration at `${lib.showAttrPath name}` must be exactly of the form `{ _secret = <absolute path outside the Nix store>; }`";
      }
    ) secrets;

    systemd.tmpfiles.settings."10-bazarr".${cfg.dataDir}.d = {
      inherit (cfg) user group;
      mode = "0700";
    };

    systemd.services.bazarr = {
      description = "Bazarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStartPre = [
          "${lib.getExe' pkgs.coreutils "install"} -m 0600 ${envFileTemplate} %t/%N/dynaconf.env"
        ]
        ++ map (
          { name, value }:
          "${lib.getExe pkgs.replace-secret} ${secretPlaceholder value._secret} %d/${credentialId name} %t/%N/dynaconf.env"
        ) secrets;

        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        SyslogIdentifier = "bazarr";
        ExecStart = pkgs.writeShellScript "start-bazarr" ''
          ${cfg.package}/bin/bazarr \
            --config '${cfg.dataDir}' \
            --no-update True
        '';
        Restart = "on-failure";
        KillSignal = "SIGINT";
        SuccessExitStatus = "0 156";
        RuntimeDirectory = "%N";
        RuntimeDirectoryMode = "0700";
        EnvironmentFile = "-%t/%N/dynaconf.env";
        LoadCredential = credentialDirectives;
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

    users.groups = lib.mkIf (cfg.group == "bazarr") { bazarr = { }; };
  };

  meta.maintainers = with lib.maintainers; [
    connor-grady
    diogotcorreia
  ];
}

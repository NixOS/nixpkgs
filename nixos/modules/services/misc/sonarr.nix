{
  config,
  pkgs,
  lib,
  utils,
  ...
}:
let
  cfg = config.services.sonarr;

  settingsEnvVars = lib.pipe cfg.settings [
    (lib.mapAttrsRecursive (
      path: value:
      lib.optionalAttrs (value != null) {
        name = lib.toUpper "SONARR__${lib.concatStringsSep "__" path}";
        value = toString (if lib.isBool value then lib.boolToString value else value);
      }
    ))
    (lib.collect (x: lib.isString x.name or false && lib.isString x.value or false))
    lib.listToAttrs
  ];
in
{
  options = {
    services.sonarr = {
      enable = lib.mkEnableOption "Sonarr";

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/sonarr/.config/NzbDrone";
        description = "The directory where Sonarr stores its data files.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the Sonarr web interface
        '';
      };

      apiKeyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        description = ''
          Path to the file containing the API key for Sonarr (32 chars).
          This will overwrite the API key in the config file.
        '';
        example = "/run/secrets/sonarr-apikey";
        default = null;
      };

      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        description = ''
          Environment file to pass secret configuration values.

          Each line must follow the `SONARR__SECTION__KEY=value` pattern.
          Please consult the documentation at the [wiki](https://wiki.servarr.com/useful-tools#using-environment-variables-for-config).
        '';
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = (pkgs.formats.ini { }).type;
          options = {
            update = {
              mechanism = lib.mkOption {
                type =
                  with lib.types;
                  nullOr (enum [
                    "external"
                    "builtIn"
                    "script"
                  ]);
                description = "which update mechanism to use";
                default = "external";
              };
              automatically = lib.mkOption {
                type = lib.types.bool;
                description = "Automatically download and install updates.";
                default = false;
              };
            };
            server = {
              port = lib.mkOption {
                type = lib.types.int;
                description = "Port Number";
                default = 8989;
              };
            };
            log = {
              analyticsEnabled = lib.mkOption {
                type = lib.types.bool;
                description = "Send Anonymous Usage Data";
                default = false;
              };
            };
          };
        };
        example = lib.options.literalExpression ''
          {
            update.mechanism = "internal";
            server = {
              urlbase = "localhost";
              port = 8989;
              bindaddress = "*";
            };
          }
        '';
        default = { };
        description = ''
          Attribute set of arbitrary config options.
          Please consult the documentation at the [wiki](https://wiki.servarr.com/useful-tools#using-environment-variables-for-config).

          WARNING: this configuration is stored in the world-readable Nix store!
          Use [](#opt-services.sonarr.environmentFiles) if it contains a secret.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "sonarr";
        description = "User account under which Sonaar runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "sonarr";
        description = "Group under which Sonaar runs.";
      };

      package = lib.mkPackageOption pkgs "sonarr" { };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.settings ? auth && cfg.settings.auth ? apikey);
        message = ''
          The `services.sonarr.settings` attribute set must not contain `ApiKey`, you should instead use `services.sonarr.apiKeyFile` to avoid storing secrets in the Nix store.
        '';
      }
    ];

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0700 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.sonarr = {
      description = "Sonarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = settingsEnvVars;
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = cfg.environmentFiles;
        LoadCredential = lib.optional (cfg.apiKeyFile != null) "SONARR__AUTH__APIKEY:${cfg.apiKeyFile}";
        ExecStartPre = lib.optionalString (cfg.apiKeyFile != null) pkgs.writeShellScript "sonarr-apikey" ''
          if [ ! -s config.xml ]; then
            echo '<?xml version="1.0" encoding="UTF-8"?><Config><ApiKey></ApiKey></Config>' > "${cfg.dataDir}/config.xml"
          fi
          ${lib.getExe pkgs.xmlstarlet} ed -L -u "/Config/ApiKey" -v "@API_KEY@" "${cfg.dataDir}/config.xml"
          ${lib.getExe pkgs.replace-secret} '@API_KEY@' ''${CREDENTIALS_DIRECTORY}/SONARR__AUTH__APIKEY "${cfg.dataDir}/config.xml"
        '';
        ExecStart = utils.escapeSystemdExecArgs [
          (lib.getExe cfg.package)
          "-nobrowser"
          "-data=${cfg.dataDir}"
        ];
        Restart = "on-failure";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.server.port ];
    };

    users.users = lib.mkIf (cfg.user == "sonarr") {
      sonarr = {
        group = cfg.group;
        home = cfg.dataDir;
        uid = config.ids.uids.sonarr;
      };
    };

    users.groups = lib.mkIf (cfg.group == "sonarr") {
      sonarr.gid = config.ids.gids.sonarr;
    };
  };
}

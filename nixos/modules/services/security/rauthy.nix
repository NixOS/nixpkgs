{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.services.rauthy;
  settingsFormat = pkgs.formats.toml { };
  finalSettingsFile = "/var/lib/rauthy/config.toml";
in
{
  meta.maintainers = with lib.maintainers; [
    gepbird
  ];

  options.services.rauthy = {
    enable = lib.mkEnableOption "Rauthy";

    package = lib.mkPackageOption pkgs "rauthy" { };

    settings = lib.mkOption {
      type = settingsFormat.type;
      default = { };
      example = {
        server = {
          proxy_mode = true;
          secret_api = {
            _secret_path = "/run/secrets/rauthy/server_secret_api";
          };
        };
      };
      description = ''
        TOML configuration options that will be writtern to config.toml
        See https://sebadob.github.io/rauthy/config/config.html.

        Settings containing secret data should be set to an
        attribute set with this format: `{ _secret_path = "/path/to/secret"; }`.
        For example settings `services.rauthy.settings.server.secret_api._secret_path`
        to a file path containing "SuperSecureSecret1337" will set the
        `server.secret_api = "SuperSecureSecret1337` TOML option securely.

        Alternatively, you can use a single file with environment variables,
        see `services.rauthy.environmentFile`.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/rauthy.cfg";
      description = ''
        Environment file to inject e.g. secrets into the configuration.
      '';
    };

  };

  config = lib.mkIf cfg.enable {
    systemd.services.rauthy = {
      description = "rauthy";
      after = [
        "postgresql.service"
      ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";

        WorkingDirecotry = "/var/lib/rauthy";
        StateDirectory = "rauthy";
        StateDirectoryMode = 750;
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;

        ExecStartPre =
          let
            checkSecretPath =
              _secret_path:
              lib.throwIf (
                !lib.isPath _secret_path && !lib.isString _secret_path
              ) "`_secret_path` must be a string or a path, but got: ${lib.typeOf _secret_path}" _secret_path;
            renderSettings =
              data:
              if lib.isAttrs data then
                if data ? _secret_path then
                  checkSecretPath data._secret_path
                else
                  lib.mapAttrs (name: renderSettings) data
              else if lib.isList data then
                lib.map renderSettings data
              else
                data;
            renderedSettingsFile = settingsFormat.generate "config.toml" (renderSettings cfg.settings);

            findSecretPaths =
              data:
              if lib.isAttrs data then
                if data ? _secret_path then data._secret_path else lib.map findSecretPaths (lib.attrValues data)
              else if lib.isList data then
                lib.map findSecretPaths data
              else
                [ ];
            secretPaths = lib.flatten (findSecretPaths cfg.settings);

            makeSecretReplacement = secretPath: ''
              ${pkgs.replace-secret}/bin/replace-secret ${
                lib.escapeShellArgs [
                  secretPath
                  secretPath
                  finalSettingsFile
                ]
              }
            '';

            secretReplacements = lib.concatMapStrings makeSecretReplacement secretPaths;
          in
          # Use "+" to run as root because the secrets may not be accessible to the dynamic user
          "+"
          + pkgs.writeShellScript "rauthy-pre" ''
            install -m 600 -o $USER ${renderedSettingsFile} ${finalSettingsFile}
            ${secretReplacements}
          '';
        ExecStart = pkgs.writeShellScript "rauthy-start" ''
          cd /var/lib/rauthy
          ${cfg.package}/bin/rauthy
        '';

        User = "rauthy";
        DynamicUser = true;
      };
    };
  };
}

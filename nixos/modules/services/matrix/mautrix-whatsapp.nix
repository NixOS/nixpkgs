{ config, pkgs, lib, ... }:

with lib;

let
  dataDir = "/var/lib/mautrix-whatsapp";
  registrationFile = "${dataDir}/whatsapp-registration.yaml";
  cfg = config.services.mautrix-whatsapp;
  settingsFormat = pkgs.formats.yaml {};
  settingsFile = settingsFormat.generate "mautrix-whatsapp-config.yaml" cfg.settings;

  puppetRegex = concatStringsSep
    ".*"
    (map
      escapeRegex
      (splitString
        "{userid}"
        cfg.settings.bridge.username_template));
in {
  options = {
    services.mautrix-whatsapp = {
      enable = mkEnableOption "Mautrix-Whatsapp, a Matrix-Whatsapp hybrid puppeting/relaybot bridge";

      settings = mkOption rec {
        apply = recursiveUpdate default;
        type = settingsFormat.type;
        default = {
          homeserver = {
              address = "http://localhost:8008";
              domain = "example.com";
          };
          appservice = rec {
              address = "http://${hostname}:${toString port}";
              hostname = "0.0.0.0";
              port = 29318;
              database = {
                  type = "postgres";
                  uri = "postgres://mautrix-whatsapp:DB_PASSWORD@localhost/mautrix-whatsapp?sslmode=disable";
              };
              as_token = "This value is generated when generating the registration";
              hs_token = "This value is generated when generating the registration";
          };
          bridge = {
              permissions = {
                  "*" = "relay";
                  "example.com" = "user";
                  "@admin:example.com" = "admin";
              };
          };
          logging = {
              directory = "/var/log/mautrix-whatsapp";
              print_level = "warning";
          };
        };
        example = literalExpression ''
          {
            homeserver = {
              address = "http://localhost:8008";
            };

            bridge.permissions = {
              "mydomain.example" = "user";
              "@admin:mydomain.example" = "admin";
            };
          };
        '';
        description = lib.mdDoc ''
          {file}`config.yaml` configuration as a Nix attribute set.
          Configuration options should match those described in
          [example-config.yaml](https://github.com/mautrix/whatsapp/blob/master/example-config.yaml).

          Secret tokens should not be specified or only in the registration file
	  Database password should be specified only in /var/lib/mautrix-whatsapp/db-password
        '';
      };

      environmentFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc ''
          File containing environment variables to be passed to the mautrix-whatsapp service.
          Should be useless.

          Any config variable can be overridden by setting `MAUTRIX_WHATSAPP_SOME_KEY` to override the `some.key` variable.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.mautrix-whatsapp = {
      isSystemUser = true;
      group = "mautrix-whatsapp";
    };
    users.groups.mautrix-whatsapp = {};

    systemd.services.mautrix-whatsapp = rec {
      wantedBy = [ "multi-user.target" ];
      wants = [
        "network-online.target"
      ] ++ optional config.services.matrix-synapse.enable "matrix-synapse.service";
      after = wants;

      preStart = ''
        # copy the config file in another location to patch it with private tokens
        cp '${settingsFile}' config.yaml

        # generate the appservice's registration file if absent
        if [ ! -f '${registrationFile}' ]; then
          ${pkgs.mautrix-whatsapp}/bin/mautrix-whatsapp \
            --generate-registration \
            --config='config.yaml' \
            --registration='${registrationFile}'
          chmod 0440 '${registrationFile}'
        fi

        # patch config with tokens from the registration file
        sed -i "s/as_token.*/as_token: \"$(grep "as_token" ${registrationFile} | sed "s/as_token: //")\"/" config.yaml
        sed -i "s/hs_token.*/hs_token: \"$(grep "hs_token" ${registrationFile} | sed "s/hs_token: //")\"/" config.yaml

        # set postgres password if file dataDir/db-password exist
        if [ -f '${dataDir}/db-password' ]; then
          sed -i "s/DB_PASSWORD/$(cat ${dataDir}/db-password)/" config.yaml
        fi
      '';

      serviceConfig = {
        Type = "simple";

        User = "mautrix-whatsapp";
        Group = "matrix-synapse";
        Restart = "on-failure";

        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        PrivateTmp = true;

        EnvironmentFile = cfg.environmentFile;

        RuntimeDirectory = "mautrix-whatsapp";
        WorkingDirectory = "/run/mautrix-whatsapp";
        StateDirectory = baseNameOf dataDir;
        LogsDirectory = baseNameOf cfg.settings.logging.directory;

        ExecStart = ''
          ${pkgs.mautrix-whatsapp}/bin/mautrix-whatsapp --config=config.yaml
        '';
      };
    };
  };

  meta.maintainers = with maintainers; [ Jo-Blade ];
}

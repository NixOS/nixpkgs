{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.mautrix-whatsapp;
  dataDir = "/var/lib/mautrix-whatsapp";
  settingsFormat = pkgs.formats.json {};

  registrationFile = "${dataDir}/whatsapp-registration.yaml";
  settingsFile = settingsFormat.generate "config.json" cfg.settings;

  startupScript = ''
    ${pkgs.yq}/bin/yq -s '.[0].appservice.as_token = .[1].as_token
      | .[0].appservice.hs_token = .[1].hs_token
      | .[0]' ${settingsFile} ${registrationFile} \
      > ${dataDir}/config.yml

    ${pkgs.mautrix-whatsapp}/bin/mautrix-whatsapp \
      --config='${dataDir}/config.yml' \
      --registration='${registrationFile}'
  '';
in {
  options.services.mautrix-whatsapp = {
    enable = mkEnableOption "Mautrix-whatsapp, a puppeting bridge between Matrix and WhatsApp.";

    settings = mkOption rec {
      apply = recursiveUpdate default;
      inherit (settingsFormat) type;

      description = lib.mdDoc ''
        {file}`config.yaml` configuration as a Nix attribute set.
        Configuration options should match those described in
        [example-config.yaml](https://github.com/mautrix/whatsapp/blob/master/example-config.yaml).
      '';
      default = {
        homeserver = {
          domain = config.services.matrix-synapse.settings.server_name;
        };
        appservice = rec {
          address = "http://localhost:29318";
          hostname = "0.0.0.0";
          port = 29318;
          database = {
            type = "sqlite3";
            uri = "${dataDir}/mautrix-whatsapp.db";
          };
          id = "whatsapp";
          bot = {
            username = "whatsappbot";
            displayname = "WhatsApp Bot";
          };
          as_token = "";
          hs_token = "";
        };
        bridge = {
          username_template = "whatsapp_{{.}}";
          displayname_template = "{{if .Notify}}{{.Notify}}{{else}}{{.Jid}}{{end}}";
          command_prefix = "!wa";
          permissions."*" = "relay";
        };
        relay = {
          enabled = true;
          management = "!whatsappbot:${toString (config.services.matrix-synapse.settings.server_name)}";
        };
        logging = {
          directory = "${dataDir}/logs";
          file_name_format = "{{.Date}}-{{.Index}}.log";
          file_date_format = "2006-01-02";
          file_mode = 0384;
          timestamp_format = "Jan _2, 2006 15:04:05";
          print_level = "info";
        };
      };
      example = {
        settings = {
          homeserver.address = https://matrix.myhomeserver.org;
          bridge.permissions = {
            "@admin:myhomeserver.org" = "admin";
          };
        };
      };
    };

    serviceDependencies = mkOption {
      type = with types; listOf str;
      default = optional config.services.matrix-synapse.enable "matrix-synapse.service";
      defaultText = literalExpression ''
        optional config.services.matrix-synapse.enable "matrix-synapse.service"
      '';
      description = lib.mdDoc ''
        List of Systemd services to require and wait for when starting the application service.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.mautrix-whatsapp = {
      description = "Mautrix-WhatsApp Service - A WhatsApp bridge for Matrix";

      wantedBy = ["multi-user.target"];
      wants = ["network-online.target"] ++ cfg.serviceDependencies;
      after = ["network-online.target"] ++ cfg.serviceDependencies;

      preStart = ''
        # generate the appservice's registration file if absent
        if [ ! -f '${registrationFile}' ]; then
          ${pkgs.mautrix-whatsapp}/bin/mautrix-whatsapp \
            --generate-registration \
            --config='${settingsFile}' \
            --registration='${registrationFile}'
        fi
        chmod 640 ${registrationFile}
      '';

      script = startupScript;

      serviceConfig = {
        Type = "simple";
        #DynamicUser = true;
        PrivateTmp = true;
        StateDirectory = baseNameOf dataDir;
        WorkingDirectory = "${dataDir}";

        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        User = "mautrix-whatsapp";
        Group = "matrix-synapse";
        SupplementaryGroups = "matrix-synapse";
        UMask = 0027;
        Restart = "always";
      };
    };

    users.groups.mautrix-whatsapp = {};
    users.users.mautrix-whatsapp = {
      isSystemUser = true;
      group = "mautrix-whatsapp";
      home = dataDir;
    };
    services.matrix-synapse.settings.app_service_config_files = ["${registrationFile}"];
  };
}

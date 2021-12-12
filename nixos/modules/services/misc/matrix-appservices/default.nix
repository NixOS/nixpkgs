{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.matrix-appservices;
  asOpts = import ./as-options.nix {
    inherit lib pkgs;
    systemConfig = config;
  };
  mkService = name: opts:
    with opts;
    let
      settingsFormat = pkgs.formats.json { };
      dataDir = "/var/lib/matrix-as-${name}";
      registrationFile = "${dataDir}/${name}-registration.yaml";
      # Replace all references to $DIR to the dat directory
      settingsData = settingsFormat.generate "config.json" settings;
      settingsFile = "${dataDir}/config.json";
      serviceDeps = [ "network-online.target" ] ++ serviceDependencies;

      registrationContent = {
        id = name;
        url =  "http://${host}:${toString port}";
        as_token = "$AS_TOKEN";
        hs_token = "$HS_TOKEN";
        sender_localpart = "$SENDER_LOCALPART";
        rate_limited = false;
      } // registrationData;
    in
    {
      description = "A matrix appservice for ${name}.";

      wantedBy = [ "multi-user.target" ];
      wants = serviceDeps;
      after = serviceDeps;
      # Appservices don't need synapse up, but synapse exists if registration files are missing
      before = mkIf (cfg.homeserver != null) [ "${cfg.homeserver}.service" ];

      path = [ pkgs.yq ];
      environment = {
        DIR = dataDir;
        SETTINGS_FILE = settingsFile;
        REGISTRATION_FILE = registrationFile;
      };

      preStart = ''
        if [ ! -f ${registrationFile} ]; then
          AS_TOKEN=$(cat /proc/sys/kernel/random/uuid) \
          HS_TOKEN=$(cat /proc/sys/kernel/random/uuid) \
          SENDER_LOCALPART=$(cat /proc/sys/kernel/random/uuid) \
          ${pkgs.envsubst}/bin/envsubst \
            -i ${settingsFormat.generate "config.json" registrationContent} \
            -o ${registrationFile}

          chmod 640 ${registrationFile}
        fi

        AS_TOKEN=$(cat ${registrationFile} | yq .as_token | tr -d '"') \
        HS_TOKEN=$(cat ${registrationFile} | yq .hs_token | tr -d '"') \
        ${pkgs.envsubst}/bin/envsubst -i ${settingsData} -o ${settingsFile}
        chmod 640 ${settingsFile}
      '';

      script = ''
        ${startupScript}
      '';

      serviceConfig = {
        Type = "simple";
        Restart = "always";

        ProtectSystem = "strict";
        PrivateTmp = true;
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;

        User = "matrix-as-${name}";
        Group = "matrix-as-${name}";
        WorkingDirectory = dataDir;
        StateDirectory = "${baseNameOf dataDir}";
        StateDirectoryMode = "0750";
        UMask = 0027;
      } // opts.serviceConfig;
    };

in
{
  options = {
    services.matrix-appservices = {
      services = mkOption {
        type = types.attrsOf asOpts;
        default = { };
        example = literalExpression ''
          whatsapp = {
            format = "mautrix-go";
            package = pkgs.mautrix-whatsapp;
          };
        '';
        description = ''
          Appservices to setup.
          Each appservice will be started as a systemd service with the prefix matrix-as.
          And its data will be stored in /var/lib/matrix-as-name.
        '';
      };

      homeserver = mkOption {
        type = types.enum [ "matrix-synapse" "dendrite" null ];
        default = "matrix-synapse";
        description = ''
          The homeserver software the appservices connect to. This will ensure appservices
          start after the homeserver and it will be used by the addRegistrationFiles option.
        '';
      };

      homeserverURL = mkOption {
        type = types.str;
        default = "https://${cfg.homeserverDomain}";
        description = ''
          URL of the homeserver the apservices connect to
        '';
      };

      homeserverDomain = mkOption {
        type = types.str;
        default = if config.networking.domain != null then config.networking.domain else "";
        defaultText = "\${config.networking.domain}";
        description = ''
          Domain of the homeserver the appservices connect to
        '';
      };

      addRegistrationFiles = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to add the application service registration files to the homeserver configuration.
          It is recommended to verify appservice files, located in /var/lib/matrix-as-*, before adding them
        '';
      };
    };
  };

  config = mkIf (cfg.services != { }) {

    assertions = mapAttrsToList
      (n: v: {
        assertion = v.format == "other" || v.package != null;
        message = "A package must be provided if a custom format is set";
      })
      cfg.services;

    users.users = mapAttrs' (n: v: nameValuePair "matrix-as-${n}" {
      group = "matrix-as-${n}";
      isSystemUser = true;
    }) cfg.services;
    users.groups = mapAttrs' (n: v: nameValuePair "matrix-as-${n}" { }) cfg.services;

    # Create a service for each appservice
    systemd.services = (mapAttrs' (n: v: nameValuePair "matrix-as-${n}" (mkService n v)) cfg.services) // {
      # Add the matrix service to the groups of all appservices to give access to the registration file
      matrix-synapse.serviceConfig.SupplementaryGroups = mapAttrsToList (n: v: "matrix-as-${n}") cfg.services;
      dendrite.serviceConfig.SupplementaryGroups = mapAttrsToList (n: v: "matrix-as-${n}") cfg.services;
    };

    services =
      let
        registrationFiles = mapAttrsToList (n: _: "/var/lib/matrix-as-${n}/${n}-registration.yaml")
            (filterAttrs (_: v: v.registrationData != { }) cfg.services);
      in
      mkIf cfg.addRegistrationFiles {
        matrix-synapse.app_service_config_files = mkIf (cfg.homeserver == "matrix-synapse") registrationFiles;
        dendrite.settings.app_service_api.config_files = mkIf (cfg.homeserver == "dendrite") registrationFiles;
      };
  };

  meta.maintainers = with maintainers; [ pacman99 Flakebi ];

}

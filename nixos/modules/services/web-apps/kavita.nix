{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.kavita;
  settingsFormat = pkgs.formats.json { };

  appsettings = settingsFormat.generate "appsettings.json" (
    {
      TokenKey = "@TOKEN@";
    }
    // cfg.settings
    // lib.optionalAttrs (cfg.settings.OpenIdConnectSettings or { } != { }) {
      OpenIdConnectSettings = cfg.settings.OpenIdConnectSettings // {
        Secret = "@OIDC_SECRET@";
      };
    }
  );
in
{
  imports = [
    (lib.mkChangedOptionModule
      [ "services" "kavita" "ipAddresses" ]
      [ "services" "kavita" "settings" "IpAddresses" ]
      (
        config:
        let
          value = lib.getAttrFromPath [ "services" "kavita" "ipAddresses" ] config;
        in
        lib.concatStringsSep "," value
      )
    )

    (lib.mkRenamedOptionModule [ "services" "kavita" "port" ] [ "services" "kavita" "settings" "Port" ])
  ];

  options.services.kavita = {
    enable = lib.mkEnableOption "Kavita reading server";

    user = lib.mkOption {
      type = lib.types.str;
      default = "kavita";
      description = "User account under which Kavita runs.";
    };

    package = lib.mkPackageOption pkgs "kavita" { };

    dataDir = lib.mkOption {
      default = "/var/lib/kavita";
      type = lib.types.str;
      description = "The directory where Kavita stores its state.";
    };

    tokenKeyFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        A file containing the TokenKey, a secret with at 512+ bits.
        It can be generated with `head -c 64 /dev/urandom | base64 --wrap=0`.
      '';
    };

    oidcSecretFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        File containing the OpenID Connect client secret.
        Required when OpenIdConnectSettings.Enabled is true.
      '';
    };

    settings = lib.mkOption {
      default = { };

      description = ''
        Kavita configuration options, as configured in {file}`appsettings.json`.
      '';

      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options = {
          Port = lib.mkOption {
            default = 5000;
            type = lib.types.port;
            description = "Port to bind to.";
          };

          IpAddresses = lib.mkOption {
            default = "0.0.0.0,::";
            type = lib.types.commas;
            description = ''
              IP Addresses to bind to. The default is to bind to all IPv4 and IPv6 addresses.
            '';
          };

          OpenIdConnectSettings = lib.mkOption {
            default = { };

            description = ''
              OpenID Connect authentication settings.
            '';

            type = lib.types.submodule {
              options = {
                Authority = lib.mkOption {
                  type = lib.types.str;
                  description = "OIDC authority URL.";
                };

                ClientId = lib.mkOption {
                  type = lib.types.str;
                  description = "OIDC client ID.";
                };

                CustomScopes = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [
                    "openid"
                    "profile"
                    "email"
                  ];
                  description = "OIDC scopes.";
                };

                Enabled = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = "Enable OIDC.";
                };
              };
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.kavita = {
      description = "Kavita";

      wantedBy = [
        "multi-user.target"
      ];

      after = [
        "network.target"
      ];

      preStart = ''
        install -m600 ${appsettings} ${lib.escapeShellArg cfg.dataDir}/config/appsettings.json

        ${pkgs.replace-secret}/bin/replace-secret '@TOKEN@' \
          ''${CREDENTIALS_DIRECTORY}/token \
          '${cfg.dataDir}/config/appsettings.json'

        ${lib.optionalString (cfg.oidcSecretFile != null) ''
          ${pkgs.replace-secret}/bin/replace-secret '@OIDC_SECRET@' \
            ''${CREDENTIALS_DIRECTORY}/oidc-secret \
            '${cfg.dataDir}/config/appsettings.json'
        ''}
      '';

      serviceConfig = {
        WorkingDirectory = cfg.dataDir;

        LoadCredential = [
          "token:${cfg.tokenKeyFile}"
        ]
        ++ lib.optional (cfg.oidcSecretFile != null) "oidc-secret:${cfg.oidcSecretFile}";

        ExecStart = lib.getExe cfg.package;

        Restart = "always";

        User = cfg.user;
      };
    };

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}'        0750 ${cfg.user} ${cfg.user} - -"
      "d '${cfg.dataDir}/config' 0750 ${cfg.user} ${cfg.user} - -"
    ];

    users = {
      users.${cfg.user} = {
        description = "kavita service user";
        isSystemUser = true;
        group = cfg.user;
        home = cfg.dataDir;
      };

      groups.${cfg.user} = { };
    };
  };

  meta.maintainers = with lib.maintainers; [
    misterio77
    sinjin2300
  ];
}

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.kavita;
  settingsFormat = pkgs.formats.json { };
  appsettings = settingsFormat.generate "appsettings.json" cfg.settings;
in
{
  imports = [
    (lib.mkChangedOptionModule
      [ "services" "kavita" "ipAdresses" ]
      [ "services" "kavita" "settings" "IpAddresses" ]
      (
        config:
        let
          value = lib.getAttrFromPath [ "services" "kavita" "ipAdresses" ] config;
        in
        lib.concatStringsSep "," value
      )
    )
    (lib.mkRenamedOptionModule [ "services" "kavita" "port" ] [ "services" "kavita" "settings" "Port" ])
    (lib.mkRenamedOptionModule
      [ "services" "kavita" "tokenKeyFile" ]
      [ "services" "kavita" "settings" "TokenKey" ]
    )
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

    settings = lib.mkOption {
      default = { };
      description = ''
        Kavita configuration options, as configured in {file}`appsettings.json`.

        Any configuration option that contains sensitive data should use a placeholder
        value (ie, `oidc_client_secret`) enclosed with an `@` character:

        `services.kavita.settings.OpenIdConnectSettings.Secret = "@oidc_client_secret@";`

        Then, use the placeholder as unique key and hydrate the secret using your
        preferred secrets management (ie, `sops-nix`):

        `services.kavita.credentials."oidc_client_secret" = config.sops.secrets."client_secret".path;`
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

          TokenKey = lib.mkOption {
            default = "@token_key@";
            type = lib.types.str;
            description = ''
              A secret with at least 512 bits. It may be generated with `head -c 64 /dev/urandom | base64 --wrap=0`.

              Suggest using a placeholder value (eg, `token_key`) enclosed by `@` character (eg, `@tokey_key@`) to avoid writing
              sensitive data to world readable nix store. Placeholder value will be defined as key in `services.kavita.credentials`
              and the associated path containing the secret will be replaced at service startup.
            '';
          };
        };
      };
      example = {
        IpAddresses = "::2,127.0.0.2";
        Port = 5001;
        TokenKey = "@token_key@";
        OpenIdConnectSettings = {
          Enabled = true;
          Authority = "https://idp.example.com";
          ClientId = "kavita";
          Secret = "@oidc_client_secret@";
        };
      };
    };

    credentials = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        token_key = "/run/secrets/kavita/token_key";
        oidc_client_secret = "/run/secrets/kavita/client_secret";
      };
      description = ''
        Secrets that will be passed to systemd service and subsequently all placeholders in {file}`appsettings.json` will be replaced
        prior to service startup.

        It is not necessary to enclose the keys/placeholder values with `@` characters here.
      '';
    };

    useDefaultEmailTemplates = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether or not to copy default e-mail templates [1] from upstream to `''${cfg.dataDir}/EmailTemplates`

        [1] https://github.com/Kareadita/Kavita/tree/develop/Kavita.Server/EmailTemplates
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.kavita = {
      description = "Kavita";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      preStart = ''
        install -m600 ${appsettings} ${lib.escapeShellArg cfg.dataDir}/config/appsettings.json
      ''
      + lib.concatStringsSep "\n" (
        lib.mapAttrsToList (key: val: ''
          ${lib.getExe pkgs.replace-secret} '@${key}@' \
            ''${CREDENTIALS_DIRECTORY}/${key} \
            ${cfg.dataDir}/config/appsettings.json'') cfg.credentials
      );
      serviceConfig = {
        WorkingDirectory = cfg.dataDir;
        LoadCredential = lib.mapAttrsToList (key: value: "${key}:${value}") cfg.credentials;
        ExecStart = lib.getExe cfg.package;
        Restart = "always";
        User = cfg.user;
      };
    };

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}'        0750 ${cfg.user} ${cfg.user} - -"
      "d '${cfg.dataDir}/config' 0750 ${cfg.user} ${cfg.user} - -"
    ]
    ++ lib.optionals cfg.useDefaultEmailTemplates [
      "L+ '${cfg.dataDir}/EmailTemplates' - - - - ${cfg.package}/lib/kavita/backend/EmailTemplates"
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

  meta.maintainers = with lib.maintainers; [ misterio77 ];
}

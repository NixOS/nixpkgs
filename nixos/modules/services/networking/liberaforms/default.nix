{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.liberaforms;

  format = pkgs.formats.pythonVars { };
  settingsFile = format.generate "dotenv" cfg.settings;
in

{
  imports = [
    ./reverse-proxy.nix
  ];

  options.services.liberaforms = {
    enable = lib.mkEnableOption "LiberaForms";
    package = lib.mkPackageOption pkgs "liberaforms" { };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8000;
      description = "Liberaforms service port.";
    };

    openPorts = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open the ports in the firewall";
    };

    secrets = {
      keyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.externalPath;
        default = null;
        example = "/run/keys/liberaforms-secret-key";
        description = ''
          File containing the secret key for session management and CSRF protection.
          Generate with: python3 -c 'import secrets; print(secrets.token_hex(32))'.
        '';
      };

      cryptoFile = lib.mkOption {
        type = lib.types.nullOr lib.types.externalPath;
        default = null;
        example = "/run/keys/liberaforms-crypto-key";
        description = ''
          Encryption key for form data. Required if E2EE_MODE is not DISABLED.
          Generate with: liberaforms-flask cryptokey create
        '';
      };
    };

    settings = lib.mkOption {
      type = lib.types.submodule (lib.modules.importApply ./settings.nix { inherit format; });
      default = { };
      description = ''
        Configuration for LiberaForms, which will be passed as environment variables.
        See <https://codeberg.org/LiberaForms/server/src/branch/main/dotenv.example>.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.secrets.keyFile != null;
        message = "`services.liberaforms.secrets.keyFile` must be set to a file containing the secret key.";
      }
      {
        assertion = !(cfg.settings ? SECRET_KEY);
        message = "Use `services.liberaforms.secrets.keyFile`, instead.";
      }
      {
        assertion = !(cfg.settings ? CRYPTO_KEY);
        message = "Use `services.liberaforms.secrets.cryptoFile`, instead.";
      }
    ];

    systemd.services.liberaforms = {
      description = "LiberaForms";
      wantedBy = [ "multi-user.target" ];
      requires = [ "postgresql.target" ];
      after = [
        "network.target"
        "postgresql.target"
      ];
      environment = {
        PGHOST = "/run/postgresql";
        PGDATABASE = "liberaforms";
        ENV_FILE = settingsFile;
        UPLOADS_DIR = "/var/lib/liberaforms/uploads";
      };
      serviceConfig = {
        User = "liberaforms";
        Group = "liberaforms";
        CacheDirectory = "liberaforms";
        LogsDirectory = "liberaforms";
        StateDirectory = "liberaforms";
        WorkingDirectory = "%S/liberaforms";
        LoadCredential = [
          "secret-key:${cfg.secrets.keyFile}"
        ]
        ++ lib.optional (cfg.secrets.cryptoFile != null) "crypto-key:${cfg.secrets.cryptoFile}";
      };
      path = [ cfg.package ];
      script = ''
        export SECRET_KEY="$(<"$CREDENTIALS_DIRECTORY/secret-key")"

        ${lib.optionalString (cfg.secrets.cryptoFile != null) ''
          export CRYPTO_KEY="$(<"$CREDENTIALS_DIRECTORY/crypto-key")"
        ''}

        liberaforms-flask database upgrade
        exec liberaforms
      '';
    };

    services.postgresql = {
      enable = true;
      ensureUsers = [
        {
          name = "liberaforms";
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = [ "liberaforms" ];
    };

    users = {
      users.liberaforms = {
        isSystemUser = true;
        group = "liberaforms";
      };
      groups.liberaforms = { };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openPorts [ cfg.port ];
    networking.firewall.allowedUDPPorts = lib.mkIf cfg.openPorts [ cfg.port ];
  };
}

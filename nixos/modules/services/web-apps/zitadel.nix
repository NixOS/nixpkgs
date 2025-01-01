{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.zitadel;

  settingsFormat = pkgs.formats.yaml { };
in
{
  options.services.zitadel =
    let
      inherit (lib)
        mkEnableOption
        mkOption
        mkPackageOption
        types
        ;
    in
    {
      enable = mkEnableOption "ZITADEL, a user and identity access management platform";

      package = mkPackageOption pkgs "ZITADEL" { default = [ "zitadel" ]; };

      user = mkOption {
        type = types.str;
        default = "zitadel";
        description = "The user to run ZITADEL under.";
      };

      group = mkOption {
        type = types.str;
        default = "zitadel";
        description = "The group to run ZITADEL under.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open the port specified in `listenPort` in the firewall.
        '';
      };

      masterKeyFile = mkOption {
        type = types.path;
        description = ''
          Path to a file containing a master encryption key for ZITADEL. The
          key must be 32 bytes.
        '';
      };

      tlsMode = mkOption {
        type = types.enum [
          "external"
          "enabled"
          "disabled"
        ];
        default = "external";
        example = "enabled";
        description = ''
          The TLS mode to use. Options are:

          - enabled: ZITADEL accepts HTTPS connections directly. You must
            configure TLS if this option is selected.
          - external: ZITADEL forces HTTPS connections, with TLS terminated at a
            reverse proxy.
          - disabled: ZITADEL accepts HTTP connections only. Should only be used
            for testing.
        '';
      };

      settings = mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type;

          options = {
            Port = mkOption {
              type = types.port;
              default = 8080;
              description = "The port that ZITADEL listens on.";
            };

            TLS = {
              KeyPath = mkOption {
                type = types.nullOr types.path;
                default = null;
                description = "Path to the TLS certificate private key.";
              };
              Key = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = ''
                  The TLS certificate private key, as a base64-encoded string.

                  Note that the contents of this option will be added to the Nix
                  store as world-readable plain text. Set
                  [KeyPath](#opt-services.zitadel.settings.TLS.KeyPath) instead
                  if this is undesired.
                '';
              };
              CertPath = mkOption {
                type = types.nullOr types.path;
                default = null;
                description = "Path to the TLS certificate.";
              };
              Cert = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = ''
                  The TLS certificate, as a base64-encoded string.

                  Note that the contents of this option will be added to the Nix
                  store as world-readable plain text. Set
                  [CertPath](#opt-services.zitadel.settings.TLS.CertPath) instead
                  if this is undesired.
                '';
              };
            };
          };
        };
        default = { };
        example = lib.literalExpression ''
          {
            Port = 8123;
            ExternalDomain = "example.com";
            TLS = {
              CertPath = "/path/to/cert.pem";
              KeyPath = "/path/to/cert.key";
            };
            Database.cockroach.Host = "db.example.com";
          };
        '';
        description = ''
          Contents of the runtime configuration file. See
          https://zitadel.com/docs/self-hosting/manage/configure for more
          details.
        '';
      };

      extraSettingsPaths = mkOption {
        type = types.listOf types.path;
        default = [ ];
        description = ''
          A list of paths to extra settings files. These will override the
          values set in [settings](#opt-services.zitadel.settings). Useful if
          you want to keep sensitive secrets out of the Nix store.
        '';
      };

      steps = mkOption {
        type = settingsFormat.type;
        default = { };
        example = lib.literalExpression ''
          {
            FirstInstance = {
              InstanceName = "Example";
              Org.Human = {
                UserName = "foobar";
                FirstName = "Foo";
                LastName = "Bar";
              };
            };
          }
        '';
        description = ''
          Contents of the database initialization config file. See
          https://zitadel.com/docs/self-hosting/manage/configure for more
          details.
        '';
      };

      extraStepsPaths = mkOption {
        type = types.listOf types.path;
        default = [ ];
        description = ''
          A list of paths to extra steps files. These will override the values
          set in [steps](#opt-services.zitadel.steps). Useful if you want to
          keep sensitive secrets out of the Nix store.
        '';
      };
    };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          cfg.tlsMode == "enabled"
          -> (
            (cfg.settings.TLS.Key != null || cfg.settings.TLS.KeyPath != null)
            && (cfg.settings.TLS.Cert != null || cfg.settings.TLS.CertPath != null)
          );
        message = ''
          A TLS certificate and key must be configured in
          services.zitadel.settings.TLS if services.zitadel.tlsMode is enabled.
        '';
      }
    ];

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.settings.Port ];

    systemd.services.zitadel =
      let
        configFile = settingsFormat.generate "config.yaml" cfg.settings;
        stepsFile = settingsFormat.generate "steps.yaml" cfg.steps;

        args = lib.cli.toGNUCommandLineShell { } {
          config = cfg.extraSettingsPaths ++ [ configFile ];
          steps = cfg.extraStepsPaths ++ [ stepsFile ];
          masterkeyFile = cfg.masterKeyFile;
          inherit (cfg) tlsMode;
        };
      in
      {
        description = "ZITADEL identity access management";
        path = [ cfg.package ];
        wantedBy = [ "multi-user.target" ];

        script = ''
          zitadel start-from-init ${args}
        '';

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          Restart = "on-failure";
        };
      };

    users.users.zitadel = lib.mkIf (cfg.user == "zitadel") {
      isSystemUser = true;
      group = cfg.group;
    };
    users.groups.zitadel = lib.mkIf (cfg.group == "zitadel") { };
  };

  meta.maintainers = [ ];
}

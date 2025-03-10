{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.matrix-hookshot;
  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "matrix-hookshot-config.yml" cfg.settings;
in
{
  options = {
    services.matrix-hookshot = {
      enable = lib.mkEnableOption "matrix-hookshot, a bridge between Matrix and project management services";

      package = lib.mkPackageOption pkgs "matrix-hookshot" { };

      registrationFile = lib.mkOption {
        type = lib.types.path;
        description = ''
          Appservice registration file.
          As it contains secret tokens, you may not want to add this to the publicly readable Nix store.
        '';
        example = lib.literalExpression ''
          pkgs.writeText "matrix-hookshot-registration" \'\'
            id: matrix-hookshot
            as_token: aaaaaaaaaa
            hs_token: aaaaaaaaaa
            namespaces:
              rooms: []
              users:
                - regex: "@_webhooks_.*:foobar"
                  exclusive: true

            sender_localpart: hookshot
            url: "http://localhost:9993"
            rate_limited: false
            \'\'
        '';
      };

      settings = lib.mkOption {
        description = ''
          {file}`config.yml` configuration as a Nix attribute set.

          For details please see the [documentation](https://matrix-org.github.io/matrix-hookshot/latest/setup/sample-configuration.html).
        '';
        example = {
          bridge = {
            domain = "example.com";
            url = "http://localhost:8008";
            mediaUrl = "https://example.com";
            port = 9993;
            bindAddress = "127.0.0.1";
          };
          listeners = [
            {
              port = 9000;
              bindAddress = "0.0.0.0";
              resources = [ "webhooks" ];
            }
            {
              port = 9001;
              bindAddress = "localhost";
              resources = [
                "metrics"
                "provisioning"
              ];
            }
          ];
        };
        default = { };
        type = lib.types.submodule {
          freeformType = settingsFormat.type;
          options = {
            passFile = lib.mkOption {
              type = lib.types.path;
              default = "/var/lib/matrix-hookshot/passkey.pem";
              description = ''
                A passkey used to encrypt tokens stored inside the bridge.
                File will be generated if not found.
              '';
            };
          };
        };
      };

      serviceDependencies = lib.mkOption {
        type = with lib.types; listOf str;
        default = lib.optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit;
        defaultText = lib.literalExpression ''
          lib.optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit
        '';
        description = ''
          List of Systemd services to require and wait for when starting the application service,
          such as the Matrix homeserver if it's running on the same host.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.matrix-hookshot = {
      description = "a bridge between Matrix and multiple project management services";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ] ++ cfg.serviceDependencies;
      after = [ "network-online.target" ] ++ cfg.serviceDependencies;

      preStart = ''
        if [ ! -f '${cfg.settings.passFile}' ]; then
          mkdir -p $(dirname '${cfg.settings.passFile}')
          ${pkgs.openssl}/bin/openssl genpkey -out '${cfg.settings.passFile}' -outform PEM -algorithm RSA -pkeyopt rsa_keygen_bits:4096
        fi
      '';

      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${cfg.package}/bin/matrix-hookshot ${configFile} ${cfg.registrationFile}";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ flandweber ];
}

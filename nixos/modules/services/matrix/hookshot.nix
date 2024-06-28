{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.services.matrix-hookshot;
  opt = options.services.matrix-hookshot;
  configFile = pkgs.writeText "matrix-hookshot-config.yml" (lib.generators.toYAML {} cfg.settings);
in {
  options = {
    services.matrix-hookshot = {
      enable = mkEnableOption "A bridge between Matrix and multiple project management services";

      package = mkPackageOption pkgs "matrix-hookshot" {};

      registrationFile = mkOption {type = types.path;};

      settings = mkOption {
        type = types.attrs;
        example = literalExpression ''
          {
            bridge = {
              domain = "example.com";
              url = "http://localhost:8008";
              mediaUrl = "https://example.com";
              port = 9993;
              bindAddress = "127.0.0.1";
            };
            passFile = "/var/lib/matrix-hookshot/passkey.pem";
            listeners = [
              {
                port = 9000;
                bindAddress = "0.0.0.0";
                resources = ["webhooks"];
              }
              {
                port = 9001;
                bindAddress = "localhost";
                resources = ["metrics" "provisioning"];
              }
            ];
          }
        '';
        description = ''
          {file}`config.yml` configuration as a Nix attribute set.

          For details please see the [documentation](https://matrix-org.github.io/matrix-hookshot/latest/setup/sample-configuration.html).

          {option}`config.passFile` will be generated if not present.
        '';
      };

      serviceDependencies = mkOption {
        type = with types; listOf str;
        default = optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit;
        defaultText = literalExpression ''
          optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit
        '';
        description = ''
          List of Systemd services to require and wait for when starting the application service,
          such as the Matrix homeserver if it's running on the same host.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.matrix-hookshot = {
      description = "a bridge between Matrix and multiple project management services";

      wantedBy = ["multi-user.target"];
      wants = ["network-online.target"] ++ cfg.serviceDependencies;
      after = ["network-online.target"] ++ cfg.serviceDependencies;

      preStart = ''
        if [ ! -f '${cfg.settings.passFile}' ]; then
          mkdir -p $(dirname ${cfg.settings.passFile})
          ${pkgs.openssl}/bin/openssl genpkey -out ${cfg.settings.passFile} -outform PEM -algorithm RSA -pkeyopt rsa_keygen_bits:4096
        fi
      '';

      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${cfg.package}/bin/matrix-hookshot ${configFile} ${cfg.registrationFile}";
      };
    };
  };

  meta.maintainers = with maintainers; [ flandweber ];
}

{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.prometheus.sachet;
  configFile = pkgs.writeText "sachet.yml" (builtins.toJSON cfg.configuration);
in
{
  options = {
    services.prometheus.sachet = {
      enable = lib.mkEnableOption "Sachet, an SMS alerting tool for the Prometheus Alertmanager";

      configuration = lib.mkOption {
        type = lib.types.nullOr lib.types.attrs;
        default = null;
        example = lib.literalExpression ''
          {
            providers = {
              twilio = {
                # environment variables gets expanded at runtime
                account_sid = "$TWILIO_ACCOUNT";
                auth_token = "$TWILIO_TOKEN";
              };
            };
            templates = [ ./some-template.tmpl ];
            receivers = [{
              name = "pager";
              provider = "twilio";
              to = [ "+33123456789" ];
              text = "{{ template \"message\" . }}";
            }];
          }
        '';
        description = ''
          Sachet's configuration as a nix attribute set.
        '';
      };

      address = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = ''
          The address Sachet will listen to.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 9876;
        description = ''
          The port Sachet will listen to.
        '';
      };

    };
  };

  config = lib.mkIf cfg.enable {
    assertions = lib.singleton {
      assertion = cfg.configuration != null;
      message = "Cannot enable Sachet without a configuration.";
    };

    systemd.services.sachet = {
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "network-online.target"
      ];
      script = ''
        ${pkgs.envsubst}/bin/envsubst -i "${configFile}" > /tmp/sachet.yaml
        exec ${pkgs.prometheus-sachet}/bin/sachet -config /tmp/sachet.yaml -listen-address ${cfg.address}:${builtins.toString cfg.port}
      '';

      serviceConfig = {
        Restart = "always";

        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;

        DynamicUser = true;
        PrivateTmp = true;
        WorkingDirectory = "/tmp/";
      };
    };
  };
}

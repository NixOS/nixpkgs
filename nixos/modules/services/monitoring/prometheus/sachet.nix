{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.prometheus.sachet;
  configFile = pkgs.writeText "sachet.yml" (builtins.toJSON cfg.configuration);
in
{
  options = {
    services.prometheus.sachet = {
      enable = mkEnableOption "Sachet is an SMS alerting tool for the Prometheus Alertmanager";

      configuration = mkOption {
        type = types.nullOr types.attrs;
        default = null;
        example = literalExample ''
          {
            providers = {
              twilio = {
                account_sid = "aCb3bbaacc554b";
                auth_token = "4736473aaabbcc66";
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
          sachet configuration as nix attribute set.
        '';
      };

      listenAddress = mkOption {
        type = types.str;
        default = "localhost:9876";
        description = ''
          The address sachet will listen to.
        '';
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      assertions = singleton {
        assertion = cfg.configuration != null;
        message = "Can not enable sachet without a configuration.";
      };
    }) (mkIf cfg.enable {
        systemd.services.sachet = {
          wantedBy = [ "multi-user.target" ];
          after = [ "network-online.target" ];
          serviceConfig = {
            Type = "simple";
            Restart = "always";

            ProtectSystem = "strict";
            ProtectHome = true;
            ProtectKernelTunables = true;
            ProtectKernelModules = true;
            ProtectControlGroups = true;

            DynamicUser = true;
            PrivateTmp = true;
            WorkingDirectory = "/tmp/";

            ExecStart = "${pkgs.prometheus-sachet}/bin/sachet -config "
             + "${configFile} -listen-address ${cfg.listenAddress}";
          };
        };
    })
  ];
}

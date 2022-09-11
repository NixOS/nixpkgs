{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.certbot;
in {

  options = {

    services.certbot = {

      enable = mkEnableOption "Certbot ACME client automatic certificate renewal";

      acceptTerms = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Accept the CA's terms of service. The default provider is Let's Encrypt,
          you can find their ToS at <https://letsencrypt.org/repository/>.
        '';
      };

      package = mkOption {
        type = types.package;
        description = mdDoc "Certbot package to use.";
        default = pkgs.certbot;
        defaultText = literalExpression "pkgs.certbot";
      };

    };

  };

  config = mkIf cfg.enable {

    assertions = [{
      assertion = cfg.acceptTerms;
      message = ''
        You must accept the CA's terms of service before using
        the ACME module by setting `security.acme.acceptTerms`
        to `true`. For Let's Encrypt's ToS see https://letsencrypt.org/repository/
      '';
    }];

    environment.systemPackages = [ cfg.package ];

    systemd.timers.certbot = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "60m";
        OnUnitActiveSec = "60m";
      };
    };

    systemd.services.certbot = {
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStart = "${cfg.package}/bin/certbot renew  --quiet --agree-tos";
      };
    };

    systemd.tmpfiles.rules = ["d /etc/letsencrypt 0750 root acme"];

  };

}


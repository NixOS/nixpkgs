{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.keylime;
in
{
  options = {
    services.keylime = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "Whether to enable keylime services.";
      };

      registrar = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = lib.mdDoc "Whether to enable keylime-registrar service.";
        };
      };

      verifier = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = lib.mdDoc "Whether to enable keylime-verifier service.";
        };
      };

      user = mkOption {
        type = types.str;
        default = "keylime";
        description = lib.mdDoc "User which runs keylime.";
      };

      group = mkOption {
        type = types.str;
        default = "keylime";
        description = lib.mdDoc "Group which runs keylime.";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.etc."keylime/tenant.conf".source = "${pkgs.keylime}/etc/config/tenant.conf";

      users.users.keylime = {
        description = "Keylime user";
        extraGroups = [ "${cfg.group}" ];
        isSystemUser = true;
      };

      users.groups.${cfg.group} = {};
    }

    (mkIf cfg.registrar.enable {
      environment.etc."keylime/registrar.conf".source = "${pkgs.keylime}/etc/config/registrar.conf";
      environment.etc."keylime/logging.conf".source = "${pkgs.keylime}/etc/config/logging.conf";

      systemd.services."keylime-registrar" = {
        description = "Keylime registrar service";
        after = [ "network.target" ];
        wantedBy = [ "default.target" ];
        serviceConfig = {
          User = "${cfg.user}";
          Group = "${cfg.group}";
          Restart = "on-failure";
          ExecStart = "${pkgs.keylime}/bin/keylime_registrar";
          TimeoutSec= 60;
          RestartSec= 120;
        };
      };
    })

    (mkIf cfg.verifier.enable {
      environment.etc."keylime/verifier.conf".source = "${pkgs.keylime}/etc/config/verifier.conf";
      environment.etc."keylime/ca.conf".source = "${pkgs.keylime}/etc/config/ca.conf";
      environment.etc."keylime/logging.conf".source = "${pkgs.keylime}/etc/config/logging.conf";

      systemd.services."keylime-verifier" = {
        description = "Keylime verifier service";
        after = [ "network.target" ];
        before = [ "keylime-registrar.service" ];
        wantedBy = [ "default.target" ];
        unitConfig = {
          StartLimitIntervalSec = 10;
          StartLimitBurst = 5;
        };

        serviceConfig = {
          User = "${cfg.user}";
          Group = "${cfg.group}";
          Restart = "on-failure";
          ExecStart = "${pkgs.keylime}/bin/keylime_verifier";
          TimeoutSec= 60;
          RestartSec= 120;
        };
      };
    })
  ]);
}

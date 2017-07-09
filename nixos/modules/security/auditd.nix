{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.security.auditd;
in {
  options = {
    security.auditd = {
      enable = mkOption {
        type        = types.enum [ false true ];
        default     = false;
        description = ''
          Whether to enable the Linux Audit daemon.
        '';
      };
    };
  };

  config = {
    systemd.services.auditd = mkIf cfg.enable {
      description = "Linux Audit daemon";
      wantedBy = [ "basic.target" ];

      unitConfig = {
        ConditionVirtualization = "!container";
        ConditionSecurity = [ "audit" ];
      };


      path = [ pkgs.audit ];

      serviceConfig = {
        ExecStartPre="${pkgs.coreutils}/bin/mkdir -p /var/log/audit";
        ExecStart = "${pkgs.audit}/bin/auditd -l -n -s nochange";
      };
    };
  };
}

{ config, lib, pkgs, ... }:

with lib;

{
  options.security.auditd.enable = mkEnableOption "the Linux Audit daemon";

  config = mkIf config.security.auditd.enable {
    systemd.services.auditd = {
      description = "Linux Audit daemon";
      wantedBy = [ "basic.target" ];

      unitConfig = {
        ConditionVirtualization = "!container";
        ConditionSecurity = [ "audit" ];
        DefaultDependencies = false;
      };

      path = [ pkgs.audit ];

      serviceConfig = {
        ExecStartPre="${pkgs.coreutils}/bin/mkdir -p /var/log/audit";
        ExecStart = "${pkgs.audit}/bin/auditd -l -n -s nochange";
      };
    };
  };
}

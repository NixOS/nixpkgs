{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.security.auditd.enable = lib.mkEnableOption "the Linux Audit daemon";

  config = lib.mkIf config.security.auditd.enable {
    boot.kernelParams = [ "audit=1" ];

    environment.systemPackages = [ pkgs.audit ];

    systemd.services.auditd = {
      description = "Linux Audit daemon";
      wantedBy = [ "sysinit.target" ];
      after = [
        "local-fs.target"
        "systemd-tmpfiles-setup.service"
      ];
      before = [
        "sysinit.target"
        "shutdown.target"
      ];
      conflicts = [ "shutdown.target" ];

      unitConfig = {
        ConditionVirtualization = "!container";
        ConditionSecurity = [ "audit" ];
        DefaultDependencies = false;
      };

      path = [ pkgs.audit ];

      serviceConfig = {
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /var/log/audit";
        ExecStart = "${pkgs.audit}/bin/auditd -l -n -s nochange";
      };
    };
  };
}

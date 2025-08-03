{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.security.auditd.enable = lib.mkEnableOption "the Linux Audit daemon";

  config = lib.mkIf config.security.auditd.enable {
    # Starting auditd should also enable loading the audit rules..
    security.audit.enable = lib.mkDefault true;

    environment.systemPackages = [ pkgs.audit ];

    systemd.services.auditd = {
      description = "Security Audit Logging Service";
      documentation = [ "man:auditd(8)" ];
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
        DefaultDependencies = false;
        RefuseManualStop = true;
        ConditionVirtualization = "!container";
        ConditionKernelCommandLine = [
          "!audit=0"
          "!audit=off"
        ];
      };

      serviceConfig = {
        LogsDirectory = "audit";
        ExecStart = "${pkgs.audit}/bin/auditd -l -n -s nochange";
        Restart = "on-failure";
        # Do not restart for intentional exits. See EXIT CODES section in auditd(8).
        RestartPreventExitStatus = "2 4 6";

        # Upstream hardening settings
        MemoryDenyWriteExecute = true;
        LockPersonality = true;
        RestrictRealtime = true;
      };
    };
  };
}

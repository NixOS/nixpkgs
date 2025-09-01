{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.security.audit;

  failureModes = {
    silent = 0;
    printk = 1;
    panic = 2;
  };

  # The order of the fixed rules is determined by augenrules(8)
  rules = pkgs.writeTextDir "audit.rules" ''
    -D
    -b ${toString cfg.backlogLimit}
    -f ${toString failureModes.${cfg.failureMode}}
    -r ${toString cfg.rateLimit}
    ${lib.concatLines cfg.rules}
    -e ${if cfg.enable == "lock" then "2" else "1"}
  '';
in
{
  options = {
    security.audit = {
      enable = lib.mkOption {
        type = lib.types.enum [
          false
          true
          "lock"
        ];
        default = false;
        description = ''
          Whether to enable the Linux audit system. The special `lock` value can be used to
          enable auditing and prevent disabling it until a restart. Be careful about locking
          this, as it will prevent you from changing your audit configuration until you
          restart. If possible, test your configuration using build-vm beforehand.
        '';
      };

      failureMode = lib.mkOption {
        type = lib.types.enum [
          "silent"
          "printk"
          "panic"
        ];
        default = "printk";
        description = "How to handle critical errors in the auditing system";
      };

      backlogLimit = lib.mkOption {
        type = lib.types.int;
        # Significantly increase from the kernel default of 64 because a
        # normal systems generates way more logs.
        default = 1024;
        description = ''
          The maximum number of outstanding audit buffers allowed; exceeding this is
          considered a failure and handled in a manner specified by failureMode.
        '';
      };

      rateLimit = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = ''
          The maximum messages per second permitted before triggering a failure as
          specified by failureMode. Setting it to zero disables the limit.
        '';
      };

      rules = lib.mkOption {
        type = lib.types.listOf lib.types.str; # (types.either types.str (types.submodule rule));
        default = [ ];
        example = [ "-a exit,always -F arch=b64 -S execve" ];
        description = ''
          The ordered audit rules, with each string appearing as one line of the audit.rules file.
        '';
      };
    };
  };

  config = lib.mkIf (cfg.enable == "lock" || cfg.enable) {
    boot.kernelParams = [
      # A lot of audit events happen before the systemd service starts. Thus
      # enable it via the kernel commandline to have the audit subsystem ready
      # as soon as the kernel starts.
      "audit=1"
      # Also set the backlog limit because the kernel default is too small to
      # capture all of them before the service starts.
      "audit_backlog_limit=${toString cfg.backlogLimit}"
    ];

    environment.systemPackages = [ pkgs.audit ];

    systemd.services.audit-rules = {
      description = "Load Audit Rules";
      wantedBy = [ "sysinit.target" ];
      before = [
        "sysinit.target"
        "shutdown.target"
      ];
      conflicts = [ "shutdown.target" ];

      unitConfig = {
        DefaultDependencies = false;
        ConditionVirtualization = "!container";
        ConditionKernelCommandLine = [
          "!audit=0"
          "!audit=off"
        ];
      };

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${lib.getExe' pkgs.audit "auditctl"} -R ${rules}/audit.rules";
        ExecStopPost = [
          # Disable auditing
          "${lib.getExe' pkgs.audit "auditctl"} -e 0"
          # Delete all rules
          "${lib.getExe' pkgs.audit "auditctl"} -D"
        ];
      };
    };
  };
}

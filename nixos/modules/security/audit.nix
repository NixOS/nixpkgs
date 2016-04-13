{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.security.audit;

  failureModes = {
    silent = 0;
    printk = 1;
    panic  = 2;
  };

  # TODO: it seems like people like their rules to be somewhat secret, yet they will not be if
  # put in the store like this. At the same time, it doesn't feel like a huge deal and working
  # around that is a pain so I'm leaving it like this for now.
  startScript = pkgs.writeScript "audit-start" ''
    #!${pkgs.stdenv.shell} -eu
    # Clear out any rules we may start with
    auditctl -D

    # Put the rules in a temporary file owned and only readable by root
    rulesfile="$(mktemp)"
    ${concatMapStrings (x: "echo '${x}' >> $rulesfile\n") cfg.rules}

    # Apply the requested rules
    auditctl -R "$rulesfile"

    # Enable and configure auditing
    auditctl \
      -e ${if cfg.enable == "lock" then "2" else "1"} \
      -b ${toString cfg.backlogLimit} \
      -f ${toString failureModes.${cfg.failureMode}} \
      -r ${toString cfg.rateLimit}
  '';

  stopScript = pkgs.writeScript "audit-stop" ''
    #!${pkgs.stdenv.shell} -eu
    # Clear the rules
    auditctl -D

    # Disable auditing
    auditctl -e 0
  '';
in {
  options = {
    security.audit = {
      enable = mkOption {
        type        = types.enum [ false true "lock" ];
        default     = true; # The kernel seems to enable it by default with no rules anyway
        description = ''
          Whether to enable the Linux audit system. The special `lock' value can be used to
          enable auditing and prevent disabling it until a restart. Be careful about locking
          this, as it will prevent you from changing your audit configuration until you
          restart. If possible, test your configuration using build-vm beforehand.
        '';
      };

      failureMode = mkOption {
        type        = types.enum [ "silent" "printk" "panic" ];
        default     = "printk";
        description = "How to handle critical errors in the auditing system";
      };

      backlogLimit = mkOption {
        type        = types.int;
        default     = 64; # Apparently the kernel default
        description = ''
          The maximum number of outstanding audit buffers allowed; exceeding this is
          considered a failure and handled in a manner specified by failureMode.
        '';
      };

      rateLimit = mkOption {
        type        = types.int;
        default     = 0;
        description = ''
          The maximum messages per second permitted before triggering a failure as
          specified by failureMode. Setting it to zero disables the limit.
        '';
      };

      rules = mkOption {
        type        = types.listOf types.str; # (types.either types.str (types.submodule rule));
        default     = [];
        example     = [ "-a exit,always -F arch=b64 -S execve" ];
        description = ''
          The ordered audit rules, with each string appearing as one line of the audit.rules file.
        '';
      };
    };
  };

  config = mkIf (cfg.enable == "lock" || cfg.enable) {
    systemd.services.audit = {
      description = "Kernel Auditing";
      wantedBy = [ "basic.target" ];

      unitConfig.ConditionVirtualization = "!container";

      path = [ pkgs.audit ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "@${startScript} audit-start";
        ExecStop  = "@${stopScript}  audit-stop";
      };
    };
  };
}

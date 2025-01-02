{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.ucarp;

  ucarpExec = concatStringsSep " " (
    [
      "${cfg.package}/bin/ucarp"
      "--interface=${cfg.interface}"
      "--srcip=${cfg.srcIp}"
      "--vhid=${toString cfg.vhId}"
      "--passfile=${cfg.passwordFile}"
      "--addr=${cfg.addr}"
      "--advbase=${toString cfg.advBase}"
      "--advskew=${toString cfg.advSkew}"
      "--upscript=${cfg.upscript}"
      "--downscript=${cfg.downscript}"
      "--deadratio=${toString cfg.deadratio}"
    ]
    ++ (optional cfg.preempt "--preempt")
    ++ (optional cfg.neutral "--neutral")
    ++ (optional cfg.shutdown "--shutdown")
    ++ (optional cfg.ignoreIfState "--ignoreifstate")
    ++ (optional cfg.noMcast "--nomcast")
    ++ (optional (cfg.extraParam != null) "--xparam=${cfg.extraParam}")
  );
in {
  options.networking.ucarp = {
    enable = mkEnableOption "ucarp, userspace implementation of CARP";

    interface = mkOption {
      type = types.str;
      description = "Network interface to bind to.";
      example = "eth0";
    };

    srcIp = mkOption {
      type = types.str;
      description = "Source (real) IP address of this host.";
    };

    vhId = mkOption {
      type = types.ints.between 1 255;
      description = "Virtual IP identifier shared between CARP hosts.";
      example = 1;
    };

    passwordFile = mkOption {
      type = types.str;
      description = "File containing shared password between CARP hosts.";
      example = "/run/keys/ucarp-password";
    };

    preempt = mkOption {
      type = types.bool;
      description = ''
        Enable preemptive failover.
        Thus, this host becomes the CARP master as soon as possible.
      '';
      default = false;
    };

    neutral = mkOption {
      type = types.bool;
      description = "Do not run downscript at start if the host is the backup.";
      default = false;
    };

    addr = mkOption {
      type = types.str;
      description = "Virtual shared IP address.";
    };

    advBase = mkOption {
      type = types.ints.unsigned;
      description = "Advertisement frequency in seconds.";
      default = 1;
    };

    advSkew = mkOption {
      type = types.ints.unsigned;
      description = "Advertisement skew in seconds.";
      default = 0;
    };

    upscript = mkOption {
      type = types.path;
      description = ''
        Command to run after become master, the interface name, virtual address
        and optional extra parameters are passed as arguments.
      '';
      example = literalExpression ''
        pkgs.writeScript "upscript" '''
          #!/bin/sh
          ''${pkgs.iproute2}/bin/ip addr add "$2"/24 dev "$1"
        ''';
      '';
    };

    downscript = mkOption {
      type = types.path;
      description = ''
        Command to run after become backup, the interface name, virtual address
        and optional extra parameters are passed as arguments.
      '';
      example = literalExpression ''
        pkgs.writeScript "downscript" '''
          #!/bin/sh
          ''${pkgs.iproute2}/bin/ip addr del "$2"/24 dev "$1"
        ''';
      '';
    };

    deadratio = mkOption {
      type = types.ints.unsigned;
      description = "Ratio to consider a host as dead.";
      default = 3;
    };

    shutdown = mkOption {
      type = types.bool;
      description = "Call downscript at exit.";
      default = false;
    };

    ignoreIfState = mkOption {
      type = types.bool;
      description = "Ignore interface state, e.g., down or no carrier.";
      default = false;
    };

    noMcast = mkOption {
      type = types.bool;
      description = "Use broadcast instead of multicast advertisements.";
      default = false;
    };

    extraParam = mkOption {
      type = types.nullOr types.str;
      description = "Extra parameter to pass to the up/down scripts.";
      default = null;
    };

    package = mkPackageOption pkgs "ucarp" {
      extraDescription = ''
        Please note that the default package, pkgs.ucarp, has not received any
        upstream updates for a long time and can be considered as unmaintained.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.ucarp = {
      description = "ucarp, userspace implementation of CARP";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        Type = "exec";
        ExecStart = ucarpExec;

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ oxzi ];
}

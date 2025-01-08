{ config, lib, pkgs, ... }:

let
  cfg = config.networking.ucarp;

  ucarpExec = lib.concatStringsSep " " (
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
    ++ (lib.optional cfg.preempt "--preempt")
    ++ (lib.optional cfg.neutral "--neutral")
    ++ (lib.optional cfg.shutdown "--shutdown")
    ++ (lib.optional cfg.ignoreIfState "--ignoreifstate")
    ++ (lib.optional cfg.noMcast "--nomcast")
    ++ (lib.optional (cfg.extraParam != null) "--xparam=${cfg.extraParam}")
  );
in {
  options.networking.ucarp = {
    enable = lib.mkEnableOption "ucarp, userspace implementation of CARP";

    interface = lib.mkOption {
      type = lib.types.str;
      description = "Network interface to bind to.";
      example = "eth0";
    };

    srcIp = lib.mkOption {
      type = lib.types.str;
      description = "Source (real) IP address of this host.";
    };

    vhId = lib.mkOption {
      type = lib.types.ints.between 1 255;
      description = "Virtual IP identifier shared between CARP hosts.";
      example = 1;
    };

    passwordFile = lib.mkOption {
      type = lib.types.str;
      description = "File containing shared password between CARP hosts.";
      example = "/run/keys/ucarp-password";
    };

    preempt = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Enable preemptive failover.
        Thus, this host becomes the CARP master as soon as possible.
      '';
      default = false;
    };

    neutral = lib.mkOption {
      type = lib.types.bool;
      description = "Do not run downscript at start if the host is the backup.";
      default = false;
    };

    addr = lib.mkOption {
      type = lib.types.str;
      description = "Virtual shared IP address.";
    };

    advBase = lib.mkOption {
      type = lib.types.ints.unsigned;
      description = "Advertisement frequency in seconds.";
      default = 1;
    };

    advSkew = lib.mkOption {
      type = lib.types.ints.unsigned;
      description = "Advertisement skew in seconds.";
      default = 0;
    };

    upscript = lib.mkOption {
      type = lib.types.path;
      description = ''
        Command to run after become master, the interface name, virtual address
        and lib.optional extra parameters are passed as arguments.
      '';
      example = lib.literalExpression ''
        pkgs.writeScript "upscript" '''
          #!/bin/sh
          ''${pkgs.iproute2}/bin/ip addr add "$2"/24 dev "$1"
        ''';
      '';
    };

    downscript = lib.mkOption {
      type = lib.types.path;
      description = ''
        Command to run after become backup, the interface name, virtual address
        and lib.optional extra parameters are passed as arguments.
      '';
      example = lib.literalExpression ''
        pkgs.writeScript "downscript" '''
          #!/bin/sh
          ''${pkgs.iproute2}/bin/ip addr del "$2"/24 dev "$1"
        ''';
      '';
    };

    deadratio = lib.mkOption {
      type = lib.types.ints.unsigned;
      description = "Ratio to consider a host as dead.";
      default = 3;
    };

    shutdown = lib.mkOption {
      type = lib.types.bool;
      description = "Call downscript at exit.";
      default = false;
    };

    ignoreIfState = lib.mkOption {
      type = lib.types.bool;
      description = "Ignore interface state, e.g., down or no carrier.";
      default = false;
    };

    noMcast = lib.mkOption {
      type = lib.types.bool;
      description = "Use broadcast instead of multicast advertisements.";
      default = false;
    };

    extraParam = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "Extra parameter to pass to the up/down scripts.";
      default = null;
    };

    package = lib.mkPackageOption pkgs "ucarp" {
      extraDescription = ''
        Please note that the default package, pkgs.ucarp, has not received any
        upstream updates for a long time and can be considered as unmaintained.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
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

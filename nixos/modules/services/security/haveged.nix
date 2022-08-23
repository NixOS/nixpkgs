{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.haveged;

in

{

  ###### interface

  options = {

    services.haveged = {

      enable = mkEnableOption ''
        haveged entropy daemon, which refills /dev/random when low.
        NOTE: does nothing on kernels newer than 5.6.
      '';
      # source for the note https://github.com/jirka-h/haveged/issues/57

      refill_threshold = mkOption {
        type = types.int;
        default = 1024;
        description = lib.mdDoc ''
          The number of bits of available entropy beneath which
          haveged should refill the entropy pool.
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    # https://github.com/jirka-h/haveged/blob/a4b69d65a8dfc5a9f52ff8505c7f58dcf8b9234f/contrib/Fedora/haveged.service
    systemd.services.haveged = {
      description = "Entropy Daemon based on the HAVEGE algorithm";
      unitConfig = {
        Documentation = "man:haveged(8)";
        DefaultDependencies = false;
        ConditionKernelVersion = "<5.6";
      };
      wantedBy = [ "sysinit.target" ];
      after = [ "systemd-tmpfiles-setup-dev.service" ];
      before = [ "sysinit.target" "shutdown.target" "systemd-journald.service" ];

      serviceConfig = {
        ExecStart = "${pkgs.haveged}/bin/haveged -w ${toString cfg.refill_threshold} --Foreground -v 1";
        Restart = "always";
        SuccessExitStatus = "137 143";
        SecureBits = "noroot-locked";
        CapabilityBoundingSet = [ "CAP_SYS_ADMIN" "CAP_SYS_CHROOT" ];
        # We can *not* set PrivateTmp=true as it can cause an ordering cycle.
        PrivateTmp = false;
        PrivateDevices = true;
        ProtectSystem = "full";
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "newuname" "~@mount" ];
        SystemCallErrorNumber = "EPERM";
      };

    };
  };

}

{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.security.grsecurity;
  grsecLockPath = "/proc/sys/kernel/grsecurity/grsec_lock";

  # Ascertain whether NixOS container support is required
  containerSupportRequired =
    config.boot.enableContainers && config.containers != {};
in

{
  meta = {
    maintainers = with maintainers; [ joachifm ];
    doc = ./grsecurity.xml;
  };

  options.security.grsecurity = {

    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable grsecurity/PaX.
      '';
    };

    lockTunables = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to automatically lock grsecurity tunables
        (<option>boot.kernel.sysctl."kernel.grsecurity.*"</option>).  Disable
        this to allow runtime configuration of grsecurity features.  Activate
        the <literal>grsec-lock</literal> service unit to prevent further
        configuration until the next reboot.
      '';
    };

    disableEfiRuntimeServices = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to disable access to EFI runtime services.  Enabling EFI runtime
        services creates a venue for code injection attacks on the kernel and
        should be disabled if at all possible.  Changing this option enters into
        effect upon reboot.
      '';
    };

  };

  config = mkIf cfg.enable {

    boot.kernelPackages = mkForce pkgs.linuxPackages_grsec_nixos;

    boot.kernelParams = [ "grsec_sysfs_restrict=0" ]
      ++ optional cfg.disableEfiRuntimeServices "noefi";

    nixpkgs.config.grsecurity = true;

    # Install PaX related utillities into the system profile.
    environment.systemPackages = with pkgs; [ gradm paxctl pax-utils ];

    # Install rules for the grsec device node
    services.udev.packages = [ pkgs.gradm ];

    # This service unit is responsible for locking the grsecurity tunables.  The
    # unit is always defined, but only activated on bootup if lockTunables is
    # toggled.  When lockTunables is toggled, failure to activate the unit will
    # enter emergency mode.  The intent is to make it difficult to silently
    # enter multi-user mode without having locked the tunables.  Some effort is
    # made to ensure that starting the unit is an idempotent operation.
    systemd.services.grsec-lock = {
      description = "Lock grsecurity tunables";

      wantedBy = optional cfg.lockTunables "multi-user.target";

      wants = [ "local-fs.target" "systemd-sysctl.service" ];
      after = [ "local-fs.target" "systemd-sysctl.service" ];
      conflicts = [ "shutdown.target" ];

      restartIfChanged = false;

      script = ''
        if ${pkgs.gnugrep}/bin/grep -Fq 0 ${grsecLockPath} ; then
          echo -n 1 > ${grsecLockPath}
        fi
      '';

      unitConfig = {
        ConditionPathIsReadWrite = grsecLockPath;
        DefaultDependencies = false;
      } // optionalAttrs cfg.lockTunables {
        OnFailure = "emergency.target";
      };

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };

    # Configure system tunables
    boot.kernel.sysctl = {
      # Read-only under grsecurity
      "kernel.kptr_restrict" = mkForce null;

      # All grsec tunables default to off, those not enabled below are
      # *disabled*.  We use mkDefault to allow expert users to override
      # our choices, but use mkForce where tunables would outright
      # conflict with other settings.

      # Enable all chroot restrictions by default (overwritten as
      # necessary below)
      "kernel.grsecurity.chroot_caps" = mkDefault 1;
      "kernel.grsecurity.chroot_deny_bad_rename" = mkDefault 1;
      "kernel.grsecurity.chroot_deny_chmod" = mkDefault 1;
      "kernel.grsecurity.chroot_deny_chroot" = mkDefault 1;
      "kernel.grsecurity.chroot_deny_fchdir" = mkDefault 1;
      "kernel.grsecurity.chroot_deny_mknod" = mkDefault 1;
      "kernel.grsecurity.chroot_deny_mount" = mkDefault 1;
      "kernel.grsecurity.chroot_deny_pivot" = mkDefault 1;
      "kernel.grsecurity.chroot_deny_shmat" = mkDefault 1;
      "kernel.grsecurity.chroot_deny_sysctl" = mkDefault 1;
      "kernel.grsecurity.chroot_deny_unix" = mkDefault 1;
      "kernel.grsecurity.chroot_enforce_chdir" = mkDefault 1;
      "kernel.grsecurity.chroot_findtask" = mkDefault 1;
      "kernel.grsecurity.chroot_restrict_nice" = mkDefault 1;

      # Enable various grsec protections
      "kernel.grsecurity.consistent_setxid" = mkDefault 1;
      "kernel.grsecurity.deter_bruteforce" = mkDefault 1;
      "kernel.grsecurity.fifo_restrictions" = mkDefault 1;
      "kernel.grsecurity.harden_ipc" = mkDefault 1;
      "kernel.grsecurity.harden_ptrace" = mkDefault 1;
      "kernel.grsecurity.harden_tty" = mkDefault 1;
      "kernel.grsecurity.ip_blackhole" = mkDefault 1;
      "kernel.grsecurity.linking_restrictions" = mkDefault 1;
      "kernel.grsecurity.ptrace_readexec" = mkDefault 1;

      # Enable auditing
      "kernel.grsecurity.audit_ptrace" = mkDefault 1;
      "kernel.grsecurity.forkfail_logging" = mkDefault 1;
      "kernel.grsecurity.rwxmap_logging" = mkDefault 1;
      "kernel.grsecurity.signal_logging" = mkDefault 1;
      "kernel.grsecurity.timechange_logging" = mkDefault 1;
    } // optionalAttrs config.nix.useSandbox {
      # chroot(2) restrictions that conflict with sandboxed Nix builds
      "kernel.grsecurity.chroot_caps" = mkForce 0;
      "kernel.grsecurity.chroot_deny_chmod" = mkForce 0;
      "kernel.grsecurity.chroot_deny_chroot" = mkForce 0;
      "kernel.grsecurity.chroot_deny_mount" = mkForce 0;
      "kernel.grsecurity.chroot_deny_pivot" = mkForce 0;
    } // optionalAttrs containerSupportRequired {
      # chroot(2) restrictions that conflict with NixOS lightweight containers
      "kernel.grsecurity.chroot_caps" = mkForce 0;
      "kernel.grsecurity.chroot_deny_chmod" = mkForce 0;
      "kernel.grsecurity.chroot_deny_mount" = mkForce 0;
      "kernel.grsecurity.chroot_restrict_nice" = mkForce 0;
      # Disable privileged IO by default, unless X is enabled
    } // optionalAttrs (!config.services.xserver.enable) {
      "kernel.grsecurity.disable_priv_io" = mkDefault 1;
    };

  };
}

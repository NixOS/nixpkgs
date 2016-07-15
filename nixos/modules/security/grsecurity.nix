{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.security.grsecurity;
  grsecLockPath = "/proc/sys/kernel/grsecurity/grsec_lock";

  # Ascertain whether ZFS is required for booting the system; grsecurity is
  # currently incompatible with ZFS, rendering the system unbootable.
  zfsNeededForBoot = filter
    (fs: (fs.neededForBoot
          || elem fs.mountPoint [ "/" "/nix" "/nix/store" "/var" "/var/log" "/var/lib" "/etc" ])
          && fs.fsType == "zfs")
    (attrValues config.fileSystems) != [];
in

{
  options.security.grsecurity = {

    enable = mkEnableOption "Grsecurity/PaX";

    lockTunables = mkOption {
      type = types.bool;
      example = false;
      default = true;
      description = ''
        Whether to automatically lock grsecurity tunables
        (<option>boot.kernel.sysctl."kernel.grsecurity.*"</option>).  Disable
        this to allow configuration of grsecurity features while the system is
        running.  The lock can be manually engaged by activating the
        <literal>grsec-lock</literal> service unit.
      '';
    };

  };

  config = mkIf cfg.enable {

    # Allow the user to select a different package set, subject to the stated
    # required kernel config
    boot.kernelPackages = mkDefault pkgs.linuxPackages_grsec_nixos;

    system.requiredKernelConfig = with config.lib.kernelConfig;
      [ (isEnabled "GRKERNSEC")
        (isEnabled "PAX")
        (isYES "GRKERNSEC_SYSCTL")
        (isYES "GRKERNSEC_SYSCTL_DISTRO")
      ];

    # Crashing on an overflow in kernel land is user unfriendly and may prevent
    # the system from booting, which is too severe for our use case.
    boot.kernelParams = [ "pax_size_overflow_report_only" ];

    # Install PaX related utillities into the system profile.  Eventually, we
    # also want to include gradm here.
    environment.systemPackages = with pkgs; [ paxctl pax-utils ];

    # Install rules for the grsec device node
    services.udev.packages = [ pkgs.gradm ];

    # This service unit is responsible for locking the Grsecurity tunables.  The
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
      # Removed under grsecurity
      "kernel.kptr_restrict" = mkForce null;
    } // optionalAttrs config.nix.useSandbox {
      # chroot(2) restrictions that conflict with sandboxed Nix builds
      "kernel.grsecurity.chroot_caps" = mkForce 0;
      "kernel.grsecurity.chroot_deny_chroot" = mkForce 0;
      "kernel.grsecurity.chroot_deny_mount" = mkForce 0;
      "kernel.grsecurity.chroot_deny_pivot" = mkForce 0;
    } // optionalAttrs config.boot.enableContainers {
      # chroot(2) restrictions that conflict with NixOS lightweight containers
      "kernel.grsecurity.chroot_deny_chmod" = mkForce 0;
      "kernel.grsecurity.chroot_deny_mount" = mkForce 0;
      "kernel.grsecurity.chroot_restrict_nice" = mkForce 0;
    };

    assertions = [
      { assertion = !zfsNeededForBoot;
        message = "grsecurity is currently incompatible with ZFS";
      }
    ];

  };
}

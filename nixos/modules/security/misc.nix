{ config, lib, ... }:

with lib;

{
  meta = {
    maintainers = [ maintainers.joachifm ];
  };

  imports = [
    (lib.mkRenamedOptionModule [ "security" "virtualization" "flushL1DataCache" ] [ "security" "virtualisation" "flushL1DataCache" ])
  ];

  options = {
    security.allowUserNamespaces = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Whether to allow creation of user namespaces.

        The motivation for disabling user namespaces is the potential
        presence of code paths where the kernel's permission checking
        logic fails to account for namespacing, instead permitting a
        namespaced process to act outside the namespace with the same
        privileges as it would have inside it.  This is particularly
        damaging in the common case of running as root within the namespace.

        When user namespace creation is disallowed, attempting to create a
        user namespace fails with "no space left on device" (ENOSPC).
        root may re-enable user namespace creation at runtime.
      '';
    };

    security.unprivilegedUsernsClone = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        When disabled, unprivileged users will not be able to create new namespaces.
        By default unprivileged user namespaces are disabled.
        This option only works in a hardened profile.
      '';
    };

    security.protectKernelImage = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to prevent replacing the running kernel image.
      '';
    };

    security.allowSimultaneousMultithreading = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Whether to allow SMT/hyperthreading.  Disabling SMT means that only
        physical CPU cores will be usable at runtime, potentially at
        significant performance cost.

        The primary motivation for disabling SMT is to mitigate the risk of
        leaking data between threads running on the same CPU core (due to
        e.g., shared caches).  This attack vector is unproven.

        Disabling SMT is a supplement to the L1 data cache flushing mitigation
        (see [](#opt-security.virtualisation.flushL1DataCache))
        versus malicious VM guests (SMT could "bring back" previously flushed
        data).
      '';
    };

    security.forcePageTableIsolation = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to force-enable the Page Table Isolation (PTI) Linux kernel
        feature even on CPU models that claim to be safe from Meltdown.

        This hardening feature is most beneficial to systems that run untrusted
        workloads that rely on address space isolation for security.
      '';
    };

    security.virtualisation.flushL1DataCache = mkOption {
      type = types.nullOr (types.enum [ "never" "cond" "always" ]);
      default = null;
      description = lib.mdDoc ''
        Whether the hypervisor should flush the L1 data cache before
        entering guests.
        See also [](#opt-security.allowSimultaneousMultithreading).

        - `null`: uses the kernel default
        - `"never"`: disables L1 data cache flushing entirely.
          May be appropriate if all guests are trusted.
        - `"cond"`: flushes L1 data cache only for pre-determined
          code paths.  May leak information about the host address space
          layout.
        - `"always"`: flushes L1 data cache every time the hypervisor
          enters the guest.  May incur significant performance cost.
      '';
    };
  };

  config = mkMerge [
    (mkIf (!config.security.allowUserNamespaces) {
      # Setting the number of allowed user namespaces to 0 effectively disables
      # the feature at runtime.  Note that root may raise the limit again
      # at any time.
      boot.kernel.sysctl."user.max_user_namespaces" = 0;

      assertions = [
        { assertion = config.nix.settings.sandbox -> config.security.allowUserNamespaces;
          message = "`nix.settings.sandbox = true` conflicts with `!security.allowUserNamespaces`.";
        }
      ];
    })

    (mkIf config.security.unprivilegedUsernsClone {
      boot.kernel.sysctl."kernel.unprivileged_userns_clone" = mkDefault true;
    })

    (mkIf config.security.protectKernelImage {
      # Disable hibernation (allows replacing the running kernel)
      boot.kernelParams = [ "nohibernate" ];
      # Prevent replacing the running kernel image w/o reboot
      boot.kernel.sysctl."kernel.kexec_load_disabled" = mkDefault true;
    })

    (mkIf (!config.security.allowSimultaneousMultithreading) {
      boot.kernelParams = [ "nosmt" ];
    })

    (mkIf config.security.forcePageTableIsolation {
      boot.kernelParams = [ "pti=on" ];
    })

    (mkIf (config.security.virtualisation.flushL1DataCache != null) {
      boot.kernelParams = [ "kvm-intel.vmentry_l1d_flush=${config.security.virtualisation.flushL1DataCache}" ];
    })
  ];
}

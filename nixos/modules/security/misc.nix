{ config, lib, ... }:

with lib;

{
  meta = {
    maintainers = [ maintainers.joachifm ];
  };

  options = {
    security.allowUserNamespaces = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to allow creation of user namespaces.  A recurring problem
        with user namespaces is the presence of code paths where the kernel's
        permission checking logic fails to account for namespacing, instead
        permitting a namespaced process to act outside the namespace with the
        same privileges as it would have inside it.  This is particularly
        damaging in the common case of running as root within the namespace.
        When user namespace creation is disallowed, attempting to create
        a user namespace fails with "no space left on device" (ENOSPC).
      '';
    };

    security.protectKernelImage = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to prevent replacing the running kernel image.
      '';
    };

    security.allowSimultaneousMultithreading = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to allow SMT/hyperthreading.  Disabling SMT means that only
        physical CPU cores will be usable at runtime, potentially at
        significant performance cost.
        </para>

        <para>
        The primary motivation for disabling SMT is to mitigate the risk of
        leaking data between threads running on the same CPU core (due to
        e.g., shared caches).  This attack vector is unproven.
        </para>

        <para>
        Disabling SMT is a supplement to the L1 data cache flushing mitigation
        (see <xref linkend="opt-security.virtualization.flushL1DataCache"/>)
        versus malicious VM guests (SMT could "bring back" previously flushed
        data).
        </para>
        <para>
      '';
    };

    security.virtualization.flushL1DataCache = mkOption {
      type = types.nullOr (types.enum [ "never" "cond" "always" ]);
      default = null;
      description = ''
        Whether the hypervisor should flush the L1 data cache before
        entering guests.
        See also <xref linkend="opt-security.allowSimultaneousMultithreading"/>.
        </para>

        <para>
          <variablelist>
          <varlistentry>
            <term><literal>null</literal></term>
            <listitem><para>uses the kernel default</para></listitem>
          </varlistentry>
          <varlistentry>
            <term><literal>"never"</literal></term>
            <listitem><para>disables L1 data cache flushing entirely.
            May be appropriate if all guests are trusted.</para></listitem>
          </varlistentry>
          <varlistentry>
            <term><literal>"cond"</literal></term>
            <listitem><para>flushes L1 data cache only for pre-determined
            code paths.  May leak information about the host address space
            layout.</para></listitem>
          </varlistentry>
          <varlistentry>
            <term><literal>"always"</literal></term>
            <listitem><para>flushes L1 data cache every time the hypervisor
            enters the guest.  May incur significant performance cost.
            </para></listitem>
          </varlistentry>
          </variablelist>
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
        { assertion = config.nix.useSandbox -> config.security.allowUserNamespaces;
          message = "`nix.useSandbox = true` conflicts with `!security.allowUserNamespaces`.";
        }
      ];
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

    (mkIf (config.security.virtualization.flushL1DataCache != null) {
      boot.kernelParams = [ "kvm-intel.vmentry_l1d_flush=${config.security.virtualization.flushL1DataCache}" ];
    })
  ];
}

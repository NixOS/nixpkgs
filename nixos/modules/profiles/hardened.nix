# A profile with most (vanilla) hardening options enabled by default,
# potentially at the cost of features and performance.

{ config, lib, pkgs, ... }:

with lib;

{
  boot.kernelPackages = mkDefault pkgs.linuxPackages_hardened;

  security.hideProcessInformation = mkDefault true;

  security.lockKernelModules = mkDefault true;

  security.apparmor.enable = mkDefault true;

  boot.kernelParams = [
    # Overwrite free'd memory
    "page_poison=1"

    # Disable legacy virtual syscalls
    "vsyscall=none"

    # Disable hibernation (allows replacing the running kernel)
    "nohibernate"
  ];

  # Restrict ptrace() usage to processes with a pre-defined relationship
  # (e.g., parent/child)
  boot.kernel.sysctl."kernel.yama.ptrace_scope" = mkOverride 500 1;

  # Prevent replacing the running kernel image w/o reboot
  boot.kernel.sysctl."kernel.kexec_load_disabled" = mkDefault true;

  # Restrict access to kernel ring buffer (information leaks)
  boot.kernel.sysctl."kernel.dmesg_restrict" = mkDefault true;

  # Hide kptrs even for processes with CAP_SYSLOG
  boot.kernel.sysctl."kernel.kptr_restrict" = mkOverride 500 2;

  # Unprivileged access to bpf() has been used for privilege escalation in
  # the past
  boot.kernel.sysctl."kernel.unprivileged_bpf_disabled" = mkDefault true;

  # Disable bpf() JIT (to eliminate spray attacks)
  boot.kernel.sysctl."net.core.bpf_jit_enable" = mkDefault false;

  # ... or at least apply some hardening to it
  boot.kernel.sysctl."net.core.bpf_jit_harden" = mkDefault true;

  # A recurring problem with user namespaces is that there are
  # still code paths where the kernel's permission checking logic
  # fails to account for namespacing, instead permitting a
  # namespaced process to act outside the namespace with the
  # same privileges as it would have inside it.  This is particularly
  # bad in the common case of running as root within the namespace.
  #
  # Setting the number of allowed user namespaces to 0 effectively disables
  # the feature at runtime.  Attempting to create a user namespace
  # with unshare will then fail with "no space left on device".
  boot.kernel.sysctl."user.max_user_namespaces" = mkDefault 0;

  # Raise ASLR entropy for 64bit & 32bit, respectively.
  #
  # Note: mmap_rnd_compat_bits may not exist on 64bit.
  boot.kernel.sysctl."vm.mmap_rnd_bits" = mkDefault 32;
  boot.kernel.sysctl."vm.mmap_rnd_compat_bits" = mkDefault 16;
}

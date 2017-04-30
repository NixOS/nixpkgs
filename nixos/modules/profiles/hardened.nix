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
}

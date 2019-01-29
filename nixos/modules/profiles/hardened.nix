# A profile with most (vanilla) hardening options enabled by default,
# potentially at the cost of features and performance.

{ lib, pkgs, ... }:

with lib;

{
  meta = {
    maintainers = [ maintainers.joachifm ];
  };

  boot.kernelPackages = mkDefault pkgs.linuxPackages_hardened;

  nix.allowedUsers = mkDefault [ "@users" ];

  security.hideProcessInformation = mkDefault true;

  security.lockKernelModules = mkDefault true;

  security.allowUserNamespaces = mkDefault false;

  security.protectKernelImage = mkDefault true;

  security.allowSimultaneousMultithreading = mkDefault false;

  security.virtualization.flushL1DataCache = mkDefault "always";

  security.apparmor.enable = mkDefault true;

  boot.kernelParams = [
    # Slab/slub sanity checks, redzoning, and poisoning
    "slub_debug=FZP"

    # Disable slab merging to make certain heap overflow attacks harder
    "slab_nomerge"

    # Overwrite free'd memory
    "page_poison=1"

    # Disable legacy virtual syscalls
    "vsyscall=none"

    # Enable PTI even if CPU claims to be safe from meltdown
    "pti=on"
  ];

  boot.blacklistedKernelModules = [
    # Obscure network protocols
    "ax25"
    "netrom"
    "rose"
  ];

  # Restrict ptrace() usage to processes with a pre-defined relationship
  # (e.g., parent/child)
  boot.kernel.sysctl."kernel.yama.ptrace_scope" = mkOverride 500 1;

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

  # Raise ASLR entropy for 64bit & 32bit, respectively.
  #
  # Note: mmap_rnd_compat_bits may not exist on 64bit.
  boot.kernel.sysctl."vm.mmap_rnd_bits" = mkDefault 32;
  boot.kernel.sysctl."vm.mmap_rnd_compat_bits" = mkDefault 16;

  # Allowing users to mmap() memory starting at virtual address 0 can turn a
  # NULL dereference bug in the kernel into code execution with elevated
  # privilege.  Mitigate by enforcing a minimum base addr beyond the NULL memory
  # space.  This breaks applications that require mapping the 0 page, such as
  # dosemu or running 16bit applications under wine.  It also breaks older
  # versions of qemu.
  #
  # The value is taken from the KSPP recommendations (Debian uses 4096).
  boot.kernel.sysctl."vm.mmap_min_addr" = mkDefault 65536;
}

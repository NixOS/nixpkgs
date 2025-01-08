# A profile with most (vanilla) hardening options enabled by default,
# potentially at the cost of stability, features and performance.
#
# This profile enables options that are known to affect system
# stability. If you experience any stability issues when using the
# profile, try disabling it. If you report an issue and use this
# profile, always mention that you do.

{
  config,
  lib,
  pkgs,
  ...
}:

{
  meta = {
    maintainers = [
      lib.maintainers.joachifm
      lib.maintainers.emily
    ];
  };

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_hardened;

  nix.settings.allowed-users = lib.mkDefault [ "@users" ];

  environment.memoryAllocator.provider = lib.mkDefault "scudo";
  environment.variables.SCUDO_OPTIONS = lib.mkDefault "ZeroContents=1";

  security.lockKernelModules = lib.mkDefault true;

  security.protectKernelImage = lib.mkDefault true;

  security.allowSimultaneousMultithreading = lib.mkDefault false;

  security.forcePageTableIsolation = lib.mkDefault true;

  # This is required by podman to run containers in rootless mode.
  security.unprivilegedUsernsClone = lib.mkDefault config.virtualisation.containers.enable;

  security.virtualisation.flushL1DataCache = lib.mkDefault "always";

  security.apparmor.enable = lib.mkDefault true;
  security.apparmor.killUnconfinedConfinables = lib.mkDefault true;

  boot.kernelParams = [
    # Don't merge slabs
    "slab_nomerge"

    # Overwrite free'd pages
    "page_poison=1"

    # Enable page allocator randomization
    "page_alloc.shuffle=1"

    # Disable debugfs
    "debugfs=off"
  ];

  boot.blacklistedKernelModules = [
    # Obscure network protocols
    "ax25"
    "netrom"
    "rose"

    # Old or rare or insufficiently audited filesystems
    "adfs"
    "affs"
    "bfs"
    "befs"
    "cramfs"
    "efs"
    "erofs"
    "exofs"
    "freevxfs"
    "f2fs"
    "hfs"
    "hpfs"
    "jfs"
    "minix"
    "nilfs2"
    "ntfs"
    "omfs"
    "qnx4"
    "qnx6"
    "sysv"
    "ufs"
  ];

  # Hide kptrs even for processes with CAP_SYSLOG
  boot.kernel.sysctl."kernel.kptr_restrict" = lib.mkOverride 500 2;

  # Disable bpf() JIT (to eliminate spray attacks)
  boot.kernel.sysctl."net.core.bpf_jit_enable" = lib.mkDefault false;

  # Disable ftrace debugging
  boot.kernel.sysctl."kernel.ftrace_enabled" = lib.mkDefault false;

  # Enable strict reverse path filtering (that is, do not attempt to route
  # packets that "obviously" do not belong to the iface's network; dropped
  # packets are logged as martians).
  boot.kernel.sysctl."net.ipv4.conf.all.log_martians" = lib.mkDefault true;
  boot.kernel.sysctl."net.ipv4.conf.all.rp_filter" = lib.mkDefault "1";
  boot.kernel.sysctl."net.ipv4.conf.default.log_martians" = lib.mkDefault true;
  boot.kernel.sysctl."net.ipv4.conf.default.rp_filter" = lib.mkDefault "1";

  # Ignore broadcast ICMP (mitigate SMURF)
  boot.kernel.sysctl."net.ipv4.icmp_echo_ignore_broadcasts" = lib.mkDefault true;

  # Ignore incoming ICMP redirects (note: default is needed to ensure that the
  # setting is applied to interfaces added after the sysctls are set)
  boot.kernel.sysctl."net.ipv4.conf.all.accept_redirects" = lib.mkDefault false;
  boot.kernel.sysctl."net.ipv4.conf.all.secure_redirects" = lib.mkDefault false;
  boot.kernel.sysctl."net.ipv4.conf.default.accept_redirects" = lib.mkDefault false;
  boot.kernel.sysctl."net.ipv4.conf.default.secure_redirects" = lib.mkDefault false;
  boot.kernel.sysctl."net.ipv6.conf.all.accept_redirects" = lib.mkDefault false;
  boot.kernel.sysctl."net.ipv6.conf.default.accept_redirects" = lib.mkDefault false;

  # Ignore outgoing ICMP redirects (this is ipv4 only)
  boot.kernel.sysctl."net.ipv4.conf.all.send_redirects" = lib.mkDefault false;
  boot.kernel.sysctl."net.ipv4.conf.default.send_redirects" = lib.mkDefault false;
}

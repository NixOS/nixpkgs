{
  lib,
  ...
}:

let
  inherit (lib) types mkDefault;

  hardeningConfigs.rev1 = {
    # see systemd-analyze capability for a full list of capabilities
    CapabilityBoundingSet = [
      "" # empty entry forces allow-list instead of deny-list
    ];

    # mounts entire filesystem read-only (except /dev, /proc, /sys)
    # different options: "full", true, false
    ProtectSystem = "strict";

    # makes /home/, /root and /run/user inaccessible
    # different options: "read-only", "tmpfs", false
    ProtectHome = true;

    # special directories for various purposes do exist, but defaulting them to something "more secure" is not universally possible.
    # RuntimeDirectory=, StateDirectory=, CacheDirectory=, LogsDirectory=, ConfigurationDirectory=
    # RuntimeDirectoryMode=, StateDirectoryMode=, CacheDirectoryMode=, LogsDirectoryMode=, ConfigurationDirectoryMode=

    # It might make sense to default /nix/store to ReadOnly
    # It might also make sense to default everything to NoExec except /run/wrappers/bin and /nix/store. However, doing so is quite radical.
    # ReadWritePaths=, ReadOnlyPaths=, InaccessiblePaths=, ExecPaths=, NoExecPaths=

    # create a private tmp directory for the process
    # different options: "disconnected" (makes a tmpfs), false
    # implies a writable tmp path
    PrivateTmp = true;

    PrivateDevices = true; # block direct hardware access. Allows pseudo-devices like /dev/null and /dev/shm

    # sets a new network namespace with only loopback device
    # limits AF_UNIX and AF_NETLINK access to only services running in a joint namespace
    # implies PrivateMounts
    PrivateNetwork = true;

    # PrivateIPC exists, but has various complicated implications and implicit effects
    # PrivateIPC=

    # PrivatePIDs exists to define process namespacing. However, it does not work with service type `Forking` and should be used with care.
    # implies MountAPIVFS=true
    # mounts /proc in a way such that only processes in the same namespace are visible
    PrivatePIDs = true;

    # Use user namespacing
    # WARNING: this makes the CaCapabilityBoundingSet only affect the user namespace, the service runs completely unprivileged on the host. Use with care!
    PrivateUsers = true;

    # protect the hostname from being changed.
    # WARNING: even though nixos uses /etc/hostname to define and change hostname, this option also prevents services from simply detecting hostname changes.
    ProtectHostname = true;

    # prevent modifications and state checks to the system clock.
    # implies removal of CAP_SYS_TIME and CAP_WAKE_ALARM
    # implies block clock set system calls
    # implies DeviceAllow=char-rtc r
    ProtectClock = true;

    # read-only: /proc/sys/, /sys/, /proc/sysrq-trigger, /proc/latency_stats, /proc/acpi, /proc/timer_stats, /proc/fs, /proc/irq
    # inaccessible: /proc/kallsyms, /proc/kcore
    # implies MountAPIVFS=true
    # Does not prevent callbacks to other processes/services (e.g. via IPC) from setting kernel tunables
    ProtectKernelTunables = true;

    # disable explicit kernel module loading
    # implies removal of CAP_SYS_MODULE
    # implies inaccessible /usr/lib/modules
    ProtectKernelModules = true;

    # dines access to kernel log ring buffer
    # implies removal of CAP_SYSLOG
    # implies inaccessible /dev/kmsg and /proc/kmsg
    ProtectKernelLogs = true;

    # true or strict disables write access to control group hierarchies
    # strict or private makes the unit run in a cgroup namespace with private /sys/fs/cgroup/
    # different options: "private", true, false
    ProtectControlGroups = "strict";

    # disable specific access for socket system call
    # different options: list of AF_UNIX, AF_INET AF_INET6, AF_NETLINK, AF_PACKET
    RestrictAddressFamilies = "none";

    # restrict access to namespacing
    # different options: false, [ "pid" "user" "net" "uts" "mnt" "cgroup" "ipc" ]
    # see `man namespaces` for a full list
    RestrictNamespaces = true;

    LockPersonality = true; # prevent service from initiating changes to its execution domain

    # prevent creating memory mappings that are writable and executable simultaneously
    # WARNING: breaks with JIT execution engines
    MemoryDenyWriteExecute = true;

    RestrictRealtime = true; # prevent service from requesting realtime scheduling

    RestrictSUIDSGID = true; # prevent setting suid/guid bit on files. Does NOT prevent existing suid/sgid binaries from being executed!

    # PrivateMounts can be used to set mount namespaces. However, debugging issues caused by this is quite complex.
    # PrivateMounts= MountFlags=

    SystemCallFilter = [ "@system-service" ]; # sensible default, works for most services. Prevents e.g. "@clock", "@mount", "@swap", "@reboot"
    SystemCallErrorNumber = "EPERM"; # services violating the SystemSystemCallFilter are killed silently by default. This makes debugging easier.

    SystemCallArchitectures = "native"; # allow only native system calls for defined SystemCallFilters

    # prevents access to /proc/<pid> of other processes
    # options: "noaccess", "invisible", "ptraceable", "default"
    ProtectProc = "invisible";

    # ProcSubset can be set to "pid" to prevent access to non-process files in /proc.
    # However, this prevents a lot of linux kernel API calls and should not be default
    # ProcSubset

    NoNewPrivileges = true; # prevents service process and children from gaining privileges via execve

    # use a dynamic user for this service instead of running as root
    # WARNING: breaks dbus
    DynamicUser = true;
  };

  latest = "rev1";
in
{
  options.systemd.services = lib.mkOption {
    type = types.attrsOf (
      types.submodule (
        { config, name, ... }:
        {
          options.lockdownByDefault = lib.mkOption {
            type = types.nullOr (types.enum (builtins.attrNames hardeningConfigs));
            default = null;
            description = ''
              If set, all privileges a service may have are removed and need to explicitly be enabled in {option}`serviceConfig`.
              See {manpage}`systemd.exec(5)` for more info about service environment configuration.
            '';
          };
          config = lib.mkIf (config.lockdownByDefault != null) {
            serviceConfig =
              let
                rev = lib.warnIf (
                  config.lockdownByDefault != latest
                ) "systemd.services.${name} uses an outdated hardening profile revision" config.lockdownByDefault;
              in
              builtins.mapAttrs (n: v: mkDefault v) hardeningConfigs."${rev}";
          };
        }
      )
    );
  };

  meta.maintainers = with lib.maintainers; [ grimmauld ];
}

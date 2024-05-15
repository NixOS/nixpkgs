{ config, lib, ... }:

with lib;

let

  sysctlOption = mkOptionType {
    name = "sysctl option value";
    check = val:
      let
        checkType = x: isBool x || isString x || isInt x || x == null;
      in
        checkType val || (val._type or "" == "override" && checkType val.content);
    merge = loc: defs: mergeOneOption loc (filterOverrides defs);
  };
  boolOrBitmask = numBitsInMask: mkOptionType {
    name = "sysctl option value";
    check = val: isBool val || 0 <= val <= ((1 <<< (numBitsInMask + 1)) - 1); # +1 bit for global enable/disable
    merge = loc: defs: foldl (a: b:
      if (a == 0 || b == 0 || a == false || b == false) then 0 # Explicitly disabled overrides all
      else if (a == 1 || a == true || b == 1 || b == true) then 1 # Explicitly enabled overrides a bitmask
      else builtins.bitwiseOr a b # Bitwise OR
    ) 0 (filterOverrides defs);
  };

in

{

  options = {
    boot.kernel.sysctl = mkOption {
      type = let
        highestValueType = types.ints.unsigned // {
          merge = loc: defs:
            foldl
              (a: b: if b.value == null then null else lib.max a b.value)
              0
              (filterOverrides defs);
        };
      in types.submodule {
        freeformType = types.attrsOf sysctlOption;
        options = {
          "net.core.rmem_max" = mkOption {
            type = types.nullOr highestValueType;
            description = "The maximum receive socket buffer size in bytes. In case of conflicting values, the highest will be used.";
            default = null;
          };

          "net.core.wmem_max" = mkOption {
            type = types.nullOr highestValueType;
            description = "The maximum send socket buffer size in bytes. In case of conflicting values, the highest will be used.";
            default = null;
          };

          "dev.tty.ldisc_autoload" = mkOption {
            type = types.nullOr types.bool;
            description = "Automatically load line discipline modules for tty devices.";
            # Prevent unprivileged attackers from loading vulnerable line disciplines with the TIOCSETD ioctl
            default = false;
          };

          "fs.protected_hardlinks" = mkOption {
            type = types.nullOr types.bool;
            description = "Protect hardlinks created by other users.";
            # Prevent unprivileged attackers from creating world-writable sticky hardlinks
            default = true;
          };

          "fs.protected_symlinks" = mkOption {
            type = types.nullOr types.bool;
            description = "Protect symlinks created by other users.";
            # Prevent unprivileged attackers from creating world-writable sticky symlinks
            default = true;
          };

          "fs.protected_fifos" = mkOption {
            type = types.nullOr highestValueType;
            description = "Protect pipes and FIFOs from being written to by other users.";
            # Prevent unprivileged attackers from creating world-writable sticky FIFOs
            default = 2;
          };

          "fs.protected_regular" = mkOption {
            type = types.nullOr highestValueType;
            description = "Protect files created by other users.";
            # Prevent unprivileged attackers from creating world-writable sticky files
            default = 2;
          };

          "fs.suid_dumpable" = mkOption {
            type = types.nullOr highestValueType;
            description = "Controls the core dump mode for setuid processes.";
            # Prevent setuid processes from dumping core
            default = 0;
          };

          "kernel.ctrl-alt-del" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable the Ctrl-Alt-Del key combination to trigger a kernel reboot.";
            # This is a security risk, as it allows users to reboot the system without authentication
            default = false;
          };

          "kernel.dmesg_restrict" = mkOption {
            type = types.nullOr types.bool;
            description = "Restrict access to kernel log buffer.";
            # Hide kernel log buffer to make it harder to exploit kernel vulnerabilities (e.g. by leaking kernel pointers)
            default = true;
          };

          "kernel.kptr_restrict" = mkOption {
            type = types.nullOr highestValueType;
            description = "Restrict access to kernel pointers.";
            # Hide kernel pointers to make it harder to exploit kernel vulnerabilities
            default = 2;
          };

          "kernel.modules_disabled" = mkOption {
            type = types.nullOr types.bool;
            description = "Disable kernel module loading.";
            # Prevent loading kernel modules after boot to reduce attack surface
            default = true;
          };

          "kernel.kexec_load_disabled" = mkOption {
            type = types.nullOr types.bool;
            description = "Disable kexec loading.";
            # Prevent loading a new kernel image without rebooting the system
            default = true;
          };

          "kernel.randomize_va_space" = mkOption {
            type = types.nullOr highestValueType;
            description = "Randomize the address space layout.";
            # Randomize the address space layout to make it harder to exploit memory corruption vulnerabilities
            default = 2;
          };

          "kernel.sysrq" = mkOption {
            type = types.nullOr (boolOrBitmask 7)
            description = "Enable SysRq key combinations.";
            # This is a security risk, as it allows users to perform various low-level operations without authentication
            # The sysrq key can be triggered remotely!
            default = false;
          };

          "kernel.perf_event_paranoid" = mkOption {
            type = types.nullOr highestValueType;
            description = "Controls use of the performance events system by unprivileged users.";
            # Restrict use of the performance events system to processes with CAP_PERFMON capability
            default = 3;
          };

          "kernel.unprivileged_bpf_disabled" = mkOption {
            type = types.nullOr highestValueType;
            description = "Disable unprivileged BPF access.";
            # Restricts loading BPF programs to processes with the CAP_BPF capability
            default = 1;
          };

          "kernel.yama.ptrace_scope" = mkOption {
            type = types.nullOr highestValueType;
            description = "Restrict ptrace access.";
            # Restrict ptrace access to processes with the CAP_SYS_PTRACE capability
            default = 2;
          };

          "kernel.unprivileged_userns_clone" = mkOption {
            type = types.nullOr highestValueType;
            description = "Restrict unprivileged user namespaces.";
            # Restricts creating user namespaces to processes with the CAP_SYS_ADMIN capability
            default = 0;
          };

          "net.core.bpf_jit_harden" = mkOption {
            type = types.nullOr highestValueType;
            description = "Harden BPF JIT against speculative execution attacks.";
            # Hardens BPF JIT against speculative execution attacks
            default = 2;
          };

          "net.ipv4.conf.all.accept_source_route" = mkOption {
            type = types.nullOr types.bool;
            description = "Accept source routed packets.";
            # Protects against MitM attacks
            default = false;
          };

          "net.ipv4.conf.all.bootp_relay" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable BOOTP relay.";
            # Protects against MitM attacks
            default = false;
          };

          "net.ipv4.conf.all.forwarding" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable IP forwarding.";
            # Protects against MitM attacks
            default = false;
          };

          "net.ipv4.conf.all.log_martians" = mkOption {
            type = types.nullOr types.bool;
            description = "Log packets with impossible addresses to the kernel log.";
            # Protects against IP spoofing attacks
            default = true;
          };

          "net.ipv4.conf.all.mc_forwarding" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable multicast routing.";
            # Protects against IP spoofing attacks
            default = false;
          };

          "net.ipv4.conf.all.proxy_arp" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable proxy ARP.";
            # Protects against ARP spoofing attacks
            default = false;
          };

          "net.ipv4.conf.all.rp_filter" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable reverse path filtering.";
            # Protects against IP spoofing attacks
            default = false;
          };

          "net.ipv4.icmp_echo_ignore_all" = mkOption {
            type = types.nullOr types.bool;
            description = "Ignore all ICMP echo requests.";
            # Protects against Smurf attacks
            default = true;
          };

          "net.ipv4.conf.all.send_redirects" = mkOption {
            type = types.nullOr types.bool;
            description = "Send ICMP redirect messages.";
            # Protects against MitM attacks
            default = false;
          };

          "net.ipv4.conf.all.secure_redirects" = mkOption {
            type = types.nullOr types.bool;
            description = "Accept only ICMP redirects from gateways listed in the default gateway list.";
            # Protects against MitM attacks
            default = false;
          };

          "net.ipv4.conf.all.accept_redirects" = mkOption {
            type = types.nullOr types.bool;
            description = "Accept ICMP redirect messages.";
            # Protects against MitM attacks
            default = false;
          };

          "net.ipv4.tcp_sack" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable TCP selective acknowledgments.";
            # Unnecessary in most cases, and can be used to exploit vulnerabilities in some TCP/IP stacks
            default = false;
          };

          "net.ipv4.tcp_dsack" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable TCP duplicate selective acknowledgments.";
            # Unnecessary in most cases, and can be used to exploit vulnerabilities in some TCP/IP stacks
            default = false;
          };

          "net.ipv4.tcp_fack" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable TCP Forward Acknowledgment.";
            # Unnecessary in most cases, and can be used to exploit vulnerabilities in some TCP/IP stacks
            default = false;
          };

          "net.ipv4.conf.default.rp_filter" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable reverse path filtering.";
            # Protects against IP spoofing attacks
            default = true;
          };

          "net.ipv4.conf.default.accept_source_route" = mkOption {
            type = types.nullOr types.bool;
            description = "Accept source routed packets.";
            # Protects against MitM attacks
            default = false;
          };

          "net.ipv4.conf.default.send_redirects" = mkOption {
            type = types.nullOr types.bool;
            description = "Send ICMP redirect messages.";
            # Protects against MitM attacks
            default = false;
          };

          "net.ipv4.conf.default.secure_redirects" = mkOption {
            type = types.nullOr types.bool;
            description = "Accept only ICMP redirects from gateways listed in the default gateway list.";
            # Protects against MitM attacks
            default = false;
          };

          "net.ipv4.conf.default.accept_redirects" = mkOption {
            type = types.nullOr types.bool;
            description = "Accept ICMP redirect messages.";
            # Protects against MitM attacks
            default = false;
          };

          "net.ipv4.conf.default.log_martians" = mkOption {
            type = types.nullOr types.bool;
            description = "Log packets with impossible addresses to the kernel log.";
            # Protects against IP spoofing attacks
            default = true;
          };

          "net.ipv4.icmp_echo_ignore_broadcasts" = mkOption {
            type = types.nullOr types.bool;
            description = "Ignore ICMP echo broadcasts.";
            # Protects against Smurf attacks
            default = true;
          };

          "net.ipv4.icmp_ignore_bogus_error_responses" = mkOption {
            type = types.nullOr types.bool;
            description = "Ignore bogus error responses.";
            # Protects against ICMP error message attacks
            default = true;
          };

          "net.ipv4.tcp_syncookies" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable TCP SYN cookies.";
            # Protects against SYN flood attacks
            default = true;
          };

          "net.ipv4.tcp_rfc1337" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable RFC 1337 protection.";
            # Protects against time-wait assassination attacks
            default = true;
          };

          "net.ipv4.tcp_timestamps" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable TCP timestamps.";
            # Improves performance and helps protect against sequence number guessing attacks
            default = true;
          };

          "net.ipv6.conf.all.accept_redirects" = mkOption {
            type = types.nullOr types.bool;
            description = "Accept ICMPv6 redirect messages.";
            # Protects against MitM attacks
            default = false;
          };

          "net.ipv6.conf.all.accept_source_route" = mkOption {
            type = types.nullOr types.bool;
            description = "Accept source routed packets.";
            # Protects against MitM attacks
            default = false;
          };

          "net.ipv6.conf.default.accept_redirects" = mkOption {
            type = types.nullOr types.bool;
            description = "Accept ICMPv6 redirect messages.";
            # Protects against MitM attacks
            default = false;
          };

          "net.ipv6.conf.default.accept_source_route" = mkOption {
            type = types.nullOr types.bool;
            description = "Accept source routed packets.";
            # Protects against MitM attacks
            default = false;
          };

          "net.ipv6.conf.all.accept_ra" = mkOption {
            type = types.nullOr types.bool;
            description = "Accept Router Advertisements.";
            # Protects against MitM attacks
            default = false;
          };

          "net.ipv6.conf.default.accept_ra" = mkOption {
            type = types.nullOr types.bool;
            description = "Accept Router Advertisements.";
            # Protects against MitM attacks
            default = false;
          };

          "vm.unprivileged_userfaultfd" = mkOption {
            type = types.nullOr types.bool;
            description = "Allow unprivileged users to register userfaultfd.";
            # Restricts userfaultfd to processes with the CAP_SYS_PTRACE capability
            # This syscall can be abused to exploit use-after-free vulnerabilities
            default = false;
          };

          "vm.max_map_count" = mkOption {
            type = types.nullOr highestValueType;
            description = "Maximum number of memory map areas a process may have.";
            # Improve compatibility with applications that allocate a lot of memory, like modern games
            default = 1048576;
          };
        };
      };
      default = {};
      example = literalExpression ''
        { "net.ipv4.tcp_syncookies" = false; "vm.swappiness" = 60; }
      '';
      description = ''
        Runtime parameters of the Linux kernel, as set by
        {manpage}`sysctl(8)`.  Note that sysctl
        parameters names must be enclosed in quotes
        (e.g. `"vm.swappiness"` instead of
        `vm.swappiness`).  The value of each
        parameter may be a string, integer, boolean, or null
        (signifying the option will not appear at all).
      '';

    };

  };

  config = {
    environment.etc."sysctl.d/60-nixos.conf".text = concatStrings (mapAttrsToList (n: v:
      optionalString (v != null) "${n}=${if v == false then "0" else toString v}\n"
    ) config.boot.kernel.sysctl);

    systemd.services.systemd-sysctl = {
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ config.environment.etc."sysctl.d/60-nixos.conf".source ];
    };
  };
}

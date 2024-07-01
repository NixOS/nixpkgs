{ config, lib, ... }:

with lib;

let
  pow = base: exp: if exp == 0 then 1 else base * (pow base (exp - 1));
  sysctlOption = mkOptionType {
    name = "sysctlOption";
    description = "A sysctl option";
    descriptionClass = "noun";
    check = val:
      let
        checkType = x: isBool x || isString x || isInt x || x == null;
      in
        checkType val || (val._type or "" == "override" && checkType val.content);
    merge = loc: defs: mergeOneOption loc (filterOverrides defs);
  };
  highestValueType = types.ints.unsigned // {
    merge = loc: defs: foldl (a: b:
      if b.value == null then null
      else lib.max a b.value
    ) 0 (filterOverrides defs);
  };
  boolOrBitmask = numBitsInMask: mkOptionType {
    name = "boolOrBitmask (${toString numBitsInMask})";
    description = "A boolean or a bitmask with ${toString (numBitsInMask + 1)} bits, where the least significant bit is the global enable/disable bit";
    descriptionClass = "noun";
    check = val: isBool val || (0 <= val && val <= ((pow 2 (numBitsInMask + 1)) - 1)); # +1 bit for global enable/disable
    merge = loc: defs: foldl (a: b:
      if (a == null) then b # Start with the default value
      else if (a == 0 || b == 0 || a == false || b == false) then 0 # Explicitly disabled overrides all
      else if (a == 1 || a == true || b == 1 || b == true) then 1 # Explicitly enabled overrides a bitmask
      else builtins.bitwiseOr a b # Bitwise OR
    ) null (filterOverrides defs);
  };
in
{
  options = {
    boot.kernel.sysctl = mkOption {
      type = types.submodule {
        freeformType = types.attrsOf sysctlOption;
        options = {
          "net.core.rmem_max" = mkOption {
            type = types.nullOr highestValueType;
            description = "The maximum receive socket buffer size in bytes. In case of conflicting values, the highest will be used";
            default = null;
          };

          "net.core.wmem_max" = mkOption {
            type = types.nullOr highestValueType;
            description = "The maximum send socket buffer size in bytes. In case of conflicting values, the highest will be used";
            default = null;
          };

          "dev.tty.ldisc_autoload" = mkOption {
            type = types.nullOr types.bool;
            description = "Automatically load line discipline modules for tty devices";
            default = null;
          };

          "fs.protected_hardlinks" = mkOption {
            type = types.nullOr types.bool;
            description = "Protect hardlinks created by other users";
            default = null;
          };

          "fs.protected_symlinks" = mkOption {
            type = types.nullOr types.bool;
            description = "Protect symlinks created by other users";
            default = null;
          };

          "fs.protected_fifos" = mkOption {
            type = types.nullOr highestValueType;
            description = "Protect pipes and FIFOs from being written to by other users";
            default = null;
          };

          "fs.protected_regular" = mkOption {
            type = types.nullOr highestValueType;
            description = "Protect files created by other users";
            default = null;
          };

          "fs.suid_dumpable" = mkOption {
            type = types.nullOr highestValueType;
            description = "Controls the core dump mode for setuid processes";
            default = null;
          };

          "kernel.ctrl-alt-del" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable the Ctrl-Alt-Del key combination to trigger a kernel reboot";
            default = null;
          };

          "kernel.dmesg_restrict" = mkOption {
            type = types.nullOr types.bool;
            description = "Restrict access to kernel log buffer";
            default = null;
          };

          "kernel.kptr_restrict" = mkOption {
            type = types.nullOr types.bool;
            description = "Restrict access to kernel pointers";
            # Hiding kernel pointers makes it harder to exploit kernel vulnerabilities
            default = true;
          };

          "kernel.modules_disabled" = mkOption {
            type = types.nullOr types.bool;
            description = "Disable kernel module loading";
            default = null;
          };

          "kernel.kexec_load_disabled" = mkOption {
            type = types.nullOr types.bool;
            description = "Disable kexec loading";
            default = null;
          };

          "kernel.randomize_va_space" = mkOption {
            type = types.nullOr highestValueType;
            description = "Randomize the address space layout";
            default = null;
          };

          "kernel.sysrq" = mkOption {
            type = types.nullOr (boolOrBitmask 7);
            description = "Enable SysRq key combinations";
            default = null;
          };

          "kernel.perf_event_paranoid" = mkOption {
            type = types.nullOr highestValueType;
            description = "Controls use of the performance events system by unprivileged users";
            default = null;
          };

          "kernel.unprivileged_bpf_disabled" = mkOption {
            type = types.nullOr highestValueType;
            description = "Disable unprivileged BPF access";
            default = null;
          };

          "kernel.yama.ptrace_scope" = mkOption {
            type = types.nullOr highestValueType;
            description = "Restrict ptrace access";
            default = null;
          };

          "kernel.unprivileged_userns_clone" = mkOption {
            type = types.nullOr highestValueType;
            description = "Restrict unprivileged user namespaces";
            default = null;
          };

          # This results in a manual build failure. WTF?
          /* "kernel.hostname" = mkOption {
            type = types.nullOr types.string;
            description = ''
              The system hostname

              You probably want to use {option}`networking.hostName` instead.
            '';
            default = null;
          }; */

          "net.core.bpf_jit_harden" = mkOption {
            type = types.nullOr highestValueType;
            description = "Harden BPF JIT against speculative execution attacks";
            default = null;
          };

          "net.bridge.bridge-nf-call-iptables" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable calling iptables from bridged packets";
            default = null;
          };

          "net.bridge.bridge-nf-call-ip6tables" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable calling ip6tables from bridged packets";
            default = null;
          };

          "net.ipv4.ip_forward" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable IP forwarding";
            default = null;
          };

          "net.ipv4.conf.all.accept_source_route" = mkOption {
            type = types.nullOr types.bool;
            description = "Accept source routed packets";
            default = null;
          };

          "net.ipv4.conf.all.bootp_relay" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable BOOTP relay";
            default = null;
          };

          "net.ipv4.conf.all.forwarding" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable IP forwarding";
            default = null;
          };

          "net.ipv4.conf.all.log_martians" = mkOption {
            type = types.nullOr types.bool;
            description = "Log packets with impossible addresses to the kernel log";
            default = null;
          };

          "net.ipv4.conf.all.mc_forwarding" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable multicast routing";
            default = null;
          };

          "net.ipv4.conf.all.proxy_arp" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable proxy ARP";
            default = null;
          };

          "net.ipv4.conf.all.rp_filter" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable reverse path filtering";
            default = null;
          };

          "net.ipv4.icmp_echo_ignore_all" = mkOption {
            type = types.nullOr types.bool;
            description = "Ignore all ICMP echo requests";
            default = null;
          };

          "net.ipv4.conf.all.send_redirects" = mkOption {
            type = types.nullOr types.bool;
            description = "Send ICMP redirect messages";
            default = null;
          };

          "net.ipv4.conf.all.secure_redirects" = mkOption {
            type = types.nullOr types.bool;
            description = "Accept only ICMP redirects from gateways listed in the default gateway list";
            default = null;
          };

          "net.ipv4.conf.all.accept_redirects" = mkOption {
            type = types.nullOr types.bool;
            description = "Accept ICMP redirect messages";
            default = null;
          };

          "net.ipv4.tcp_keepalive_time" = mkOption {
            type = types.nullOr highestValueType;
            description = "The time in seconds a connection needs to be idle before TCP begins sending keepalive probes";
            default = null;
          };

          "net.ipv4.tcp_sack" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable TCP selective acknowledgments";
            default = null;
          };

          "net.ipv4.tcp_dsack" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable TCP duplicate selective acknowledgments";
            default = null;
          };

          "net.ipv4.tcp_fack" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable TCP Forward Acknowledgment";
            default = null;
          };

          "net.ipv4.conf.default.rp_filter" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable reverse path filtering";
            default = null;
          };

          "net.ipv4.conf.default.accept_source_route" = mkOption {
            type = types.nullOr types.bool;
            description = "Accept source routed packets";
            default = null;
          };

          "net.ipv4.conf.default.send_redirects" = mkOption {
            type = types.nullOr types.bool;
            description = "Send ICMP redirect messages";
            default = null;
          };

          "net.ipv4.conf.default.secure_redirects" = mkOption {
            type = types.nullOr types.bool;
            description = "Accept only ICMP redirects from gateways listed in the default gateway list";
            default = null;
          };

          "net.ipv4.conf.default.accept_redirects" = mkOption {
            type = types.nullOr types.bool;
            description = "Accept ICMP redirect messages";
            default = null;
          };

          "net.ipv4.conf.default.log_martians" = mkOption {
            type = types.nullOr types.bool;
            description = "Log packets with impossible addresses to the kernel log";
            default = null;
          };

          "net.ipv4.icmp_echo_ignore_broadcasts" = mkOption {
            type = types.nullOr types.bool;
            description = "Ignore ICMP echo broadcasts";
            default = null;
          };

          "net.ipv4.icmp_ignore_bogus_error_responses" = mkOption {
            type = types.nullOr types.bool;
            description = "Ignore bogus error responses";
            default = null;
          };

          "net.ipv4.tcp_syncookies" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable TCP SYN cookies";
            default = null;
          };

          "net.ipv4.tcp_rfc1337" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable RFC 1337 protection";
            default = null;
          };

          "net.ipv4.tcp_timestamps" = mkOption {
            type = types.nullOr types.bool;
            description = "Enable TCP timestamps";
            default = null;
          };

          "net.ipv6.conf.all.accept_redirects" = mkOption {
            type = types.nullOr types.bool;
            description = "Accept ICMPv6 redirect messages";
            default = null;
          };

          "net.ipv6.conf.all.accept_source_route" = mkOption {
            type = types.nullOr types.bool;
            description = "Accept source routed packets";
            default = null;
          };

          "net.ipv6.conf.default.accept_redirects" = mkOption {
            type = types.nullOr types.bool;
            description = "Accept ICMPv6 redirect messages";
            default = null;
          };

          "net.ipv6.conf.default.accept_source_route" = mkOption {
            type = types.nullOr types.bool;
            description = "Accept source routed packets";
            default = null;
          };

          "net.ipv6.conf.all.accept_ra" = mkOption {
            type = types.nullOr types.bool;
            description = "Accept Router Advertisements";
            default = null;
          };

          "net.ipv6.conf.default.accept_ra" = mkOption {
            type = types.nullOr types.bool;
            description = "Accept Router Advertisements";
            default = null;
          };

          "vm.unprivileged_userfaultfd" = mkOption {
            type = types.nullOr types.bool;
            description = "Allow unprivileged users to register userfaultfd";
            default = null;
          };

          "vm.max_map_count" = mkOption {
            type = types.nullOr highestValueType;
            description = "Maximum number of memory map areas a process may have";
            # Improve compatibility with applications that allocate a lot of memory, like modern games
            default = 1048576;
          };

          "vm.overcommit_memory" = mkOption {
            type = types.nullOr types.int;
            description = ''
              Controls memory overcommit handling

              0 = Heuristic overcommit handling
              1 = Always overcommit
              2 = Never overcommit
            '';
            default = null;
          };

          "vm.overcommit_ratio" = mkOption {
            type = types.nullOr highestValueType;
            description = "Percentage of physical memory that is allowed to be overcommitted";
            default = null;
          };

          "vm.overcommit_kbytes" = mkOption {
            type = types.nullOr highestValueType;
            description = "Amount of memory that is allowed to be overcommitted";
            default = null;
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

  meta.maintainers = [ maintainers.pandapip1 ];
}

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

in

{

  options = {

    boot.kernel.sysctl = mkOption {
      default = {};
      example = literalExample ''
        { "net.ipv4.tcp_syncookies" = false; "vm.swappiness" = 60; }
      '';
      type = types.attrsOf sysctlOption;
      description = ''
        Runtime parameters of the Linux kernel, as set by
        <citerefentry><refentrytitle>sysctl</refentrytitle>
        <manvolnum>8</manvolnum></citerefentry>.  Note that sysctl
        parameters names must be enclosed in quotes
        (e.g. <literal>"vm.swappiness"</literal> instead of
        <literal>vm.swappiness</literal>).  The value of each
        parameter may be a string, integer, boolean, or null
        (signifying the option will not appear at all).
      '';
    };

  };

  config = {

    environment.etc."sysctl.d/60-nixos.conf".text =
      concatStrings (mapAttrsToList (n: v:
        optionalString (v != null) "${n}=${if v == false then "0" else toString v}\n"
      ) config.boot.kernel.sysctl);

    systemd.services.systemd-sysctl =
      { wantedBy = [ "multi-user.target" ];
        restartTriggers = [ config.environment.etc."sysctl.d/60-nixos.conf".source ];
      };

    # Hide kernel pointers (e.g. in /proc/modules) for unprivileged
    # users as these make it easier to exploit kernel vulnerabilities.
    boot.kernel.sysctl."kernel.kptr_restrict" = mkDefault 1;

    # Disable YAMA by default to allow easy debugging.
    boot.kernel.sysctl."kernel.yama.ptrace_scope" = mkDefault 0;

    # Dynamic since kernel v5.12
    # https://github.com/torvalds/linux/commit/ac7b79fd190b02e7151bc7d2b9da692f537657f3
    # From version 5.12 inotify instances are charegd memcg, so to let memcg work
    # properly in all possible circumstance, kernel mainatainers (see commit) suggest
    # to make this value ineffective by setting it to the maximum
    boot.kernel.sysctl."fs.inotify.max_user_instances" =
      if (config.boot.kernelPackages.kernel.kernelAtLeast "5.12")
      then mkDefault 2147483647 # INT_MAX, dynamically limited based on available memory
      else mkDefault 8192; # instead of 128

    # Dynamic since kernel v5.11
    # https://github.com/torvalds/linux/commit/92890123749bafc317bbfacbe0a62ce08d78efb7
    boot.kernel.sysctl."fs.inotify.max_user_watches" = mkIf
      (config.boot.kernelPackages.kernel.kernelOlder "5.11")
      (mkDefault 1048576); # instead of 8192

  };
}

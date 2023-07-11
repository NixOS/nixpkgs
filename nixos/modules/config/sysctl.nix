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
      type = types.submodule {
        freeformType = types.attrsOf sysctlOption;
        options."net.core.rmem_max" = mkOption {
          type = types.nullOr types.ints.unsigned // {
            merge = loc: defs:
              foldl
                (a: b: if b.value == null then null else lib.max a b.value)
                0
                (filterOverrides defs);
          };
          default = null;
          description = lib.mdDoc "The maximum socket receive buffer size. In case of conflicting values, the highest will be used.";
        };
      };
      default = {};
      example = literalExpression ''
        { "net.ipv4.tcp_syncookies" = false; "vm.swappiness" = 60; }
      '';
      description = lib.mdDoc ''
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

    # Improve compatibility with applications that allocate
    # a lot of memory, like modern games
    boot.kernel.sysctl."vm.max_map_count" = mkDefault 1048576;
  };
}

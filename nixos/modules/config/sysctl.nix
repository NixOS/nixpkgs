{ config, lib, ... }:
let

  sysctlOption = lib.mkOptionType {
    name = "sysctl option value";
    check =
      val:
      let
        checkType = x: lib.isBool x || lib.isString x || lib.isInt x || x == null;
      in
      checkType val || (val._type or "" == "override" && checkType val.content);
    merge = loc: defs: lib.mergeOneOption loc defs;
  };

in

{

  options = {

    boot.kernel.sysctl = lib.mkOption {
      type =
        let
          highestValueType = lib.types.ints.unsigned // {
            merge = loc: defs: lib.foldl (a: b: if b.value == null then null else lib.max a b.value) 0 defs;
          };
        in
        lib.types.submodule {
          freeformType = lib.types.attrsOf sysctlOption;
          options = {
            "net.core.rmem_max" = lib.mkOption {
              type = lib.types.nullOr highestValueType;
              default = null;
              description = "The maximum receive socket buffer size in bytes. In case of conflicting values, the highest will be used.";
            };

            "net.core.wmem_max" = lib.mkOption {
              type = lib.types.nullOr highestValueType;
              default = null;
              description = "The maximum send socket buffer size in bytes. In case of conflicting values, the highest will be used.";
            };
          };
        };
      default = { };
      example = lib.literalExpression ''
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

    environment.etc."sysctl.d/60-nixos.conf".text = lib.concatStrings (
      lib.mapAttrsToList (
        n: v: lib.optionalString (v != null) "${n}=${if v == false then "0" else toString v}\n"
      ) config.boot.kernel.sysctl
    );

    systemd.services.systemd-sysctl = {
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ config.environment.etc."sysctl.d/60-nixos.conf".source ];
    };

    # NixOS wide defaults
    boot.kernel.sysctl = {
      # Hide kernel pointers (e.g. in /proc/modules) for unprivileged
      # users as these make it easier to exploit kernel vulnerabilities.
      "kernel.kptr_restrict" = lib.mkDefault 1;

      # Improve compatibility with applications that allocate
      # a lot of memory, like modern games
      "vm.max_map_count" = lib.mkDefault 1048576;

      # The default max inotify watches is 8192.
      # Nowadays most apps require a good number of inotify watches,
      # the value below is used by default on several other distros.
      "fs.inotify.max_user_instances" = lib.mkDefault 524288;
      "fs.inotify.max_user_watches" = lib.mkDefault 524288;

      # Mitigate some TOCTOU vulnerabilites
      # cf. https://www.kernel.org/doc/Documentation/admin-guide/sysctl/fs.rst
      #
      # Don’t allow O_CREAT open on FIFOs not owned by the user in world‐ or
      # group‐writable sticky directories (e.g. /tmp), unless owned by the
      # directory owner
      "fs.protected_fifos" = lib.mkDefault 2;

      # Don’t allow users to create hardlinks unless they own the source
      # file or have read/write access to it
      "fs.protected_hardlinks" = lib.mkDefault 1;

      # Don’t allow O_CREAT open on regular files not owned by user in world‐
      # or group‐writable sticky directories (e.g. /tmp), unless owned by the
      # directory owner
      "fs.protected_regular" = lib.mkDefault 2;

      # Don’t follow symlinks in sticky world‐writable directories (e.g. /tmp),
      # unless the user ID of the follower matches the symlink, or the
      # directory owner matches the symlink
      "fs.protected_symlinks" = lib.mkDefault 1;
    };
  };
}

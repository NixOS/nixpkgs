{
  lib,
  config,
  utils,
  pkgs,
  ...
}:

let
  inherit (lib)
    all
    any
    concatLines
    concatStringsSep
    escapeShellArg
    flatten
    floatToString
    foldl'
    head
    isAttrs
    isDerivation
    isFloat
    isList
    length
    listToAttrs
    match
    mapAttrsToList
    mkOption
    nameValuePair
    removePrefix
    splitString
    tail
    throwIf
    types
    ;

  inherit (lib.options)
    showDefs
    showOption
    ;

  inherit (lib.strings)
    escapeC
    isConvertibleWithToString
    ;

  inherit (lib.types)
    optionDescriptionPhrase
    ;

  inherit (lib.path.subpath) join;

  inherit (utils) escapeSystemdPath;

  cfg = config.boot.kernel.sysctl;

  mergeEqualValueStrOption =
    loc: defs:
    if length defs == 1 then
      (head defs).value
    else
      (foldl' (
        first: def:
        # merge definitions if they produce the same value string
        throwIf (mkValueString first.value != mkValueString def.value)
          "The option \"${showOption loc}\" has conflicting definition values:${
            showDefs [
              first
              def
            ]
          }"
          first
      ) (head defs) (tail defs)).value;

  sysctlAttrs = with types; nullOr (either sysctlValue (attrsOf sysctlAttrs));
  sysctlValue = lib.mkOptionType {
    name = "sysctl value";
    description = "sysctl option value";
    descriptionClass = "noun";
    check = v: isConvertibleWithToString v;
    merge = mergeEqualValueStrOption;
  };

  sysctlBool = with types; either bool (ints.between 0 1);
  sysctlTuple =
    len: elemType:
    with types;
    addCheck (listOf elemType) (val: length val == len)
    // {
      description = "${toString len}-tuple (list) of ${
        optionDescriptionPhrase (class: class == "noun" || class == "composite") elemType
      }";
      merge = mergeEqualValueStrOption;
    };

  sysctlMax = types.ints.unsigned // {
    merge =
      loc: defs:
      lib.foldl (a: b: if b.value == null then null else lib.max a b.value) 0 (lib.filterOverrides defs);
  };

  mapAttrsToListRecursive =
    fn: set:
    let
      recurse =
        p: v:
        if isAttrs v && !isDerivation v then mapAttrsToList (n: v: recurse (p ++ [ n ]) v) v else fn p v;
    in
    flatten (recurse [ ] set);

  mkPath = p: "/proc/sys" + removePrefix "." (join (flatten (map (splitString ".") p)));
  hasGlob = p: any (n: match ''(.*[^\\])?[*?[].*'' n != null) p;

  mkValueString =
    v:
    # true will be converted to "1" by toString, saving one branch
    if v == false then
      "0"
    else if isFloat v then
      floatToString v # warn about loss of precision
    else if isList v then
      toString (map mkValueString v)
    else
      toString v;

  # escape whitespace and linebreaks, as well as the escape character itself,
  # to ensure that field boundaries are always preserved
  escapeTmpfiles = escapeC [
    "\t"
    "\n"
    "\r"
    " "
    "\\"
  ];

  tmpfiles = pkgs.runCommand "nixos-sysctl-tmpfiles.d" { } (
    ''
      mkdir "$out"
    ''
    + concatLines (
      mapAttrsToListRecursive (
        p: v:
        let
          path = mkPath p;
        in
        if v == null then
          [ ]
        else
          ''
            printf 'w %s - - - - %s\n' \
              ${escapeShellArg (escapeTmpfiles path)} \
              ${escapeShellArg (escapeTmpfiles (mkValueString v))} \
              >"$out"/${escapeShellArg (escapeSystemdPath path)}.conf
          ''
      ) cfg
    )
  );

  commonConf = {
    forwarding = mkOption {
      type = with types; nullOr (either bool (ints.between 0 1));
      default = null;
      description = "Enable packet forwarding between interfaces.";
    };
  };

  ipv4Conf = commonConf // {
    accept_arp = mkOption {
      type = with types; nullOr (either bool (ints.between 0 1));
      default = null;
      description = "Accept ARP on interface.";
    };
  };

  ipv6Conf = commonConf // {
    acceprt_ra = mkOption {
      type = with types; nullOr (either bool (ints.between 0 1));
      default = null;
      description = "Accept router advertisements on interface.";
    };
  };
in
{
  options = {
    boot.kernel.sysctl = mkOption {
      type = types.submodule {
        freeformType = types.attrsOf sysctlAttrs // {
          description = "nested attribute set of null or sysctl option values";
        };

        options = {
          fs = {
            nr_open = mkOption {
              type = types.nullOr sysctlMax;
              default = null;
              description = ''
                Maximum number of open file handles per process.

                In case of conflicting definitions, the highest value will be
                used.
              '';
            };
          };

          kernel = {
            dmesg_restrict = mkOption {
              type = with types; nullOr sysctlBool;
              default = null;
              description = ''
                Restrict access access to kernel log for unprivileged users.
              '';
            };

            nmi_watchdog = mkOption {
              type = with types; nullOr sysctlBool;
              default = null;
              description = ''
                Enable the NMI watchdog (hard lock‐up detector) on x86 systems.
              '';
            };

            panic = mkOption {
              type = with types; nullOr int;
              default = null;
              description = ''
                Kernel behaviour on panic:

                - if zero, the kernel will loop forever;
                - if negative, the kernel will reboot immediately;
                - if positive, the kernel will reboot after the corresponding
                  number of seconds.
              '';
            };

            sysrq = mkOption {
              type = with types; nullOr (either bool ints.unsigned);
              default = null;
              description = ''
                Magic system request (SysRq) function configuration:

                - 0: disable SysRq completely,
                - 1: enable all SysRq functions,
                - >1: bit mask of allowed SysRq functions.

                cf. <https://docs.kernel.org/admin-guide/sysrq.html>
              '';
            };
          };

          net = {
            core = {
              bpf_jit_enable = mkOption {
                type = with types; nullOr (either bool (ints.between 0 2));
                default = null;
                description = ''
                  Enable the BPF just‐in‐time (JIT) compiler.

                  - 0 or false: disable the JIT,
                  - 1 or true: enable the JIT,
                  - 2: enable the JIT and emit traces.
                '';
              };

              bpf_jit_harden = mkOption {
                type = with types; nullOr (ints.between 0 2);
                default = null;
                description = ''
                  Harden the BPF just‐in‐time (JIT) compiler.

                  - 0: disable JIT hardening,
                  - 1: enable JIT hardening for unprivileged users only,
                  - 2: enable JIT hardening for all users.
                '';
              };

              default_qdisc = mkOption {
                type = with types; nullOr (strMatching "[a-z_]+");
                default = null;
                description = ''
                  Default queuing discipline for network devices.
                '';
              };

              rmem_default = mkOption {
                type = with types; nullOr sysctlMax;
                default = null;
                description = ''
                  Default socket receive buffer size in bytes.

                  In case of conflicting values, the highest will be used.
                '';
              };

              rmem_max = mkOption {
                default = null;
                description = ''
                  Maximum socket receive buffer size in bytes.

                  In case of conflicting values, the highest will be used.
                '';
              };

              wmem_default = mkOption {
                type = with types; nullOr sysctlMax;
                default = null;
                description = ''
                  Default socket send buffer size in bytes.

                  In case of conflicting values, the highest will be used.
                '';
              };

              wmem_max = mkOption {
                type = with types; nullOr sysctlMax;
                default = null;
                description = ''
                  Maximum socket send buffer size in bytes.

                  In case of conflicting values, the highest will be used.
                '';
              };

              optmem_max = mkOption {
                type = with types; nullOr sysctlMax;
                default = null;
                description = ''
                  Maximum socket ancillary buffer size in bytes.

                  In case of conflicting values, the highest will be used.
                '';
              };
            };

            ipv4 = {
              conf = mkOption {
                type =
                  with types;
                  submodule {
                    freeformType =
                      with types;
                      attrsOf (submodule {
                        options = ipv4Conf;
                      });

                    options = {
                      default = mkOption {
                        type = types.submodule { options = ipv4Conf; };
                        default = { };
                        description = ''
                          Network interface settings defaults.
                        '';
                      };

                      all = mkOption {
                        type = types.submodule { options = ipv4Conf; };
                        default = { };
                        description = ''
                          Network interface settings overrides.
                        '';
                      };
                    };
                  };

                default = { };
                description = ''
                  Network interface settings.
                '';
              };

              ip_forward = mkOption {
                type = with types; nullOr sysctlBool;
                default = null;
                description = ''
                  Enable packet forwarding between interfaces.
                '';
              };

              tcp_congestion_control = mkOption {
                type = with types; nullOr (strMatching "[a-z_]+");
                default = null;
                description = ''
                  TCP congestion control algorithm for new connections.
                '';
              };

              tcp_ecn = mkOption {
                type = with types; nullOr (ints.between 0 2);
                default = null;
                description = ''
                  Explicit Congestion Notification for TCP connections:

                  - 0: disable ECN,
                  - 1: enable ECN when requested by incoming connections,
                    and also request ECN on outgoing connections.
                  - 2: enable ECN when requested by incoming connections,
                    but do not request ECN on outgoing connections.
                '';
              };

              tcp_rmem = mkOption {
                type = with types; nullOr (sysctlTuple 3 sysctlMax);
                default = null;
                description = ''
                  Minimum, default, and maximum TCP socket receive buffer sizes
                  in bytes, provided as a list of three integers.
                '';
              };

              tcp_syncookies = mkOption {
                type = with types; nullOr sysctlBool;
                default = null;
                description = ''
                  Enable TCP SYN cookies.
                '';
              };

              tcp_fastopen = mkOption {
                type = with types; nullOr ints.unsigned;
                default = null;
                description = ''
                  TCP Fast Open settings to send and accept data in the opening
                  SYN packet. The value is a bitmap of flags.
                '';
              };

              tcp_wmem = mkOption {
                type = with types; nullOr (sysctlTuple 3 sysctlMax);
                default = null;
                description = ''
                  Minimum, default, and maximum TCP socket send buffer sizes
                  in bytes, provided as a list of three integers.
                '';
              };
            };

            ipv6 = {
              conf = mkOption {
                type =
                  with types;
                  submodule {
                    freeformType =
                      with types;
                      attrsOf (submodule {
                        options = ipv4Conf;
                      });

                    options = {
                      default = mkOption {
                        type = types.submodule { options = ipv4Conf; };
                        default = { };
                        description = ''
                          Network interface settings defaults.
                        '';
                      };

                      all = mkOption {
                        type = types.submodule { options = ipv4Conf; };
                        default = { };
                        description = ''
                          Network interface settings overrides.
                        '';
                      };
                    };
                  };

                default = { };
                description = ''
                  Network interface settings.
                '';
              };
            };
          };

          vm = {
            dirty_expire_centisecs = mkOption {
              type = with types; nullOr ints.unsigned;
              default = null;
              description = ''
                Minimum age in centiseconds after which dirty page cache data
                becomes eligible for flushing by the kernel flusher thread.
              '';
            };

            dirty_background_ratio = mkOption {
              type = with types; nullOr (ints.between 0 100);
              default = null;
              description = ''
                Percentage of available memory at which the background kernel
                flusher thread will start writing out dirty page cache data to
                disk.
              '';
            };

            dirty_ratio = mkOption {
              type = with types; nullOr (ints.between 0 100);
              default = null;
              description = ''
                Percentage of available memory at which processes generating
                disk writes will start writing out data to disk synchronously.
              '';
            };

            swappiness = mkOption {
              type = with types; nullOr (ints.between 0 200);
              default = null;
              description = ''
                Relative I/O cost of swapping versus filesystem paging:
              '';
            };
          };
        };
      };

      description = ''
        sysctl options to be set as soon as they become available in the
        /proc/sys filesystem.

        Attribute names represent path components and cannot be `.` or `..` nor
        contain any slash character (`/`).

        Names may contain shell‐style glob patterns (`*`, `?` and `[…]`)
        matching a single path component, these should however be used with
        caution, as they may produce non‐deterministic results if attribute
        paths overlap.

        Values will be converted to strings, with list elements concatenated
        with spaces and booleans converted to numeric values (`0` or `1`).
        `null` values are ignored, allowing removal of values defined in other
        modules, as are empty attribute sets.

        List values defined in different modules will _not_ be concatenated.

        This option may only be used for sysctl options which can be set
        idempotently, as the configured values might be written more than once.
      '';

      default = { };

      example = lib.literalExpression ''
        {
          net.ipv4.tcp_syncookies = false;
          vm.swappiness = 60;
        }
      '';
    };
  };

  config = {
    systemd = {
      paths =
        {
          "nixos-sysctl@" = {
            description = "/%I sysctl watcher";
            pathConfig.PathExistsGlob = "/%I";
            unitConfig.DefaultDependencies = false;
          };
        }
        // listToAttrs (
          mapAttrsToListRecursive (
            p: v:
            if v == null then
              [ ]
            else
              nameValuePair "nixos-sysctl@${escapeSystemdPath (mkPath p)}" {
                overrideStrategy = "asDropin";
                wantedBy = [ "sysinit.target" ];
                before = [ "sysinit.target" ];
              }
          ) cfg
        );

      services."nixos-sysctl@" = {
        description = "/%I sysctl setter";
        unitConfig = {
          DefaultDependencies = false;
          AssertPathIsMountPoint = "/proc";
          AssertPathExistsGlob = "/%I";
        };

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;

          # while we could be tempted to use simple shell script to set the
          # sysfs attributes specified by the path or glob pattern, it is
          # almost impossible to properly escape a glob pattern so that it
          # can be used safely in a shell script
          ExecStart = "${lib.getExe' config.systemd.package "systemd-tmpfiles"} --prefix=/proc/sys --create ${tmpfiles}/%i.conf";

          # hardening may be overkill for such a simple and short‐lived
          # service, the following settings would however be suitable to deny
          # access to anything but /proc
          #InaccessiblePaths = [ "/sys" ];
          #ProtectProc = "noaccess";
          #ProtectSystem = "strict";
          #PrivateDevices = true;
          #SystemCallErrorNumber = "EPERM";
          #SystemCallFilter = [
          #  "@basic-io"
          #  "@file-system"
          #];
        };
      };
    };

    warnings = mapAttrsToListRecursive (
      p: v:
      # we might want to check if there actually is an overlap between a glob
      # pattern and another path, before warning about it
      lib.optional (hasGlob p)
        "Attribute path \"${concatStringsSep "." p}\" contains glob patterns. Please ensure that these do not overlap with other sysctl options."
      ++ lib.optional (
        match ''.+\..+'' (head p) != null
      ) "Attribute \"${head p}\" uses the old option format. Please remove the quotes around it."
    ) cfg;

    assertions = mapAttrsToListRecursive (p: v: [
      {
        assertion = all (n: match ''(\.\.?|.*/.*)'' n == null) p;
        message = "Attribute path \"${concatStringsSep "." p}\" has invalid components.";
      }
    ]) cfg;

    # Hide kernel pointers (e.g. in /proc/modules) for unprivileged
    # users as these make it easier to exploit kernel vulnerabilities.
    boot.kernel.sysctl.kernel.kptr_restrict = lib.mkDefault 1;

    # Improve compatibility with applications that allocate
    # a lot of memory, like modern games
    boot.kernel.sysctl.vm.max_map_count = lib.mkDefault 1048576;
  };

  meta.maintainers = with lib.maintainers; [ mvs ];
}

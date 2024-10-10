{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    mkIf
    mkOptionDefault
    ;
  cfg = config.services.vpp;

  # Converts the config option to a string
  parseConfig =
    cfg:
    let
      inherit (lib.lists) sort concatMap filter;

      sortedAttrs =
        set:
        sort (
          l: r:
          if l == "extraConfig" then
            false # Always put extraConfig last
          else if builtins.isAttrs set.${l} == builtins.isAttrs set.${r} then
            l < r
          else
            builtins.isAttrs set.${r} # Attrsets should be last, makes for a nice config
          # This last case occurs when any side (but not both) is an attrset
          # The order of these is correct when the attrset is on the right
          # which we're just returning
        ) (builtins.attrNames set);

      # Specifies an attrset that encodes the value according to its type
      encode =
        name: value:
        {
          null = [ ];
          bool = lib.optional value name;
          int = [ "${name} ${builtins.toString value}" ];

          # extraConfig should be inserted verbatim
          string = [ (if name == "extraConfig" then value else "${name} ${value}") ];

          # Values like `foo = [ "bar" "baz" ];` should be transformed into
          #   foo bar
          #   foo baz
          list = concatMap (encode name) value;

          # Values like `foo = { bar = { baz = true; }; bar2 = { baz2 = true; }; };` should be transformed into
          #   foo bar {
          #     baz
          #   }
          #   foo bar2 {
          #     baz2
          #   }
          set = concatMap (
            subname:
            lib.optionals (value.${subname} != null) (
              [ "${name} ${subname} {" ] ++ (map (line: "  ${line}") (toLines value.${subname})) ++ [ "}" ]
            )
          ) (filter (v: v != null) (builtins.attrNames value));
        }
        .${builtins.typeOf value};

      # One level "above" encode, acts upon a set and uses encode on each name,value pair
      toLines = set: concatMap (name: encode name set.${name}) (sortedAttrs set);

      # Moves top-level attrsets into a dummy "" value, so that `section = {...}` is transformed to `section  {...}`
      parseSections =
        set:
        builtins.mapAttrs (name: value: {
          "" = value;
        }) set;
    in
    lib.strings.concatStringsSep "\n" (toLines (parseSections cfg));

  semanticTypes = with types; rec {
    vppAtom = nullOr (oneOf [
      int
      bool
      str
    ]);
    vppAttr = attrsOf vppAll;
    vppAll = oneOf [
      vppAtom
      (listOf vppAtom)
      vppAttr
    ];
    vppConf = attrsOf (
      vppAll
      // {
        # Since this is a recursive type and the description by default contains
        # the description of its subtypes, infinite recursion would occur without
        # explicitly breaking this cycle
        description = "vpp values (null, atoms (str, int, bool), list of atoms, or attrsets of vpp values)";
      }
    );
  };

  instanceOpts =
    { name, ... }:
    {
      options = {
        enable = mkEnableOption "FD.io's Vector Packet Processor, a high-performance userspace network stack.";

        name = mkOption {
          type = types.str;
          default = name;
          description = ''
            Name is used as a suffix for the service name.
            By default it takes the value you use for `<instance>` in:
            {option}`services.vpp.instances.<instance>`
          '';
        };

        package = mkPackageOption pkgs "vpp" { };

        kernelModule = mkOption {
          type = types.nullOr types.str;
          default = "uio_pci_generic";
          example = "vfio-pci";
          description = "UIO kernel driver module to load before starting this VPP instance. Set to `null` to disable this functionality.";
        };

        group = mkOption {
          type = types.str;
          default = "vpp";
          example = "vpp-main";
          description = "Group that grants users in it privileges to control this instance via {command}`vppctl`.";
        };

        config = mkOption {
          type = semanticTypes.vppConf;
          defaultText = ''
            unix = {
              nodaemon = true;
              nosyslog = true;
              cli-listen = "/run/vpp/\${name}-cli.sock";
              gid = config.services.vpp.instances.\${name}.group;
              startup-config = config.services.vpp.instances.\${name}.startupConfigFile;
            };
            api-segment.gid = config.services.vpp.instances.\${name}.group;
          '';
          example = lib.literalExpression ''
            {
              dpdk = {
                dev."0000:01:00.0" = {
                  name = "sfp0";
                  num-rx-queues = 4;
                };
                dev."0000:01:00.1" = { };
                ## In the case of many devices that don't need special config, they can also be defined in a list:
                # dev = [ "0000:01:00.0" "0000:01:00.1" ];
                ## And, since `x = [ y ];` is functionally identical to `x = y;`, this is also possible:
                # dev = [
                #   {
                #     default.num-rx-queues = 4;
                #
                #     "0000:01:00.0" = {
                #       name = "uplink";
                #       num-rx-queues = 8;
                #     };
                #   }
                #   [ "0000:02:00.0" "0000:02:00.1" ]
                # ];

                blacklist = [
                  "8086:10fb"
                ];

                no-multi-seg = true;
                no-tx-checksum-offload = true;

                extraConfig = "dev 0000:02:00.0";
              };

              cpu = {
                main-core = 0;
                workers = 4;
              };

              plugins = {
                plugin."rdma_plugin.so".disable = true;
              };
            }
          '';
          description = ''
            Configuration for VPP, see <https://fd.io/docs/vpp/master/configuration/reference.html> for details.

            Nix value declared here will be translated directly to the config format VPP uses. Attributes
            called `extraConfig` will be inserted verbatim into the resulting config file.

            Top-level attrsets, lists and primitives get parsed as expected, i.e. `foo = { bar.enable = true };`
            becomes `foo { bar }` in the final config file. Nested attrsets on the other hand, such as
            {option}`dpdk.dev`, get parsed differently. For example, this config:
            ```nix
            config = {
              dpdk = {
                dev = {
                  "foo".name = "bar";
                  "baz".name = "qux";
                };
              };
            };
            ```
            Would get parsed into the following:
            ```
            dpdk {
              dev foo { name bar }
              dev baz { name qux }
            }
            ```
            Notice how `dev.foo` becomes `dev foo { }` instead of `dev { foo { } }`.
          '';
        };

        configFile = mkOption {
          type = types.path;
          example = "/etc/vpp/startup.conf";
          default = pkgs.writeText "vpp-${name}.conf" (parseConfig cfg.instances.${name}.config);
          defaultText = ''
            pkgs.writeText "vpp-\${name}.conf" (parseConfig config.services.vpp.instances.\${name}.config);
          '';
          description = ''
            Configuration file passed to {command}`vpp -c`.
            It is recommended to use the {option}`config` option instead.

            Setting this option will override the config file
            auto-generated from the {option}`config` option.
          '';
        };

        startupConfig = mkOption {
          type = types.str;
          default = "";
          example = ''
            set interface state TenGigabitEthernet1/0/0 up
            set interface state TenGigabitEthernet1/0/1 up
            set interface ip address TenGigabitEthernet1/0/0 2001:db8::1/64
            set interface ip address TenGigabitEthernet1/0/1 2001:db8:1234::1/64
          '';
          description = ''
            Script to run on startup in {command}`vppctl`, passed to
            VPP's `startup-config` option in the `unix` section as a file.

            This is used to configure things like IP addresses and routes. To configure
            interfaces, plugins, etc., see the {option}`config` option.
          '';
        };

        startupConfigFile = mkOption {
          type = types.path;
          example = "./vpp-startup.conf";
          default = pkgs.writeText "vpp-${name}-startup.conf" cfg.instances.${name}.startupConfig;
          defaultText = ''
            pkgs.writeText "vpp-\${name}-startup.conf" (builtins.toString config.services.vpp.instances.\${name}.startupConfig);
          '';
          description = ''
            File to run as a script on startup in {command}`vppctl`, passed
            to VPP's `startup-config` option in the `unix` section.

            Setting this option will override {option}`startupConfig`.
          '';
        };
      };

      # default for `config` defined here so user config doesn't completely overwrite it
      config.config = {
        unix = {
          nodaemon = mkOptionDefault true;
          nosyslog = mkOptionDefault true;
          cli-listen = mkOptionDefault "/run/vpp/${name}-cli.sock";
          gid = mkOptionDefault cfg.instances.${name}.group;
          startup-config = mkOptionDefault (builtins.toString cfg.instances.${name}.startupConfigFile);
        };
        api-segment.gid = mkOptionDefault cfg.instances.${name}.group;
      };
    };
in
{
  options.services.vpp = {
    hugepages = {
      autoSetup = mkOption {
        default = false;
        example = true;
        description = ''
          Whether to automatically setup hugepages for use with FD.io's Vector Packet Processor.

          If any programs other than VPP use hugepages or you want to use 1GB hugepages, it's recommended
          to keep this `false` and set them up manually using {option}`boot.kernel.sysctl` or {option}`boot.kernelParams`.
        '';
      };

      count = mkOption {
        type = types.ints.positive;
        default = 1024;
        example = 512;
        description = "Number of 2MB hugepages to setup on the system if {option}`services.vpp.hugepages.autoSetup` is enabled.";
      };
    };

    instances =
      with lib;
      mkOption {
        default = { };
        type = types.attrsOf (types.submodule instanceOpts);
        description = ''
          VPP supports multiple instances for testing or other purposes.
          If you don't require multiple instances of VPP you can define just the one.
        '';
        example = {
          main = {
            enable = true;
            group = "vpp-main";
            config = { };
          };
          test = {
            enable = false;
            group = "vpp-test";
            config = { };
          };
        };
      };
  };

  config =
    let
      #TODO: systemd hardening
      mkInstanceServiceConfig = instance: {
        description = "Vector Packet Processing Process";
        after = [
          "syslog.target"
          "network.target"
          "auditd.service"
        ];
        serviceConfig = {
          ExecStartPre =
            [
              "-${pkgs.coreutils}/bin/rm -f /dev/shm/db /dev/shm/global_vm /dev/shm/vpe-api"
            ]
            ++ (lib.optional (
              instance.kernelModule != null
            ) "-/run/current-system/sw/bin/modprobe ${instance.kernelModule}");
          ExecStart = "${instance.package}/bin/vpp -c ${instance.configFile}";
          Type = "simple";
          Restart = "on-failure";
          RestartSec = "5s";
          RuntimeDirectory = "vpp";
        };
        wantedBy = [ "multi-user.target" ];
      };
      instances = lib.attrValues cfg.instances;
    in
    {
      boot.kernel.sysctl = mkIf cfg.hugepages.autoSetup {
        # defaults for 2MB hugepages, see https://fd.io/docs/vpp/master/gettingstarted/running/index.html#huge-pages
        "vm.hugetlb_shm_group" = mkOptionDefault 0;
        "vm.nr_hugepages" = cfg.hugepages.count;
        "vm.max_map_count" = cfg.hugepages.count * 2;
        "kernel.shmmax" = cfg.hugepages.count * 2097152; # * 2 * 1024 * 1024
      };

      users.groups = lib.mkMerge (
        map (
          instance:
          lib.mkIf instance.enable {
            ${instance.group} = { };
          }
        ) instances
      );

      systemd.services = lib.mkMerge (
        map (
          instance:
          lib.mkIf instance.enable {
            "vpp-${instance.name}" = mkInstanceServiceConfig instance;
          }
        ) instances
      );

      meta.maintainers = with lib.maintainers; [ romner-set ];
    };
}

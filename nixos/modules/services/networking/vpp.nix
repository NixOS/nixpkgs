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
    ;
  cfg = config.services.vpp;

  # Converts the settings option to a string
  #
  # Top-level attrsets, lists and primitives get parsed as expected, i.e. `foo = { bar = true; };`
  # becomes `foo { bar }` in the final config file. Nested attrsets on the other hand, such as
  # {option}`dpdk.dev`, get parsed differently. For example, this config:
  # ```nix
  # settings = {
  #   dpdk = {
  #     dev = {
  #       "foo".name = "bar";
  #       "baz".name = "qux";
  #     };
  #   };
  # };
  # ```
  # Would get parsed into the following:
  # ```
  # dpdk {
  #   dev foo { name bar }
  #   dev baz { name qux }
  # }
  # ```
  # Notice how `dev.foo` becomes `dev foo { }` instead of `dev { foo { } }`.
  parseConfig =
    cfg:
    let
      inherit (lib) concatMap;

      # Specifies an attrset that encodes the value according to its type
      encode =
        name: value:
        {
          null = [ ];
          bool = lib.optional value name;
          int = [ "${name} ${toString value}" ];
          string = [ "${name} ${value}" ];

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
          ) (lib.filter (v: v != null) (builtins.attrNames value));
        }
        .${builtins.typeOf value};

      # One level "above" encode, acts upon a set and uses encode on each name,value pair
      toLines = set: concatMap (name: encode name set.${name}) (builtins.attrNames set);

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
    vppAll =
      (oneOf [
        vppAtom
        (listOf vppAtom)
        vppAttr
      ])
      // {
        # Since this is a recursive type and the description by default contains
        # the description of its subtypes, infinite recursion would occur without
        # explicitly breaking this cycle
        description = "vpp values (atoms (null, str, int, bool), list of atoms, or attrsets of vpp values)";
      };
  };

  vppOpts =
    { name, ... }:
    {
      options = {
        enable = mkEnableOption "FD.io's Vector Packet Processor, a high-performance userspace network stack";

        name = mkOption {
          type = types.str;
          default = name;
          description = ''
            Name is used as a suffix for the service name.
            By default it takes the value you use for `<name>` in:
            {option}`services.vpp.instances.<name>`
          '';
        };

        package = mkPackageOption pkgs "vpp" { };

        kernelModule = mkOption {
          type = types.nullOr types.str;
          default = "uio_pci_generic";
          example = "vfio-pci";
          description = "Kernel driver module to load before starting this VPP instance. Set to `null` to disable this functionality.";
        };

        group = mkOption {
          type = types.str;
          default = "vpp";
          example = "vpp-main";
          description = "Group that grants users in it privileges to control this instance via {command}`vppctl`.";
        };

        settings = mkOption {
          description = ''
            Configuration for VPP, see <https://fd.io/docs/vpp/master/configuration/reference.html> for details.

            Nix value declared here will be translated directly to the config format VPP uses.
          '';
          defaultText = ''
            unix = {
              nodaemon = true;
              nosyslog = true;
              cli-listen = "/run/vpp/\${name}-cli.sock";
              gid = config.services.vpp.instances.\${name}.group;
              startup-config = config.services.vpp.instances.\${name}.startupConfigFile;
              cli-prompt = "vpp-\${name}";
            };
            api-segment = {
              prefix = "\${name}";
              gid = config.services.vpp.instances.\${name}.group;
            };
          '';
          example = lib.literalExpression ''
            {
              unix.cli-listen = "/run/vpp/cli.sock";

              plugins.plugin."rdma_plugin.so".disable = true;
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
                #     "0000:01:00.0".name = "uplink";
                #   }
                #   [ "0000:02:00.0" "0000:02:00.1" ]
                # ];
              };
            }
          '';
          type = types.submodule {
            freeformType = semanticTypes.vppAttr;
            options =
              let
                # Most of the defaults don't need to be changed except under very specific circumstances and
                # all have their values documented in defaultText, so they're not visible to reduce clutter
                mkOptionWithDefault =
                  value:
                  mkOption {
                    default = value;
                    type = semanticTypes.vppAll;
                    visible = false;
                  };
              in
              {
                ## Config defaults
                api-segment = {
                  prefix = mkOptionWithDefault name;
                  gid = mkOptionWithDefault cfg.instances.${name}.group;
                };

                unix = {
                  nodaemon = mkOptionWithDefault true;
                  nosyslog = mkOptionWithDefault true;
                  gid = mkOptionWithDefault cfg.instances.${name}.group;
                  startup-config = mkOptionWithDefault (toString cfg.instances.${name}.startupConfigFile);

                  cli-prompt = mkOptionWithDefault "vpp-${name}";
                  cli-listen = mkOption {
                    # Visible in documentation unlike other defaults, since changing this
                    # setting will likely be pretty common on single-instance configs
                    type = types.str;
                    default = "/run/vpp/${name}-cli.sock";
                    example = "localhost:5002";
                    description = ''
                      Address in the format IPADDR:PORT or a socket path the CLI should listen on. If you only run
                      a single instance of VPP, it's recommended to change this to `/run/vpp/cli.sock` so
                      {command}`vppctl` can be used without specifying this path using the `-s` argument.
                    '';
                  };
                };

                ## User-facing option documentation
                plugins.plugin = mkOption {
                  type = types.attrsOf (
                    types.submodule {
                      freeformType = semanticTypes.vppAll;
                      options.enable = mkOption {
                        type = types.nullOr types.bool;
                        example = true;
                        default = null;
                        description = ''
                          Whether to enable this plugin. Because of how the config is parsed, `false`
                          has no effect. If you want to explicitly turn a plugin off use {option}`disable`.
                        '';
                      };
                      options.disable = mkOption {
                        type = types.nullOr types.bool;
                        example = true;
                        default = null;
                        description = ''
                          Whether to disable this plugin. Because of how the config is parsed, `false`
                          has no effect. If you want to explicitly turn a plugin on use {option}`enable`.
                        '';
                      };
                    }
                  );
                  example = {
                    default.disable = true;
                    "dpdk_plugin.so".enable = true;
                  };
                  default = { };
                  description = ''
                    Configuration for specific plugins, usually used to turn a plugin on or off.
                    Special value `default` applies to all plugins.
                  '';
                };

                dpdk = {
                  dev = mkOption {
                    type = types.attrsOf (
                      types.submodule {
                        freeformType = semanticTypes.vppAll;

                        options.name = mkOption {
                          type = types.nullOr types.str;
                          example = "eth0";
                          default = null;
                          description = "Override the name of this interface as seen from the CLI.";
                        };
                        options.num-rx-queues = mkOption {
                          type = types.nullOr types.ints.positive;
                          example = 4;
                          default = null;
                          description = ''
                            Number of receive queues on this interface. Useful for multi-threaded operation.
                            Use the `cpu.*` options to setup workers if you want to use this option.
                          '';
                        };
                      }
                    );
                    example = {
                      "0000:01:00.0".name = "eth0";
                    };
                    default = { };
                    description = ''
                      Which DPDK network interfaces VPP should bind to, can also be specified as a list if no
                      per-device configuration is needed. Special value `default` applies to all interfaces.
                    '';
                  };

                  blacklist = mkOption {
                    type = types.oneOf [
                      types.str
                      (types.listOf types.str)
                    ];
                    example = "8086:10fb";
                    default = [ ];
                    description = "Device types to blacklist, using PCI vendor:device syntax.";
                  };
                };

                cpu = {
                  main-core = mkOption {
                    type = types.nullOr types.ints.unsigned;
                    example = 0;
                    default = null;
                    description = ''
                      Logical CPU core where the main thread runs, if unset VPP will use core 1 if available.
                    '';
                  };

                  corelist-workers = mkOption {
                    type = types.nullOr types.str;
                    example = "2-3,18-19";
                    default = null;
                    description = ''
                      Explicitly set logical CPUs on which VPP worker threads will run.

                      {option}`skip-cores` and {option}`workers` are incompatible with {option}`corelist-workers`.
                    '';
                  };

                  skip-cores = mkOption {
                    type = types.nullOr types.ints.positive;
                    example = 8;
                    default = null;
                    description = ''
                      Set number of logical CPU cores to skip when using the {option}`workers` option.

                      {option}`skip-cores` and {option}`workers` are incompatible with {option}`corelist-workers`.
                    '';
                  };
                  workers = mkOption {
                    type = types.nullOr types.ints.positive;
                    example = 4;
                    default = null;
                    description = ''
                      Set number of workers to be created and automatically assigned. Workers will be pinned to
                      N consecutive CPU cores while skipping {option}`skip-cores` CPU core(s) and main thread's core.

                      {option}`skip-cores` and {option}`workers` are incompatible with {option}`corelist-workers`.
                    '';
                  };
                };
              };
          };
        };

        extraConfig = mkOption {
          type = types.lines;
          default = "";
          description = ''
            Extra configuration to append to the configuration file.
          '';
        };

        settingsFile = mkOption {
          type = types.path;
          example = "/etc/vpp/startup.conf";
          default =
            let
              inherit (cfg.instances.${name}) settings extraConfig;
            in
            pkgs.writeText "vpp-${name}.conf" ((parseConfig settings) + extraConfig);
          defaultText = lib.literalExpression ''pkgs.writeText "vpp-\${name}.conf" ((parseConfig settings) + extraConfig)'';
          description = ''
            Configuration file passed to {command}`vpp -c`.
            It is recommended to use the {option}`settings` option instead.

            Setting this option will override the config file
            auto-generated from the {option}`settings` and {option}`extraConfig` options.
          '';
        };

        startupConfig = mkOption {
          type = types.lines;
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
            interfaces, plugins, etc., see the {option}`settings` option.
          '';
        };

        startupConfigFile = mkOption {
          type = types.path;
          example = "./vpp-startup.conf";
          default = pkgs.writeText "vpp-${name}-startup.conf" cfg.instances.${name}.startupConfig;
          defaultText = lib.literalExpression ''pkgs.writeText "vpp-\${name}-startup.conf" (toString config.services.vpp.instances.\${name}.startupConfig)'';
          description = ''
            File to run as a script on startup in {command}`vppctl`, passed
            to VPP's `startup-config` option in the `unix` section.

            Setting this option will override {option}`startupConfig`.
          '';
        };
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
          Whether to automatically setup 2MB hugepages for use with FD.io's Vector Packet Processor.

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

    instances = mkOption {
      default = { };
      type = types.attrsOf (types.submodule vppOpts);
      description = ''
        VPP supports multiple instances for testing or other purposes.
        If you don't require multiple instances of VPP you can define just the one.
      '';
      example = lib.literalExpression ''
        {
          "main" = {
            enable = true;
            group = "vpp-main";
            settings = { };
          };
          "test" = {
            enable = false;
            group = "vpp-test";
            settings = { };
          };
        };
      '';
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
          ExecStart = "${instance.package}/bin/vpp -c ${instance.settingsFile}";
          Type = "simple";
          Restart = "on-failure";
          RestartSec = "5s";
          RuntimeDirectory = "vpp";
        };
        wantedBy = [ "multi-user.target" ];
      };
      instances = lib.attrValues cfg.instances;
    in
    lib.mkIf (lib.any (v: v.enable) instances) {
      environment.systemPackages = [
        pkgs.vpp # for the vppctl tool
      ];

      boot.kernel.sysctl = lib.mkIf cfg.hugepages.autoSetup {
        # defaults for 2MB hugepages, see https://fd.io/docs/vpp/master/gettingstarted/running/index.html#huge-pages
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

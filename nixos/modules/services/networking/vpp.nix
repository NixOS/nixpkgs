{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.vpp;

  mapAttrsToLines =
    f: attrs:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList f (
        lib.filterAttrs (_: value: value != null && value != { } && value != [ ]) attrs
      )
    );
  prefixWith = prefix: lines: lib.replaceString "\n" ("\n" + prefix) lines;

  # Parse the settings option into a string
  parseSettings =
    settings:
    mapAttrsToLines (sectionName: section: ''
      ${sectionName} {
        ${prefixWith "  " (mapAttrsToLines parseAttr section)}
      }
    '') settings;

  # Parse a single VPP config value (e.g. settings.unix.cli-listen) into a string
  parseAttr =
    name: value:
    {
      bool = lib.optionalString value name;
      int = "${name} ${toString value}";
      string = "${name} ${value}";

      # Values like `foo = [ {bar = {};} {baz = {};} ];` should be transformed into
      #   foo bar {}
      #   foo baz {}
      # which is equivalent to `foo = {bar = {}; baz = {};};`.
      list = lib.concatMapStringsSep "\n" (parseAttr name) value;

      # Values like `foo.bar.baz = true;` should be transformed into
      #   foo bar {
      #     baz
      #   }
      set = mapAttrsToLines (subname: subvalue: ''
        ${name} ${subname} {
          ${prefixWith "  " (mapAttrsToLines parseAttr subvalue)}
        }
      '') value;
    }
    .${builtins.typeOf value}
    or (throw ''services.vpp.settings: Unsupported type "${builtins.typeOf value}"'');

  # Type for the settings option
  settingsTypes = with lib.types; {
    atom =
      (oneOf [
        int
        bool
        str
        (listOf settingsTypes.atom)
        settingsTypes.nestedAttrs
      ])
      // {
        # Description needs to be overridden for recursive types
        description = "VPP atom (int, bool, string, list of VPP atoms, attrs of attrs of null or VPP atoms)";
      };

    attrs = (attrsOf (nullOr settingsTypes.atom)) // {
      description = "attrs of null or " + settingsTypes.atom.description;
    };

    nestedAttrs = (attrsOf settingsTypes.attrs) // {
      description = "attrs of " + settingsTypes.attrs.description;
    };
  };

  # Documented options and defaults for settings
  settingsOptions =
    let
      # Most of the defaults shouldn't ever need to be changed and all have their values
      # documented in defaultText, so they're not visible to reduce clutter
      mkHiddenDefault =
        type: value:
        lib.mkOption {
          inherit type;
          default = value;
          visible = false;
        };
    in
    {
      # Config defaults

      api-segment.gid = mkHiddenDefault lib.types.str cfg.group;
      unix = with lib.types; {
        nodaemon = mkHiddenDefault bool true;
        nosyslog = mkHiddenDefault bool true;
        cli-listen = mkHiddenDefault str "/run/vpp/cli.sock";
        startup-config = mkHiddenDefault str (
          toString (pkgs.writeText "vpp-startup.conf" cfg.startupConfig)
        );
        gid = mkHiddenDefault str cfg.group;
      };
      logging.default-syslog-log-level = mkHiddenDefault lib.types.str "info";

      # Option documentation

      plugins.plugin = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            freeformType = settingsTypes.attrs;

            options.enable = lib.mkOption {
              type = with lib.types; nullOr bool;
              description = ''
                Whether to enable this plugin. Because of how the config is parsed, `false`
                has no effect. If you want to explicitly turn a plugin off use {option}`disable`.
              '';
              default = null;
              example = true;
            };
            options.disable = lib.mkOption {
              type = with lib.types; nullOr bool;
              description = ''
                Whether to disable this plugin. Because of how the config is parsed, `false`
                has no effect. If you want to explicitly turn a plugin on use {option}`enable`.
              '';
              default = null;
              example = true;
            };
          }
        );
        description = ''
          Configuration for specific plugins, usually used to turn a plugin on or off.
          Special value `default` applies to all plugins.
        '';
        default = { };
        example = lib.literalExpression ''
          {
            default.disable = true;
            "dpdk_plugin.so".enable = true;
          }
        '';
      };

      dpdk = {
        dev = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule {
              freeformType = settingsTypes.attrs;

              options.name = lib.mkOption {
                type = with lib.types; nullOr str;
                description = "Override the name of this interface as seen from the CLI.";
                default = null;
                example = "eth0";
              };
              options.num-rx-queues = lib.mkOption {
                type = with lib.types; nullOr ints.positive;
                description = ''
                  Number of receive queues on this interface. Useful for multi-threaded operation.
                  Use the `cpu.*` options to setup workers if you want to use this option.
                '';
                default = null;
                example = 4;
              };
            }
          );
          description = ''
            Which DPDK network interfaces VPP should bind to.
            Special value `default` applies to all interfaces.
          '';
          default = { };
          example = lib.literalExpression ''
            {
              default.num-rx-queues = 4;
              "0000:01:00.0".name = "eth0";
            }
          '';
        };

        blacklist = lib.mkOption {
          type =
            with lib.types;
            oneOf [
              str
              (listOf str)
            ];
          description = "Device types to blacklist, using PCI vendor:device syntax.";
          default = [ ];
          example = "8086:10fb";
        };
      };

      cpu = {
        main-core = lib.mkOption {
          type = with lib.types; nullOr ints.unsigned;
          description = ''
            Logical CPU core where the main thread runs, if unset VPP will use core 1 if available.

            {option}`main-core` and {option}`corelist-workers` are incompatible with
            {option}`skip-cores` and {option}`workers`.
          '';
          default = null;
          example = 0;
        };
        corelist-workers = lib.mkOption {
          type = with lib.types; nullOr str;
          description = ''
            Explicitly set logical CPUs on which VPP worker threads will run.

            {option}`main-core` and {option}`corelist-workers` are incompatible with
            {option}`skip-cores` and {option}`workers`.
          '';
          default = null;
          example = "2-3,18-19";
        };

        skip-cores = lib.mkOption {
          type = with lib.types; nullOr ints.positive;
          description = ''
            Set number of logical CPU cores to skip when using the {option}`workers` option.
            Using this option, the main thread will be pinned to the next available CPU core after skipping.

            {option}`skip-cores` and {option}`workers` are incompatible with
            {option}`main-core` and {option}`corelist-workers`.
          '';
          default = null;
          example = 8;
        };
        workers = lib.mkOption {
          type = with lib.types; nullOr ints.positive;
          description = ''
            Set number of workers to be created and automatically assigned. Workers will be pinned to
            N consecutive CPU cores while skipping {option}`skip-cores` CPU core(s) and the main thread's core.

            {option}`skip-cores` and {option}`workers` are incompatible with
            {option}`main-core` and {option}`corelist-workers`.
          '';
          default = null;
          example = 4;
        };
      };
    };
in
{
  options.services.vpp = {
    enable = lib.mkEnableOption "FD.io's Vector Packet Processor";

    package = lib.mkPackageOption pkgs "vpp" { };

    group = lib.mkOption {
      type = lib.types.str;
      description = "Group that grants users in it privileges to control this instance via {command}`vppctl`.";
      default = "vpp";
      example = "wheel";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsTypes.nestedAttrs;
        options = settingsOptions;
      };
      description = ''
        Configuration for VPP, see <https://fd.io/docs/vpp/master/configuration/reference.html> for details.
        Nix value declared here will be translated directly to the config format VPP uses.

        ::: {.note}
        VPP requires hugepages and a loaded PCI driver to work. Hugepages can be configured manually or via
        {option}`services.vpp.hugepages`, but loading the correct PCI driver for your hardware is your responsibility.

        See the
        [upstream documentation on hugepages](https://fd.io/docs/vpp/master/gettingstarted/running/index.html#huge-pages),
        upstream VPP (but not this module!) also defaults to loading the `uio_pci_generic` driver if you don't
        require a specific one.
        :::
      '';
      defaultText = lib.literalExpression ''
        {
          api-segment.gid = config.services.vpp.group;
          unix = {
            nodaemon = true;
            nosyslog = true;
            cli-listen = "/run/vpp/cli.sock";
            startup-config = <generated from config.services.vpp.startupConfig>;
            gid = config.services.vpp.group;
          };
          logging.default-syslog-log-level = "info";
        }
      '';
      example = lib.literalExpression ''
        {
          plugins.plugin."rdma_plugin.so".disable = true;

          cpu.corelist-workers = "2-3,18-19";
          dpdk.dev = {
            default.num-rx-queues = 4;
            "0000:01:00.0".name = "sfp0";
            "0000:01:00.1".name = "sfp1";
          };
        }
      '';
    };

    startupConfig = lib.mkOption {
      type = lib.types.lines;
      description = ''
        Script to run on startup in {command}`vppctl`, passed to
        VPP's `startup-config` option in the `unix` section as a file.

        This is used to configure things like IP addresses and routes. To
        configure interfaces, plugins, etc., see the {option}`settings` option.
      '';
      default = "";
      example = ''
        set interface state TenGigabitEthernet1/0/0 up
        set interface state TenGigabitEthernet1/0/1 up
        set interface ip address TenGigabitEthernet1/0/0 2001:db8:1::1/64
        set interface ip address TenGigabitEthernet1/0/1 2001:db8:2::1/64
      '';
    };

    hugepages = {
      enable = lib.mkEnableOption "" // {
        description = ''
          Whether to automatically setup 2MB hugepages, see the upstream documentation:
          <https://fd.io/docs/vpp/master/gettingstarted/running/index.html#huge-pages>

          You can control how many to setup using {option}`services.vpp.hugepages.count`. Changes take effect after reboot.

          If any programs other than VPP use hugepages or you want to use 1GB hugepages, it's recommended
          to keep this `false` and set them up manually using {option}`boot.kernel.sysctl` or {option}`boot.kernelParams`.
        '';
      };

      count = lib.mkOption {
        type = lib.types.ints.positive;
        default = 1024;
        example = 2048;
        description = "Number of 2MB hugepages to setup on the system if {option}`services.vpp.hugepages.enable` is true.";
      };

      silenceWarning = lib.mkOption {
        type = lib.types.bool;
        description = ''
          Silence warning that occurs if hugepages aren't detected on the system.

          ::: {.note}
          Alongside hugepages, users of this module are also expected to load a kernel
          driver that VPP can use. If you aren't sure and don't require a specific one,
          `uio_pci_generic` should work.
          :::
        '';
        default = false;
        example = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    warnings =
      let
        hugepagesDetected =
          config.boot.kernel.sysctl ? "vm.nr_hugepages"
          || builtins.any (lib.hasPrefix "hugepages=") config.boot.kernelParams;
      in
      lib.optional (!hugepagesDetected && !cfg.silenceNoHugepages) ''
        `services.vpp` is enabled, but hugepages aren't configured!

        VPP requires hugepages and a loaded PCI driver to work, users are expected
        to configure this themselves. See the upstream documentation on hugepages:

        https://fd.io/docs/vpp/master/gettingstarted/running/index.html#huge-pages

        Upstream VPP (but not this module) also defaults to loading the `uio_pci_generic`
        driver, which works if you aren't sure and don't require a specific one.

        If this is a false positive, you can silence this warning by setting the
        `services.vpp.hugepages.silenceWarning` option to true.
      '';

    boot.kernel.sysctl = lib.mkIf cfg.hugepages.enable {
      # defaults for 2MB hugepages, see https://fd.io/docs/vpp/master/gettingstarted/running/index.html#huge-pages
      "vm.nr_hugepages" = cfg.hugepages.count;
      "vm.max_map_count" = cfg.hugepages.count * 2;
      "kernel.shmmax" = cfg.hugepages.count * 2097152; # * 2 * 1024 * 1024
    };

    environment.systemPackages = [ cfg.package ]; # for the vppctl tool

    users.groups.${cfg.group} = { };

    systemd.services.vpp = {
      description = "Vector Packet Processing Process";
      after = [
        "syslog.target"
        "network.target"
        "auditd.service"
      ];
      serviceConfig = {
        ExecStartPre = [
          # https://s3-docs.fd.io/vpp/26.02/gettingstarted/running/index.html#systemd-file-vpp-service
          "-${pkgs.coreutils}/bin/rm -f /dev/shm/db /dev/shm/global_vm /dev/shm/vpe-api"
        ];
        ExecStart = "${cfg.package}/bin/vpp -c ${pkgs.writeText "vpp.conf" (parseSettings cfg.settings)}";
        Type = "simple";
        Restart = "on-failure";
        RestartSec = "5s";
        RuntimeDirectory = "vpp";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };

  meta.maintainers = with lib.maintainers; [ maevii ];
}

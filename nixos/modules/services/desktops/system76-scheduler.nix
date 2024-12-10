{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.system76-scheduler;

  inherit (builtins)
    concatStringsSep
    map
    toString
    attrNames
    ;
  inherit (lib)
    boolToString
    types
    mkOption
    literalExpression
    optional
    mkIf
    mkMerge
    ;
  inherit (types)
    nullOr
    listOf
    bool
    int
    ints
    float
    str
    enum
    ;

  withDefaults =
    optionSpecs: defaults:
    lib.genAttrs (attrNames optionSpecs) (
      name:
      mkOption (
        optionSpecs.${name}
        // {
          default = optionSpecs.${name}.default or defaults.${name} or null;
        }
      )
    );

  latencyProfile = withDefaults {
    latency = {
      type = int;
      description = "`sched_latency_ns`.";
    };
    nr-latency = {
      type = int;
      description = "`sched_nr_latency`.";
    };
    wakeup-granularity = {
      type = float;
      description = "`sched_wakeup_granularity_ns`.";
    };
    bandwidth-size = {
      type = int;
      description = "`sched_cfs_bandwidth_slice_us`.";
    };
    preempt = {
      type = enum [
        "none"
        "voluntary"
        "full"
      ];
      description = "Preemption mode.";
    };
  };
  schedulerProfile = withDefaults {
    nice = {
      type = nullOr (ints.between (-20) 19);
      description = "Niceness.";
    };
    class = {
      type = nullOr (enum [
        "idle"
        "batch"
        "other"
        "rr"
        "fifo"
      ]);
      example = literalExpression "\"batch\"";
      description = "CPU scheduler class.";
    };
    prio = {
      type = nullOr (ints.between 1 99);
      example = literalExpression "49";
      description = "CPU scheduler priority.";
    };
    ioClass = {
      type = nullOr (enum [
        "idle"
        "best-effort"
        "realtime"
      ]);
      example = literalExpression "\"best-effort\"";
      description = "IO scheduler class.";
    };
    ioPrio = {
      type = nullOr (ints.between 0 7);
      example = literalExpression "4";
      description = "IO scheduler priority.";
    };
    matchers = {
      type = nullOr (listOf str);
      default = [ ];
      example = literalExpression ''
        [
          "include cgroup=\"/user.slice/*.service\" parent=\"systemd\""
          "emacs"
        ]
      '';
      description = "Process matchers.";
    };
  };

  cfsProfileToString =
    name:
    let
      p = cfg.settings.cfsProfiles.${name};
    in
    "${name} latency=${toString p.latency} nr-latency=${toString p.nr-latency} wakeup-granularity=${toString p.wakeup-granularity} bandwidth-size=${toString p.bandwidth-size} preempt=\"${p.preempt}\"";

  prioToString = class: prio: if prio == null then "\"${class}\"" else "(${class})${toString prio}";

  schedulerProfileToString =
    name: a: indent:
    concatStringsSep " " (
      [ "${indent}${name}" ]
      ++ (optional (a.nice != null) "nice=${toString a.nice}")
      ++ (optional (a.class != null) "sched=${prioToString a.class a.prio}")
      ++ (optional (a.ioClass != null) "io=${prioToString a.ioClass a.ioPrio}")
      ++ (optional ((builtins.length a.matchers) != 0) (
        "{\n${concatStringsSep "\n" (map (m: "  ${indent}${m}") a.matchers)}\n${indent}}"
      ))
    );

in
{
  options = {
    services.system76-scheduler = {
      enable = lib.mkEnableOption "system76-scheduler";

      package = mkOption {
        type = types.package;
        default = config.boot.kernelPackages.system76-scheduler;
        defaultText = literalExpression "config.boot.kernelPackages.system76-scheduler";
        description = "Which System76-Scheduler package to use.";
      };

      useStockConfig = mkOption {
        type = bool;
        default = true;
        description = ''
          Use the (reasonable and featureful) stock configuration.

          When this option is `true`, `services.system76-scheduler.settings`
          are ignored.
        '';
      };

      settings = {
        cfsProfiles = {
          enable = mkOption {
            type = bool;
            default = true;
            description = "Tweak CFS latency parameters when going on/off battery";
          };

          default = latencyProfile {
            latency = 6;
            nr-latency = 8;
            wakeup-granularity = 1.0;
            bandwidth-size = 5;
            preempt = "voluntary";
          };
          responsive = latencyProfile {
            latency = 4;
            nr-latency = 10;
            wakeup-granularity = 0.5;
            bandwidth-size = 3;
            preempt = "full";
          };
        };

        processScheduler = {
          enable = mkOption {
            type = bool;
            default = true;
            description = "Tweak scheduling of individual processes in real time.";
          };

          useExecsnoop = mkOption {
            type = bool;
            default = true;
            description = "Use execsnoop (otherwise poll the precess list periodically).";
          };

          refreshInterval = mkOption {
            type = int;
            default = 60;
            description = "Process list poll interval, in seconds";
          };

          foregroundBoost = {
            enable = mkOption {
              type = bool;
              default = true;
              description = ''
                Boost foreground process priorities.

                (And de-boost background ones).  Note that this option needs cooperation
                from the desktop environment to work.  On Gnome the client side is
                implemented by the "System76 Scheduler" shell extension.
              '';
            };
            foreground = schedulerProfile {
              nice = 0;
              ioClass = "best-effort";
              ioPrio = 0;
            };
            background = schedulerProfile {
              nice = 6;
              ioClass = "idle";
            };
          };

          pipewireBoost = {
            enable = mkOption {
              type = bool;
              default = true;
              description = "Boost Pipewire client priorities.";
            };
            profile = schedulerProfile {
              nice = -6;
              ioClass = "best-effort";
              ioPrio = 0;
            };
          };
        };
      };

      assignments = mkOption {
        type = types.attrsOf (
          types.submodule {
            options = schedulerProfile { };
          }
        );
        default = { };
        example = literalExpression ''
          {
            nix-builds = {
              nice = 15;
              class = "batch";
              ioClass = "idle";
              matchers = [
                "nix-daemon"
              ];
            };
          }
        '';
        description = "Process profile assignments.";
      };

      exceptions = mkOption {
        type = types.listOf str;
        default = [ ];
        example = literalExpression ''
          [
            "include descends=\"schedtool\""
            "schedtool"
          ]
        '';
        description = "Processes that are left alone.";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];

    systemd.services.system76-scheduler = {
      description = "Manage process priorities and CFS scheduler latencies for improved responsiveness on the desktop";
      wantedBy = [ "multi-user.target" ];
      path = [
        # execsnoop needs those to extract kernel headers:
        pkgs.kmod
        pkgs.gnutar
        pkgs.xz
      ];
      serviceConfig = {
        Type = "dbus";
        BusName = "com.system76.Scheduler";
        ExecStart = "${cfg.package}/bin/system76-scheduler daemon";
        ExecReload = "${cfg.package}/bin/system76-scheduler daemon reload";
      };
    };

    environment.etc = mkMerge [
      (mkIf cfg.useStockConfig {
        # No custom settings: just use stock configuration with a fix for Pipewire
        "system76-scheduler/config.kdl".source = "${cfg.package}/data/config.kdl";
        "system76-scheduler/process-scheduler/00-dist.kdl".source = "${cfg.package}/data/pop_os.kdl";
        "system76-scheduler/process-scheduler/01-fix-pipewire-paths.kdl".source =
          ../../../../pkgs/os-specific/linux/system76-scheduler/01-fix-pipewire-paths.kdl;
      })

      (
        let
          settings = cfg.settings;
          cfsp = settings.cfsProfiles;
          ps = settings.processScheduler;
        in
        mkIf (!cfg.useStockConfig) {
          "system76-scheduler/config.kdl".text = ''
            version "2.0"
            autogroup-enabled false
            cfs-profiles enable=${boolToString cfsp.enable} {
              ${cfsProfileToString "default"}
              ${cfsProfileToString "responsive"}
            }
            process-scheduler enable=${boolToString ps.enable} {
              execsnoop ${boolToString ps.useExecsnoop}
              refresh-rate ${toString ps.refreshInterval}
              assignments {
                ${
                  if ps.foregroundBoost.enable then
                    (schedulerProfileToString "foreground" ps.foregroundBoost.foreground "    ")
                  else
                    ""
                }
                ${
                  if ps.foregroundBoost.enable then
                    (schedulerProfileToString "background" ps.foregroundBoost.background "    ")
                  else
                    ""
                }
                ${
                  if ps.pipewireBoost.enable then
                    (schedulerProfileToString "pipewire" ps.pipewireBoost.profile "    ")
                  else
                    ""
                }
              }
            }
          '';
        }
      )

      {
        "system76-scheduler/process-scheduler/02-config.kdl".text =
          "exceptions {\n${concatStringsSep "\n" (map (e: "  ${e}") cfg.exceptions)}\n}\n"
          + "assignments {\n"
          + (concatStringsSep "\n" (
            map (name: schedulerProfileToString name cfg.assignments.${name} "  ") (attrNames cfg.assignments)
          ))
          + "\n}\n";
      }
    ];
  };

  meta = {
    maintainers = [ lib.maintainers.cmm ];
  };
}

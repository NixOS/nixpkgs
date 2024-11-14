{
  lib,
  config,
  yaml,
  ...
}:
let
  cfg = config.services.suricata;
  inherit (lib)
    mkEnableOption
    mkOption
    types
    literalExpression
    ;
  mkDisableOption =
    name:
    mkEnableOption name
    // {
      default = true;
      example = false;
    };
in
{
  freeformType = yaml.type;
  options = {
    vars = mkOption {
      type = types.nullOr (
        types.submodule {
          options = {
            address-groups = mkOption {
              type = (
                types.submodule {
                  options = {
                    HOME_NET = mkOption { default = "[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"; };
                    EXTERNAL_NET = mkOption { default = "!$HOME_NET"; };
                    HTTP_SERVERS = mkOption { default = "$HOME_NET"; };
                    SMTP_SERVERS = mkOption { default = "$HOME_NET"; };
                    SQL_SERVERS = mkOption { default = "$HOME_NET"; };
                    DNS_SERVERS = mkOption { default = "$HOME_NET"; };
                    TELNET_SERVERS = mkOption { default = "$HOME_NET"; };
                    AIM_SERVERS = mkOption { default = "$EXTERNAL_NET"; };
                    DC_SERVERS = mkOption { default = "$HOME_NET"; };
                    DNP3_SERVER = mkOption { default = "$HOME_NET"; };
                    DNP3_CLIENT = mkOption { default = "$HOME_NET"; };
                    MODBUS_CLIENT = mkOption { default = "$HOME_NET"; };
                    MODBUS_SERVER = mkOption { default = "$HOME_NET"; };
                    ENIP_CLIENT = mkOption { default = "$HOME_NET"; };
                    ENIP_SERVER = mkOption { default = "$HOME_NET"; };
                  };
                }
              );
              default = { };
              example = {
                HOME_NET = "[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]";
                EXTERNAL_NET = "!$HOME_NET";
                HTTP_SERVERS = "$HOME_NET";
                SMTP_SERVERS = "$HOME_NET";
                SQL_SERVERS = "$HOME_NET";
                DNS_SERVERS = "$HOME_NET";
                TELNET_SERVERS = "$HOME_NET";
                AIM_SERVERS = "$EXTERNAL_NET";
                DC_SERVERS = "$HOME_NET";
                DNP3_SERVER = "$HOME_NET";
                DNP3_CLIENT = "$HOME_NET";
                MODBUS_CLIENT = "$HOME_NET";
                MODBUS_SERVER = "$HOME_NET";
                ENIP_CLIENT = "$HOME_NET";
                ENIP_SERVER = "$HOME_NET";
              };
              description = ''
                The address group variables for suricata, if not defined the
                default value of suricata (see example) will be used.
                Your settings will extend the predefined values in example.
              '';
            };

            port-groups = mkOption {
              type = with types; nullOr (attrsOf str);
              default = {
                HTTP_PORTS = "80";
                SHELLCODE_PORTS = "!80";
                ORACLE_PORTS = "1521";
                SSH_PORTS = "22";
                DNP3_PORTS = "20000";
                MODBUS_PORTS = "502";
                FILE_DATA_PORTS = "[$HTTP_PORTS,110,143]";
                FTP_PORTS = "21";
                GENEVE_PORTS = "6081";
                VXLAN_PORTS = "4789";
                TEREDO_PORTS = "3544";
              };
              description = ''
                The port group variables for suricata.
              '';
            };
          };
        }
      );
      default = { }; # add default values to config
    };

    stats = mkOption {
      type =
        with types;
        nullOr (submodule {
          options = {
            enable = mkEnableOption "suricata global stats";

            interval = mkOption {
              type = types.str;
              default = "8";
              description = ''
                The interval field (in seconds) controls the interval at
                which stats are updated in the log.
              '';
            };

            decoder-events = mkOption {
              type = types.bool;
              default = true;
              description = ''
                Add decode events to stats
              '';
            };

            decoder-events-prefix = mkOption {
              type = types.str;
              default = "decoder.event";
              description = ''
                Decoder event prefix in stats. Has been 'decoder' before, but that leads
                to missing events in the eve.stats records.
              '';
            };

            stream-events = mkOption {
              type = types.bool;
              default = false;
              description = ''
                Add stream events as stats.
              '';
            };
          };
        });
      default = null; # do not add to config unless specified
    };

    plugins = mkOption {
      type = with types; nullOr (listOf path);
      default = null;
      description = ''
        Plugins -- Experimental -- specify the filename for each plugin shared object
      '';
    };

    outputs = mkOption {
      type =
        with types;
        nullOr (
          listOf (
            attrsOf (submodule {
              freeformType = yaml.type;
              options = {
                enabled = mkEnableOption "<NAME>";
              };
            })
          )
        );
      default = null;
      example = literalExpression ''
        [
          {
            fast = {
              enabled = "yes";
              filename = "fast.log";
              append = "yes";
            };
          }
          {
            eve-log = {
              enabled = "yes";
              filetype = "regular";
              filename = "eve.json";
              community-id = true;
              types = [
                {
                  alert.tagged-packets = "yes";
                }
              ];
            };
          }
        ];
      '';
      description = ''
        Configure the type of alert (and other) logging you would like.

        Valid values for <NAME> are e. g. `fast`, `eve-log`, `syslog`, `file-store`, ...
        - `fast`: a line based alerts log similar to Snort's fast.log
        - `eve-log`: Extensible Event Format (nicknamed EVE) event log in JSON format

        For more details regarding the configuration, checkout the shipped suricata.yaml
        ```shell
        nix-shell -p suricata yq coreutils-full --command 'yq < $(dirname $(which suricata))/../etc/suricata/suricata.yaml'
        ```
        and the [suricata documentation](https://docs.suricata.io/en/latest/output/index.html).
      '';
    };

    "default-log-dir" = mkOption {
      type = types.str;
      default = "/var/log/suricata";
      description = ''
        The default logging directory. Any log or output file will be placed here if it's
        not specified with a full path name. This can be overridden with the -l command
        line parameter.
      '';
    };

    logging = {
      "default-log-level" = mkOption {
        type = types.enum [
          "error"
          "warning"
          "notice"
          "info"
          "perf"
          "config"
          "debug"
        ];
        default = "notice";
        description = ''
          The default log level: can be overridden in an output section.
          Note that debug level logging will only be emitted if Suricata was
          compiled with the --enable-debug configure option.
        '';
      };

      "default-log-format" = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The default output format. Optional parameter, should default to
          something reasonable if not provided. Can be overridden in an
          output section.  You can leave this out to get the default.
        '';
      };

      "default-output-filter" = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          A regex to filter output.  Can be overridden in an output section.
          Defaults to empty (no filter).
        '';
      };

      "stacktrace-on-signal" = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Requires libunwind to be available when Suricata is configured and built.
          If a signal unexpectedly terminates Suricata, displays a brief diagnostic
          message with the offending stacktrace if enabled.
        '';
      };

      outputs = {
        console = {
          enable = mkDisableOption "logging to console";
        };
        file = {
          enable = mkDisableOption "logging to file";

          level = mkOption {
            type = types.enum [
              "error"
              "warning"
              "notice"
              "info"
              "perf"
              "config"
              "debug"
            ];
            default = "info";
            description = ''
              Loglevel for logs written to the logfile
            '';
          };

          filename = mkOption {
            type = types.str;
            default = "suricata.log";
            description = ''
              Filename of the logfile
            '';
          };

          format = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = ''
              Logformat for logs written to the logfile
            '';
          };

          type = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = ''
              Type of logfile
            '';
          };
        };
        syslog = {
          enable = mkEnableOption "logging to syslog";

          facility = mkOption {
            type = types.str;
            default = "local5";
            description = ''
              Facility to log to
            '';
          };

          format = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = ''
              Logformat for logs send to syslog
            '';
          };

          type = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = ''
              Type of logs send to syslog
            '';
          };
        };
      };
    };

    "af-packet" = mkOption {
      type =
        with types;
        nullOr (
          listOf (submodule {
            freeformType = yaml.type;
            options = {
              interface = mkOption {
                type = types.str;
                default = null;
              };
            };
          })
        );
      default = null;
      description = ''
        Linux high speed capture support
      '';
    };

    "af-xdp" = mkOption {
      type =
        with types;
        nullOr (
          listOf (submodule {
            freeformType = yaml.type;
            options = {
              interface = mkOption {
                type = types.str;
                default = null;
              };
            };
          })
        );
      default = null;
      description = ''
        Linux high speed af-xdp capture support, see
        [docs/capture-hardware/af-xdp](https://docs.suricata.io/en/suricata-7.0.3/capture-hardware/af-xdp.html)
      '';
    };

    "dpdk" = mkOption {
      type =
        with types;
        nullOr (submodule {
          options = {
            eal-params.proc-type = mkOption {
              type = with types; nullOr str;
              default = null;
            };
            interfaces = mkOption {
              type =
                with types;
                nullOr (
                  listOf (submodule {
                    freeformType = yaml.type;
                    options = {
                      interface = mkOption {
                        type = types.str;
                        default = null;
                      };
                    };
                  })
                );
              default = null;
            };
          };
        });
      default = null;
      description = ''
        DPDK capture support, see
        [docs/capture-hardware/dpdk](https://docs.suricata.io/en/suricata-7.0.3/capture-hardware/dpdk.html)
      '';
    };

    "pcap" = mkOption {
      type =
        with types;
        nullOr (
          listOf (submodule {
            freeformType = yaml.type;
            options = {
              interface = mkOption {
                type = types.str;
                default = null;
              };
            };
          })
        );
      default = null;
      description = ''
        Cross platform libpcap capture support
      '';
    };

    "pcap-file".checksum-checks = mkOption {
      type = types.enum [
        "yes"
        "no"
        "auto"
      ];
      default = "auto";
      description = ''
        Possible values are:
        - yes: checksum validation is forced
        - no: checksum validation is disabled
        - auto: Suricata uses a statistical approach to detect when
        checksum off-loading is used. (default)
        Warning: 'checksum-validation' must be set to yes to have checksum tested
      '';
    };

    "app-layer" = mkOption {
      type =
        with types;
        nullOr (submodule {
          options = {
            "error-policy" = mkOption {
              type = types.enum [
                "drop-flow"
                "pass-flow"
                "bypass"
                "drop-packet"
                "pass-packet"
                "reject"
                "ignore"
              ];
              default = "ignore";
              description = ''
                The error-policy setting applies to all app-layer parsers. Values can be
                "drop-flow", "pass-flow", "bypass", "drop-packet", "pass-packet", "reject" or
                "ignore" (the default).
              '';
            };
            protocols = mkOption {
              type =
                with types;
                nullOr (
                  attrsOf (submodule {
                    freeformType = yaml.type;
                    options = {
                      enabled = mkOption {
                        type = types.enum [
                          "yes"
                          "no"
                          "detection-only"
                        ];
                        default = "no";
                        description = ''
                          The option "enabled" takes 3 values - "yes", "no", "detection-only".
                          "yes" enables both detection and the parser, "no" disables both, and
                          "detection-only" enables protocol detection only (parser disabled).
                        '';
                      };
                    };
                  })
                );
              default = null;
            };
          };
        });
      default = null; # do not add to config unless specified
    };

    "run-as" = {
      user = mkOption {
        type = types.str;
        default = "suricata";
        description = "Run Suricata with a specific user-id";
      };
      group = mkOption {
        type = types.str;
        default = "suricata";
        description = "Run Suricata with a specific group-id";
      };
    };

    "host-mode" = mkOption {
      type = types.enum [
        "router"
        "sniffer-only"
        "auto"
      ];
      default = "auto";
      description = ''
        If the Suricata box is a router for the sniffed networks, set it to 'router'. If
        it is a pure sniffing setup, set it to 'sniffer-only'. If set to auto, the variable
        is internally switched to 'router' in IPS mode and 'sniffer-only' in IDS mode.
        This feature is currently only used by the reject* keywords.
      '';
    };

    "unix-command" = mkOption {
      type =
        with types;
        nullOr (submodule {
          options = {
            enabled = mkOption {
              type = types.either types.bool (types.enum [ "auto" ]);
              default = "auto";
            };
            filename = mkOption {
              type = types.path;
              default = "/run/suricata/suricata-command.socket";
            };
          };
        });
      default = { };
      description = ''
        Unix command socket that can be used to pass commands to Suricata.
        An external tool can then connect to get information from Suricata
        or trigger some modifications of the engine. Set enabled to yes
        to activate the feature. In auto mode, the feature will only be
        activated in live capture mode. You can use the filename variable to set
        the file name of the socket.
      '';
    };

    "exception-policy" = mkOption {
      type = types.enum [
        "auto"
        "drop-packet"
        "drop-flow"
        "reject"
        "bypass"
        "pass-packet"
        "pass-flow"
        "ignore"
      ];
      default = "auto";
      description = ''
        Define a common behavior for all exception policies.
        In IPS mode, the default is drop-flow. For cases when that's not possible, the
        engine will fall to drop-packet. To fallback to old behavior (setting each of
        them individually, or ignoring all), set this to ignore.
        All values available for exception policies can be used, and there is one
        extra option: auto - which means drop-flow or drop-packet (as explained above)
        in IPS mode, and ignore in IDS mode. Exception policy values are: drop-packet,
        drop-flow, reject, bypass, pass-packet, pass-flow, ignore (disable).
      '';
    };

    "default-rule-path" = mkOption {
      type = types.path;
      default = "/var/lib/suricata/rules";
      description = "Path in which suricata-update managed rules are stored by default";
    };

    "rule-files" = mkOption {
      type = types.listOf types.str;
      default = [ "suricata.rules" ];
      description = "Files to load suricata-update managed rules, relative to 'default-rule-path'";
    };

    "classification-file" = mkOption {
      type = types.str;
      default = "/var/lib/suricata/rules/classification.config";
      description = "Suricata classification configuration file";
    };

    "reference-config-file" = mkOption {
      type = types.str;
      default = "${cfg.package}/etc/suricata/reference.config";
      description = "Suricata reference configuration file";
    };

    "threshold-file" = mkOption {
      type = types.str;
      default = "${cfg.package}/etc/suricata/threshold.config";
      description = "Suricata threshold configuration file";
    };

    includes = mkOption {
      type = with types; nullOr (listOf path);
      default = null;
      description = ''
        Files to include in the suricata configuration. See
        [docs/configuration/suricata-yaml](https://docs.suricata.io/en/suricata-7.0.3/configuration/suricata-yaml.html)
        for available options.
      '';
    };
  };
}

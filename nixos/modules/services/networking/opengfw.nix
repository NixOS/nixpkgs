{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    lib.mkOption
    types
    mkIf
    lib.optionalString
    ;
  cfg = config.services.opengfw;
in
{
  options.services.opengfw = {
    enable = lib.mkEnableOption ''
      OpenGFW, A flexible, easy-to-use, open source implementation of GFW on Linux
    '';

    package = lib.mkPackageOption pkgs "opengfw" { default = "opengfw"; };

    user = lib.mkOption {
      default = "opengfw";
      type = lib.types.singleLineStr;
      description = "Username of the OpenGFW user.";
    };

    dir = lib.mkOption {
      default = "/var/lib/opengfw";
      type = lib.types.singleLineStr;
      description = ''
        Working directory of the OpenGFW service and home of `opengfw.user`.
      '';
    };

    logFile = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      example = "/var/lib/opengfw/opengfw.log";
      description = ''
        File to write the output to instead of systemd.
      '';
    };

    logFormat = lib.mkOption {
      description = ''
        Format of the logs. [logFormatMap](https://github.com/apernet/OpenGFW/blob/d7737e92117a11c9a6100d53019fac3b9d724fe3/cmd/root.go#L62)
      '';
      default = "json";
      example = "console";
      type = lib.types.enum [
        "json"
        "console"
      ];
    };

    pcapReplay = lib.mkOption {
      default = null;
      example = "./opengfw.pcap";
      type = lib.types.nullOr lib.types.path;
      description = ''
        Path to PCAP replay file.
        In pcap mode, none of the actions in the rules have any effect.
        This mode is mainly for debugging.
      '';
    };

    logLevel = lib.mkOption {
      description = ''
        Level of the logs. [logLevelMap](https://github.com/apernet/OpenGFW/blob/d7737e92117a11c9a6100d53019fac3b9d724fe3/cmd/root.go#L55)
      '';
      default = "info";
      example = "warn";
      type = lib.types.enum [
        "debug"
        "info"
        "warn"
        "error"
      ];
    };

    rulesFile = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = ''
        Path to file containing OpenGFW rules.
      '';
    };

    settingsFile = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = ''
        Path to file containing OpenGFW settings.
      '';
    };

    settings = lib.mkOption {
      default = null;
      description = ''
        Settings passed to OpenGFW. [Example config](https://gfw.dev/docs/build-run/#config-example)
      '';
      type = lib.types.nullOr (
        types.submodule {
          options = {
            replay = lib.mkOption {
              description = ''
                PCAP replay settings.
              '';
              default = { };
              type = lib.types.submodule {
                options = {
                  realtime = lib.mkOption {
                    description = ''
                      Whether the packets in the PCAP file should be replayed in "real time" (instead of as fast as possible).
                    '';
                    default = false;
                    example = true;
                    type = lib.types.bool;
                  };
                };
              };
            };

            io = lib.mkOption {
              description = ''
                IO settings.
              '';
              default = { };
              type = lib.types.submodule {
                options = {
                  queueSize = lib.mkOption {
                    description = "IO queue size.";
                    type = lib.types.int;
                    default = 1024;
                    example = 2048;
                  };
                  local = lib.mkOption {
                    description = ''
                      Set to false if you want to run OpenGFW on FORWARD chain. (e.g. on a router)
                    '';
                    type = lib.types.bool;
                    default = true;
                    example = false;
                  };
                  rst = lib.mkOption {
                    description = ''
                      Set to true if you want to send RST for blocked TCP connections, needs `local = false`.
                    '';
                    type = lib.types.bool;
                    default = !cfg.settings.io.local;
                    defaultText = "`!config.services.opengfw.settings.io.local`";
                    example = false;
                  };
                  rcvBuf = lib.mkOption {
                    description = "Netlink receive buffer size.";
                    type = lib.types.int;
                    default = 4194304;
                    example = 2097152;
                  };
                  sndBuf = lib.mkOption {
                    description = "Netlink send buffer size.";
                    type = lib.types.int;
                    default = 4194304;
                    example = 2097152;
                  };
                };
              };
            };
            ruleset = lib.mkOption {
              description = ''
                The path to load specific local geoip/geosite db files.
                If not set, they will be automatically downloaded from (Loyalsoldier/v2ray-rules-dat)[https://github.com/Loyalsoldier/v2ray-rules-dat].
              '';
              default = { };
              type = lib.types.submodule {
                options = {
                  geoip = lib.mkOption {
                    description = "Path to `geoip.dat`.";
                    default = null;
                    type = lib.types.nullOr lib.types.path;
                  };
                  geosite = lib.mkOption {
                    description = "Path to `geosite.dat`.";
                    default = null;
                    type = lib.types.nullOr lib.types.path;
                  };
                };
              };
            };
            workers = lib.mkOption {
              default = { };
              description = "Worker settings.";
              type = lib.types.submodule {
                options = {
                  count = lib.mkOption {
                    type = lib.types.int;
                    description = ''
                      Number of workers.
                      Recommended to be no more than the number of CPU cores
                    '';
                    default = 4;
                    example = 8;
                  };
                  queueSize = lib.mkOption {
                    type = lib.types.int;
                    description = "Worker queue size.";
                    default = 16;
                    example = 32;
                  };
                  tcpMaxBufferedPagesTotal = lib.mkOption {
                    type = lib.types.int;
                    description = ''
                      TCP max total buffered pages.
                    '';
                    default = 4096;
                    example = 8192;
                  };
                  tcpMaxBufferedPagesPerConn = lib.mkOption {
                    type = lib.types.int;
                    description = ''
                      TCP max total bufferd pages per connection.
                    '';
                    default = 64;
                    example = 128;
                  };
                  tcpTimeout = lib.mkOption {
                    type = lib.types.str;
                    description = ''
                      How long a connection is considered dead when no data is being transferred.
                      Dead connections are purged from TCP reassembly pools once per minute.
                    '';
                    default = "10m";
                    example = "5m";
                  };
                  udpMaxStreams = lib.mkOption {
                    type = lib.types.int;
                    description = "UDP max streams.";
                    default = 4096;
                    example = 8192;
                  };
                };
              };
            };
          };
        }
      );
    };

    rules = lib.mkOption {
      default = [ ];
      description = ''
        Rules passed to OpenGFW. [Example rules](https://gfw.dev/docs/rules)
      '';
      type = lib.types.listOf (
        types.submodule {
          options = {
            name = lib.mkOption {
              description = "Name of the rule.";
              example = "block google dns";
              type = lib.types.singleLineStr;
            };

            action = lib.mkOption {
              description = ''
                Action of the rule. [Supported actions](https://gfw.dev/docs/rules#supported-actions)
              '';
              default = "allow";
              example = "block";
              type = lib.types.enum [
                "allow"
                "block"
                "drop"
                "modify"
              ];
            };

            log = lib.mkOption {
              description = "Whether to enable logging for the rule.";
              default = true;
              example = false;
              type = lib.types.bool;
            };

            expr = lib.mkOption {
              description = ''
                [Expr Language](https://expr-lang.org/docs/language-definition) expression using [analyzers](https://gfw.dev/docs/analyzers) and [functions](https://gfw.dev/docs/functions).
              '';
              type = lib.types.str;
              example = ''dns != nil && dns.qr && any(dns.questions, {.name endsWith "google.com"})'';
            };

            modifier = lib.mkOption {
              default = null;
              description = ''
                Modification of specified packets when using the `modify` action. [Available modifiers](https://github.com/apernet/OpenGFW/tree/master/modifier)
              '';
              type = lib.types.nullOr (
                types.submodule {
                  options = {
                    name = lib.mkOption {
                      description = "Name of the modifier.";
                      type = lib.types.singleLineStr;
                      example = "dns";
                    };

                    args = lib.mkOption {
                      description = "Arguments passed to the modifier.";
                      type = lib.types.attrs;
                      example = {
                        a = "0.0.0.0";
                        aaaa = "::";
                      };
                    };
                  };
                }
              );
            };
          };
        }
      );

      example = [
        {
          name = "block v2ex http";
          action = "block";
          expr = ''string(http?.req?.headers?.host) endsWith "v2ex.com"'';
        }
        {
          name = "block google socks";
          action = "block";
          expr = ''string(socks?.req?.addr) endsWith "google.com" && socks?.req?.port == 80'';
        }
        {
          name = "v2ex dns poisoning";
          action = "modify";
          modifier = {
            name = "dns";
            args = {
              a = "0.0.0.0";
              aaaa = "::";
            };
          };
          expr = ''dns != nil && dns.qr && any(dns.questions, {.name endsWith "v2ex.com"})'';
        }
      ];
    };
  };

  config =
    let
      format = pkgs.formats.yaml { };

      settings =
        if cfg.settings != null then
          format.generate "opengfw-config.yaml" cfg.settings
        else
          cfg.settingsFile;
      rules = if cfg.rules != [ ] then format.generate "opengfw-rules.yaml" cfg.rules else cfg.rulesFile;
    in
    lib.mkIf cfg.enable {
      security.wrappers.OpenGFW = {
        owner = cfg.user;
        group = cfg.user;
        capabilities = "cap_net_admin+ep";
        source = "${cfg.package}/bin/OpenGFW";
      };

      systemd.services.opengfw = {
        description = "OpenGFW";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        path = with pkgs; [ iptables ];

        preStart = ''
          ${lib.optionalString (rules != null) "ln -sf ${rules} rules.yaml"}
          ${lib.optionalString (settings != null) "ln -sf ${settings} config.yaml"}
        '';

        script = ''
          ${config.security.wrapperDir}/OpenGFW \
            -f ${cfg.logFormat} \
            -l ${cfg.logLevel} \
            ${lib.optionalString (cfg.pcapReplay != null) "-p ${cfg.pcapReplay}"} \
            -c config.yaml \
            rules.yaml
        '';

        serviceConfig = rec {
          WorkingDirectory = cfg.dir;
          ExecReload = "kill -HUP $MAINPID";
          Restart = "always";
          User = cfg.user;
          StandardOutput = lib.mkIf (cfg.logFile != null) "append:${cfg.logFile}";
          StandardError = StandardOutput;
        };
      };

      users = {
        groups.${cfg.user} = { };
        users.${cfg.user} = {
          description = "opengfw user";
          isSystemUser = true;
          group = cfg.user;
          home = cfg.dir;
          createHome = true;
          homeMode = "750";
        };
      };
    };
  meta.maintainers = with lib.maintainers; [ eum3l ];
}

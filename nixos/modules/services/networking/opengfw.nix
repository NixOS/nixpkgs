{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    optionalString
    ;
  cfg = config.services.opengfw;
in
{
  options.services.opengfw = {
    enable = lib.mkEnableOption ''
      OpenGFW, A flexible, easy-to-use, open source implementation of GFW on Linux
    '';

    package = lib.mkPackageOption pkgs "opengfw" { default = "opengfw"; };

    user = mkOption {
      default = "opengfw";
      type = types.singleLineStr;
      description = "Username of the OpenGFW user.";
    };

    dir = mkOption {
      default = "/var/lib/opengfw";
      type = types.singleLineStr;
      description = ''
        Working directory of the OpenGFW service and home of `opengfw.user`.
      '';
    };

    logFile = mkOption {
      default = null;
      type = types.nullOr types.path;
      example = "/var/lib/opengfw/opengfw.log";
      description = ''
        File to write the output to instead of systemd.
      '';
    };

    logFormat = mkOption {
      description = ''
        Format of the logs. [logFormatMap](https://github.com/apernet/OpenGFW/blob/d7737e92117a11c9a6100d53019fac3b9d724fe3/cmd/root.go#L62)
      '';
      default = "json";
      example = "console";
      type = types.enum [
        "json"
        "console"
      ];
    };

    pcapReplay = mkOption {
      default = null;
      example = "./opengfw.pcap";
      type = types.nullOr types.path;
      description = ''
        Path to PCAP replay file.
        In pcap mode, none of the actions in the rules have any effect.
        This mode is mainly for debugging.
      '';
    };

    logLevel = mkOption {
      description = ''
        Level of the logs. [logLevelMap](https://github.com/apernet/OpenGFW/blob/d7737e92117a11c9a6100d53019fac3b9d724fe3/cmd/root.go#L55)
      '';
      default = "info";
      example = "warn";
      type = types.enum [
        "debug"
        "info"
        "warn"
        "error"
      ];
    };

    rulesFile = mkOption {
      default = null;
      type = types.nullOr types.path;
      description = ''
        Path to file containing OpenGFW rules.
      '';
    };

    settingsFile = mkOption {
      default = null;
      type = types.nullOr types.path;
      description = ''
        Path to file containing OpenGFW settings.
      '';
    };

    settings = mkOption {
      default = null;
      description = ''
        Settings passed to OpenGFW. [Example config](https://gfw.dev/docs/build-run/#config-example)
      '';
      type = types.nullOr (
        types.submodule {
          options = {
            replay = mkOption {
              description = ''
                PCAP replay settings.
              '';
              default = { };
              type = types.submodule {
                options = {
                  realtime = mkOption {
                    description = ''
                      Whether the packets in the PCAP file should be replayed in "real time" (instead of as fast as possible).
                    '';
                    default = false;
                    example = true;
                    type = types.bool;
                  };
                };
              };
            };

            io = mkOption {
              description = ''
                IO settings.
              '';
              default = { };
              type = types.submodule {
                options = {
                  queueSize = mkOption {
                    description = "IO queue size.";
                    type = types.int;
                    default = 1024;
                    example = 2048;
                  };
                  local = mkOption {
                    description = ''
                      Set to false if you want to run OpenGFW on FORWARD chain. (e.g. on a router)
                    '';
                    type = types.bool;
                    default = true;
                    example = false;
                  };
                  rst = mkOption {
                    description = ''
                      Set to true if you want to send RST for blocked TCP connections, needs `local = false`.
                    '';
                    type = types.bool;
                    default = !cfg.settings.io.local;
                    defaultText = "`!config.services.opengfw.settings.io.local`";
                    example = false;
                  };
                  rcvBuf = mkOption {
                    description = "Netlink receive buffer size.";
                    type = types.int;
                    default = 4194304;
                    example = 2097152;
                  };
                  sndBuf = mkOption {
                    description = "Netlink send buffer size.";
                    type = types.int;
                    default = 4194304;
                    example = 2097152;
                  };
                };
              };
            };
            ruleset = mkOption {
              description = ''
                The path to load specific local geoip/geosite db files.
                If not set, they will be automatically downloaded from [Loyalsoldier/v2ray-rules-dat](https://github.com/Loyalsoldier/v2ray-rules-dat).
              '';
              default = { };
              type = types.submodule {
                options = {
                  geoip = mkOption {
                    description = "Path to `geoip.dat`.";
                    default = null;
                    type = types.nullOr types.path;
                  };
                  geosite = mkOption {
                    description = "Path to `geosite.dat`.";
                    default = null;
                    type = types.nullOr types.path;
                  };
                };
              };
            };
            workers = mkOption {
              default = { };
              description = "Worker settings.";
              type = types.submodule {
                options = {
                  count = mkOption {
                    type = types.int;
                    description = ''
                      Number of workers.
                      Recommended to be no more than the number of CPU cores
                    '';
                    default = 4;
                    example = 8;
                  };
                  queueSize = mkOption {
                    type = types.int;
                    description = "Worker queue size.";
                    default = 16;
                    example = 32;
                  };
                  tcpMaxBufferedPagesTotal = mkOption {
                    type = types.int;
                    description = ''
                      TCP max total buffered pages.
                    '';
                    default = 4096;
                    example = 8192;
                  };
                  tcpMaxBufferedPagesPerConn = mkOption {
                    type = types.int;
                    description = ''
                      TCP max total bufferd pages per connection.
                    '';
                    default = 64;
                    example = 128;
                  };
                  tcpTimeout = mkOption {
                    type = types.str;
                    description = ''
                      How long a connection is considered dead when no data is being transferred.
                      Dead connections are purged from TCP reassembly pools once per minute.
                    '';
                    default = "10m";
                    example = "5m";
                  };
                  udpMaxStreams = mkOption {
                    type = types.int;
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

    rules = mkOption {
      default = [ ];
      description = ''
        Rules passed to OpenGFW. [Example rules](https://gfw.dev/docs/rules)
      '';
      type = types.listOf (
        types.submodule {
          options = {
            name = mkOption {
              description = "Name of the rule.";
              example = "block google dns";
              type = types.singleLineStr;
            };

            action = mkOption {
              description = ''
                Action of the rule. [Supported actions](https://gfw.dev/docs/rules#supported-actions)
              '';
              default = "allow";
              example = "block";
              type = types.enum [
                "allow"
                "block"
                "drop"
                "modify"
              ];
            };

            log = mkOption {
              description = "Whether to enable logging for the rule.";
              default = true;
              example = false;
              type = types.bool;
            };

            expr = mkOption {
              description = ''
                [Expr Language](https://expr-lang.org/docs/language-definition) expression using [analyzers](https://gfw.dev/docs/analyzers) and [functions](https://gfw.dev/docs/functions).
              '';
              type = types.str;
              example = ''dns != nil && dns.qr && any(dns.questions, {.name endsWith "google.com"})'';
            };

            modifier = mkOption {
              default = null;
              description = ''
                Modification of specified packets when using the `modify` action. [Available modifiers](https://github.com/apernet/OpenGFW/tree/master/modifier)
              '';
              type = types.nullOr (
                types.submodule {
                  options = {
                    name = mkOption {
                      description = "Name of the modifier.";
                      type = types.singleLineStr;
                      example = "dns";
                    };

                    args = mkOption {
                      description = "Arguments passed to the modifier.";
                      type = types.attrs;
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
    mkIf cfg.enable {
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
          ${optionalString (rules != null) "ln -sf ${rules} rules.yaml"}
          ${optionalString (settings != null) "ln -sf ${settings} config.yaml"}
        '';

        script = ''
          ${config.security.wrapperDir}/OpenGFW \
            -f ${cfg.logFormat} \
            -l ${cfg.logLevel} \
            ${optionalString (cfg.pcapReplay != null) "-p ${cfg.pcapReplay}"} \
            -c config.yaml \
            rules.yaml
        '';

        serviceConfig = rec {
          WorkingDirectory = cfg.dir;
          ExecReload = "${lib.getExe' pkgs.coreutils "kill"} -HUP $MAINPID";
          Restart = "always";
          User = cfg.user;
          StandardOutput = mkIf (cfg.logFile != null) "append:${cfg.logFile}";
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

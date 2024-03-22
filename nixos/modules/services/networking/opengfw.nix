{ lib
, pkgs
, config
, ...
}:
let
  inherit (lib) mkOption types mkIf mdDoc optionalString;
  cfg = config.services.opengfw;
  format = pkgs.formats.yaml { };

  settings =
    if cfg.settings != null
    then format.generate "opengfw-config.yaml" cfg.settings
    else cfg.settingsFile;
  rules =
    if cfg.rules != [ ]
    then format.generate "opengfw-rules.yaml" cfg.rules
    else cfg.rulesFile;
in
{
  options.services.opengfw = {
    enable = lib.mkEnableOption (mdDoc "A flexible, easy-to-use, open source implementation of GFW on Linux.");

    package = lib.mkPackageOption pkgs "opengfw" {
      default = "opengfw";
    };

    user = mkOption {
      default = "opengfw";
      type = types.singleLineStr;
      description = mdDoc ''
        Username of OpenGFW user.
      '';
    };

    dir = mkOption {
      default = "/var/lib/opengfw";
      type = types.singleLineStr;
      description = mdDoc ''
        Working directory of service and home of opengfw.user.
      '';
    };

    logDir = mkOption {
      default = null;
      type = types.nullOr types.singleLineStr;
      example = "/home/user/opengfw.log";
      description = mdDoc ''
        File to write the output to instead of systemd.
      '';
    };

    rulesFile = mkOption {
      default = null;
      type = types.nullOr types.path;
      description = mdDoc ''
        File instead of declaring opengfw.rules.
      '';
    };

    settingsFile = mkOption {
      default = null;
      type = types.nullOr types.path;
      description = mdDoc ''
        File instead of declaring opengfw.settings.
      '';
    };

    settings = mkOption {
      default = null;
      description = mdDoc ''
        Settings passed to OpenGFW. [Example config](https://github.com/apernet/OpenGFW#example-config)
      '';
      type = types.nullOr (types.submodule {
        options = {
          io = mkOption {
            description = mdDoc ''
              IO settings.
            '';
            default = { };
            type = types.submodule {
              options = {
                queueSize = mkOption {
                  description = mdDoc ''
                    IO queue size.
                  '';
                  type = types.int;
                  default = 1024;
                  example = 2048;
                };
                local = mkOption {
                  description = mdDoc ''
                    Set to false if you want to run OpenGFW on FORWARD chain.
                  '';
                  type = types.bool;
                  default = true;
                  example = false;
                };
                rst = mkOption {
                  description = mdDoc ''
                    Set to true if you want to send RST for blocked TCP connections, needs `local = false`.
                  '';
                  type = types.bool;
                  default = !cfg.settings.io.local;
                  defaultText = lib.literalExpression "!cfg.settings.io.local";
                  example = false;
                };
                rcvBuf = mkOption {
                  description = mdDoc ''
                    Netlink recieve buffer size.
                  '';
                  type = types.int;
                  default = 4194304;
                  example = 2097152;
                };
                sndBuf = mkOption {
                  description = mdDoc ''
                    Netlink send buffer size.
                  '';
                  type = types.int;
                  default = 4194304;
                  example = 2097152;
                };
              };
            };
          };
          geo = mkOption {
            description = mdDoc ''
              The path to load specific local geoip/geosite db files.
              If not set, they will be automatically downloaded from (Loyalsoldier/v2ray-rules-dat)[https://github.com/Loyalsoldier/v2ray-rules-dat].
            '';
            default = { };
            type = types.submodule {
              options = {
                geoip = mkOption {
                  description = mdDoc ''
                    IO queue size.
                  '';
                  default = null;
                  type = types.nullOr types.path;
                };
                geosite = mkOption {
                  description = mdDoc ''
                    Set to false if you want to run OpenGFW on FORWARD chain.
                  '';
                  default = null;
                  type = types.nullOr types.path;
                };
              };
            };
          };
          workers = mkOption {
            default = { };
            description = ''
              Worker settings.
            '';
            type = types.submodule {
              options = {
                count = mkOption {
                  type = types.int;
                  description = mdDoc ''
                    Number of workers.
                  '';
                  default = 4;
                  example = 8;
                };
                queueSize = mkOption {
                  type = types.int;
                  description = mdDoc ''
                    Worker queue size.
                  '';
                  default = 16;
                  example = 32;
                };
                tcpMaxBufferedPagesTotal = mkOption {
                  type = types.int;
                  description = mdDoc ''
                    TCP max total buffered pages.
                  '';
                  default = 4096;
                  example = 8192;
                };
                tcpMaxBufferedPagesPerConn = mkOption {
                  type = types.int;
                  description = mdDoc ''
                    TCP max total bufferd pages per connection.
                  '';
                  default = 64;
                  example = 128;
                };
                udpMaxStreams = mkOption {
                  type = types.int;
                  description = mdDoc ''
                    UDP max streams.
                  '';
                  default = 4096;
                  example = 8192;
                };
              };
            };
          };
        };
      });
    };

    rules = mkOption {
      default = [ ];
      description = mdDoc ''
        Rules passed to OpenGFW. [Example rules](https://github.com/apernet/OpenGFW?tab=readme-ov-file#example-rules)
      '';
      type = types.listOf (
        types.submodule {
          options = {
            name = mkOption {
              description = mdDoc "Name of the rule.";
              example = "block google dns";
              type = types.singleLineStr;
            };

            action = mkOption {
              description = mdDoc ''
                Action of the rule. [Supported actions](https://github.com/apernet/OpenGFW?tab=readme-ov-file#supported-actions)
              '';
              default = "allow";
              example = "block";
              type = types.enum [ "allow" "block" "drop" "modify" ];
            };

            log = mkOption {
              description = mdDoc "Wether to enable logging for the rule.";
              default = true;
              example = false;
              type = types.bool;
            };

            expr = mkOption {
              description = mdDoc ''
                [Expr Language](https://expr-lang.org/docs/language-definition) expression using [OpenGFW analyzers](https://github.com/apernet/OpenGFW/blob/master/docs/Analyzers.md).
              '';
              type = types.str;
              example = ''dns != nil && dns.qr && any(dns.questions, {.name endsWith "google.com"})'';
            };

            modifier = mkOption {
              default = null;
              description = mdDoc ''
                Modification of specified packets when using the `modify` action. [Available modifiers](https://github.com/apernet/OpenGFW/tree/master/modifier)
              '';
              type = types.nullOr (
                types.submodule {
                  options = {
                    name = mkOption {
                      description = mdDoc "Name of the modifier.";
                      type = types.singleLineStr;
                      example = "dns";
                    };

                    args = mkOption {
                      description = mdDoc "Arguments passed to the modifier.";
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

  config = mkIf cfg.enable {
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

      serviceConfig = rec {
        WorkingDirectory = cfg.dir;
        ExecStart = "${config.security.wrapperDir}/OpenGFW -c config.yaml rules.yaml";
        ExecReload = "kill -HUP $MAINPID";
        Restart = "always";
        User = cfg.user;
        StandardOutput = mkIf (cfg.logDir != null) "append:${cfg.logDir}";
        StandardError = StandardOutput;
      };
    };

    users = {
      groups.${cfg.user} = { };
      users.${cfg.user} = {
        description = "opengfw user";
        isNormalUser = true;
        group = cfg.user;
        home = cfg.dir;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ eum3l ];
}

{ config, lib, pkgs, ... }:
with lib;
let
  pkg = pkgs._3proxy;
  cfg = config.services._3proxy;
  optionalList = list: if list == [ ] then "*" else concatMapStringsSep "," toString list;
in {
  options.services._3proxy = {
    enable = mkEnableOption "3proxy";
    confFile = mkOption {
      type = types.path;
      example = "/var/lib/3proxy/3proxy.conf";
      description = ''
        Ignore all other 3proxy options and load configuration from this file.
      '';
    };
    usersFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/var/lib/3proxy/3proxy.passwd";
      description = ''
        Load users and passwords from this file.

        Example users file with plain-text passwords:

        ```
          test1:CL:password1
          test2:CL:password2
        ```

        Example users file with md5-crypted passwords:

        ```
          test1:CR:$1$tFkisVd2$1GA8JXkRmTXdLDytM/i3a1
          test2:CR:$1$rkpibm5J$Aq1.9VtYAn0JrqZ8M.1ME.
        ```

        You can generate md5-crypted passwords via https://unix4lyfe.org/crypt/
        Note that htpasswd tool generates incompatible md5-crypted passwords.
        Consult [documentation](https://github.com/z3APA3A/3proxy/wiki/How-To-%28incomplete%29#USERS) for more information.
      '';
    };
    services = mkOption {
      type = types.listOf (types.submodule {
        options = {
          type = mkOption {
            type = types.enum [
              "proxy"
              "socks"
              "pop3p"
              "ftppr"
              "admin"
              "dnspr"
              "tcppm"
              "udppm"
            ];
            example = "proxy";
            description = ''
              Service type. The following values are valid:

              - `"proxy"`: HTTP/HTTPS proxy (default port 3128).
              - `"socks"`: SOCKS 4/4.5/5 proxy (default port 1080).
              - `"pop3p"`: POP3 proxy (default port 110).
              - `"ftppr"`: FTP proxy (default port 21).
              - `"admin"`: Web interface (default port 80).
              - `"dnspr"`: Caching DNS proxy (default port 53).
              - `"tcppm"`: TCP portmapper.
              - `"udppm"`: UDP portmapper.
            '';
          };
          bindAddress = mkOption {
            type = types.str;
            default = "[::]";
            example = "127.0.0.1";
            description = ''
              Address used for service.
            '';
          };
          bindPort = mkOption {
            type = types.nullOr types.int;
            default = null;
            example = 3128;
            description = ''
              Override default port used for service.
            '';
          };
          maxConnections = mkOption {
            type = types.int;
            default = 100;
            example = 1000;
            description = ''
              Maximum number of simulationeous connections to this service.
            '';
          };
          auth = mkOption {
            type = types.listOf (types.enum [ "none" "iponly" "strong" ]);
            example = [ "iponly" "strong" ];
            description = ''
              Authentication type. The following values are valid:

              - `"none"`: disables both authentication and authorization. You can not use ACLs.
              - `"iponly"`: specifies no authentication. ACLs authorization is used.
              - `"strong"`: authentication by username/password. If user is not registered their access is denied regardless of ACLs.

              Double authentication is possible, e.g.

              ```
                {
                  auth = [ "iponly" "strong" ];
                  acl = [
                    {
                      rule = "allow";
                      targets = [ "192.168.0.0/16" ];
                    }
                    {
                      rule = "allow"
                      users = [ "user1" "user2" ];
                    }
                  ];
                }
              ```
              In this example strong username authentication is not required to access 192.168.0.0/16.
            '';
          };
          acl = mkOption {
            type = types.listOf (types.submodule {
              options = {
                rule = mkOption {
                  type = types.enum [ "allow" "deny" ];
                  example = "allow";
                  description = ''
                    ACL rule. The following values are valid:

                    - `"allow"`: connections allowed.
                    - `"deny"`: connections not allowed.
                  '';
                };
                users = mkOption {
                  type = types.listOf types.str;
                  default = [ ];
                  example = [ "user1" "user2" "user3" ];
                  description = ''
                    List of users, use empty list for any.
                  '';
                };
                sources = mkOption {
                  type = types.listOf types.str;
                  default = [ ];
                  example = [ "127.0.0.1" "192.168.1.0/24" ];
                  description = ''
                    List of source IP range, use empty list for any.
                  '';
                };
                targets = mkOption {
                  type = types.listOf types.str;
                  default = [ ];
                  example = [ "127.0.0.1" "192.168.1.0/24" ];
                  description = ''
                    List of target IP ranges, use empty list for any.
                    May also contain host names instead of addresses.
                    It's possible to use wildmask in the beginning and in the the end of hostname, e.g. `*badsite.com` or `*badcontent*`.
                    Hostname is only checked if hostname presents in request.
                  '';
                };
                targetPorts = mkOption {
                  type = types.listOf types.int;
                  default = [ ];
                  example = [ 80 443 ];
                  description = ''
                    List of target ports, use empty list for any.
                  '';
                };
              };
            });
            default = [ ];
            example = literalExpression ''
              [
                {
                  rule = "allow";
                  users = [ "user1" ];
                }
                {
                  rule = "allow";
                  sources = [ "192.168.1.0/24" ];
                }
                {
                  rule = "deny";
                }
              ]
            '';
            description = ''
              Use this option to limit user access to resources.
            '';
          };
          extraArguments = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "-46";
            description = ''
              Extra arguments for service.
              Consult "Options" section in [documentation](https://github.com/z3APA3A/3proxy/wiki/3proxy.cfg) for available arguments.
            '';
          };
          extraConfig = mkOption {
            type = types.nullOr types.lines;
            default = null;
            description = ''
              Extra configuration for service. Use this to configure things like bandwidth limiter or ACL-based redirection.
              Consult [documentation](https://github.com/z3APA3A/3proxy/wiki/3proxy.cfg) for available options.
            '';
          };
        };
      });
      default = [ ];
      example = literalExpression ''
        [
          {
            type = "proxy";
            bindAddress = "192.168.1.24";
            bindPort = 3128;
            auth = [ "none" ];
          }
          {
            type = "proxy";
            bindAddress = "10.10.1.20";
            bindPort = 3128;
            auth = [ "iponly" ];
          }
          {
            type = "socks";
            bindAddress = "172.17.0.1";
            bindPort = 1080;
            auth = [ "strong" ];
          }
        ]
      '';
      description = ''
        Use this option to define 3proxy services.
      '';
    };
    denyPrivate = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to deny access to private IP ranges including loopback.
      '';
    };
    privateRanges = mkOption {
      type = types.listOf types.str;
      default = [
        "0.0.0.0/8"
        "127.0.0.0/8"
        "10.0.0.0/8"
        "100.64.0.0/10"
        "172.16.0.0/12"
        "192.168.0.0/16"
        "::"
        "::1"
        "fc00::/7"
      ];
      description = ''
        What IP ranges to deny access when denyPrivate is set tu true.
      '';
    };
    resolution = mkOption {
      type = types.submodule {
        options = {
          nserver = mkOption {
            type = types.listOf types.str;
            default = [ ];
            example = [ "127.0.0.53" "192.168.1.3:5353/tcp" ];
            description = ''
              List of nameservers to use.

              Up to 5 nservers may be specified. If no nserver is configured,
              default system name resolution functions are used.
            '';
          };
          nscache = mkOption {
            type = types.int;
            default = 65535;
            description = "Set name cache size for IPv4.";
          };
          nscache6 = mkOption {
            type = types.int;
            default = 65535;
            description = "Set name cache size for IPv6.";
          };
          nsrecord = mkOption {
            type = types.attrsOf types.str;
            default = { };
            example = literalExpression ''
              {
                "files.local" = "192.168.1.12";
                "site.local" = "192.168.1.43";
              }
            '';
            description = "Adds static nsrecords.";
          };
        };
      };
      default = { };
      description = ''
        Use this option to configure name resolution and DNS caching.
      '';
    };
    extraConfig = mkOption {
      type = types.nullOr types.lines;
      default = null;
      description = ''
        Extra configuration, appended to the 3proxy configuration file.
        Consult [documentation](https://github.com/z3APA3A/3proxy/wiki/3proxy.cfg) for available options.
      '';
    };
  };

  config = mkIf cfg.enable {
    services._3proxy.confFile = mkDefault (pkgs.writeText "3proxy.conf" ''
      # log to stdout
      log

      ${concatMapStringsSep "\n" (x: "nserver " + x) cfg.resolution.nserver}

      nscache ${toString cfg.resolution.nscache}
      nscache6 ${toString cfg.resolution.nscache6}

      ${concatMapStringsSep "\n" (x: "nsrecord " + x)
      (mapAttrsToList (name: value: "${name} ${value}")
        cfg.resolution.nsrecord)}

      ${optionalString (cfg.usersFile != null)
        ''users $"${cfg.usersFile}"''
      }

      ${concatMapStringsSep "\n" (service: ''
        auth ${concatStringsSep " " service.auth}

        ${optionalString (cfg.denyPrivate)
        "deny * * ${optionalList cfg.privateRanges}"}

        ${concatMapStringsSep "\n" (acl:
          "${acl.rule} ${
            concatMapStringsSep " " optionalList [
              acl.users
              acl.sources
              acl.targets
              acl.targetPorts
            ]
          }") service.acl}

        maxconn ${toString service.maxConnections}

        ${optionalString (service.extraConfig != null) service.extraConfig}

        ${service.type} -i${toString service.bindAddress} ${
          optionalString (service.bindPort != null)
          "-p${toString service.bindPort}"
        } ${
          optionalString (service.extraArguments != null) service.extraArguments
        }

        flush
      '') cfg.services}
      ${optionalString (cfg.extraConfig != null) cfg.extraConfig}
    '');
    systemd.services."3proxy" = {
      description = "Tiny free proxy server";
      documentation = [ "https://github.com/z3APA3A/3proxy/wiki" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "3proxy";
        ExecStart = "${pkg}/bin/3proxy ${cfg.confFile}";
        Restart = "on-failure";
      };
    };
  };

  meta.maintainers = with maintainers; [ misuzu ];
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.crab-hole;

  settingsFormat = pkgs.formats.toml { };
in
{
  options = {
    services.crab-hole = {
      enable = lib.mkEnableOption "Crab-hole Service";

      package = lib.mkPackageOption pkgs "crab-hole" { };

      supplementaryGroups = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "acme" ];
        description = "Adds additional groups to the crab-hole service. Can be useful to prevent permission issues.";
      };

      settings = lib.mkOption {
        description = "Crab-holes config. See big example https://github.com/LuckyTurtleDev/crab-hole/blob/main/example-config.toml";

        example = {
          downstream = [
            {
              listen = "localhost";
              port = 8080;
              protocol = "udp";
            }
            {
              certificate = "dns.example.com.crt";
              dns_hostname = "dns.example.com";
              key = "dns.example.com.key";
              listen = "[::]";
              port = 8055;
              protocol = "https";
              timeout_ms = 3000;
            }
          ];
          api = {
            admin_key = "1234";
            listen = "127.0.0.1";
            port = 8080;
            show_doc = true;
          };
          blocklist = {
            allow_list = [
              "file:///allowed.txt"
            ];
            include_subdomains = true;
            lists = [
              "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts"
              "https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt"
              "file:///blocked.txt"
            ];
          };
          upstream = {
            name_servers = [
              {
                protocol = "tls";
                socket_addr = "[2606:4700:4700::1111]:853";
                tls_dns_name = "1dot1dot1dot1.cloudflare-dns.com";
                trust_nx_responses = false;
              }
              {
                protocol = "tls";
                socket_addr = "1.1.1.1:853";
                tls_dns_name = "1dot1dot1dot1.cloudflare-dns.com";
                trust_nx_responses = false;
              }
            ];
            options = {
              validate = false;
            };
          };
        };

        type = lib.types.submodule {
          freeformType = settingsFormat.type;
          options = {
            blocklist = {
              include_subdomains = lib.mkEnableOption "Include Subdomains";
              lists = lib.mkOption {
                type = lib.types.listOf (lib.types.either lib.types.str lib.types.path);
                default = [ ];
                description = "List of blocklists. If files are added via url, make sure the service has access to them!";
                apply = x: (lib.lists.forEach x (v: if builtins.isPath v then ("file://${v}") else v));
              };
              allow_list = lib.mkOption {
                type = lib.types.listOf (lib.types.either lib.types.str lib.types.path);
                default = [ ];
                description = "List of allowlists. If files are added via url, make sure the service has access to them!";
                apply = x: (lib.lists.forEach x (v: if builtins.isPath v then ("file://${v}") else v));
              };
            };

            downstream = lib.mkOption {
              description = "Configuration for the downstream DNS Servers";
              type = lib.types.listOf (
                lib.types.submodule {
                  freeformType = settingsFormat.type;
                  options = {
                    protocol = lib.mkOption {
                      type = lib.types.enum [
                        "udp"
                        "tls"
                        "https"
                        "quic"
                      ];
                      example = "udp";
                      default = "udp";
                      description = "The protocol to listen on";
                    };
                    listen = lib.mkOption {
                      type = lib.types.str;
                      example = "[::]";
                      default = "localhost";
                      description = "The IP to listen on";
                    };
                    port = lib.mkOption {
                      type = lib.types.ints.u16;
                      example = 53;
                      default = 53;
                      description = "The port to listen on";
                    };
                  };
                }
              );
            };

            upstream = {
              options = lib.mkOption {
                default = { };
                description = "Set resolover options. For a full list see https://docs.rs/trust-dns-resolver/0.23.0/trust_dns_resolver/config/struct.ResolverOpts.html";
                type = lib.types.submodule {
                  freeformType = settingsFormat.type;
                };
              };
              name_servers = lib.mkOption {
                description = "Configuration for the NameServers";
                type = lib.types.listOf (
                  lib.types.submodule {
                    options = {
                      protocol = lib.mkOption {
                        type = lib.types.enum [
                          "udp"
                          "tls"
                          "https"
                          "quic"
                        ];
                        example = "tls";
                        default = "tls";
                        description = "The protocol to use when communicating with the NameServer";
                      };
                      socket_addr = lib.mkOption {
                        type = lib.types.str;
                        example = "1.1.1.1:853";
                        description = "Address of the upstream DNS server";
                      };
                      tls_dns_name = lib.mkOption {
                        type = lib.types.str;
                        example = "1dot1dot1dot1.cloudflare-dns.com";
                        description = "Domain name of the upstream DNS server";
                      };
                      trust_nx_responses = lib.mkEnableOption "Whether to trust `NXDOMAIN` responses from upstream nameservers";
                    };
                  }
                );
              };
            };
          };
        };
      };

      configFile = lib.mkOption {
        type = lib.types.path;
        description = "The config file of crab-hole. If files are added via url, make sure the service has access to them. Setting this option will override any configuration applied by the settings option.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Warning due to DNSSec issue in crab-hole
    warnings = lib.optional (cfg.settings.upstream.options.validate or false) ''
      Validate options will ONLY allow DNSSec domains. See https://github.com/LuckyTurtleDev/crab-hole/issues/29
    '';

    services.crab-hole.configFile = lib.mkDefault (
      settingsFormat.generate "crab-hole.toml" cfg.settings
    );
    environment.etc."crab-hole.toml".source = cfg.configFile;

    systemd.services.crab-hole = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      description = "Crab-hole dns server";
      environment.HOME = "/var/lib/crab-hole";
      restartTriggers = [ cfg.configFile ];
      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        SupplementaryGroups = lib.strings.concatStringsSep " " cfg.supplementaryGroups;

        StateDirectory = "crab-hole";
        WorkingDirectory = "/var/lib/crab-hole";

        ExecStart = lib.getExe cfg.package;

        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";

        Restart = "on-failure";
        RestartSec = 1;
      };
    };
  };

  meta.maintainers = [
    lib.maintainers.NiklasVousten
  ];
  # Readme from upstream
  meta.doc = ./crab-hole.md;
}

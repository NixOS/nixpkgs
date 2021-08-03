{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.services.kea;

  format = pkgs.formats.json {};

  ctrlAgentConfig = format.generate "kea-ctrl-agent.conf" {
    Control-agent = cfg.ctrl-agent.settings;
  };
  dhcp4Config = format.generate "kea-dhcp4.conf" {
    Dhcp4 = cfg.dhcp4.settings;
  };
  dhcp6Config = format.generate "kea-dhcp6.conf" {
    Dhcp6 = cfg.dhcp6.settings;
  };
  dhcpDdnsConfig = format.generate "kea-dhcp-ddns.conf" {
    DhcpDdns = cfg.dhcp-ddns.settings;
  };

  package = pkgs.kea;
in
{
  options.services.kea = with types; {
    ctrl-agent = mkOption {
      description = ''
        Kea Control Agent configuration
      '';
      default = {};
      type = submodule {
        options = {
          enable = mkEnableOption "Kea Control Agent";

          extraArgs = mkOption {
            type = listOf str;
            default = [];
            description = ''
              List of additonal arguments to pass to the daemon.
            '';
          };

          settings = mkOption {
            type = format.type;
            default = null;
            description = ''
              Kea Control Agent configuration as an attribute set, see <link xlink:href="https://kea.readthedocs.io/en/kea-${package.version}/arm/agent.html"/>.
            '';
          };
        };
      };
    };

    dhcp4 = mkOption {
      description = ''
        DHCP4 Server configuration
      '';
      default = {};
      type = submodule {
        options = {
          enable = mkEnableOption "Kea DHCP4 server";

          extraArgs = mkOption {
            type = listOf str;
            default = [];
            description = ''
              List of additonal arguments to pass to the daemon.
            '';
          };

          settings = mkOption {
            type = format.type;
            default = null;
            example = {
              valid-lifetime = 4000;
              renew-timer = 1000;
              rebind-timer = 2000;
              interfaces-config = {
                interfaces = [
                  "eth0"
                ];
              };
              lease-database = {
                type = "memfile";
                persist = true;
                name = "/var/lib/kea/dhcp4.leases";
              };
              subnet4 = [ {
                subnet = "192.0.2.0/24";
                pools = [ {
                  pool = "192.0.2.100 - 192.0.2.240";
                } ];
              } ];
            };
            description = ''
              Kea DHCP4 configuration as an attribute set, see <link xlink:href="https://kea.readthedocs.io/en/kea-${package.version}/arm/dhcp4-srv.html"/>.
            '';
          };
        };
      };
    };

    dhcp6 = mkOption {
      description = ''
        DHCP6 Server configuration
      '';
      default = {};
      type = submodule {
        options = {
          enable = mkEnableOption "Kea DHCP6 server";

          extraArgs = mkOption {
            type = listOf str;
            default = [];
            description = ''
              List of additonal arguments to pass to the daemon.
            '';
          };

          settings = mkOption {
            type = format.type;
            default = null;
            example = {
              valid-lifetime = 4000;
              renew-timer = 1000;
              rebind-timer = 2000;
              preferred-lifetime = 3000;
              interfaces-config = {
                interfaces = [
                  "eth0"
                ];
              };
              lease-database = {
                type = "memfile";
                persist = true;
                name = "/var/lib/kea/dhcp6.leases";
              };
              subnet6 = [ {
                subnet = "2001:db8:1::/64";
                pools = [ {
                  pool = "2001:db8:1::1-2001:db8:1::ffff";
                } ];
              } ];
            };
            description = ''
              Kea DHCP6 configuration as an attribute set, see <link xlink:href="https://kea.readthedocs.io/en/kea-${package.version}/arm/dhcp6-srv.html"/>.
            '';
          };
        };
      };
    };

    dhcp-ddns = mkOption {
      description = ''
        Kea DHCP-DDNS configuration
      '';
      default = {};
      type = submodule {
        options = {
          enable = mkEnableOption "Kea DDNS server";

          extraArgs = mkOption {
            type = listOf str;
            default = [];
            description = ''
              List of additonal arguments to pass to the daemon.
            '';
          };

          settings = mkOption {
            type = format.type;
            default = null;
            example = {
              ip-address = "127.0.0.1";
              port = 53001;
              dns-server-timeout = 100;
              ncr-protocol = "UDP";
              ncr-format = "JSON";
              tsig-keys = [ ];
              forward-ddns = {
                ddns-domains = [ ];
              };
              reverse-ddns = {
                ddns-domains = [ ];
              };
            };
            description = ''
              Kea DHCP-DDNS configuration as an attribute set, see <link xlink:href="https://kea.readthedocs.io/en/kea-${package.version}/arm/ddns.html"/>.
            '';
          };
        };
      };
    };
  };

  config = let
    commonServiceConfig = {
      ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      DynamicUser = true;
      User = "kea";
      ConfigurationDirectory = "kea";
      RuntimeDirectory = "kea";
      StateDirectory = "kea";
      UMask = "0077";
    };
  in mkIf (cfg.ctrl-agent.enable || cfg.dhcp4.enable || cfg.dhcp6.enable || cfg.dhcp-ddns.enable) (mkMerge [
  {
    environment.systemPackages = [ package ];
  }

  (mkIf cfg.ctrl-agent.enable {

    environment.etc."kea/ctrl-agent.conf".source = ctrlAgentConfig;

    systemd.services.kea-ctrl-agent = {
      description = "Kea Control Agent";
      documentation = [
        "man:kea-ctrl-agent(8)"
        "https://kea.readthedocs.io/en/kea-${package.version}/arm/agent.html"
      ];

      after = [
        "network-online.target"
        "time-sync.target"
      ];
      wantedBy = [
        "kea-dhcp4-server.service"
        "kea-dhcp6-server.service"
        "kea-dhcp-ddns-server.service"
      ];

      environment = {
        KEA_PIDFILE_DIR = "/run/kea";
      };

      restartTriggers = [
        ctrlAgentConfig
      ];

      serviceConfig = {
        ExecStart = "${package}/bin/kea-ctrl-agent -c /etc/kea/ctrl-agent.conf ${lib.escapeShellArgs cfg.dhcp4.extraArgs}";
        KillMode = "process";
        Restart = "on-failure";
      } // commonServiceConfig;
    };
  })

  (mkIf cfg.dhcp4.enable {

    environment.etc."kea/dhcp4-server.conf".source = dhcp4Config;

    systemd.services.kea-dhcp4-server = {
      description = "Kea DHCP4 Server";
      documentation = [
        "man:kea-dhcp4(8)"
        "https://kea.readthedocs.io/en/kea-${package.version}/arm/dhcp4-srv.html"
      ];

      after = [
        "network-online.target"
        "time-sync.target"
      ];
      wantedBy = [
        "multi-user.target"
      ];

      environment = {
        KEA_PIDFILE_DIR = "/run/kea";
      };

      restartTriggers = [
        dhcp4Config
      ];

      serviceConfig = {
        ExecStart = "${package}/bin/kea-dhcp4 -c /etc/kea/dhcp4-server.conf ${lib.escapeShellArgs cfg.dhcp4.extraArgs}";
        # Kea does not request capabilities by itself
        AmbientCapabilities = [
          "CAP_NET_BIND_SERVICE"
          "CAP_NET_RAW"
        ];
        CapabilityBoundingSet = [
          "CAP_NET_BIND_SERVICE"
          "CAP_NET_RAW"
        ];
      } // commonServiceConfig;
    };
  })

  (mkIf cfg.dhcp6.enable {

    environment.etc."kea/dhcp6-server.conf".source = dhcp6Config;

    systemd.services.kea-dhcp6-server = {
      description = "Kea DHCP6 Server";
      documentation = [
        "man:kea-dhcp6(8)"
        "https://kea.readthedocs.io/en/kea-${package.version}/arm/dhcp6-srv.html"
      ];

      after = [
        "network-online.target"
        "time-sync.target"
      ];
      wantedBy = [
        "multi-user.target"
      ];

      environment = {
        KEA_PIDFILE_DIR = "/run/kea";
      };

      restartTriggers = [
        dhcp6Config
      ];

      serviceConfig = {
        ExecStart = "${package}/bin/kea-dhcp6 -c /etc/kea/dhcp6-server.conf ${lib.escapeShellArgs cfg.dhcp6.extraArgs}";
        # Kea does not request capabilities by itself
        AmbientCapabilities = [
          "CAP_NET_BIND_SERVICE"
        ];
        CapabilityBoundingSet = [
          "CAP_NET_BIND_SERVICE"
        ];
      } // commonServiceConfig;
    };
  })

  (mkIf cfg.dhcp-ddns.enable {

    environment.etc."kea/dhcp-ddns.conf".source = dhcpDdnsConfig;

    systemd.services.kea-dhcp-ddns-server = {
      description = "Kea DHCP-DDNS Server";
      documentation = [
        "man:kea-dhcp-ddns(8)"
        "https://kea.readthedocs.io/en/kea-${package.version}/arm/ddns.html"
      ];

      after = [
        "network-online.target"
        "time-sync.target"
      ];
      wantedBy = [
        "multi-user.target"
      ];

      environment = {
        KEA_PIDFILE_DIR = "/run/kea";
      };

      restartTriggers = [
        dhcpDdnsConfig
      ];

      serviceConfig = {
        ExecStart = "${package}/bin/kea-dhcp-ddns -c /etc/kea/dhcp-ddns.conf ${lib.escapeShellArgs cfg.dhcp-ddns.extraArgs}";
        AmbientCapabilites = [
          "CAP_NET_BIND_SERVICE"
        ];
        CapabilityBoundingSet = [
          "CAP_NET_BIND_SERVICE"
        ];
      } // commonServiceConfig;
    };
  })

  ]);

  meta.maintainers = with maintainers; [ hexa ];
}

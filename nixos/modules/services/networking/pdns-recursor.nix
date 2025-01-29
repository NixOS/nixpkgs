{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.pdns-recursor;

  configFile = (settingsFormat.generate "recursor.yml" cfg.settings);

  settingsFormat = pkgs.formats.yaml { };
in
{
  options.services.pdns-recursor = {
    enable = mkEnableOption "PowerDNS Recursor, a recursive DNS server";

    settings = mkOption {
      type = types.submodule {
        options = {

          carbon = mkOption {
            type = types.submodule {
              freeformType = settingsFormat.type;
            };
          };

          dnssec = mkOption {
            type = types.submodule {
              freeformType = settingsFormat.type;
              options = {
                validation = mkOption {
                  type = types.enum [
                    "off"
                    "process-no-validate"
                    "process"
                    "log-fail"
                    "validate"
                  ];
                  default = "validate";
                  description = ''
                    Controls the level of DNSSEC processing done by the PowerDNS Recursor.
                    See https://doc.powerdns.com/md/recursor/dnssec/ for a detailed explanation.
                  '';
                };
              };
            };
          };

          ecs = mkOption {
            type = types.submodule {
              freeformType = settingsFormat.type;
            };
          };

          incoming = mkOption {
            type = types.submodule {
              freeformType = settingsFormat.type;
              options = {
                allow_from = mkOption {
                  type = types.listOf types.str;
                  default = [
                    "127.0.0.0/8"
                    "10.0.0.0/8"
                    "100.64.0.0/10"
                    "169.254.0.0/16"
                    "192.168.0.0/16"
                    "172.16.0.0/12"
                    "::1/128"
                    "fc00::/7"
                    "fe80::/10"
                  ];
                  example = [
                    "0.0.0.0/0"
                    "::/0"
                  ];
                  description = ''
                    IP address ranges of clients allowed to make DNS queries.
                  '';
                };

                listen = mkOption {
                  type = listOf types.str;
                  default = [
                    "::"
                    "0.0.0.0"
                  ];
                  description = ''
                    IP addresses Recursor DNS server will bind to.
                  '';
                };

                port = mkOption {
                  type = types.port;
                  default = 53;
                  description = ''
                    Port number Recursor DNS server will bind to.
                  '';
                };
              };
            };

            logging = mkOption {
              type = types.submodule {
                freeformType = settingsFormat.type;
              };
            };

            nod = mkOption {
              type = types.submodule {
                freeformType = settingsFormat.type;
              };
            };

            outgoing = mkOption {
              type = types.submodule {
                freeformType = settingsFormat.type;
              };
            };

            packetcache = mkOption {
              type = types.submodule {
                freeformType = settingsFormat.type;
              };
            };

            recordcache = mkOption {
              type = types.submodule {
                freeformType = settingsFormat.type;
              };
            };

            recursor = mkOption {
              type = types.submodule {
                freeformType = settingsFormat.type;
                options = {
                  export_etc_hosts = mkOption {
                    type = types.bool;
                    default = false;
                    description = ''
                      Whether to export names and IP addresses defined in /etc/hosts.
                    '';
                  };

                  forward_zones = mkOption {
                    type = types.attrs;
                    default = { };
                    description = ''
                      DNS zones to be forwarded to other authoritative servers.
                    '';
                  };

                  forward_zones_recurse = mkOption {
                    type = types.attrs;
                    example = {
                      eth = "[::1]:5353";
                    };
                    default = { };
                    description = ''
                      DNS zones to be forwarded to other recursive servers.
                    '';
                  };

                  serve_rfc1918 = mkOption {
                    type = types.bool;
                    default = true;
                    description = ''
                      Whether to directly resolve the RFC1918 reverse-mapping domains:
                      `10.in-addr.arpa`,
                      `168.192.in-addr.arpa`,
                      `16-31.172.in-addr.arpa`
                      This saves load on the AS112 servers.
                    '';
                  };
                };
              };
            };

            snmp = mkOption {
              type = types.submodule {
                freeformType = settingsFormat.type;
              };
            };

            webservice = mkOption {
              type = types.submodule {
                freeformType = settingsFormat.type;
                options = {
                  address = mkOption {
                    type = types.str;
                    default = "0.0.0.0";
                    description = ''
                      IP address Recursor REST API server will bind to.
                    '';
                  };

                  port = mkOption {
                    type = types.port;
                    default = 8082;
                    description = ''
                      Port number Recursor REST API server will bind to.
                    '';
                  };

                  allow_from = mkOption {
                    type = types.listOf types.str;
                    default = [
                      "127.0.0.1"
                      "::1"
                    ];
                    example = [
                      "0.0.0.0/0"
                      "::/0"
                    ];
                    description = ''
                      IP address ranges of clients allowed to make API requests.
                    '';
                  };
                };
              };
            };
          };
        };
      };
    };

    luaConfig = mkOption {
      type = settingsFormat.type;
      default = "";
      description = ''
        The content Lua configuration file for PowerDNS Recursor. See
        <https://doc.powerdns.com/recursor/lua-config/index.html>.
      '';
    };
  };

  config = mkIf cfg.enable {

    environment.etc."pdns-recursor".source = configFile;

    services.pdns-recursor.settings = mkDefault {
      settings = {
        logging = {
          disable_syslog = true;
          timestamp = false;
        };
        recursor = {
          lua_config_file = pkgs.writeText "recursor.lua" cfg.luaConfig;
          write_pid = false;
        };
      };
    };

    systemd.packages = [ pkgs.pdns-recursor ];

    systemd.services.pdns-recursor = {
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = [
          ""
          "${pkgs.pdns-recursor}/bin/pdns_recursor --config-dir=${configFile}"
        ];
      };
    };

    users.users.pdns-recursor = {
      isSystemUser = true;
      group = "pdns-recursor";
      description = "PowerDNS Recursor daemon user";
    };

    users.groups.pdns-recursor = { };

  };

  imports = [
    (mkRenamedOptionModule
      ["services" "pdns-recursor" "dns"]
      ["services" "pdns-recursor" "incoming"])
    (mkRenamedOptionModule
      ["services" "pdns-recursor" "dns" "allowFrom"]
      ["services" "pdns-recursor" "incoming" "allow_from"])
    (mkRenamedOptionModule
      ["services" "pdns-recursor" "dns" "address"]
      ["services" "pdns-recursor" "incoming" "listen"])
    (mkRenamedOptionModule
      ["services" "pdns-recursor" "api"]
      ["services" "pdns-recursor" "webservice"])
    (mkRenamedOptionModule
      ["services" "pdns-recursor" "api" "allowFrom"]
      ["services" "pdns-recursor" "webservice" "allow_from"])
    (mkRenamedOptionModule
      ["services" "pdns-recursor" "exportHosts"]
      ["services" "pdns-recursor" "recursor" "export_etc_hosts"])
    (mkRenamedOptionModule
      ["services" "pdns-recursor" "forwardZones"]
      ["services" "pdns-recursor" "recursor" "forward_zones"])
    (mkRenamedOptionModule
      ["services" "pdns-recursor" "forwardZonesRecurse"]
      ["services" "pdns-recursor" "recursor" "forward_zones_recurse"])
    (mkRenamedOptionModule
      ["services" "pdns-recursor" "serveRFC1918"]
      ["services" "pdns-recursor" "recursor" "serve_rfc1918"])
    (mkRenamedOptionModule
      ["services" "pdns-recursor" "dnssecValidation"]
      ["services" "pdns-recursor" "dnssec" "validation"])
    (mkRemovedOptionModule [
      "services"
      "pdns-recursor"
      "extraConfig"
    ] "Declare additional parameters in the format following the YAML format of the official documentation in services.pdns-recursor.settings.")
  ];

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

}

{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.pdns-recursor;

  cfgName = "recursor";

  configDir =
    pkgs.runCommand "${cfgName}.yml"
      {
        nativeBuildInputs = [ pkgs.remarshal ];
        passAsFile = [ "value" ];
        value = builtins.toJSON cfg.settings;
      }
      ''
        mkdir "$out"
        json2yaml -i "$valuePath" -o "$out/${cfgName}.yml"
      '';

  settingsFormat = pkgs.formats.yaml { };

  forwardZoneMkChange =
    field: config:
    let
      value = getAttrFromPath [ "services" "pdns-recursor" field ] config;
    in
    mapAttrsToList (zone: uri: {
      inherit zone;
      forwarders = [ uri ];
    }) value;

  forwardZone = types.submodule {
    options = {
      zone = mkOption {
        description = ''
          zone
        '';
        type = types.str;
      };
      forwarders = mkOption {
        description = ''
          forwarders
        '';
        type = types.listOf types.str;
      };
      recurse = mkOption {
        description = ''
          recurse ?
        '';
        type = types.bool;
        default = false;
      };
      notify_allowed = mkOption {
        description = ''
          Notify allowed ?
        '';
        type = types.bool;
        default = false;
      };
    };
  };
in
{
  options.services.pdns-recursor = {
    enable = mkEnableOption "PowerDNS Recursor, a recursive DNS server";

    settings = mkOption {
      description = ''
        Global configuration transcribed in YAML format
      '';
      type = types.submodule {
        options = {

          carbon = mkOption {
            default = { };
            description = ''
              Global carbon configuration transcribed in YAML format
            '';
            type = types.submodule { freeformType = settingsFormat.type; };
          };

          dnssec = mkOption {
            default = { };
            description = ''
              Global dnssec configuration transcribed in YAML format
            '';
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
            default = { };
            description = ''
              Global ecs configuration transcribed in YAML format
            '';
            type = types.submodule { freeformType = settingsFormat.type; };
          };

          incoming = mkOption {
            default = { };
            description = ''
              Global incoming configuration transcribed in YAML format
            '';
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
                  type = types.listOf types.str;
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
          };

          logging = mkOption {
            default = { };
            description = ''
              Global logging configuration transcribed in YAML format
            '';
            type = types.submodule { freeformType = settingsFormat.type; };
          };

          nod = mkOption {
            default = { };
            description = ''
              Global nod configuration transcribed in YAML format
            '';
            type = types.submodule { freeformType = settingsFormat.type; };
          };

          outgoing = mkOption {
            default = { };
            description = ''
              Global outgoing configuration transcribed in YAML format
            '';
            type = types.submodule { freeformType = settingsFormat.type; };
          };

          packetcache = mkOption {
            default = { };
            description = ''
              Global packetcache configuration transcribed in YAML format
            '';
            type = types.submodule { freeformType = settingsFormat.type; };
          };

          recordcache = mkOption {
            default = { };
            description = ''
              Global recordcache configuration transcribed in YAML format
            '';
            type = types.submodule { freeformType = settingsFormat.type; };
          };

          recursor = mkOption {
            description = ''
              Global recursor configuration transcribed in YAML format
            '';
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
                  type = types.listOf forwardZone;
                  default = { };
                  description = ''
                    DNS zones to be forwarded to other authoritative servers.
                  '';
                };

                forward_zones_recurse = mkOption {
                  type = types.listOf forwardZone;
                  example = [
                    {
                      zone = "example1.com";
                      forwarders = [ "[::1]:5300" ];
                    }
                  ];
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
            default = { };
            description = ''
              Global snmp configuration transcribed in YAML format
            '';
            type = types.submodule { freeformType = settingsFormat.type; };
          };

          webservice = mkOption {
            default = { };
            description = ''
              Global webservice configuration transcribed in YAML format
            '';
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

    luaConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        The content Lua configuration file for PowerDNS Recursor. See
        <https://doc.powerdns.com/recursor/lua-config/index.html>.
      '';
    };
  };

  config = mkIf cfg.enable {

    environment.etc."pdns-recursor".source = configDir;

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
          "${pkgs.pdns-recursor}/bin/pdns_recursor --config-dir=${configDir}"
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
      [ "services" "pdns-recursor" "dns" "address" ]
      [
        "services"
        "pdns-recursor"
        "settings"
        "incoming"
        "listen"
      ]
    )
    (mkRenamedOptionModule
      [ "services" "pdns-recursor" "dns" "allowFrom" ]
      [
        "services"
        "pdns-recursor"
        "settings"
        "incoming"
        "allow_from"
      ]
    )
    (mkRenamedOptionModule
      [ "services" "pdns-recursor" "dns" "port" ]
      [
        "services"
        "pdns-recursor"
        "settings"
        "incoming"
        "port"
      ]
    )
    (mkRenamedOptionModule
      [ "services" "pdns-recursor" "api" "address" ]
      [
        "services"
        "pdns-recursor"
        "settings"
        "webservice"
        "address"
      ]
    )
    (mkRenamedOptionModule
      [ "services" "pdns-recursor" "api" "allowFrom" ]
      [
        "services"
        "pdns-recursor"
        "settings"
        "webservice"
        "allow_from"
      ]
    )
    (mkRenamedOptionModule
      [ "services" "pdns-recursor" "api" "port" ]
      [
        "services"
        "pdns-recursor"
        "settings"
        "webservice"
        "port"
      ]
    )
    (mkRenamedOptionModule
      [ "services" "pdns-recursor" "exportHosts" ]
      [
        "services"
        "pdns-recursor"
        "settings"
        "recursor"
        "export_etc_hosts"
      ]
    )
    (mkChangedOptionModule
      [ "services" "pdns-recursor" "forwardZones" ]
      [
        "services"
        "pdns-recursor"
        "settings"
        "recursor"
        "forward_zones"
      ]
      (forwardZoneMkChange "forwardZones")
    )
    (mkChangedOptionModule
      [
        "services"
        "pdns-recursor"
        "forwardZonesRecurse"
      ]
      [
        "services"
        "pdns-recursor"
        "settings"
        "recursor"
        "forward_zones_recurse"
      ]
      (forwardZoneMkChange "forwardZonesRecurse")
    )
    (mkRenamedOptionModule
      [ "services" "pdns-recursor" "serveRFC1918" ]
      [
        "services"
        "pdns-recursor"
        "settings"
        "recursor"
        "serve_rfc1918"
      ]
    )
    (mkRenamedOptionModule
      [ "services" "pdns-recursor" "dnssecValidation" ]
      [
        "services"
        "pdns-recursor"
        "settings"
        "dnssec"
        "validation"
      ]
    )
    (mkRemovedOptionModule [ "services" "pdns-recursor" "extraConfig" ]
      "Declare additional parameters in the format following the YAML format of the official documentation in services.pdns-recursor.settings."
    )
  ];

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

}

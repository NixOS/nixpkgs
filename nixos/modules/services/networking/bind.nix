{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.bind;

  bindPkg = config.services.bind.package;

  bindUser = "named";

  bindZoneCoerce = list: builtins.listToAttrs (lib.forEach list (zone: { name = zone.name; value = zone; }));

  makeSOARecord = soa: ''
@ ${toString soa.ttl} SOA  ${soa.nameserver} (
                      ${soa.admin}
                      ${toString soa.serial}
                      ${toString soa.refresh}
                      ${toString soa.retry}
                      ${toString soa.expire}
                      ${toString soa.ttl})'';

  identity = _: value: value;

  makeGenericRecord = name: value: "${name} ${toString value.ttl} ${value.type} ${value.value}";
  makeGenericRecords = transformation: records:
      concatStringsSep "\n" (mapAttrsToList makeGenericRecord (mapAttrs transformation records));

  makeNSRecords = records:
    let
      transformNS = _: value: value // { type = "NS"; };
    in
      makeGenericRecords transformNS records;
  makeMXRecords = records:
    let
      transformMX = _: record: record // {
        type = "MX";
        value = "${toString record.priority} ${record.value}";
      };
    in
      makeGenericRecords transformMX records;


  makeZoneFile = name: records: pkgs.writeTextFile {
    name = "${name}.zone";
    text = ''$ORIGIN ${name}.
${makeSOARecord records.SOA}
${makeNSRecords records.NS}
${makeGenericRecords identity records.A}
${makeGenericRecords identity records.AAAA}
${makeGenericRecords identity records.CNAME}
${makeGenericRecords identity records.TXT}
${makeMXRecords records.MX}
      '';
  };

  defaultDNSRecord = type: ttl: types.submodule {
    options = {
      type = mkOption {
        type = types.str;
        default = type;
        description = lib.mdDoc "Type of this DNS record";
      };
      ttl = mkOption {
        type = types.int;
        default = ttl;
        description = lib.mdDoc "TTL for this record";
      };
      value = mkOption {
        type = types.str;
        description = lib.mdDoc "value of this record";
      };
    };
  };

  bindZoneOptions = { name, config, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        default = name;
        description = lib.mdDoc "Name of the zone.";
      };
      master = mkOption {
        description = lib.mdDoc "Master=false means slave server";
        type = types.bool;
      };
      file = mkOption {
        type = types.either types.str types.path;
        default = makeZoneFile name config.records;
        defaultText = "Generated from records";
        description = lib.mdDoc "Zone file resource records contain columns of data, separated by whitespace, that define the record.";
      };
      records = mkOption {
        description = lib.mdDoc "Record entries for this zone";
        default = {};
        type = types.submodule {
          options = {
            ttl = mkOption {
              type = types.int;
              default = 60;
              description = lib.mdDoc "Default TTL for records in this zone";
            };
            SOA = mkOption {
              description = lib.mdDoc "SOA record entry";
              type = types.submodule {
                options = {
                  nameserver = mkOption {
                    type = types.str;
                    description = lib.mdDoc "Default nameserver for this SOA record";
                  };
                  admin = mkOption {
                    type = types.str;
                    description = lib.mdDoc "Admin address for the zone";
                  };
                  serial = mkOption {
                    type = types.int;
                    description = lib.mdDoc "Serial number for the zone";
                  };
                  refresh = mkOption {
                    type = types.int;
                    description = lib.mdDoc "Length of time before secondary servers should pull new SOA record";
                  };
                  retry = mkOption {
                    type = types.int;
                    description = lib.mdDoc "Length of time before asking for an update if server is unresponsive";
                  };
                  expire = mkOption {
                    type = types.int;
                    description = lib.mdDoc "Length of time before secondary servers should stop polling an unresponsive server";
                  };
                  ttl = mkOption {
                    type = types.int;
                    default = config.records.ttl;
                    description = lib.mdDoc "TTL for the SOA record";
                  };
                };
              };
            };
            NS = mkOption {
              description = lib.mdDoc "NS record entries";
              default = {};
              example = {
                "foo" = {
                  ttl = 60;
                  value  = "ns1.example.com.";
                };
              };
              type = types.attrsOf (defaultDNSRecord "NS" config.records.ttl);
            };
            A = mkOption {
              description = lib.mdDoc "A record entries";
              default = {};
              example = {
                "foo" = {
                  ttl = 60;
                  value  = "192.0.1.2";
                };
              };
              type = types.attrsOf (defaultDNSRecord "A" config.records.ttl);
            };
            AAAA = mkOption {
              description = lib.mdDoc "AAAA record entries";
              default = {};
              example = {
                "foo" = {
                  ttl = 60;
                  value  = "2001:420::2617:de4::d87f:2092";
                };
              };
              type = types.attrsOf (defaultDNSRecord "AAAA" config.records.ttl);
            };
            CNAME = mkOption {
              description = lib.mdDoc "CNAME record entries";
              default = {};
              example = {
                "foo" = {
                  ttl = 60;
                  value  = "bar.zone.org";
                };
              };
              type = types.attrsOf (defaultDNSRecord "CNAME" config.records.ttl);
            };
            TXT = mkOption {
              description = lib.mdDoc "TXT record entries";
              default = {};
              example = {
                "foo" = {
                  ttl = 60;
                  value  = "Wohooo, a TXT entry in my DNS entries";
                };
              };
              type = types.attrsOf (defaultDNSRecord "TXT" config.records.ttl);
            };
            MX = mkOption {
              description = lib.mdDoc "MX record entries";
              default = {};
              example = {
                "foo" = {
                  ttl = 60;
                  value  = "mailhost1.example.com";
                  priority = 10;
                };
              };
              type = types.attrsOf (types.submodule {
                options = {
                  ttl = mkOption {
                    type = types.int;
                    default = config.records.ttl;
                    description = lib.mdDoc "TTL for this DNS entry";
                  };
                  value = mkOption {
                    type = types.str;
                    description = lib.mdDoc "Value for this MX record";
                  };
                  priority = mkOption {
                    type = types.int;
                    description = lib.mdDoc "Priority for this MX record";
                  };
                };
              });
            };

          };
        };
      };
      masters = mkOption {
        type = types.listOf types.str;
        description = lib.mdDoc "List of servers for inclusion in stub and secondary zones.";
      };
      slaves = mkOption {
        type = types.listOf types.str;
        description = lib.mdDoc "Addresses who may request zone transfers.";
        default = [ ];
      };
      extraConfig = mkOption {
        type = types.str;
        description = lib.mdDoc "Extra zone config to be appended at the end of the zone section.";
        default = "";
      };
    };
  };

  confFile = pkgs.writeText "named.conf"
    ''
      include "/etc/bind/rndc.key";
      controls {
        inet 127.0.0.1 allow {localhost;} keys {"rndc-key";};
      };

      acl cachenetworks { ${concatMapStrings (entry: " ${entry}; ") cfg.cacheNetworks} };
      acl badnetworks { ${concatMapStrings (entry: " ${entry}; ") cfg.blockedNetworks} };

      options {
        listen-on { ${concatMapStrings (entry: " ${entry}; ") cfg.listenOn} };
        listen-on-v6 { ${concatMapStrings (entry: " ${entry}; ") cfg.listenOnIpv6} };
        allow-query { cachenetworks; };
        blackhole { badnetworks; };
        forward ${cfg.forward};
        forwarders { ${concatMapStrings (entry: " ${entry}; ") cfg.forwarders} };
        directory "${cfg.directory}";
        pid-file "/run/named/named.pid";
        ${cfg.extraOptions}
      };

      ${cfg.extraConfig}

      ${ concatMapStrings
          ({ name, file, records, master ? true, slaves ? [], masters ? [], extraConfig ? "" }:
            ''
              zone "${name}" {
                type ${if master then "master" else "slave"};
                file "${file}";
                ${ if master then
                   ''
                     allow-transfer {
                       ${concatMapStrings (ip: "${ip};\n") slaves}
                     };
                   ''
                   else
                   ''
                     masters {
                       ${concatMapStrings (ip: "${ip};\n") masters}
                     };
                   ''
                }
                allow-query { any; };
                ${extraConfig}
              };
            '')
          (attrValues cfg.zones) }
    '';

in

{

  ###### interface

  options = {

    services.bind = {

      enable = mkEnableOption (lib.mdDoc "BIND domain name server");


      package = mkOption {
        type = types.package;
        default = pkgs.bind;
        defaultText = literalExpression "pkgs.bind";
        description = lib.mdDoc "The BIND package to use.";
      };

      cacheNetworks = mkOption {
        default = [ "127.0.0.0/24" ];
        type = types.listOf types.str;
        description = lib.mdDoc ''
          What networks are allowed to use us as a resolver.  Note
          that this is for recursive queries -- all networks are
          allowed to query zones configured with the `zones` option.
          It is recommended that you limit cacheNetworks to avoid your
          server being used for DNS amplification attacks.
        '';
      };

      blockedNetworks = mkOption {
        default = [ ];
        type = types.listOf types.str;
        description = lib.mdDoc ''
          What networks are just blocked.
        '';
      };

      ipv4Only = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Only use ipv4, even if the host supports ipv6.
        '';
      };

      forwarders = mkOption {
        default = config.networking.nameservers;
        defaultText = literalExpression "config.networking.nameservers";
        type = types.listOf types.str;
        description = lib.mdDoc ''
          List of servers we should forward requests to.
        '';
      };

      forward = mkOption {
        default = "first";
        type = types.enum ["first" "only"];
        description = lib.mdDoc ''
          Whether to forward 'first' (try forwarding but lookup directly if forwarding fails) or 'only'.
        '';
      };

      listenOn = mkOption {
        default = [ "any" ];
        type = types.listOf types.str;
        description = lib.mdDoc ''
          Interfaces to listen on.
        '';
      };

      listenOnIpv6 = mkOption {
        default = [ "any" ];
        type = types.listOf types.str;
        description = lib.mdDoc ''
          Ipv6 interfaces to listen on.
        '';
      };

      directory = mkOption {
        type = types.str;
        default = "/run/named";
        description = lib.mdDoc "Working directory of BIND.";
      };

      zones = mkOption {
        default = [ ];
        type = with types; coercedTo (listOf attrs) bindZoneCoerce (attrsOf (types.submodule bindZoneOptions));
        description = lib.mdDoc ''
          List of zones we claim authority over.
        '';
        example = {
          "example.com" = {
            master = false;
            file = "/var/dns/example.com";
            masters = [ "192.168.0.1" ];
            slaves = [ ];
            extraConfig = "";
          };
        };
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Extra lines to be added verbatim to the generated named configuration file.
        '';
      };

      extraOptions = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Extra lines to be added verbatim to the options section of the
          generated named configuration file.
        '';
      };

      configFile = mkOption {
        type = types.path;
        default = confFile;
        defaultText = literalExpression "confFile";
        description = lib.mdDoc ''
          Overridable config file to use for named. By default, that
          generated by nixos.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    networking.resolvconf.useLocalResolver = mkDefault true;

    users.users.${bindUser} =
      {
        group = bindUser;
        description = "BIND daemon user";
        isSystemUser = true;
      };
    users.groups.${bindUser} = {};

    systemd.services.bind = {
      description = "BIND Domain Name Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        mkdir -m 0755 -p /etc/bind
        if ! [ -f "/etc/bind/rndc.key" ]; then
          ${bindPkg.out}/sbin/rndc-confgen -c /etc/bind/rndc.key -u ${bindUser} -a -A hmac-sha256 2>/dev/null
        fi

        ${pkgs.coreutils}/bin/mkdir -p /run/named
        chown ${bindUser} /run/named

        ${pkgs.coreutils}/bin/mkdir -p ${cfg.directory}
        chown ${bindUser} ${cfg.directory}
      '';

      serviceConfig = {
        ExecStart = "${bindPkg.out}/sbin/named -u ${bindUser} ${optionalString cfg.ipv4Only "-4"} -c ${cfg.configFile} -f";
        ExecReload = "${bindPkg.out}/sbin/rndc -k '/etc/bind/rndc.key' reload";
        ExecStop = "${bindPkg.out}/sbin/rndc -k '/etc/bind/rndc.key' stop";
      };

      unitConfig.Documentation = "man:named(8)";
    };
  };
}

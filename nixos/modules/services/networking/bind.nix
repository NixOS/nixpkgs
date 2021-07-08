{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.bind;

  bindUser = "named";

  bindZoneCoerce = list: builtins.listToAttrs (lib.forEach list (zone: { name = zone.name; value = zone; }));

  bindZoneOptions = { name, config, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        default = name;
        description = "Name of the zone.";
      };
      master = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Flag to indicate that this zone is a master.
          master=false indicates that this is a slave.
        '';
      };
      file = mkOption {
        type = with types; nullOr (oneOf [ str path (submodule fileOpts) ]);
        default = null;
        description = ''
          Path to a zonefile, or attrset to generate one.
          Example:
          { records = [
                { name = "ns"; value = "192.168.1.1"; }
              ];
          };
        '';
      };
      masters = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "List of servers for inclusion in stub and secondary zones.";
      };
      slaves = mkOption {
        type = types.listOf types.str;
        description = "Addresses who may request zone transfers.";
        default = [ ];
      };
      extraConfig = mkOption {
        type = types.str;
        description = "Extra zone config to be appended at the end of the zone section.";
        default = "";
      };
    };
  };
  zoneFile = { name, opts }: pkgs.writeText "zone-${name}.conf"
    ''
        $TTL ${opts.default_ttl}
        @  IN  SOA  ${opts.name_primary}.${name}. ${opts.owner} (
            ${builtins.toString opts.serial}  ; serial
            ${opts.refresh}  ; refresh
            ${opts.retry}  ; retry
            ${opts.expire}  ; expire
            ${opts.minimum_ttl})  ; minimum ttl
            NS  ${opts.name_primary}.${name}.
        ${concatMapStrings (
        x: ''
          ${x.name} ${if x.ttl == null then opts.default_ttl else x.ttl} IN ${x.type} ${x.value}
        ''
      ) opts.records}
    '';

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
        forward first;
        forwarders { ${concatMapStrings (entry: " ${entry}; ") cfg.forwarders} };
        directory "/run/named";
        pid-file "/run/named/named.pid";
        ${cfg.extraOptions}
      };

      ${cfg.extraConfig}

      ${ concatMapStrings
      ({ name, file, master, slaves, masters, extraConfig }:
        # generate zone-file if file is an attrset, else use file
        # checks if the attrs isn't a derivation in case something like pkgs.writeText was assigned to the file.
          ''
            zone "${name}" {
              type ${if master then "master" else "slave"};
              file "${if (builtins.isAttrs file) && !(isDerivation file) then zoneFile { inherit name; opts = file; } else file}";
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

  fileOpts = {
    options = {
      owner = mkOption {
        default = "admin.your-domain.org";
        description = ''
          Email address of the servers technical contact (the @ is replaced by a dot).
        '';
      };
      name_primary = mkOption {
        default = "ns";
        example = "ns1";
        description = ''
          This will be used to generate the name of the primary DNS server.
          The primary DNS server's name will be: <command>{fileSettings.name_primary}.{name}"</command>
        '';
      };
      serial = mkOption {
        default = 1;
        type = types.ints.unsigned;
        description = ''
          Unsigned 32bit int, version-number of the zone, should be incremented with each change.
        '';
      };
      refresh = mkOption {
        default = "8H";
        description = ''
          Time interval between checks of the primary nameserver's serial number.
        '';
      };
      retry = mkOption {
        default = "2H";
        description = ''
          Time interval to wait prior to retrying a failed attempt to updated a zone.
        '';
      };
      expire = mkOption {
        default = "4W";
        description = ''
          Time interval to wait before considering the primary server unavailable.
        '';
      };
      minimum_ttl = mkOption {
        default = "1D";
        description = ''
          Time interval of caching a negative response.
        '';
      };
      default_ttl = mkOption {
        default = "3D";
        description = ''
          Default TTL.
        '';
      };

      records = mkOption {
        type = with types;
          listOf (
            submodule {
              options = {
                name = mkOption {
                  type = str;
                  example = "test";
                  description = "Start of test.mydomain.local .";
                };
                type = mkOption {
                  type = enum [ "A" "AAAA" "NS" "MX" "CNAME" "RP" "TXT" "SOA" "HINFO" "SRV" "DANE" "TLSA" "DS" "CAA" ];
                  default = "A";
                  example = "CNAME";
                  description = "Type of records.";
                };
                value = mkOption {
                  default = "127.0.0.1";
                  type = str;
                  example = "192.168.1.1";
                  description = "Value of dns entry.";
                };
                ttl = mkOption {
                  default = "3H";
                  type = str;
                  example = "3H";
                  description = "TTL";
                };
              };
            }
          );
        default = [ ];
        example = [{ name = "ns"; value = "192.168.1.1"; type = "A"; }];
        description = "List of dns-records, you should always set the primary DNS server.";
      };

    };
  };

in

{

  ###### interface

  options = {

    services.bind = {

      enable = mkEnableOption "BIND domain name server";

      cacheNetworks = mkOption {
        default = [ "127.0.0.0/24" ];
        type = types.listOf types.str;
        description = "
          What networks are allowed to use us as a resolver.  Note
          that this is for recursive queries -- all networks are
          allowed to query zones configured with the `zones` option.
          It is recommended that you limit cacheNetworks to avoid your
          server being used for DNS amplification attacks.
        ";
      };

      blockedNetworks = mkOption {
        default = [ ];
        type = types.listOf types.str;
        description = "
          What networks are just blocked.
        ";
      };

      ipv4Only = mkOption {
        default = false;
        type = types.bool;
        description = "
          Only use ipv4, even if the host supports ipv6.
        ";
      };

      forwarders = mkOption {
        default = config.networking.nameservers;
        type = types.listOf types.str;
        description = "
          List of servers we should forward requests to.
        ";
      };

      listenOn = mkOption {
        default = [ "any" ];
        type = types.listOf types.str;
        description = "
          Interfaces to listen on.
        ";
      };

      listenOnIpv6 = mkOption {
        default = [ "any" ];
        type = types.listOf types.str;
        description = "
          Ipv6 interfaces to listen on.
        ";
      };

      zones = mkOption {
        default = [ ];
        type = with types; coercedTo (listOf attrs) bindZoneCoerce (attrsOf (types.submodule bindZoneOptions));
        description = "
          List of zones we claim authority over.
        ";
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
        description = "
          Extra lines to be added verbatim to the generated named configuration file.
        ";
      };

      extraOptions = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra lines to be added verbatim to the options section of the
          generated named configuration file.
        '';
      };

      configFile = mkOption {
        type = types.path;
        default = confFile;
        defaultText = "confFile";
        description = "
          Overridable config file to use for named. By default, that
          generated by nixos.
        ";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = (foldr (x: y: y && x.file != null) true (lib.flatten (attrValues cfg.zones)));
        message = "Each zone specified in bind.zones requires a zone-file.";
      }
    ];

    networking.resolvconf.useLocalResolver = mkDefault true;

    users.users.${bindUser} =
      {
        uid = config.ids.uids.bind;
        description = "BIND daemon user";
      };

    systemd.services.bind = {
      description = "BIND Domain Name Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        mkdir -m 0755 -p /etc/bind
        if ! [ -f "/etc/bind/rndc.key" ]; then
          ${pkgs.bind.out}/sbin/rndc-confgen -c /etc/bind/rndc.key -u ${bindUser} -a -A hmac-sha256 2>/dev/null
        fi

        ${pkgs.coreutils}/bin/mkdir -p /run/named
        chown ${bindUser} /run/named
      '';

      serviceConfig = {
        ExecStart = "${pkgs.bind.out}/sbin/named -u ${bindUser} ${optionalString cfg.ipv4Only "-4"} -c ${cfg.configFile} -f";
        ExecReload = "${pkgs.bind.out}/sbin/rndc -k '/etc/bind/rndc.key' reload";
        ExecStop = "${pkgs.bind.out}/sbin/rndc -k '/etc/bind/rndc.key' stop";
      };

      unitConfig.Documentation = "man:named(8)";
    };
  };
}

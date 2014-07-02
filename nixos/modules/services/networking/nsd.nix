{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.nsd;

  username = "nsd";
  stateDir = "/var/lib/nsd";
  pidFile  = stateDir + "/var/nsd.pid";

  zoneFiles = pkgs.stdenv.mkDerivation {
      preferLocalBuild = true;
      name = "nsd-env";
      buildCommand = concatStringsSep "\n"
        [ "mkdir -p $out"
          (concatStrings (mapAttrsToList (zoneName: zoneOptions: ''
            cat > "$out/${zoneName}" <<_EOF_
            ${zoneOptions.data}
            _EOF_
          '') zoneConfigs))
        ];
  };

  configFile = pkgs.writeText "nsd.conf" ''
    server:
      username: ${username}
      chroot:   "${stateDir}"

      # The directory for zonefile: files. The daemon chdirs here.
      zonesdir: "${stateDir}"

      # the list of dynamically added zones.
      zonelistfile: "${stateDir}/var/zone.list"
      database:     "${stateDir}/var/nsd.db"
      logfile:      "${stateDir}/var/nsd.log"
      pidfile:      "${pidFile}"
      xfrdfile:     "${stateDir}/var/xfrd.state"
      xfrdir:       "${stateDir}/tmp"

      # interfaces
    ${forEach "  ip-address: " cfg.interfaces}

      server-count:        ${toString cfg.serverCount}
      ip-transparent:      ${yesOrNo  cfg.ipTransparent}
      do-ip4:              ${yesOrNo  cfg.ipv4}
      do-ip6:              ${yesOrNo  cfg.ipv6}
      port:                ${toString cfg.port}
      verbosity:           ${toString cfg.verbosity}
      hide-version:        ${yesOrNo  cfg.hideVersion}
      identity:            "${cfg.identity}"
      ${maybeString "nsid: " cfg.nsid}
      tcp-count:           ${toString cfg.tcpCount}
      tcp-query-count:     ${toString cfg.tcpQueryCount}
      tcp-timeout:         ${toString cfg.tcpTimeout}
      ipv4-edns-size:      ${toString cfg.ipv4EDNSSize}
      ipv6-edns-size:      ${toString cfg.ipv6EDNSSize}
      ${if cfg.statistics == null then "" else "statistics:          ${toString cfg.statistics}"}
      xfrd-reload-timeout: ${toString cfg.xfrdReloadTimeout}
      zonefiles-check:     ${yesOrNo  cfg.zonefilesCheck}

      rrl-size:                ${toString cfg.ratelimit.size}
      rrl-ratelimit:           ${toString cfg.ratelimit.ratelimit}
      rrl-whitelist-ratelimit: ${toString cfg.ratelimit.whitelistRatelimit}
      ${maybeString "rrl-slip: "               cfg.ratelimit.slip}
      ${maybeString "rrl-ipv4-prefix-length: " cfg.ratelimit.ipv4PrefixLength}
      ${maybeString "rrl-ipv6-prefix-length: " cfg.ratelimit.ipv6PrefixLength}

    ${keyConfigFile}

    remote-control:
      control-enable:    ${yesOrNo  cfg.remoteControl.enable}
    ${forEach "  control-interface: " cfg.remoteControl.interfaces}
      control-port:      ${toString cfg.port}
      server-key-file:   "${cfg.remoteControl.serverKeyFile}"
      server-cert-file:  "${cfg.remoteControl.serverCertFile}"
      control-key-file:  "${cfg.remoteControl.controlKeyFile}"
      control-cert-file: "${cfg.remoteControl.controlCertFile}"

    # zone files reside in "${zoneFiles}" linked to "${stateDir}/zones"
    ${concatStrings (mapAttrsToList zoneConfigFile zoneConfigs)}

    ${cfg.extraConfig}
  '';

  yesOrNo     = b: if b then "yes" else "no";
  maybeString = pre: s: if s == null then "" else ''${pre} "${s}"'';
  forEach     = pre: l: concatMapStrings (x: pre + x + "\n") l;


  keyConfigFile = concatStrings (mapAttrsToList (keyName: keyOptions: ''
    key:
      name:      "${keyName}"
      algorithm: "${keyOptions.algorithm}"
      include:   "${stateDir}/private/${keyName}"
  '') cfg.keys);

  copyKeys = concatStrings (mapAttrsToList (keyName: keyOptions: ''
    secret=$(cat "${keyOptions.keyFile}")
    dest="${stateDir}/private/${keyName}"
    echo "  secret: \"$secret\"" > "$dest"
    ${pkgs.coreutils}/bin/chown ${username}:${username} "$dest"
    ${pkgs.coreutils}/bin/chmod 0400 "$dest"
  '') cfg.keys);


  zoneConfigFile = name: zone: ''
        zone:
          name:         "${name}"
          zonefile:     "${stateDir}/zones/${name}"
          ${maybeString "outgoing-interface: " zone.outgoingInterface}
        ${forEach     "  rrl-whitelist: "      zone.rrlWhitelist}

        ${forEach     "  allow-notify: "       zone.allowNotify}
        ${forEach     "  request-xfr: "        zone.requestXFR}
          allow-axfr-fallback: ${yesOrNo       zone.allowAXFRFallback}

        ${forEach     "  notify: "             zone.notify}
          notify-retry:                        ${toString zone.notifyRetry}
        ${forEach     "  provide-xfr: "        zone.provideXFR}

    '';

  zoneConfigs = zoneConfigs' {} "" { children = cfg.zones; };

  zoneConfigs' = parent: name: zone:
    if !(zone ? children) || zone.children == null || zone.children == { }
      # leaf -> actual zone
      then listToAttrs [ (nameValuePair name (parent // zone)) ]

      # fork -> pattern
      else zipAttrsWith (name: head) (
          mapAttrsToList (name: child: zoneConfigs' (parent // zone // { children = {}; }) name child)
                         zone.children
      );

  # fighting infinite recursion
  zoneOptions  = zoneOptionsRaw // childConfig zoneOptions1 true;
  zoneOptions1 = zoneOptionsRaw // childConfig zoneOptions2 false;
  zoneOptions2 = zoneOptionsRaw // childConfig zoneOptions3 false;
  zoneOptions3 = zoneOptionsRaw // childConfig zoneOptions4 false;
  zoneOptions4 = zoneOptionsRaw // childConfig zoneOptions5 false;
  zoneOptions5 = zoneOptionsRaw // childConfig zoneOptions6 false;
  zoneOptions6 = zoneOptionsRaw // childConfig null         false;

  childConfig = x: v: { options.children = { type = types.attrsOf x; visible = v; }; };

  zoneOptionsRaw = types.submodule (
    { options, ... }:
    { options = {
        children = mkOption {
            default     = {};
            description = ''
              Children zones inherit all options of their parents. Attributes
              defined in a child will overwrite the ones of its parent. Only
              leaf zones will be actually served. This way it's possible to
              define maybe zones which share most attributes without
              duplicating everything. This mechanism replaces nsd's patterns
              in a save and functional way.
            '';
        };

        allowNotify = mkOption {
          type        = types.listOf types.str;
          default     = [ ];
          example     = [ "192.0.2.0/24 NOKEY" "10.0.0.1-10.0.0.5 my_tsig_key_name"
                           "10.0.3.4&255.255.0.0 BLOCKED"
                        ];
          description = ''
            Listed primary servers are allowed to notify this secondary server.
            <screen><![CDATA[
            Format: <ip> <key-name | NOKEY | BLOCKED>

            <ip> either a plain IPv4/IPv6 address or range. Valid patters for ranges:
            * 10.0.0.0/24            # via subnet size
            * 10.0.0.0&255.255.255.0 # via subnet mask
            * 10.0.0.1-10.0.0.254    # via range

            A optional port number could be added with a '@':
            * 2001:1234::1@1234

            <key-name | NOKEY | BLOCKED>
            * <key-name> will use the specified TSIG key
            * NOKEY      no TSIG signature is required
            * BLOCKED    notifies from non-listed or blocked IPs will be ignored
            * ]]></screen>
          '';
        };

        requestXFR = mkOption {
          type        = types.listOf types.str;
          default     = [];
          example     = [];
          description = ''
            Format: <code>[AXFR|UDP] &lt;ip-address&gt; &lt;key-name | NOKEY&gt;</code>
          '';
        };

        allowAXFRFallback = mkOption {
          type        = types.bool;
          default     = true;
          description = ''
            If NSD as secondary server should be allowed to AXFR if the primary
            server does not allow IXFR.
          '';
        };

        notify = mkOption {
          type        = types.listOf types.str;
          default     = [];
          example     = [ "10.0.0.1@3721 my_key" "::5 NOKEY" ];
          description = ''
            This primary server will notify all given secondary servers about
            zone changes.
            <screen><![CDATA[
            Format: <ip> <key-name | NOKEY>

            <ip> a plain IPv4/IPv6 address with on optional port number (ip@port)

            <key-name | NOKEY>
            * <key-name> sign notifies with the specified key
            * NOKEY      don't sign notifies
            ]]></screen>
          '';
        };

        notifyRetry = mkOption {
          type        = types.int;
          default     = 5;
          description = ''
            Specifies the number of retries for failed notifies. Set this along with notify.
          '';
        };

        provideXFR = mkOption {
          type        = types.listOf types.str;
          default     = [];
          example     = [ "192.0.2.0/24 NOKEY" "192.0.2.0/24 my_tsig_key_name" ];
          description = ''
            Allow these IPs and TSIG to transfer zones, addr TSIG|NOKEY|BLOCKED
            address range 192.0.2.0/24, 1.2.3.4&amp;255.255.0.0, 3.0.2.20-3.0.2.40
          '';
        };

        outgoingInterface = mkOption {
          type        = types.nullOr types.str;
          default     = null;
          example     = "2000::1@1234";
          description = ''
            This address will be used for zone-transfere requests if configured
            as a secondary server or notifications in case of a primary server.
            Supply either a plain IPv4 or IPv6 address with an optional port
            number (ip@port).
          '';
        };

        rrlWhitelist = mkOption {
          type        = types.listOf types.str;
          default     = [];
          description = ''
            Whitelists the given rrl-types.
            The RRL classification types are:  nxdomain,  error, referral, any,
            rrsig, wildcard, nodata, dnskey, positive, all
          '';
        };

        data = mkOption {
          type        = types.str;
          default     = "";
          example     = "";
          description = ''
            The actual zone data. This is the content of your zone file.
            Use imports or pkgs.lib.readFile if you don't want this data in your config file.
          '';
        };

      };
    }
  );

in
{
  options = {
    services.nsd = {

      enable = mkOption {
        type        = types.bool;
        default     = false;
        description = ''
          Whether to enable the NSD authoritative domain name server.
        '';
      };

      rootServer = mkOption {
        type        = types.bool;
        default     = false;
        description = ''
          Wheter if this server will be a root server (a DNS root server, you
          usually don't want that).
        '';
      };

      interfaces = mkOption {
        type        = types.listOf types.str;
        default     = [ "127.0.0.0" "::1" ];
        description = ''
          What addresses the server should listen to.
        '';
      };

      serverCount = mkOption {
        type        = types.int;
        default     = 1;
        description = ''
          Number of NSD servers to fork. Put the number of CPUs to use here.
        '';
      };

      ipTransparent = mkOption {
        type        = types.bool;
        default     = false;
        description = ''
          Allow binding to non local addresses.
        '';
      };

      ipv4 = mkOption {
        type        = types.bool;
        default     = true;
        description = ''
          Wheter to listen on IPv4 connections.
        '';
      };

      ipv6 = mkOption {
        type        = types.bool;
        default     = true;
        description = ''
          Wheter to listen on IPv6 connections.
        '';
      };

      port = mkOption {
        type        = types.int;
        default     = 53;
        description = ''
          Port the service should bind do.
        '';
      };

      verbosity = mkOption {
        type        = types.int;
        default     = 0;
        description = ''
          Verbosity level.
        '';
      };

      hideVersion = mkOption {
        type        = types.bool;
        default     = true;
        description = ''
          Wheter NSD should answer VERSION.BIND and VERSION.SERVER CHAOS class queries.
        '';
      };

      identity = mkOption {
        type        = types.str;
        default     = "unidentified server";
        description = ''
          Identify the server (CH TXT ID.SERVER entry).
        '';
      };

      nsid = mkOption {
        type        = types.nullOr types.str;
        default     = null;
        description = ''
          NSID identity (hex string, or "ascii_somestring").
        '';
      };

      tcpCount = mkOption {
        type        = types.int;
        default     = 100;
        description = ''
          Maximum number of concurrent TCP connections per server.
        '';
      };

      tcpQueryCount = mkOption {
        type        = types.int;
        default     = 0;
        description = ''
          Maximum number of queries served on a single TCP connection.
          0 means no maximum.
        '';
      };

      tcpTimeout = mkOption {
        type        = types.int;
        default     = 120;
        description = ''
          TCP timeout in seconds.
        '';
      };

      ipv4EDNSSize = mkOption {
        type        = types.int;
        default     = 4096;
        description = ''
          Preferred EDNS buffer size for IPv4.
        '';
      };

      ipv6EDNSSize = mkOption {
        type        = types.int;
        default     = 4096;
        description = ''
          Preferred EDNS buffer size for IPv6.
        '';
      };

      statistics = mkOption {
        type        = types.nullOr types.int;
        default     = null;
        description = ''
          Statistics are produced every number of seconds. Prints to log.
          If null no statistics are logged.
        '';
      };

      xfrdReloadTimeout = mkOption {
        type        = types.int;
        default     = 1;
        description = ''
          Number of seconds between reloads triggered by xfrd.
        '';
      };

      zonefilesCheck = mkOption {
        type        = types.bool;
        default     = true;
        description = ''
          Wheter to check mtime of all zone files on start and sighup.
        '';
      };


      extraConfig = mkOption {
        type        = types.str;
        default     = "";
        description = ''
          Extra nsd config.
        '';
      };


      ratelimit = mkOption {
        type = types.submodule (
          { options, ... }:
          { options = {

              enable = mkOption {
                type        = types.bool;
                default     = false;
                description = ''
                  Enable ratelimit capabilities.
                '';
              };

              size = mkOption {
                type        = types.int;
                default     = 1000000;
                description = ''
                  Size of the hashtable. More buckets use more memory but lower
                  the chance of hash hash collisions.
                '';
              };

              ratelimit = mkOption {
                type        = types.int;
                default     = 200;
                description = ''
                  Max qps allowed from any query source.
                  0 means unlimited. With an verbosity of 2 blocked and
                  unblocked subnets will be logged.
                '';
              };

              whitelistRatelimit = mkOption {
                type        = types.int;
                default     = 2000;
                description = ''
                  Max qps allowed from whitelisted sources.
                  0 means unlimited. Set the rrl-whitelist option for specific
                  queries to apply this limit instead of the default to them.
                '';
              };

              slip = mkOption {
                type        = types.nullOr types.int;
                default     = null;
                description = ''
                  Number of packets that get discarded before replying a SLIP response.
                  0 disables SLIP responses. 1 will make every response a SLIP response.
                '';
              };

              ipv4PrefixLength = mkOption {
                type        = types.nullOr types.int;
                default     = null;
                description = ''
                  IPv4 prefix length. Addresses are grouped by netblock.
                '';
              };

              ipv6PrefixLength = mkOption {
                type        = types.nullOr types.int;
                default     = null;
                description = ''
                  IPv6 prefix length. Addresses are grouped by netblock.
                '';
              };

            };
          });
        default = {
        };
        example = {};
        description = ''
        '';
      };


      remoteControl = mkOption {
        type = types.submodule (
          { config, options, ... }:
          { options = {

              enable = mkOption {
                type        = types.bool;
                default     = false;
                description = ''
                  Wheter to enable remote control via nsd-control(8).
                '';
              };

              interfaces = mkOption {
                type        = types.listOf types.str;
                default     = [ "127.0.0.1" "::1" ];
                description = ''
                  Which interfaces NSD should bind to for remote control.
                '';
              };

              port = mkOption {
                type        = types.int;
                default     = 8952;
                description = ''
                  Port number for remote control operations (uses TLS over TCP).
                '';
              };

              serverKeyFile = mkOption {
                type        = types.path;
                default     = "/etc/nsd/nsd_server.key";
                description = ''
                  Path to the server private key, which is used by the server
                  but not by nsd-control. This file is generated by nsd-control-setup.
                '';
              };

              serverCertFile = mkOption {
                type        = types.path;
                default     = "/etc/nsd/nsd_server.pem";
                description = ''
                  Path to the server self signed certificate, which is used by the server
                  but and by nsd-control. This file is generated by nsd-control-setup.
                '';
              };

              controlKeyFile = mkOption {
                type        = types.path;
                default     = "/etc/nsd/nsd_control.key";
                description = ''
                  Path to the client private key, which is used by nsd-control
                  but not by the server. This file is generated by nsd-control-setup.
                '';
              };

              controlCertFile = mkOption {
                type        = types.path;
                default     = "/etc/nsd/nsd_control.pem";
                description = ''
                  Path to the client certificate signed with the server certificate.
                  This file is used by nsd-control and generated by nsd-control-setup.
                '';
              };

            };

          });
        default = {
        };
        example = {};
        description = ''
        '';
      };


      keys = mkOption {
        type = types.attrsOf (types.submodule (
          { options, ... }:
          { options = {

              algorithm = mkOption {
                type        = types.str;
                default     = "hmac-sha256";
                description = ''
                  Authentication algorithm for this key.
                '';
              };

              keyFile = mkOption {
                type        = types.path;
                description = ''
                  Path to the file which contains the actual base64 encoded
                  key. The key will be copied into "${stateDir}/private" before
                  NSD starts. The copied file is only accessibly by the NSD
                  user.
                '';
              };

            };
          }));
        default = {
        };
        example = {
            "tsig.example.org" = {
              algorithm = "hmac-md5";
              secret    = "aaaaaabbbbbbccccccdddddd";
            };
        };
        description = ''
          Define your TSIG keys here.
        '';
      };

      zones = mkOption {
        type        = types.attrsOf zoneOptions;
        default     = {};
        example     = {
            "serverGroup1" = {
                provideXFR = [ "10.1.2.3 NOKEY" ];
                children = {
                    "example.com." = {
                        data = ''
                          $ORIGIN example.com.
                          $TTL    86400
                          @ IN SOA a.ns.example.com. admin.example.com. (
                          ...
                        '';
                    };
                    "example.org." = {
                        data = ''
                          $ORIGIN example.org.
                          $TTL    86400
                          @ IN SOA a.ns.example.com. admin.example.com. (
                          ...
                        '';
                    };
                };
            };

            "example.net." = {
                provideXFR = [ "10.3.2.1 NOKEY" ];
                data = ''...'';
            };
        };
        description = ''
          Define your zones here. Zones can cascade other zones and therefore
          inherit settings from parent zones. Look at the definition of
          children to learn about inheritance and child zones.
          The given example will define 3 zones (example.(com|org|net).). Both
          example.com. and example.org. inherit their configuration from
          serverGroup1.
        '';
      };

    };
  };

  config = mkIf cfg.enable {

    # this is not working :(
    nixpkgs.config.nsd = {
        ipv6       = cfg.ipv6;
        ratelimit  = cfg.ratelimit.enable;
        rootServer = cfg.rootServer;
    };

    users.extraGroups = singleton {
        name = username;
        gid  = config.ids.gids.nsd;
    };

    users.extraUsers = singleton {
        name        = username;
        description = "NSD service user";
        home        = stateDir;
        createHome  = true;
        uid         = config.ids.uids.nsd;
        group       = username;
    };

    systemd.services.nsd = {
      description = "NSD authoritative only domain name service";
      wantedBy    = [ "multi-user.target" ];
      after       = [ "network.target" ];

      serviceConfig = {
        Type      = "forking";
        PIDFile   = pidFile;
        Restart   = "always";
        ExecStart = "${pkgs.nsd}/sbin/nsd -c ${configFile}";
      };

      preStart = ''
        ${pkgs.coreutils}/bin/mkdir -m 0700 -p "${stateDir}/private"
        ${pkgs.coreutils}/bin/mkdir -m 0700 -p "${stateDir}/tmp"
        ${pkgs.coreutils}/bin/mkdir -m 0700 -p "${stateDir}/var"

        ${pkgs.coreutils}/bin/touch "${stateDir}/don't touch anything in here"

        ${pkgs.coreutils}/bin/rm -f "${stateDir}/private/"*
        ${pkgs.coreutils}/bin/rm -f "${stateDir}/tmp/"*

        ${pkgs.coreutils}/bin/chown nsd:nsd -R "${stateDir}/private"
        ${pkgs.coreutils}/bin/chown nsd:nsd -R "${stateDir}/tmp"
        ${pkgs.coreutils}/bin/chown nsd:nsd -R "${stateDir}/var"

        ${pkgs.coreutils}/bin/rm -rf "${stateDir}/zones"
        ${pkgs.coreutils}/bin/cp -r  "${zoneFiles}" "${stateDir}/zones"

        ${copyKeys}
      '';
    };

  };
}

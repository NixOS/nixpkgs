{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.nsd;

  username = "nsd";
  stateDir = "/var/lib/nsd";
  pidFile = stateDir + "/var/nsd.pid";

  # build nsd with the options needed for the given config
  nsdPkg = pkgs.nsd.override {
    bind8Stats = cfg.bind8Stats;
    ipv6 = cfg.ipv6;
    ratelimit = cfg.ratelimit.enable;
    rootServer = cfg.rootServer;
    zoneStats = length (collect (x: (x.zoneStats or null) != null) cfg.zones) > 0;
  };


  nsdEnv = pkgs.buildEnv {
    name = "nsd-env";

    paths = [ configFile ]
      ++ mapAttrsToList (name: zone: writeZoneData name zone.data) zoneConfigs;

    postBuild = ''
      echo "checking zone files"
      cd $out/zones

      for zoneFile in *; do
        echo "|- checking zone '$out/zones/$zoneFile'"
        ${nsdPkg}/sbin/nsd-checkzone "$zoneFile" "$zoneFile" || {
          if grep -q \\\\\\$ "$zoneFile"; then
            echo zone "$zoneFile" contains escaped dollar signes \\\$
            echo Escaping them is not needed any more. Please make shure \
                 to unescape them where they prefix a variable name
          fi

          exit 1
        }
      done

      echo "checking configuration file"
      ${nsdPkg}/sbin/nsd-checkconf $out/nsd.conf
    '';
  };

  writeZoneData = name: text: pkgs.writeTextFile {
    inherit name text;
    destination = "/zones/${name}";
  };


  # options are ordered alphanumerically by the nixos option name
  configFile = pkgs.writeTextDir "nsd.conf" ''
    server:
      chroot:   "${stateDir}"
      username: ${username}

      # The directory for zonefile: files. The daemon chdirs here.
      zonesdir: "${stateDir}"

      # the list of dynamically added zones.
      database:     "${stateDir}/var/nsd.db"
      pidfile:      "${pidFile}"
      xfrdfile:     "${stateDir}/var/xfrd.state"
      xfrdir:       "${stateDir}/tmp"
      zonelistfile: "${stateDir}/var/zone.list"

      # interfaces
    ${forEach "  ip-address: " cfg.interfaces}

      ip-freebind:         ${yesOrNo  cfg.ipFreebind}
      hide-version:        ${yesOrNo  cfg.hideVersion}
      identity:            "${cfg.identity}"
      ip-transparent:      ${yesOrNo  cfg.ipTransparent}
      do-ip4:              ${yesOrNo  cfg.ipv4}
      ipv4-edns-size:      ${toString cfg.ipv4EDNSSize}
      do-ip6:              ${yesOrNo  cfg.ipv6}
      ipv6-edns-size:      ${toString cfg.ipv6EDNSSize}
      log-time-ascii:      ${yesOrNo  cfg.logTimeAscii}
      ${maybeString "nsid: " cfg.nsid}
      port:                ${toString cfg.port}
      reuseport:           ${yesOrNo  cfg.reuseport}
      round-robin:         ${yesOrNo  cfg.roundRobin}
      server-count:        ${toString cfg.serverCount}
      ${maybeToString "statistics: " cfg.statistics}
      tcp-count:           ${toString cfg.tcpCount}
      tcp-query-count:     ${toString cfg.tcpQueryCount}
      tcp-timeout:         ${toString cfg.tcpTimeout}
      verbosity:           ${toString cfg.verbosity}
      ${maybeString "version: " cfg.version}
      xfrd-reload-timeout: ${toString cfg.xfrdReloadTimeout}
      zonefiles-check:     ${yesOrNo  cfg.zonefilesCheck}

      ${maybeString "rrl-ipv4-prefix-length: " cfg.ratelimit.ipv4PrefixLength}
      ${maybeString "rrl-ipv6-prefix-length: " cfg.ratelimit.ipv6PrefixLength}
      rrl-ratelimit:           ${toString cfg.ratelimit.ratelimit}
      ${maybeString "rrl-slip: "               cfg.ratelimit.slip}
      rrl-size:                ${toString cfg.ratelimit.size}
      rrl-whitelist-ratelimit: ${toString cfg.ratelimit.whitelistRatelimit}

    ${keyConfigFile}

    remote-control:
      control-enable:    ${yesOrNo  cfg.remoteControl.enable}
      control-key-file:  "${cfg.remoteControl.controlKeyFile}"
      control-cert-file: "${cfg.remoteControl.controlCertFile}"
    ${forEach "  control-interface: " cfg.remoteControl.interfaces}
      control-port:      ${toString cfg.remoteControl.port}
      server-key-file:   "${cfg.remoteControl.serverKeyFile}"
      server-cert-file:  "${cfg.remoteControl.serverCertFile}"

    ${concatStrings (mapAttrsToList zoneConfigFile zoneConfigs)}

    ${cfg.extraConfig}
  '';

  yesOrNo = b: if b then "yes" else "no";
  maybeString = prefix: x: if x == null then "" else ''${prefix} "${x}"'';
  maybeToString = prefix: x: if x == null then "" else ''${prefix} ${toString x}'';
  forEach = pre: l: concatMapStrings (x: pre + x + "\n") l;


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
    chown ${username}:${username} "$dest"
    chmod 0400 "$dest"
  '') cfg.keys);


  # options are ordered alphanumerically by the nixos option name
  zoneConfigFile = name: zone: ''
    zone:
      name:         "${name}"
      zonefile:     "${stateDir}/zones/${name}"
      ${maybeString "outgoing-interface: " zone.outgoingInterface}
    ${forEach     "  rrl-whitelist: "      zone.rrlWhitelist}
      ${maybeString "zonestats: "          zone.zoneStats}

      ${maybeToString "max-refresh-time: " zone.maxRefreshSecs}
      ${maybeToString "min-refresh-time: " zone.minRefreshSecs}
      ${maybeToString "max-retry-time:   " zone.maxRetrySecs}
      ${maybeToString "min-retry-time:   " zone.minRetrySecs}

      allow-axfr-fallback: ${yesOrNo       zone.allowAXFRFallback}
    ${forEach     "  allow-notify: "       zone.allowNotify}
    ${forEach     "  request-xfr: "        zone.requestXFR}

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
  zoneOptions = zoneOptionsRaw // childConfig zoneOptions1 true;
  zoneOptions1 = zoneOptionsRaw // childConfig zoneOptions2 false;
  zoneOptions2 = zoneOptionsRaw // childConfig zoneOptions3 false;
  zoneOptions3 = zoneOptionsRaw // childConfig zoneOptions4 false;
  zoneOptions4 = zoneOptionsRaw // childConfig zoneOptions5 false;
  zoneOptions5 = zoneOptionsRaw // childConfig zoneOptions6 false;
  zoneOptions6 = zoneOptionsRaw // childConfig null         false;

  childConfig = x: v: { options.children = { type = types.attrsOf x; visible = v; }; };

  # options are ordered alphanumerically
  zoneOptionsRaw = types.submodule {
    options = {

      allowAXFRFallback = mkOption {
        type = types.bool;
        default = true;
        description = ''
          If NSD as secondary server should be allowed to AXFR if the primary
          server does not allow IXFR.
        '';
      };

      allowNotify = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "192.0.2.0/24 NOKEY" "10.0.0.1-10.0.0.5 my_tsig_key_name"
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

      children = mkOption {
        default = {};
        description = ''
          Children zones inherit all options of their parents. Attributes
          defined in a child will overwrite the ones of its parent. Only
          leaf zones will be actually served. This way it's possible to
          define maybe zones which share most attributes without
          duplicating everything. This mechanism replaces nsd's patterns
          in a save and functional way.
        '';
      };

      data = mkOption {
        type = types.str;
        default = "";
        example = "";
        description = ''
          The actual zone data. This is the content of your zone file.
          Use imports or pkgs.lib.readFile if you don't want this data in your config file.
        '';
      };

      maxRefreshSecs = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          Limit refresh time for secondary zones. This is the timer which
          checks to see if the zone has to be refetched when it expires.
          Normally the value from the SOA record is used, but this  option
          restricts that value.
        '';
      };

      minRefreshSecs = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          Limit refresh time for secondary zones.
        '';
      };

      maxRetrySecs = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          Limit retry time for secondary zones. This is the timeout after
          a failed fetch attempt for the zone. Normally the value from
          the SOA record is used, but this option restricts that value.
        '';
      };

      minRetrySecs = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          Limit retry time for secondary zones.
        '';
      };


      notify = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "10.0.0.1@3721 my_key" "::5 NOKEY" ];
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
        type = types.int;
        default = 5;
        description = ''
          Specifies the number of retries for failed notifies. Set this along with notify.
        '';
      };

      outgoingInterface = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "2000::1@1234";
        description = ''
          This address will be used for zone-transfere requests if configured
          as a secondary server or notifications in case of a primary server.
          Supply either a plain IPv4 or IPv6 address with an optional port
          number (ip@port).
        '';
      };

      provideXFR = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "192.0.2.0/24 NOKEY" "192.0.2.0/24 my_tsig_key_name" ];
        description = ''
          Allow these IPs and TSIG to transfer zones, addr TSIG|NOKEY|BLOCKED
          address range 192.0.2.0/24, 1.2.3.4&amp;255.255.0.0, 3.0.2.20-3.0.2.40
        '';
      };

      requestXFR = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [];
        description = ''
          Format: <code>[AXFR|UDP] &lt;ip-address&gt; &lt;key-name | NOKEY&gt;</code>
        '';
      };

      rrlWhitelist = mkOption {
        type = with types; listOf (enum [ "nxdomain" "error" "referral" "any" "rrsig" "wildcard" "nodata" "dnskey" "positive" "all" ]);
        default = [];
        description = ''
          Whitelists the given rrl-types.
        '';
      };

      zoneStats = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "%s";
        description = ''
          When set to something distinct to null NSD is able to collect
          statistics per zone. All statistics of this zone(s) will be added
          to the group specified by this given name. Use "%s" to use the zones
          name as the group. The groups are output from nsd-control stats
          and stats_noreset.
        '';
      };

    };
  };

in
{
  # options are ordered alphanumerically
  options.services.nsd = {

    enable = mkEnableOption "NSD authoritative DNS server";

    bind8Stats = mkEnableOption "BIND8 like statistics";

    extraConfig = mkOption {
      type = types.str;
      default = "";
      description = ''
        Extra nsd config.
      '';
    };

    hideVersion = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether NSD should answer VERSION.BIND and VERSION.SERVER CHAOS class queries.
      '';
    };

    identity = mkOption {
      type = types.str;
      default = "unidentified server";
      description = ''
        Identify the server (CH TXT ID.SERVER entry).
      '';
    };

    interfaces = mkOption {
      type = types.listOf types.str;
      default = [ "127.0.0.0" "::1" ];
      description = ''
        What addresses the server should listen to.
      '';
    };

    ipFreebind = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to bind to nonlocal addresses and interfaces that are down.
        Similar to ip-transparent.
      '';
    };

    ipTransparent = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Allow binding to non local addresses.
      '';
    };

    ipv4 = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to listen on IPv4 connections.
      '';
    };

    ipv4EDNSSize = mkOption {
      type = types.int;
      default = 4096;
      description = ''
        Preferred EDNS buffer size for IPv4.
      '';
    };

    ipv6 = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to listen on IPv6 connections.
      '';
    };

    ipv6EDNSSize = mkOption {
      type = types.int;
      default = 4096;
      description = ''
        Preferred EDNS buffer size for IPv6.
      '';
    };

    logTimeAscii = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Log time in ascii, if false then in unix epoch seconds.
      '';
    };

    nsid = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        NSID identity (hex string, or "ascii_somestring").
      '';
    };

    port = mkOption {
      type = types.int;
      default = 53;
      description = ''
        Port the service should bind do.
      '';
    };

    reuseport = mkOption {
      type = types.bool;
      default = pkgs.stdenv.isLinux;
      description = ''
        Whether to enable SO_REUSEPORT on all used sockets. This lets multiple
        processes bind to the same port. This speeds up operation especially
        if the server count is greater than one and makes fast restarts less
        prone to fail
      '';
    };

    rootServer = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether this server will be a root server (a DNS root server, you
        usually don't want that).
      '';
    };

    roundRobin = mkEnableOption "round robin rotation of records";

    serverCount = mkOption {
      type = types.int;
      default = 1;
      description = ''
        Number of NSD servers to fork. Put the number of CPUs to use here.
      '';
    };

    statistics = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        Statistics are produced every number of seconds. Prints to log.
        If null no statistics are logged.
      '';
    };

    tcpCount = mkOption {
      type = types.int;
      default = 100;
      description = ''
        Maximum number of concurrent TCP connections per server.
      '';
    };

    tcpQueryCount = mkOption {
      type = types.int;
      default = 0;
      description = ''
        Maximum number of queries served on a single TCP connection.
        0 means no maximum.
      '';
    };

    tcpTimeout = mkOption {
      type = types.int;
      default = 120;
      description = ''
        TCP timeout in seconds.
      '';
    };

    verbosity = mkOption {
      type = types.int;
      default = 0;
      description = ''
        Verbosity level.
      '';
    };

    version = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        The version string replied for CH TXT version.server and version.bind
        queries. Will use the compiled package version on null.
        See hideVersion for enabling/disabling this responses.
      '';
    };

    xfrdReloadTimeout = mkOption {
      type = types.int;
      default = 1;
      description = ''
        Number of seconds between reloads triggered by xfrd.
      '';
    };

    zonefilesCheck = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to check mtime of all zone files on start and sighup.
      '';
    };


    keys = mkOption {
      type = types.attrsOf (types.submodule {
        options = {

          algorithm = mkOption {
            type = types.str;
            default = "hmac-sha256";
            description = ''
              Authentication algorithm for this key.
            '';
          };

          keyFile = mkOption {
            type = types.path;
            description = ''
              Path to the file which contains the actual base64 encoded
              key. The key will be copied into "${stateDir}/private" before
              NSD starts. The copied file is only accessibly by the NSD
              user.
            '';
          };

        };
      });
      default = {};
      example = literalExample ''
        { "tsig.example.org" = {
            algorithm = "hmac-md5";
            keyFile = "/path/to/my/key";
          };
        }
      '';
      description = ''
        Define your TSIG keys here.
      '';
    };


    ratelimit = {

      enable = mkEnableOption "ratelimit capabilities";

      ipv4PrefixLength = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          IPv4 prefix length. Addresses are grouped by netblock.
        '';
      };

      ipv6PrefixLength = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          IPv6 prefix length. Addresses are grouped by netblock.
        '';
      };

      ratelimit = mkOption {
        type = types.int;
        default = 200;
        description = ''
          Max qps allowed from any query source.
          0 means unlimited. With an verbosity of 2 blocked and
          unblocked subnets will be logged.
        '';
      };

      slip = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          Number of packets that get discarded before replying a SLIP response.
          0 disables SLIP responses. 1 will make every response a SLIP response.
        '';
      };

      size = mkOption {
        type = types.int;
        default = 1000000;
        description = ''
          Size of the hashtable. More buckets use more memory but lower
          the chance of hash hash collisions.
        '';
      };

      whitelistRatelimit = mkOption {
        type = types.int;
        default = 2000;
        description = ''
          Max qps allowed from whitelisted sources.
          0 means unlimited. Set the rrl-whitelist option for specific
          queries to apply this limit instead of the default to them.
        '';
      };

    };


    remoteControl = {

      enable = mkEnableOption "remote control via nsd-control";

      controlCertFile = mkOption {
        type = types.path;
        default = "/etc/nsd/nsd_control.pem";
        description = ''
          Path to the client certificate signed with the server certificate.
          This file is used by nsd-control and generated by nsd-control-setup.
        '';
      };

      controlKeyFile = mkOption {
        type = types.path;
        default = "/etc/nsd/nsd_control.key";
        description = ''
          Path to the client private key, which is used by nsd-control
          but not by the server. This file is generated by nsd-control-setup.
        '';
      };

      interfaces = mkOption {
        type = types.listOf types.str;
        default = [ "127.0.0.1" "::1" ];
        description = ''
          Which interfaces NSD should bind to for remote control.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 8952;
        description = ''
          Port number for remote control operations (uses TLS over TCP).
        '';
      };

      serverCertFile = mkOption {
        type = types.path;
        default = "/etc/nsd/nsd_server.pem";
        description = ''
          Path to the server self signed certificate, which is used by the server
          but and by nsd-control. This file is generated by nsd-control-setup.
        '';
      };

      serverKeyFile = mkOption {
        type = types.path;
        default = "/etc/nsd/nsd_server.key";
        description = ''
          Path to the server private key, which is used by the server
          but not by nsd-control. This file is generated by nsd-control-setup.
        '';
      };

    };


    zones = mkOption {
      type = types.attrsOf zoneOptions;
      default = {};
      example = literalExample ''
        { "serverGroup1" = {
            provideXFR = [ "10.1.2.3 NOKEY" ];
            children = {
              "example.com." = {
                data = '''
                  $ORIGIN example.com.
                  $TTL    86400
                  @ IN SOA a.ns.example.com. admin.example.com. (
                  ...
                ''';
              };
              "example.org." = {
                data = '''
                  $ORIGIN example.org.
                  $TTL    86400
                  @ IN SOA a.ns.example.com. admin.example.com. (
                  ...
                ''';
              };
            };
          };

          "example.net." = {
            provideXFR = [ "10.3.2.1 NOKEY" ];
            data = '''
              ...
            ''';
          };
        }
      '';
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

  config = mkIf cfg.enable {

    users.extraGroups = singleton {
      name = username;
      gid = config.ids.gids.nsd;
    };

    users.extraUsers = singleton {
      name = username;
      description = "NSD service user";
      home = stateDir;
      createHome  = true;
      uid = config.ids.uids.nsd;
      group = username;
    };

    systemd.services.nsd = {
      description = "NSD authoritative only domain name service";

      after = [ "keys.target" "network.target" ];
      wantedBy = [ "multi-user.target" ];
      wants = [ "keys.target" ];

      serviceConfig = {
        ExecStart = "${nsdPkg}/sbin/nsd -d -c ${nsdEnv}/nsd.conf";
        StandardError = "null";
        PIDFile = pidFile;
        Restart = "always";
        RestartSec = "4s";
        StartLimitBurst = 4;
        StartLimitInterval = "5min";
      };

      preStart = ''
        rm -Rf "${stateDir}/private/"
        rm -Rf "${stateDir}/tmp/"

        mkdir -m 0700 -p "${stateDir}/private"
        mkdir -m 0700 -p "${stateDir}/tmp"
        mkdir -m 0700 -p "${stateDir}/var"

        cat > "${stateDir}/don't touch anything in here" << EOF
        Everything in this directory except NSD's state in var is
        automatically generated and will be purged and redeployed
        by the nsd.service pre-start script.
        EOF

        chown ${username}:${username} -R "${stateDir}/private"
        chown ${username}:${username} -R "${stateDir}/tmp"
        chown ${username}:${username} -R "${stateDir}/var"

        rm -rf "${stateDir}/zones"
        cp -rL "${nsdEnv}/zones" "${stateDir}/zones"

        ${copyKeys}
      '';
    };

  };
}

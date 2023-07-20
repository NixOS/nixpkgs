{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.i2pd;

  homeDir = "/var/lib/i2pd";

  strOpt = k: v: k + " = " + v;
  boolOpt = k: v: k + " = " + boolToString v;
  intOpt = k: v: k + " = " + toString v;
  lstOpt = k: xs: k + " = " + concatStringsSep "," xs;
  optionalNullString = o: s: optional (s != null) (strOpt o s);
  optionalNullBool = o: b: optional (b != null) (boolOpt o b);
  optionalNullInt = o: i: optional (i != null) (intOpt o i);
  optionalEmptyList = o: l: optional ([] != l) (lstOpt o l);

  mkEnableTrueOption = name: mkEnableOption (lib.mdDoc name) // { default = true; };

  mkEndpointOpt = name: addr: port: {
    enable = mkEnableOption (lib.mdDoc name);
    name = mkOption {
      type = types.str;
      default = name;
      description = lib.mdDoc "The endpoint name.";
    };
    address = mkOption {
      type = types.str;
      default = addr;
      description = lib.mdDoc "Bind address for ${name} endpoint.";
    };
    port = mkOption {
      type = types.port;
      default = port;
      description = lib.mdDoc "Bind port for ${name} endpoint.";
    };
  };

  i2cpOpts = name: {
    length = mkOption {
      type = types.int;
      description = lib.mdDoc "Guaranteed minimum hops for ${name} tunnels.";
      default = 3;
    };
    quantity = mkOption {
      type = types.int;
      description = lib.mdDoc "Number of simultaneous ${name} tunnels.";
      default = 5;
    };
  };

  mkKeyedEndpointOpt = name: addr: port: keyloc:
    (mkEndpointOpt name addr port) // {
      keys = mkOption {
        type = with types; nullOr str;
        default = keyloc;
        description = lib.mdDoc ''
          File to persist ${lib.toUpper name} keys.
        '';
      };
      inbound = i2cpOpts name;
      outbound = i2cpOpts name;
      latency.min = mkOption {
        type = with types; nullOr int;
        description = lib.mdDoc "Min latency for tunnels.";
        default = null;
      };
      latency.max = mkOption {
        type = with types; nullOr int;
        description = lib.mdDoc "Max latency for tunnels.";
        default = null;
      };
    };

  commonTunOpts = name: {
    outbound = i2cpOpts name;
    inbound = i2cpOpts name;
    crypto.tagsToSend = mkOption {
      type = types.int;
      description = lib.mdDoc "Number of ElGamal/AES tags to send.";
      default = 40;
    };
    destination = mkOption {
      type = types.str;
      description = lib.mdDoc "Remote endpoint, I2P hostname or b32.i2p address.";
    };
    keys = mkOption {
      type = types.str;
      default = name + "-keys.dat";
      description = lib.mdDoc "Keyset used for tunnel identity.";
    };
  } // mkEndpointOpt name "127.0.0.1" 0;

  sec = name: "\n[" + name + "]";
  notice = "# DO NOT EDIT -- this file has been generated automatically.";
  i2pdConf = let
    opts = [
      notice
      (strOpt "loglevel" cfg.logLevel)
      (boolOpt "logclftime" cfg.logCLFTime)
      (boolOpt "ipv4" cfg.enableIPv4)
      (boolOpt "ipv6" cfg.enableIPv6)
      (boolOpt "notransit" cfg.notransit)
      (boolOpt "floodfill" cfg.floodfill)
      (intOpt "netid" cfg.netid)
    ] ++ (optionalNullInt "bandwidth" cfg.bandwidth)
      ++ (optionalNullInt "port" cfg.port)
      ++ (optionalNullString "family" cfg.family)
      ++ (optionalNullString "datadir" cfg.dataDir)
      ++ (optionalNullInt "share" cfg.share)
      ++ (optionalNullBool "ssu" cfg.ssu)
      ++ (optionalNullBool "ntcp" cfg.ntcp)
      ++ (optionalNullString "ntcpproxy" cfg.ntcpProxy)
      ++ (optionalNullString "ifname" cfg.ifname)
      ++ (optionalNullString "ifname4" cfg.ifname4)
      ++ (optionalNullString "ifname6" cfg.ifname6)
      ++ [
      (sec "limits")
      (intOpt "transittunnels" cfg.limits.transittunnels)
      (intOpt "coresize" cfg.limits.coreSize)
      (intOpt "openfiles" cfg.limits.openFiles)
      (intOpt "ntcphard" cfg.limits.ntcpHard)
      (intOpt "ntcpsoft" cfg.limits.ntcpSoft)
      (intOpt "ntcpthreads" cfg.limits.ntcpThreads)
      (sec "upnp")
      (boolOpt "enabled" cfg.upnp.enable)
      (sec "precomputation")
      (boolOpt "elgamal" cfg.precomputation.elgamal)
      (sec "reseed")
      (boolOpt "verify" cfg.reseed.verify)
    ] ++ (optionalNullString "file" cfg.reseed.file)
      ++ (optionalEmptyList "urls" cfg.reseed.urls)
      ++ (optionalNullString "floodfill" cfg.reseed.floodfill)
      ++ (optionalNullString "zipfile" cfg.reseed.zipfile)
      ++ (optionalNullString "proxy" cfg.reseed.proxy)
      ++ [
      (sec "trust")
      (boolOpt "enabled" cfg.trust.enable)
      (boolOpt "hidden" cfg.trust.hidden)
    ] ++ (optionalEmptyList "routers" cfg.trust.routers)
      ++ (optionalNullString "family" cfg.trust.family)
      ++ [
      (sec "websockets")
      (boolOpt "enabled" cfg.websocket.enable)
      (strOpt "address" cfg.websocket.address)
      (intOpt "port" cfg.websocket.port)
      (sec "exploratory")
      (intOpt "inbound.length" cfg.exploratory.inbound.length)
      (intOpt "inbound.quantity" cfg.exploratory.inbound.quantity)
      (intOpt "outbound.length" cfg.exploratory.outbound.length)
      (intOpt "outbound.quantity" cfg.exploratory.outbound.quantity)
      (sec "ntcp2")
      (boolOpt "enabled" cfg.ntcp2.enable)
      (boolOpt "published" cfg.ntcp2.published)
      (intOpt "port" cfg.ntcp2.port)
      (sec "addressbook")
      (strOpt "defaulturl" cfg.addressbook.defaulturl)
    ] ++ (optionalEmptyList "subscriptions" cfg.addressbook.subscriptions)
      ++ [
      (sec "meshnets")
      (boolOpt "yggdrasil" cfg.yggdrasil.enable)
    ] ++ (optionalNullString "yggaddress" cfg.yggdrasil.address)
      ++ (flip map
      (collect (proto: proto ? port && proto ? address) cfg.proto)
      (proto: let protoOpts = [
        (sec proto.name)
        (boolOpt "enabled" proto.enable)
        (strOpt "address" proto.address)
        (intOpt "port" proto.port)
        ] ++ (optionals (proto ? keys) (optionalNullString "keys" proto.keys))
        ++ (optionals (proto ? auth) (optionalNullBool "auth" proto.auth))
        ++ (optionals (proto ? user) (optionalNullString "user" proto.user))
        ++ (optionals (proto ? pass) (optionalNullString "pass" proto.pass))
        ++ (optionals (proto ? strictHeaders) (optionalNullBool "strictheaders" proto.strictHeaders))
        ++ (optionals (proto ? hostname) (optionalNullString "hostname" proto.hostname))
        ++ (optionals (proto ? outproxy) (optionalNullString "outproxy" proto.outproxy))
        ++ (optionals (proto ? outproxyPort) (optionalNullInt "outproxyport" proto.outproxyPort))
        ++ (optionals (proto ? outproxyEnable) (optionalNullBool "outproxy.enabled" proto.outproxyEnable));
        in (concatStringsSep "\n" protoOpts)
      ));
  in
    pkgs.writeText "i2pd.conf" (concatStringsSep "\n" opts);

  tunnelConf = let opts = [
    notice
    (flip map
      (collect (tun: tun ? port && tun ? destination) cfg.outTunnels)
      (tun: let outTunOpts = [
        (sec tun.name)
        "type = client"
        (intOpt "port" tun.port)
        (strOpt "destination" tun.destination)
        ] ++ (optionals (tun ? destinationPort) (optionalNullInt "destinationport" tun.destinationPort))
        ++ (optionals (tun ? keys) (optionalNullString "keys" tun.keys))
        ++ (optionals (tun ? address) (optionalNullString "address" tun.address))
        ++ (optionals (tun ? inbound.length) (optionalNullInt "inbound.length" tun.inbound.length))
        ++ (optionals (tun ? inbound.quantity) (optionalNullInt "inbound.quantity" tun.inbound.quantity))
        ++ (optionals (tun ? outbound.length) (optionalNullInt "outbound.length" tun.outbound.length))
        ++ (optionals (tun ? outbound.quantity) (optionalNullInt "outbound.quantity" tun.outbound.quantity))
        ++ (optionals (tun ? crypto.tagsToSend) (optionalNullInt "crypto.tagstosend" tun.crypto.tagsToSend));
        in concatStringsSep "\n" outTunOpts))
    (flip map
      (collect (tun: tun ? port && tun ? address) cfg.inTunnels)
      (tun: let inTunOpts = [
        (sec tun.name)
        "type = server"
        (intOpt "port" tun.port)
        (strOpt "host" tun.address)
      ] ++ (optionals (tun ? destination) (optionalNullString "destination" tun.destination))
        ++ (optionals (tun ? keys) (optionalNullString "keys" tun.keys))
        ++ (optionals (tun ? inPort) (optionalNullInt "inport" tun.inPort))
        ++ (optionals (tun ? accessList) (optionalEmptyList "accesslist" tun.accessList));
        in concatStringsSep "\n" inTunOpts))];
    in pkgs.writeText "i2pd-tunnels.conf" opts;

  i2pdFlags = concatStringsSep " " (
    optional (cfg.address != null) ("--host=" + cfg.address) ++ [
    "--service"
    ("--conf=" + i2pdConf)
    ("--tunconf=" + tunnelConf)
  ]);

in

{

  imports = [
    (mkRenamedOptionModule [ "services" "i2pd" "extIp" ] [ "services" "i2pd" "address" ])
  ];

  ###### interface

  options = {

    services.i2pd = {

      enable = mkEnableOption (lib.mdDoc "I2Pd daemon") // {
        description = lib.mdDoc ''
          Enables I2Pd as a running service upon activation.
          Please read http://i2pd.readthedocs.io/en/latest/ for further
          configuration help.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.i2pd;
        defaultText = literalExpression "pkgs.i2pd";
        description = lib.mdDoc ''
          i2pd package to use.
        '';
      };

      logLevel = mkOption {
        type = types.enum ["debug" "info" "warn" "error"];
        default = "error";
        description = lib.mdDoc ''
          The log level. {command}`i2pd` defaults to "info"
          but that generates copious amounts of log messages.

          We default to "error" which is similar to the default log
          level of {command}`tor`.
        '';
      };

      logCLFTime = mkEnableOption (lib.mdDoc "Full CLF-formatted date and time to log");

      address = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc ''
          Your external IP or hostname.
        '';
      };

      family = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc ''
          Specify a family the router belongs to.
        '';
      };

      dataDir = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc ''
          Alternative path to storage of i2pd data (RI, keys, peer profiles, ...)
        '';
      };

      share = mkOption {
        type = types.int;
        default = 100;
        description = lib.mdDoc ''
          Limit of transit traffic from max bandwidth in percents.
        '';
      };

      ifname = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc ''
          Network interface to bind to.
        '';
      };

      ifname4 = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc ''
          IPv4 interface to bind to.
        '';
      };

      ifname6 = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc ''
          IPv6 interface to bind to.
        '';
      };

      ntcpProxy = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc ''
          Proxy URL for NTCP transport.
        '';
      };

      ntcp = mkEnableTrueOption "ntcp";
      ssu = mkEnableTrueOption "ssu";

      notransit = mkEnableOption (lib.mdDoc "notransit") // {
        description = lib.mdDoc ''
          Tells the router to not accept transit tunnels during startup.
        '';
      };

      floodfill = mkEnableOption (lib.mdDoc "floodfill") // {
        description = lib.mdDoc ''
          If the router is declared to be unreachable and needs introduction nodes.
        '';
      };

      netid = mkOption {
        type = types.int;
        default = 2;
        description = lib.mdDoc ''
          I2P overlay netid.
        '';
      };

      bandwidth = mkOption {
        type = with types; nullOr int;
        default = null;
        description = lib.mdDoc ''
           Set a router bandwidth limit integer in KBps.
           If not set, {command}`i2pd` defaults to 32KBps.
        '';
      };

      port = mkOption {
        type = with types; nullOr int;
        default = null;
        description = lib.mdDoc ''
          I2P listen port. If no one is given the router will pick between 9111 and 30777.
        '';
      };

      enableIPv4 = mkEnableTrueOption "IPv4 connectivity";
      enableIPv6 = mkEnableOption (lib.mdDoc "IPv6 connectivity");
      nat = mkEnableTrueOption "NAT bypass";

      upnp.enable = mkEnableOption (lib.mdDoc "UPnP service discovery");
      upnp.name = mkOption {
        type = types.str;
        default = "I2Pd";
        description = lib.mdDoc ''
          Name i2pd appears in UPnP forwardings list.
        '';
      };

      precomputation.elgamal = mkEnableTrueOption "Precomputed ElGamal tables" // {
        description = lib.mdDoc ''
          Whenever to use precomputated tables for ElGamal.
          {command}`i2pd` defaults to `false`
          to save 64M of memory (and looses some performance).

          We default to `true` as that is what most
          users want anyway.
        '';
      };

      reseed.verify = mkEnableOption (lib.mdDoc "SU3 signature verification");

      reseed.file = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc ''
          Full path to SU3 file to reseed from.
        '';
      };

      reseed.urls = mkOption {
        type = with types; listOf str;
        default = [];
        description = lib.mdDoc ''
          Reseed URLs.
        '';
      };

      reseed.floodfill = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc ''
          Path to router info of floodfill to reseed from.
        '';
      };

      reseed.zipfile = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc ''
          Path to local .zip file to reseed from.
        '';
      };

      reseed.proxy = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc ''
          URL for reseed proxy, supports http/socks.
        '';
      };

     addressbook.defaulturl = mkOption {
        type = types.str;
        default = "http://joajgazyztfssty4w2on5oaqksz6tqoxbduy553y34mf4byv6gpq.b32.i2p/export/alive-hosts.txt";
        description = lib.mdDoc ''
          AddressBook subscription URL for initial setup
        '';
      };
     addressbook.subscriptions = mkOption {
        type = with types; listOf str;
        default = [
          "http://inr.i2p/export/alive-hosts.txt"
          "http://i2p-projekt.i2p/hosts.txt"
          "http://stats.i2p/cgi-bin/newhosts.txt"
        ];
        description = lib.mdDoc ''
          AddressBook subscription URLs
        '';
      };

      trust.enable = mkEnableOption (lib.mdDoc "Explicit trust options");

      trust.family = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc ''
          Router Family to trust for first hops.
        '';
      };

      trust.routers = mkOption {
        type = with types; listOf str;
        default = [];
        description = lib.mdDoc ''
          Only connect to the listed routers.
        '';
      };

      trust.hidden = mkEnableOption (lib.mdDoc "Router concealment");

      websocket = mkEndpointOpt "websockets" "127.0.0.1" 7666;

      exploratory.inbound = i2cpOpts "exploratory";
      exploratory.outbound = i2cpOpts "exploratory";

      ntcp2.enable = mkEnableTrueOption "NTCP2";
      ntcp2.published = mkEnableOption (lib.mdDoc "NTCP2 publication");
      ntcp2.port = mkOption {
        type = types.port;
        default = 0;
        description = lib.mdDoc ''
          Port to listen for incoming NTCP2 connections (0=auto).
        '';
      };

      limits.transittunnels = mkOption {
        type = types.int;
        default = 2500;
        description = lib.mdDoc ''
          Maximum number of active transit sessions.
        '';
      };

      limits.coreSize = mkOption {
        type = types.int;
        default = 0;
        description = lib.mdDoc ''
          Maximum size of corefile in Kb (0 - use system limit).
        '';
      };

      limits.openFiles = mkOption {
        type = types.int;
        default = 0;
        description = lib.mdDoc ''
          Maximum number of open files (0 - use system default).
        '';
      };

      limits.ntcpHard = mkOption {
        type = types.int;
        default = 0;
        description = lib.mdDoc ''
          Maximum number of active transit sessions.
        '';
      };

      limits.ntcpSoft = mkOption {
        type = types.int;
        default = 0;
        description = lib.mdDoc ''
          Threshold to start probabalistic backoff with ntcp sessions (default: use system limit).
        '';
      };

      limits.ntcpThreads = mkOption {
        type = types.int;
        default = 1;
        description = lib.mdDoc ''
          Maximum number of threads used by NTCP DH worker.
        '';
      };

      yggdrasil.enable = mkEnableOption (lib.mdDoc "Yggdrasil");

      yggdrasil.address = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc ''
          Your local yggdrasil address. Specify it if you want to bind your router to a
          particular address.
        '';
      };

      proto.http = (mkEndpointOpt "http" "127.0.0.1" 7070) // {

        auth = mkEnableOption (lib.mdDoc "Webconsole authentication");

        user = mkOption {
          type = types.str;
          default = "i2pd";
          description = lib.mdDoc ''
            Username for webconsole access
          '';
        };

        pass = mkOption {
          type = types.str;
          default = "i2pd";
          description = lib.mdDoc ''
            Password for webconsole access.
          '';
        };

        strictHeaders = mkOption {
          type = with types; nullOr bool;
          default = null;
          description = lib.mdDoc ''
            Enable strict host checking on WebUI.
          '';
        };

        hostname = mkOption {
          type = with types; nullOr str;
          default = null;
          description = lib.mdDoc ''
            Expected hostname for WebUI.
          '';
        };
      };

      proto.httpProxy = (mkKeyedEndpointOpt "httpproxy" "127.0.0.1" 4444 "httpproxy-keys.dat")
      // {
        outproxy = mkOption {
          type = with types; nullOr str;
          default = null;
          description = lib.mdDoc "Upstream outproxy bind address.";
        };
      };
      proto.socksProxy = (mkKeyedEndpointOpt "socksproxy" "127.0.0.1" 4447 "socksproxy-keys.dat")
      // {
        outproxyEnable = mkEnableOption (lib.mdDoc "SOCKS outproxy");
        outproxy = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = lib.mdDoc "Upstream outproxy bind address.";
        };
        outproxyPort = mkOption {
          type = types.int;
          default = 4444;
          description = lib.mdDoc "Upstream outproxy bind port.";
        };
      };

      proto.sam = mkEndpointOpt "sam" "127.0.0.1" 7656;
      proto.bob = mkEndpointOpt "bob" "127.0.0.1" 2827;
      proto.i2cp = mkEndpointOpt "i2cp" "127.0.0.1" 7654;
      proto.i2pControl = mkEndpointOpt "i2pcontrol" "127.0.0.1" 7650;

      outTunnels = mkOption {
        default = {};
        type = with types; attrsOf (submodule (
          { name, ... }: {
            options = {
              destinationPort = mkOption {
                type = with types; nullOr int;
                default = null;
                description = lib.mdDoc "Connect to particular port at destination.";
              };
            } // commonTunOpts name;
            config = {
              name = mkDefault name;
            };
          }
        ));
        description = lib.mdDoc ''
          Connect to someone as a client and establish a local accept endpoint
        '';
      };

      inTunnels = mkOption {
        default = {};
        type = with types; attrsOf (submodule (
          { name, ... }: {
            options = {
              inPort = mkOption {
                type = types.int;
                default = 0;
                description = lib.mdDoc "Service port. Default to the tunnel's listen port.";
              };
              accessList = mkOption {
                type = with types; listOf str;
                default = [];
                description = lib.mdDoc "I2P nodes that are allowed to connect to this service.";
              };
            } // commonTunOpts name;
            config = {
              name = mkDefault name;
            };
          }
        ));
        description = lib.mdDoc ''
          Serve something on I2P network at port and delegate requests to address inPort.
        '';
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    users.users.i2pd = {
      group = "i2pd";
      description = "I2Pd User";
      home = homeDir;
      createHome = true;
      uid = config.ids.uids.i2pd;
    };

    users.groups.i2pd.gid = config.ids.gids.i2pd;

    systemd.services.i2pd = {
      description = "Minimal I2P router";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig =
      {
        User = "i2pd";
        WorkingDirectory = homeDir;
        Restart = "on-abort";
        ExecStart = "${cfg.package}/bin/i2pd ${i2pdFlags}";
      };
    };
  };
}

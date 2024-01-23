{ config, lib, options, pkgs, ... }:

with builtins;
with lib;

let
  cfg = config.services.tor;
  opt = options.services.tor;
  stateDir = "/var/lib/tor";
  runDir = "/run/tor";
  descriptionGeneric = option: ''
    See [torrc manual](https://2019.www.torproject.org/docs/tor-manual.html.en#${option}).
  '';
  bindsPrivilegedPort =
    any (p0:
      let p1 = if p0 ? "port" then p0.port else p0; in
      if p1 == "auto" then false
      else let p2 = if isInt p1 then p1 else toInt p1; in
        p1 != null && 0 < p2 && p2 < 1024)
    (flatten [
      cfg.settings.ORPort
      cfg.settings.DirPort
      cfg.settings.DNSPort
      cfg.settings.ExtORPort
      cfg.settings.HTTPTunnelPort
      cfg.settings.NATDPort
      cfg.settings.SOCKSPort
      cfg.settings.TransPort
    ]);
  optionBool = optionName: mkOption {
    type = with types; nullOr bool;
    default = null;
    description = lib.mdDoc (descriptionGeneric optionName);
  };
  optionInt = optionName: mkOption {
    type = with types; nullOr int;
    default = null;
    description = lib.mdDoc (descriptionGeneric optionName);
  };
  optionString = optionName: mkOption {
    type = with types; nullOr str;
    default = null;
    description = lib.mdDoc (descriptionGeneric optionName);
  };
  optionStrings = optionName: mkOption {
    type = with types; listOf str;
    default = [];
    description = lib.mdDoc (descriptionGeneric optionName);
  };
  optionAddress = mkOption {
    type = with types; nullOr str;
    default = null;
    example = "0.0.0.0";
    description = lib.mdDoc ''
      IPv4 or IPv6 (if between brackets) address.
    '';
  };
  optionUnix = mkOption {
    type = with types; nullOr path;
    default = null;
    description = lib.mdDoc ''
      Unix domain socket path to use.
    '';
  };
  optionPort = mkOption {
    type = with types; nullOr (oneOf [port (enum ["auto"])]);
    default = null;
  };
  optionPorts = optionName: mkOption {
    type = with types; listOf port;
    default = [];
    description = lib.mdDoc (descriptionGeneric optionName);
  };
  optionIsolablePort = with types; oneOf [
    port (enum ["auto"])
    (submodule ({config, ...}: {
      options = {
        addr = optionAddress;
        port = optionPort;
        flags = optionFlags;
        SessionGroup = mkOption { type = nullOr int; default = null; };
      } // genAttrs isolateFlags (name: mkOption { type = types.bool; default = false; });
      config = {
        flags = filter (name: config.${name} == true) isolateFlags ++
                optional (config.SessionGroup != null) "SessionGroup=${toString config.SessionGroup}";
      };
    }))
  ];
  optionIsolablePorts = optionName: mkOption {
    default = [];
    type = with types; either optionIsolablePort (listOf optionIsolablePort);
    description = lib.mdDoc (descriptionGeneric optionName);
  };
  isolateFlags = [
    "IsolateClientAddr"
    "IsolateClientProtocol"
    "IsolateDestAddr"
    "IsolateDestPort"
    "IsolateSOCKSAuth"
    "KeepAliveIsolateSOCKSAuth"
  ];
  optionSOCKSPort = doConfig: let
    flags = [
      "CacheDNS" "CacheIPv4DNS" "CacheIPv6DNS" "GroupWritable" "IPv6Traffic"
      "NoDNSRequest" "NoIPv4Traffic" "NoOnionTraffic" "OnionTrafficOnly"
      "PreferIPv6" "PreferIPv6Automap" "PreferSOCKSNoAuth" "UseDNSCache"
      "UseIPv4Cache" "UseIPv6Cache" "WorldWritable"
    ] ++ isolateFlags;
    in with types; oneOf [
      port (submodule ({config, ...}: {
        options = {
          unix = optionUnix;
          addr = optionAddress;
          port = optionPort;
          flags = optionFlags;
          SessionGroup = mkOption { type = nullOr int; default = null; };
        } // genAttrs flags (name: mkOption { type = types.bool; default = false; });
        config = mkIf doConfig { # Only add flags in SOCKSPort to avoid duplicates
          flags = filter (name: config.${name} == true) flags ++
                  optional (config.SessionGroup != null) "SessionGroup=${toString config.SessionGroup}";
        };
      }))
    ];
  optionFlags = mkOption {
    type = with types; listOf str;
    default = [];
  };
  optionORPort = optionName: mkOption {
    default = [];
    example = 443;
    type = with types; oneOf [port (enum ["auto"]) (listOf (oneOf [
      port
      (enum ["auto"])
      (submodule ({config, ...}:
        let flags = [ "IPv4Only" "IPv6Only" "NoAdvertise" "NoListen" ];
        in {
        options = {
          addr = optionAddress;
          port = optionPort;
          flags = optionFlags;
        } // genAttrs flags (name: mkOption { type = types.bool; default = false; });
        config = {
          flags = filter (name: config.${name} == true) flags;
        };
      }))
    ]))];
    description = lib.mdDoc (descriptionGeneric optionName);
  };
  optionBandwidth = optionName: mkOption {
    type = with types; nullOr (either int str);
    default = null;
    description = lib.mdDoc (descriptionGeneric optionName);
  };
  optionPath = optionName: mkOption {
    type = with types; nullOr path;
    default = null;
    description = lib.mdDoc (descriptionGeneric optionName);
  };

  mkValueString = k: v:
    if v == null then ""
    else if isBool v then
      (if v then "1" else "0")
    else if v ? "unix" && v.unix != null then
      "unix:"+v.unix +
      optionalString (v ? "flags") (" " + concatStringsSep " " v.flags)
    else if v ? "port" && v.port != null then
      optionalString (v ? "addr" && v.addr != null) "${v.addr}:" +
      toString v.port +
      optionalString (v ? "flags") (" " + concatStringsSep " " v.flags)
    else if k == "ServerTransportPlugin" then
      optionalString (v.transports != []) "${concatStringsSep "," v.transports} exec ${v.exec}"
    else if k == "HidServAuth" then
      v.onion + " " + v.auth
    else generators.mkValueStringDefault {} v;
  genTorrc = settings:
    generators.toKeyValue {
      listsAsDuplicateKeys = true;
      mkKeyValue = k: generators.mkKeyValueDefault { mkValueString = mkValueString k; } " " k;
    }
    (lib.mapAttrs (k: v:
      # Not necesssary, but prettier rendering
      if elem k [ "AutomapHostsSuffixes" "DirPolicy" "ExitPolicy" "SocksPolicy" ]
      && v != []
      then concatStringsSep "," v
      else v)
    (lib.filterAttrs (k: v: !(v == null || v == ""))
    settings));
  torrc = pkgs.writeText "torrc" (
    genTorrc cfg.settings +
    concatStrings (mapAttrsToList (name: onion:
      "HiddenServiceDir ${onion.path}\n" +
      genTorrc onion.settings) cfg.relay.onionServices)
  );
in
{
  imports = [
    (mkRenamedOptionModule [ "services" "tor" "client" "dns" "automapHostsSuffixes" ] [ "services" "tor" "settings" "AutomapHostsSuffixes" ])
    (mkRemovedOptionModule [ "services" "tor" "client" "dns" "isolationOptions" ] "Use services.tor.settings.DNSPort instead.")
    (mkRemovedOptionModule [ "services" "tor" "client" "dns" "listenAddress" ] "Use services.tor.settings.DNSPort instead.")
    (mkRemovedOptionModule [ "services" "tor" "client" "privoxy" "enable" ] "Use services.privoxy.enable and services.privoxy.enableTor instead.")
    (mkRemovedOptionModule [ "services" "tor" "client" "socksIsolationOptions" ] "Use services.tor.settings.SOCKSPort instead.")
    (mkRemovedOptionModule [ "services" "tor" "client" "socksListenAddressFaster" ] "Use services.tor.settings.SOCKSPort instead.")
    (mkRenamedOptionModule [ "services" "tor" "client" "socksPolicy" ] [ "services" "tor" "settings" "SocksPolicy" ])
    (mkRemovedOptionModule [ "services" "tor" "client" "transparentProxy" "isolationOptions" ] "Use services.tor.settings.TransPort instead.")
    (mkRemovedOptionModule [ "services" "tor" "client" "transparentProxy" "listenAddress" ] "Use services.tor.settings.TransPort instead.")
    (mkRenamedOptionModule [ "services" "tor" "controlPort" ] [ "services" "tor" "settings" "ControlPort" ])
    (mkRemovedOptionModule [ "services" "tor" "extraConfig" ] "Please use services.tor.settings instead.")
    (mkRenamedOptionModule [ "services" "tor" "hiddenServices" ] [ "services" "tor" "relay" "onionServices" ])
    (mkRenamedOptionModule [ "services" "tor" "relay" "accountingMax" ] [ "services" "tor" "settings" "AccountingMax" ])
    (mkRenamedOptionModule [ "services" "tor" "relay" "accountingStart" ] [ "services" "tor" "settings" "AccountingStart" ])
    (mkRenamedOptionModule [ "services" "tor" "relay" "address" ] [ "services" "tor" "settings" "Address" ])
    (mkRenamedOptionModule [ "services" "tor" "relay" "bandwidthBurst" ] [ "services" "tor" "settings" "BandwidthBurst" ])
    (mkRenamedOptionModule [ "services" "tor" "relay" "bandwidthRate" ] [ "services" "tor" "settings" "BandwidthRate" ])
    (mkRenamedOptionModule [ "services" "tor" "relay" "bridgeTransports" ] [ "services" "tor" "settings" "ServerTransportPlugin" "transports" ])
    (mkRenamedOptionModule [ "services" "tor" "relay" "contactInfo" ] [ "services" "tor" "settings" "ContactInfo" ])
    (mkRenamedOptionModule [ "services" "tor" "relay" "exitPolicy" ] [ "services" "tor" "settings" "ExitPolicy" ])
    (mkRemovedOptionModule [ "services" "tor" "relay" "isBridge" ] "Use services.tor.relay.role instead.")
    (mkRemovedOptionModule [ "services" "tor" "relay" "isExit" ] "Use services.tor.relay.role instead.")
    (mkRenamedOptionModule [ "services" "tor" "relay" "nickname" ] [ "services" "tor" "settings" "Nickname" ])
    (mkRenamedOptionModule [ "services" "tor" "relay" "port" ] [ "services" "tor" "settings" "ORPort" ])
    (mkRenamedOptionModule [ "services" "tor" "relay" "portSpec" ] [ "services" "tor" "settings" "ORPort" ])
  ];

  options = {
    services.tor = {
      enable = mkEnableOption (lib.mdDoc ''Tor daemon.
        By default, the daemon is run without
        relay, exit, bridge or client connectivity'');

      openFirewall = mkEnableOption (lib.mdDoc "opening of the relay port(s) in the firewall");

      package = mkPackageOption pkgs "tor" { };

      enableGeoIP = mkEnableOption (lib.mdDoc ''use of GeoIP databases.
        Disabling this will disable by-country statistics for bridges and relays
        and some client and third-party software functionality'') // { default = true; };

      controlSocket.enable = mkEnableOption (lib.mdDoc ''control socket,
        created in `${runDir}/control`'');

      client = {
        enable = mkEnableOption (lib.mdDoc ''the routing of application connections.
          You might want to disable this if you plan running a dedicated Tor relay'');

        transparentProxy.enable = mkEnableOption (lib.mdDoc "transparent proxy");
        dns.enable = mkEnableOption (lib.mdDoc "DNS resolver");

        socksListenAddress = mkOption {
          type = optionSOCKSPort false;
          default = {addr = "127.0.0.1"; port = 9050; IsolateDestAddr = true;};
          example = {addr = "192.168.0.1"; port = 9090; IsolateDestAddr = true;};
          description = lib.mdDoc ''
            Bind to this address to listen for connections from
            Socks-speaking applications.
          '';
        };

        onionServices = mkOption {
          description = lib.mdDoc (descriptionGeneric "HiddenServiceDir");
          default = {};
          example = {
            "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" = {
              clientAuthorizations = ["/run/keys/tor/alice.prv.x25519"];
            };
          };
          type = types.attrsOf (types.submodule ({name, config, ...}: {
            options.clientAuthorizations = mkOption {
              description = lib.mdDoc ''
                Clients' authorizations for a v3 onion service,
                as a list of files containing each one private key, in the format:
                ```
                descriptor:x25519:<base32-private-key>
                ```
                ${descriptionGeneric "_client_authorization"}
              '';
              type = with types; listOf path;
              default = [];
              example = ["/run/keys/tor/alice.prv.x25519"];
            };
          }));
        };
      };

      relay = {
        enable = mkEnableOption (lib.mdDoc "tor relaying") // {
          description = lib.mdDoc ''
            Whether to enable relaying of Tor traffic for others.

            See <https://www.torproject.org/docs/tor-doc-relay>
            for details.

            Setting this to true requires setting
            {option}`services.tor.relay.role`
            and
            {option}`services.tor.settings.ORPort`
            options.
          '';
        };

        role = mkOption {
          type = types.enum [ "exit" "relay" "bridge" "private-bridge" ];
          description = lib.mdDoc ''
            Your role in Tor network. There're several options:

            - `exit`:
              An exit relay. This allows Tor users to access regular
              Internet services through your public IP.

              You can specify which services Tor users may access via
              your exit relay using {option}`settings.ExitPolicy` option.

            - `relay`:
              Regular relay. This allows Tor users to relay onion
              traffic to other Tor nodes, but not to public
              Internet.

              See
              <https://www.torproject.org/docs/tor-doc-relay.html.en>
              for more info.

            - `bridge`:
              Regular bridge. Works like a regular relay, but
              doesn't list you in the public relay directory and
              hides your Tor node behind obfs4proxy.

              Using this option will make Tor advertise your bridge
              to users through various mechanisms like
              <https://bridges.torproject.org/>, though.

              See <https://www.torproject.org/docs/bridges.html.en>
              for more info.

            - `private-bridge`:
              Private bridge. Works like regular bridge, but does
              not advertise your node in any way.

              Using this role means that you won't contribute to Tor
              network in any way unless you advertise your node
              yourself in some way.

              Use this if you want to run a private bridge, for
              example because you'll give out your bridge addr
              manually to your friends.

              Switching to this role after measurable time in
              "bridge" role is pretty useless as some Tor users
              would have learned about your node already. In the
              latter case you can still change
              {option}`port` option.

              See <https://www.torproject.org/docs/bridges.html.en>
              for more info.

            ::: {.important}
            Running an exit relay may expose you to abuse
            complaints. See
            <https://www.torproject.org/faq.html.en#ExitPolicies>
            for more info.
            :::

            ::: {.important}
            Note that some misconfigured and/or disrespectful
            towards privacy sites will block you even if your
            relay is not an exit relay. That is, just being listed
            in a public relay directory can have unwanted
            consequences.

            Which means you might not want to use
            this role if you browse public Internet from the same
            network as your relay, unless you want to write
            e-mails to those sites (you should!).
            :::

            ::: {.important}
            WARNING: THE FOLLOWING PARAGRAPH IS NOT LEGAL ADVICE.
            Consult with your lawyer when in doubt.

            The `bridge` role should be safe to use in most situations
            (unless the act of forwarding traffic for others is
            a punishable offence under your local laws, which
            would be pretty insane as it would make ISP illegal).
            :::
          '';
        };

        onionServices = mkOption {
          description = lib.mdDoc (descriptionGeneric "HiddenServiceDir");
          default = {};
          example = {
            "example.org/www" = {
              map = [ 80 ];
              authorizedClients = [
                "descriptor:x25519:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
              ];
            };
          };
          type = types.attrsOf (types.submodule ({name, config, ...}: {
            options.path = mkOption {
              type = types.path;
              description = lib.mdDoc ''
                Path where to store the data files of the hidden service.
                If the {option}`secretKey` is null
                this defaults to `${stateDir}/onion/$onion`,
                otherwise to `${runDir}/onion/$onion`.
              '';
            };
            options.secretKey = mkOption {
              type = with types; nullOr path;
              default = null;
              example = "/run/keys/tor/onion/expyuzz4wqqyqhjn/hs_ed25519_secret_key";
              description = lib.mdDoc ''
                Secret key of the onion service.
                If null, Tor reuses any preexisting secret key (in {option}`path`)
                or generates a new one.
                The associated public key and hostname are deterministically regenerated
                from this file if they do not exist.
              '';
            };
            options.authorizeClient = mkOption {
              description = lib.mdDoc (descriptionGeneric "HiddenServiceAuthorizeClient");
              default = null;
              type = types.nullOr (types.submodule ({...}: {
                options = {
                  authType = mkOption {
                    type = types.enum [ "basic" "stealth" ];
                    description = lib.mdDoc ''
                      Either `"basic"` for a general-purpose authorization protocol
                      or `"stealth"` for a less scalable protocol
                      that also hides service activity from unauthorized clients.
                    '';
                  };
                  clientNames = mkOption {
                    type = with types; nonEmptyListOf (strMatching "[A-Za-z0-9+-_]+");
                    description = lib.mdDoc ''
                      Only clients that are listed here are authorized to access the hidden service.
                      Generated authorization data can be found in {file}`${stateDir}/onion/$name/hostname`.
                      Clients need to put this authorization data in their configuration file using
                      [](#opt-services.tor.settings.HidServAuth).
                    '';
                  };
                };
              }));
            };
            options.authorizedClients = mkOption {
              description = lib.mdDoc ''
                Authorized clients for a v3 onion service,
                as a list of public key, in the format:
                ```
                descriptor:x25519:<base32-public-key>
                ```
                ${descriptionGeneric "_client_authorization"}
              '';
              type = with types; listOf str;
              default = [];
              example = ["descriptor:x25519:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"];
            };
            options.map = mkOption {
              description = lib.mdDoc (descriptionGeneric "HiddenServicePort");
              type = with types; listOf (oneOf [
                port (submodule ({...}: {
                  options = {
                    port = optionPort;
                    target = mkOption {
                      default = null;
                      type = nullOr (submodule ({...}: {
                        options = {
                          unix = optionUnix;
                          addr = optionAddress;
                          port = optionPort;
                        };
                      }));
                    };
                  };
                }))
              ]);
              apply = map (v: if isInt v then {port=v; target=null;} else v);
            };
            options.version = mkOption {
              description = lib.mdDoc (descriptionGeneric "HiddenServiceVersion");
              type = with types; nullOr (enum [2 3]);
              default = null;
            };
            options.settings = mkOption {
              description = lib.mdDoc ''
                Settings of the onion service.
                ${descriptionGeneric "_hidden_service_options"}
              '';
              default = {};
              type = types.submodule {
                freeformType = with types;
                  (attrsOf (nullOr (oneOf [str int bool (listOf str)]))) // {
                    description = "settings option";
                  };
                options.HiddenServiceAllowUnknownPorts = optionBool "HiddenServiceAllowUnknownPorts";
                options.HiddenServiceDirGroupReadable = optionBool "HiddenServiceDirGroupReadable";
                options.HiddenServiceExportCircuitID = mkOption {
                  description = lib.mdDoc (descriptionGeneric "HiddenServiceExportCircuitID");
                  type = with types; nullOr (enum ["haproxy"]);
                  default = null;
                };
                options.HiddenServiceMaxStreams = mkOption {
                  description = lib.mdDoc (descriptionGeneric "HiddenServiceMaxStreams");
                  type = with types; nullOr (ints.between 0 65535);
                  default = null;
                };
                options.HiddenServiceMaxStreamsCloseCircuit = optionBool "HiddenServiceMaxStreamsCloseCircuit";
                options.HiddenServiceNumIntroductionPoints = mkOption {
                  description = lib.mdDoc (descriptionGeneric "HiddenServiceNumIntroductionPoints");
                  type = with types; nullOr (ints.between 0 20);
                  default = null;
                };
                options.HiddenServiceSingleHopMode = optionBool "HiddenServiceSingleHopMode";
                options.RendPostPeriod = optionString "RendPostPeriod";
              };
            };
            config = {
              path = mkDefault ((if config.secretKey == null then stateDir else runDir) + "/onion/${name}");
              settings.HiddenServiceVersion = config.version;
              settings.HiddenServiceAuthorizeClient =
                if config.authorizeClient != null then
                  config.authorizeClient.authType + " " +
                  concatStringsSep "," config.authorizeClient.clientNames
                else null;
              settings.HiddenServicePort = map (p: mkValueString "" p.port + " " + mkValueString "" p.target) config.map;
            };
          }));
        };
      };

      settings = mkOption {
        description = lib.mdDoc ''
          See [torrc manual](https://2019.www.torproject.org/docs/tor-manual.html.en)
          for documentation.
        '';
        default = {};
        type = types.submodule {
          freeformType = with types;
            (attrsOf (nullOr (oneOf [str int bool (listOf str)]))) // {
              description = "settings option";
            };
          options.Address = optionString "Address";
          options.AssumeReachable = optionBool "AssumeReachable";
          options.AccountingMax = optionBandwidth "AccountingMax";
          options.AccountingStart = optionString "AccountingStart";
          options.AuthDirHasIPv6Connectivity = optionBool "AuthDirHasIPv6Connectivity";
          options.AuthDirListBadExits = optionBool "AuthDirListBadExits";
          options.AuthDirPinKeys = optionBool "AuthDirPinKeys";
          options.AuthDirSharedRandomness = optionBool "AuthDirSharedRandomness";
          options.AuthDirTestEd25519LinkKeys = optionBool "AuthDirTestEd25519LinkKeys";
          options.AuthoritativeDirectory = optionBool "AuthoritativeDirectory";
          options.AutomapHostsOnResolve = optionBool "AutomapHostsOnResolve";
          options.AutomapHostsSuffixes = optionStrings "AutomapHostsSuffixes" // {
            default = [".onion" ".exit"];
            example = [".onion"];
          };
          options.BandwidthBurst = optionBandwidth "BandwidthBurst";
          options.BandwidthRate = optionBandwidth "BandwidthRate";
          options.BridgeAuthoritativeDir = optionBool "BridgeAuthoritativeDir";
          options.BridgeRecordUsageByCountry = optionBool "BridgeRecordUsageByCountry";
          options.BridgeRelay = optionBool "BridgeRelay" // { default = false; };
          options.CacheDirectory = optionPath "CacheDirectory";
          options.CacheDirectoryGroupReadable = optionBool "CacheDirectoryGroupReadable"; # default is null and like "auto"
          options.CellStatistics = optionBool "CellStatistics";
          options.ClientAutoIPv6ORPort = optionBool "ClientAutoIPv6ORPort";
          options.ClientDNSRejectInternalAddresses = optionBool "ClientDNSRejectInternalAddresses";
          options.ClientOnionAuthDir = mkOption {
            description = lib.mdDoc (descriptionGeneric "ClientOnionAuthDir");
            default = null;
            type = with types; nullOr path;
          };
          options.ClientPreferIPv6DirPort = optionBool "ClientPreferIPv6DirPort"; # default is null and like "auto"
          options.ClientPreferIPv6ORPort = optionBool "ClientPreferIPv6ORPort"; # default is null and like "auto"
          options.ClientRejectInternalAddresses = optionBool "ClientRejectInternalAddresses";
          options.ClientUseIPv4 = optionBool "ClientUseIPv4";
          options.ClientUseIPv6 = optionBool "ClientUseIPv6";
          options.ConnDirectionStatistics = optionBool "ConnDirectionStatistics";
          options.ConstrainedSockets = optionBool "ConstrainedSockets";
          options.ContactInfo = optionString "ContactInfo";
          options.ControlPort = mkOption rec {
            description = lib.mdDoc (descriptionGeneric "ControlPort");
            default = [];
            example = [{port = 9051;}];
            type = with types; oneOf [port (enum ["auto"]) (listOf (oneOf [
              port (enum ["auto"]) (submodule ({config, ...}: let
                flags = ["GroupWritable" "RelaxDirModeCheck" "WorldWritable"];
                in {
                options = {
                  unix = optionUnix;
                  flags = optionFlags;
                  addr = optionAddress;
                  port = optionPort;
                } // genAttrs flags (name: mkOption { type = types.bool; default = false; });
                config = {
                  flags = filter (name: config.${name} == true) flags;
                };
              }))
            ]))];
          };
          options.ControlPortFileGroupReadable= optionBool "ControlPortFileGroupReadable";
          options.ControlPortWriteToFile = optionPath "ControlPortWriteToFile";
          options.ControlSocket = optionPath "ControlSocket";
          options.ControlSocketsGroupWritable = optionBool "ControlSocketsGroupWritable";
          options.CookieAuthFile = optionPath "CookieAuthFile";
          options.CookieAuthFileGroupReadable = optionBool "CookieAuthFileGroupReadable";
          options.CookieAuthentication = optionBool "CookieAuthentication";
          options.DataDirectory = optionPath "DataDirectory" // { default = stateDir; };
          options.DataDirectoryGroupReadable = optionBool "DataDirectoryGroupReadable";
          options.DirPortFrontPage = optionPath "DirPortFrontPage";
          options.DirAllowPrivateAddresses = optionBool "DirAllowPrivateAddresses";
          options.DormantCanceledByStartup = optionBool "DormantCanceledByStartup";
          options.DormantOnFirstStartup = optionBool "DormantOnFirstStartup";
          options.DormantTimeoutDisabledByIdleStreams = optionBool "DormantTimeoutDisabledByIdleStreams";
          options.DirCache = optionBool "DirCache";
          options.DirPolicy = mkOption {
            description = lib.mdDoc (descriptionGeneric "DirPolicy");
            type = with types; listOf str;
            default = [];
            example = ["accept *:*"];
          };
          options.DirPort = optionORPort "DirPort";
          options.DirReqStatistics = optionBool "DirReqStatistics";
          options.DisableAllSwap = optionBool "DisableAllSwap";
          options.DisableDebuggerAttachment = optionBool "DisableDebuggerAttachment";
          options.DisableNetwork = optionBool "DisableNetwork";
          options.DisableOOSCheck = optionBool "DisableOOSCheck";
          options.DNSPort = optionIsolablePorts "DNSPort";
          options.DoSCircuitCreationEnabled = optionBool "DoSCircuitCreationEnabled";
          options.DoSConnectionEnabled = optionBool "DoSConnectionEnabled"; # default is null and like "auto"
          options.DoSRefuseSingleHopClientRendezvous = optionBool "DoSRefuseSingleHopClientRendezvous";
          options.DownloadExtraInfo = optionBool "DownloadExtraInfo";
          options.EnforceDistinctSubnets = optionBool "EnforceDistinctSubnets";
          options.EntryStatistics = optionBool "EntryStatistics";
          options.ExitPolicy = optionStrings "ExitPolicy" // {
            default = ["reject *:*"];
            example = ["accept *:*"];
          };
          options.ExitPolicyRejectLocalInterfaces = optionBool "ExitPolicyRejectLocalInterfaces";
          options.ExitPolicyRejectPrivate = optionBool "ExitPolicyRejectPrivate";
          options.ExitPortStatistics = optionBool "ExitPortStatistics";
          options.ExitRelay = optionBool "ExitRelay"; # default is null and like "auto"
          options.ExtORPort = mkOption {
            description = lib.mdDoc (descriptionGeneric "ExtORPort");
            default = null;
            type = with types; nullOr (oneOf [
              port (enum ["auto"]) (submodule ({...}: {
                options = {
                  addr = optionAddress;
                  port = optionPort;
                };
              }))
            ]);
            apply = p: if isInt p || isString p then { port = p; } else p;
          };
          options.ExtORPortCookieAuthFile = optionPath "ExtORPortCookieAuthFile";
          options.ExtORPortCookieAuthFileGroupReadable = optionBool "ExtORPortCookieAuthFileGroupReadable";
          options.ExtendAllowPrivateAddresses = optionBool "ExtendAllowPrivateAddresses";
          options.ExtraInfoStatistics = optionBool "ExtraInfoStatistics";
          options.FascistFirewall = optionBool "FascistFirewall";
          options.FetchDirInfoEarly = optionBool "FetchDirInfoEarly";
          options.FetchDirInfoExtraEarly = optionBool "FetchDirInfoExtraEarly";
          options.FetchHidServDescriptors = optionBool "FetchHidServDescriptors";
          options.FetchServerDescriptors = optionBool "FetchServerDescriptors";
          options.FetchUselessDescriptors = optionBool "FetchUselessDescriptors";
          options.ReachableAddresses = optionStrings "ReachableAddresses";
          options.ReachableDirAddresses = optionStrings "ReachableDirAddresses";
          options.ReachableORAddresses = optionStrings "ReachableORAddresses";
          options.GeoIPFile = optionPath "GeoIPFile";
          options.GeoIPv6File = optionPath "GeoIPv6File";
          options.GuardfractionFile = optionPath "GuardfractionFile";
          options.HidServAuth = mkOption {
            description = lib.mdDoc (descriptionGeneric "HidServAuth");
            default = [];
            type = with types; listOf (oneOf [
              (submodule {
                options = {
                  onion = mkOption {
                    type = strMatching "[a-z2-7]{16}\\.onion";
                    description = lib.mdDoc "Onion address.";
                    example = "xxxxxxxxxxxxxxxx.onion";
                  };
                  auth = mkOption {
                    type = strMatching "[A-Za-z0-9+/]{22}";
                    description = lib.mdDoc "Authentication cookie.";
                  };
                };
              })
            ]);
            example = [
              {
                onion = "xxxxxxxxxxxxxxxx.onion";
                auth = "xxxxxxxxxxxxxxxxxxxxxx";
              }
            ];
          };
          options.HiddenServiceNonAnonymousMode = optionBool "HiddenServiceNonAnonymousMode";
          options.HiddenServiceStatistics = optionBool "HiddenServiceStatistics";
          options.HSLayer2Nodes = optionStrings "HSLayer2Nodes";
          options.HSLayer3Nodes = optionStrings "HSLayer3Nodes";
          options.HTTPTunnelPort = optionIsolablePorts "HTTPTunnelPort";
          options.IPv6Exit = optionBool "IPv6Exit";
          options.KeyDirectory = optionPath "KeyDirectory";
          options.KeyDirectoryGroupReadable = optionBool "KeyDirectoryGroupReadable";
          options.LogMessageDomains = optionBool "LogMessageDomains";
          options.LongLivedPorts = optionPorts "LongLivedPorts";
          options.MainloopStats = optionBool "MainloopStats";
          options.MaxAdvertisedBandwidth = optionBandwidth "MaxAdvertisedBandwidth";
          options.MaxCircuitDirtiness = optionInt "MaxCircuitDirtiness";
          options.MaxClientCircuitsPending = optionInt "MaxClientCircuitsPending";
          options.NATDPort = optionIsolablePorts "NATDPort";
          options.NewCircuitPeriod = optionInt "NewCircuitPeriod";
          options.Nickname = optionString "Nickname";
          options.ORPort = optionORPort "ORPort";
          options.OfflineMasterKey = optionBool "OfflineMasterKey";
          options.OptimisticData = optionBool "OptimisticData"; # default is null and like "auto"
          options.PaddingStatistics = optionBool "PaddingStatistics";
          options.PerConnBWBurst = optionBandwidth "PerConnBWBurst";
          options.PerConnBWRate = optionBandwidth "PerConnBWRate";
          options.PidFile = optionPath "PidFile";
          options.ProtocolWarnings = optionBool "ProtocolWarnings";
          options.PublishHidServDescriptors = optionBool "PublishHidServDescriptors";
          options.PublishServerDescriptor = mkOption {
            description = lib.mdDoc (descriptionGeneric "PublishServerDescriptor");
            type = with types; nullOr (enum [false true 0 1 "0" "1" "v3" "bridge"]);
            default = null;
          };
          options.ReducedExitPolicy = optionBool "ReducedExitPolicy";
          options.RefuseUnknownExits = optionBool "RefuseUnknownExits"; # default is null and like "auto"
          options.RejectPlaintextPorts = optionPorts "RejectPlaintextPorts";
          options.RelayBandwidthBurst = optionBandwidth "RelayBandwidthBurst";
          options.RelayBandwidthRate = optionBandwidth "RelayBandwidthRate";
          #options.RunAsDaemon
          options.Sandbox = optionBool "Sandbox";
          options.ServerDNSAllowBrokenConfig = optionBool "ServerDNSAllowBrokenConfig";
          options.ServerDNSAllowNonRFC953Hostnames = optionBool "ServerDNSAllowNonRFC953Hostnames";
          options.ServerDNSDetectHijacking = optionBool "ServerDNSDetectHijacking";
          options.ServerDNSRandomizeCase = optionBool "ServerDNSRandomizeCase";
          options.ServerDNSResolvConfFile = optionPath "ServerDNSResolvConfFile";
          options.ServerDNSSearchDomains = optionBool "ServerDNSSearchDomains";
          options.ServerTransportPlugin = mkOption {
            description = lib.mdDoc (descriptionGeneric "ServerTransportPlugin");
            default = null;
            type = with types; nullOr (submodule ({...}: {
              options = {
                transports = mkOption {
                  description = lib.mdDoc "List of pluggable transports.";
                  type = listOf str;
                  example = ["obfs2" "obfs3" "obfs4" "scramblesuit"];
                };
                exec = mkOption {
                  type = types.str;
                  description = lib.mdDoc "Command of pluggable transport.";
                };
              };
            }));
          };
          options.ShutdownWaitLength = mkOption {
            type = types.int;
            default = 30;
            description = lib.mdDoc (descriptionGeneric "ShutdownWaitLength");
          };
          options.SocksPolicy = optionStrings "SocksPolicy" // {
            example = ["accept *:*"];
          };
          options.SOCKSPort = mkOption {
            description = lib.mdDoc (descriptionGeneric "SOCKSPort");
            default = lib.optionals cfg.settings.HiddenServiceNonAnonymousMode [{port = 0;}];
            defaultText = literalExpression ''
              if config.${opt.settings}.HiddenServiceNonAnonymousMode == true
              then [ { port = 0; } ]
              else [ ]
            '';
            example = [{port = 9090;}];
            type = types.listOf (optionSOCKSPort true);
          };
          options.TestingTorNetwork = optionBool "TestingTorNetwork";
          options.TransPort = optionIsolablePorts "TransPort";
          options.TransProxyType = mkOption {
            description = lib.mdDoc (descriptionGeneric "TransProxyType");
            type = with types; nullOr (enum ["default" "TPROXY" "ipfw" "pf-divert"]);
            default = null;
          };
          #options.TruncateLogFile
          options.UnixSocksGroupWritable = optionBool "UnixSocksGroupWritable";
          options.UseDefaultFallbackDirs = optionBool "UseDefaultFallbackDirs";
          options.UseMicrodescriptors = optionBool "UseMicrodescriptors";
          options.V3AuthUseLegacyKey = optionBool "V3AuthUseLegacyKey";
          options.V3AuthoritativeDirectory = optionBool "V3AuthoritativeDirectory";
          options.VersioningAuthoritativeDirectory = optionBool "VersioningAuthoritativeDirectory";
          options.VirtualAddrNetworkIPv4 = optionString "VirtualAddrNetworkIPv4";
          options.VirtualAddrNetworkIPv6 = optionString "VirtualAddrNetworkIPv6";
          options.WarnPlaintextPorts = optionPorts "WarnPlaintextPorts";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    # Not sure if `cfg.relay.role == "private-bridge"` helps as tor
    # sends a lot of stats
    warnings = optional (cfg.settings.BridgeRelay &&
      flatten (mapAttrsToList (n: o: o.map) cfg.relay.onionServices) != [])
      ''
        Running Tor hidden services on a public relay makes the
        presence of hidden services visible through simple statistical
        analysis of publicly available data.
        See https://trac.torproject.org/projects/tor/ticket/8742

        You can safely ignore this warning if you don't intend to
        actually hide your hidden services. In either case, you can
        always create a container/VM with a separate Tor daemon instance.
      '' ++
      flatten (mapAttrsToList (n: o:
        optionals (o.settings.HiddenServiceVersion == 2) [
          (optional (o.settings.HiddenServiceExportCircuitID != null) ''
            HiddenServiceExportCircuitID is used in the HiddenService: ${n}
            but this option is only for v3 hidden services.
          '')
        ] ++
        optionals (o.settings.HiddenServiceVersion != 2) [
          (optional (o.settings.HiddenServiceAuthorizeClient != null) ''
            HiddenServiceAuthorizeClient is used in the HiddenService: ${n}
            but this option is only for v2 hidden services.
          '')
          (optional (o.settings.RendPostPeriod != null) ''
            RendPostPeriod is used in the HiddenService: ${n}
            but this option is only for v2 hidden services.
          '')
        ]
      ) cfg.relay.onionServices);

    users.groups.tor.gid = config.ids.gids.tor;
    users.users.tor =
      { description = "Tor Daemon User";
        createHome  = true;
        home        = stateDir;
        group       = "tor";
        uid         = config.ids.uids.tor;
      };

    services.tor.settings = mkMerge [
      (mkIf cfg.enableGeoIP {
        GeoIPFile = "${cfg.package.geoip}/share/tor/geoip";
        GeoIPv6File = "${cfg.package.geoip}/share/tor/geoip6";
      })
      (mkIf cfg.controlSocket.enable {
        ControlPort = [ { unix = runDir + "/control"; GroupWritable=true; RelaxDirModeCheck=true; } ];
      })
      (mkIf cfg.relay.enable (
        optionalAttrs (cfg.relay.role != "exit") {
          ExitPolicy = mkForce ["reject *:*"];
        } //
        optionalAttrs (elem cfg.relay.role ["bridge" "private-bridge"]) {
          BridgeRelay = true;
          ExtORPort.port = mkDefault "auto";
          ServerTransportPlugin.transports = mkDefault ["obfs4"];
          ServerTransportPlugin.exec = mkDefault "${lib.getExe pkgs.obfs4} managed";
        } // optionalAttrs (cfg.relay.role == "private-bridge") {
          ExtraInfoStatistics = false;
          PublishServerDescriptor = false;
        }
      ))
      (mkIf (!cfg.relay.enable) {
        # Avoid surprises when leaving ORPort/DirPort configurations in cfg.settings,
        # because it would still enable Tor as a relay,
        # which can trigger all sort of problems when not carefully done,
        # like the blocklisting of the machine's IP addresses
        # by some hosting providers...
        DirPort = mkForce [];
        ORPort = mkForce [];
        PublishServerDescriptor = mkForce false;
      })
      (mkIf (!cfg.client.enable) {
        # Make sure application connections via SOCKS are disabled
        # when services.tor.client.enable is false
        SOCKSPort = mkForce [ 0 ];
      })
      (mkIf cfg.client.enable (
        { SOCKSPort = [ cfg.client.socksListenAddress ];
        } // optionalAttrs cfg.client.transparentProxy.enable {
          TransPort = [{ addr = "127.0.0.1"; port = 9040; }];
        } // optionalAttrs cfg.client.dns.enable {
          DNSPort = [{ addr = "127.0.0.1"; port = 9053; }];
          AutomapHostsOnResolve = true;
        } // optionalAttrs (flatten (mapAttrsToList (n: o: o.clientAuthorizations) cfg.client.onionServices) != []) {
          ClientOnionAuthDir = runDir + "/ClientOnionAuthDir";
        }
      ))
    ];

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts =
        concatMap (o:
          if isInt o && o > 0 then [o]
          else optionals (o ? "port" && isInt o.port && o.port > 0) [o.port]
        ) (flatten [
          cfg.settings.ORPort
          cfg.settings.DirPort
        ]);
    };

    systemd.services.tor = {
      description = "Tor Daemon";
      path = [ pkgs.tor ];

      wantedBy = [ "multi-user.target" ];
      after    = [ "network.target" ];
      restartTriggers = [ torrc ];

      serviceConfig = {
        Type = "simple";
        User = "tor";
        Group = "tor";
        ExecStartPre = [
          "${cfg.package}/bin/tor -f ${torrc} --verify-config"
          # DOC: Appendix G of https://spec.torproject.org/rend-spec-v3
          ("+" + pkgs.writeShellScript "ExecStartPre" (concatStringsSep "\n" (flatten (["set -eu"] ++
            mapAttrsToList (name: onion:
              optional (onion.authorizedClients != []) ''
                rm -rf ${escapeShellArg onion.path}/authorized_clients
                install -d -o tor -g tor -m 0700 ${escapeShellArg onion.path} ${escapeShellArg onion.path}/authorized_clients
              '' ++
              imap0 (i: pubKey: ''
                echo ${pubKey} |
                install -o tor -g tor -m 0400 /dev/stdin ${escapeShellArg onion.path}/authorized_clients/${toString i}.auth
              '') onion.authorizedClients ++
              optional (onion.secretKey != null) ''
                install -d -o tor -g tor -m 0700 ${escapeShellArg onion.path}
                key="$(cut -f1 -d: ${escapeShellArg onion.secretKey} | head -1)"
                case "$key" in
                 ("== ed25519v"*"-secret")
                  install -o tor -g tor -m 0400 ${escapeShellArg onion.secretKey} ${escapeShellArg onion.path}/hs_ed25519_secret_key;;
                 (*) echo >&2 "NixOS does not (yet) support secret key type for onion: ${name}"; exit 1;;
                esac
              ''
            ) cfg.relay.onionServices ++
            mapAttrsToList (name: onion: imap0 (i: prvKeyPath:
              let hostname = removeSuffix ".onion" name; in ''
              printf "%s:" ${escapeShellArg hostname} | cat - ${escapeShellArg prvKeyPath} |
              install -o tor -g tor -m 0700 /dev/stdin \
               ${runDir}/ClientOnionAuthDir/${escapeShellArg hostname}.${toString i}.auth_private
            '') onion.clientAuthorizations)
            cfg.client.onionServices
          ))))
        ];
        ExecStart = "${cfg.package}/bin/tor -f ${torrc}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        KillSignal = "SIGINT";
        TimeoutSec = cfg.settings.ShutdownWaitLength + 30; # Wait a bit longer than ShutdownWaitLength before actually timing out
        Restart = "on-failure";
        LimitNOFILE = 32768;
        RuntimeDirectory = [
          # g+x allows access to the control socket
          "tor"
          "tor/root"
          # g+x can't be removed in ExecStart=, but will be removed by Tor
          "tor/ClientOnionAuthDir"
        ];
        RuntimeDirectoryMode = "0710";
        StateDirectoryMode = "0700";
        StateDirectory = [
            "tor"
            "tor/onion"
          ] ++
          flatten (mapAttrsToList (name: onion:
            optional (onion.secretKey == null) "tor/onion/${name}"
          ) cfg.relay.onionServices);
        # The following options are only to optimize:
        # systemd-analyze security tor
        RootDirectory = runDir + "/root";
        RootDirectoryStartOnly = true;
        #InaccessiblePaths = [ "-+${runDir}/root" ];
        UMask = "0066";
        BindPaths = [ stateDir ];
        BindReadOnlyPaths = [ storeDir "/etc" ] ++
          optionals config.services.resolved.enable [
            "/run/systemd/resolve/stub-resolv.conf"
            "/run/systemd/resolve/resolv.conf"
          ];
        AmbientCapabilities   = [""] ++ lib.optional bindsPrivilegedPort "CAP_NET_BIND_SERVICE";
        CapabilityBoundingSet = [""] ++ lib.optional bindsPrivilegedPort "CAP_NET_BIND_SERVICE";
        # ProtectClock= adds DeviceAllow=char-rtc r
        DeviceAllow = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateNetwork = mkDefault false;
        PrivateTmp = true;
        # Tor cannot currently bind privileged port when PrivateUsers=true,
        # see https://gitlab.torproject.org/legacy/trac/-/issues/20930
        PrivateUsers = !bindsPrivilegedPort;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" "AF_NETLINK" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        # See also the finer but experimental option settings.Sandbox
        SystemCallFilter = [
          "@system-service"
          # Groups in @system-service which do not contain a syscall listed by:
          # perf stat -x, 2>perf.log -e 'syscalls:sys_enter_*' tor
          # in tests, and seem likely not necessary for tor.
          "~@aio" "~@chown" "~@keyring" "~@memlock" "~@resources" "~@setuid" "~@timer"
        ];
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
      };
    };

    environment.systemPackages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [ julm ];
}

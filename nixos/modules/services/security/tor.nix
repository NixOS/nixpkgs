{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.services.tor;
  opt = options.services.tor;
  stateDir = "/var/lib/tor";
  runDir = "/run/tor";
  descriptionGeneric = option: ''
    See [torrc manual](https://2019.www.torproject.org/docs/tor-manual.html.en#${option}).
  '';
  bindsPrivilegedPort =
    lib.any
      (
        p0:
        let
          p1 = if p0 ? "port" then p0.port else p0;
        in
        if p1 == "auto" then
          false
        else
          let
            p2 = if lib.isInt p1 then p1 else lib.toInt p1;
          in
          p1 != null && 0 < p2 && p2 < 1024
      )
      (
        lib.flatten [
          cfg.settings.ORPort
          cfg.settings.DirPort
          cfg.settings.DNSPort
          cfg.settings.ExtORPort
          cfg.settings.HTTPTunnelPort
          cfg.settings.NATDPort
          cfg.settings.SOCKSPort
          cfg.settings.TransPort
        ]
      );
  optionBool =
    optionName:
    lib.mkOption {
      type = with lib.types; nullOr bool;
      default = null;
      description = (descriptionGeneric optionName);
    };
  optionInt =
    optionName:
    lib.mkOption {
      type = with lib.types; nullOr int;
      default = null;
      description = (descriptionGeneric optionName);
    };
  optionString =
    optionName:
    lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      description = (descriptionGeneric optionName);
    };
  optionStrings =
    optionName:
    lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = (descriptionGeneric optionName);
    };
  optionAddress = lib.mkOption {
    type = with lib.types; nullOr str;
    default = null;
    example = "0.0.0.0";
    description = ''
      IPv4 or IPv6 (if between brackets) address.
    '';
  };
  optionUnix = lib.mkOption {
    type = with lib.types; nullOr path;
    default = null;
    description = ''
      Unix domain socket path to use.
    '';
  };
  optionPort = lib.mkOption {
    type =
      with lib.types;
      nullOr (oneOf [
        port
        (enum [ "auto" ])
      ]);
    default = null;
  };
  optionPorts =
    optionName:
    lib.mkOption {
      type = with lib.types; listOf port;
      default = [ ];
      description = (descriptionGeneric optionName);
    };
  optionIsolablePort =
    with lib.types;
    oneOf [
      port
      (enum [ "auto" ])
      (submodule (
        { config, ... }:
        {
          options = {
            addr = optionAddress;
            port = optionPort;
            flags = optionFlags;
            SessionGroup = lib.mkOption {
              type = nullOr int;
              default = null;
            };
          }
          // lib.genAttrs isolateFlags (
            name:
            lib.mkOption {
              type = types.bool;
              default = false;
            }
          );
          config = {
            flags =
              lib.filter (name: config.${name} == true) isolateFlags
              ++ lib.optional (config.SessionGroup != null) "SessionGroup=${toString config.SessionGroup}";
          };
        }
      ))
    ];
  optionIsolablePorts =
    optionName:
    lib.mkOption {
      default = [ ];
      type = with lib.types; either optionIsolablePort (listOf optionIsolablePort);
      description = (descriptionGeneric optionName);
    };
  isolateFlags = [
    "IsolateClientAddr"
    "IsolateClientProtocol"
    "IsolateDestAddr"
    "IsolateDestPort"
    "IsolateSOCKSAuth"
    "KeepAliveIsolateSOCKSAuth"
  ];
  optionSOCKSPort =
    doConfig:
    let
      flags = [
        "CacheDNS"
        "CacheIPv4DNS"
        "CacheIPv6DNS"
        "GroupWritable"
        "IPv6Traffic"
        "NoDNSRequest"
        "NoIPv4Traffic"
        "NoOnionTraffic"
        "OnionTrafficOnly"
        "PreferIPv6"
        "PreferIPv6Automap"
        "PreferSOCKSNoAuth"
        "UseDNSCache"
        "UseIPv4Cache"
        "UseIPv6Cache"
        "WorldWritable"
      ]
      ++ isolateFlags;
    in
    with lib.types;
    oneOf [
      port
      (submodule (
        { config, ... }:
        {
          options = {
            unix = optionUnix;
            addr = optionAddress;
            port = optionPort;
            flags = optionFlags;
            SessionGroup = lib.mkOption {
              type = nullOr int;
              default = null;
            };
          }
          // lib.genAttrs flags (
            name:
            lib.mkOption {
              type = types.bool;
              default = false;
            }
          );
          config = lib.mkIf doConfig {
            # Only add flags in SOCKSPort to avoid duplicates
            flags =
              lib.filter (name: config.${name} == true) flags
              ++ lib.optional (config.SessionGroup != null) "SessionGroup=${toString config.SessionGroup}";
          };
        }
      ))
    ];
  optionFlags = lib.mkOption {
    type = with lib.types; listOf str;
    default = [ ];
  };
  optionORPort =
    optionName:
    lib.mkOption {
      default = [ ];
      example = 443;
      type =
        with lib.types;
        oneOf [
          port
          (enum [ "auto" ])
          (listOf (oneOf [
            port
            (enum [ "auto" ])
            (submodule (
              { config, ... }:
              let
                flags = [
                  "IPv4Only"
                  "IPv6Only"
                  "NoAdvertise"
                  "NoListen"
                ];
              in
              {
                options = {
                  addr = optionAddress;
                  port = optionPort;
                  flags = optionFlags;
                }
                // lib.genAttrs flags (
                  name:
                  lib.mkOption {
                    type = types.bool;
                    default = false;
                  }
                );
                config = {
                  flags = lib.filter (name: config.${name} == true) flags;
                };
              }
            ))
          ]))
        ];
      description = (descriptionGeneric optionName);
    };
  optionBandwidth =
    optionName:
    lib.mkOption {
      type = with lib.types; nullOr (either int str);
      default = null;
      description = (descriptionGeneric optionName);
    };
  optionPath =
    optionName:
    lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      description = (descriptionGeneric optionName);
    };

  mkValueString =
    k: v:
    if v == null then
      ""
    else if lib.isBool v then
      (if v then "1" else "0")
    else if v ? "unix" && v.unix != null then
      "unix:" + v.unix + lib.optionalString (v ? "flags") (" " + lib.concatStringsSep " " v.flags)
    else if v ? "port" && v.port != null then
      lib.optionalString (v ? "addr" && v.addr != null) "${v.addr}:"
      + toString v.port
      + lib.optionalString (v ? "flags") (" " + lib.concatStringsSep " " v.flags)
    else if k == "ServerTransportPlugin" then
      lib.optionalString (v.transports != [ ]) "${lib.concatStringsSep "," v.transports} exec ${v.exec}"
    else if k == "HidServAuth" then
      v.onion + " " + v.auth
    else
      lib.generators.mkValueStringDefault { } v;
  genTorrc =
    settings:
    lib.generators.toKeyValue
      {
        listsAsDuplicateKeys = true;
        mkKeyValue = k: lib.generators.mkKeyValueDefault { mkValueString = mkValueString k; } " " k;
      }
      (
        lib.mapAttrs (
          k: v:
          # Not necessary, but prettier rendering
          if
            lib.elem k [
              "AutomapHostsSuffixes"
              "DirPolicy"
              "ExitPolicy"
              "SocksPolicy"
            ]
            && v != [ ]
          then
            lib.concatStringsSep "," v
          else
            v
        ) (lib.filterAttrs (k: v: !(v == null || v == "")) settings)
      );
  torrc = pkgs.writeText "torrc" (
    genTorrc cfg.settings
    + lib.concatStrings (
      lib.mapAttrsToList (
        name: onion: "HiddenServiceDir ${onion.path}\n" + genTorrc onion.settings
      ) cfg.relay.onionServices
    )
  );
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "tor" "client" "dns" "automapHostsSuffixes" ]
      [ "services" "tor" "settings" "AutomapHostsSuffixes" ]
    )
    (lib.mkRemovedOptionModule [
      "services"
      "tor"
      "client"
      "dns"
      "isolationOptions"
    ] "Use services.tor.settings.DNSPort instead.")
    (lib.mkRemovedOptionModule [
      "services"
      "tor"
      "client"
      "dns"
      "listenAddress"
    ] "Use services.tor.settings.DNSPort instead.")
    (lib.mkRemovedOptionModule [
      "services"
      "tor"
      "client"
      "privoxy"
      "enable"
    ] "Use services.privoxy.enable and services.privoxy.enableTor instead.")
    (lib.mkRemovedOptionModule [
      "services"
      "tor"
      "client"
      "socksIsolationOptions"
    ] "Use services.tor.settings.SOCKSPort instead.")
    (lib.mkRemovedOptionModule [
      "services"
      "tor"
      "client"
      "socksListenAddressFaster"
    ] "Use services.tor.settings.SOCKSPort instead.")
    (lib.mkRenamedOptionModule
      [ "services" "tor" "client" "socksPolicy" ]
      [ "services" "tor" "settings" "SocksPolicy" ]
    )
    (lib.mkRemovedOptionModule [
      "services"
      "tor"
      "client"
      "transparentProxy"
      "isolationOptions"
    ] "Use services.tor.settings.TransPort instead.")
    (lib.mkRemovedOptionModule [
      "services"
      "tor"
      "client"
      "transparentProxy"
      "listenAddress"
    ] "Use services.tor.settings.TransPort instead.")
    (lib.mkRenamedOptionModule
      [ "services" "tor" "controlPort" ]
      [ "services" "tor" "settings" "ControlPort" ]
    )
    (lib.mkRemovedOptionModule [
      "services"
      "tor"
      "extraConfig"
    ] "Please use services.tor.settings instead.")
    (lib.mkRenamedOptionModule
      [ "services" "tor" "hiddenServices" ]
      [ "services" "tor" "relay" "onionServices" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "tor" "relay" "accountingMax" ]
      [ "services" "tor" "settings" "AccountingMax" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "tor" "relay" "accountingStart" ]
      [ "services" "tor" "settings" "AccountingStart" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "tor" "relay" "address" ]
      [ "services" "tor" "settings" "Address" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "tor" "relay" "bandwidthBurst" ]
      [ "services" "tor" "settings" "BandwidthBurst" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "tor" "relay" "bandwidthRate" ]
      [ "services" "tor" "settings" "BandwidthRate" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "tor" "relay" "bridgeTransports" ]
      [ "services" "tor" "settings" "ServerTransportPlugin" "transports" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "tor" "relay" "contactInfo" ]
      [ "services" "tor" "settings" "ContactInfo" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "tor" "relay" "exitPolicy" ]
      [ "services" "tor" "settings" "ExitPolicy" ]
    )
    (lib.mkRemovedOptionModule [
      "services"
      "tor"
      "relay"
      "isBridge"
    ] "Use services.tor.relay.role instead.")
    (lib.mkRemovedOptionModule [
      "services"
      "tor"
      "relay"
      "isExit"
    ] "Use services.tor.relay.role instead.")
    (lib.mkRenamedOptionModule
      [ "services" "tor" "relay" "nickname" ]
      [ "services" "tor" "settings" "Nickname" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "tor" "relay" "port" ]
      [ "services" "tor" "settings" "ORPort" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "tor" "relay" "portSpec" ]
      [ "services" "tor" "settings" "ORPort" ]
    )
  ];

  options = {
    services.tor = {
      enable = lib.mkEnableOption ''
        Tor daemon.
                By default, the daemon is run without
                relay, exit, bridge or client connectivity'';

      openFirewall = lib.mkEnableOption "opening of the relay port(s) in the firewall";

      package = lib.mkPackageOption pkgs "tor" { };

      obfs4Package = lib.mkPackageOption pkgs "obfs4" { };

      enableGeoIP =
        lib.mkEnableOption ''
          use of GeoIP databases.
                  Disabling this will disable by-country statistics for bridges and relays
                  and some client and third-party software functionality''
        // {
          default = true;
        };

      controlSocket.enable = lib.mkEnableOption ''
        control socket,
                created in `${runDir}/control`'';

      client = {
        enable = lib.mkEnableOption ''
          the routing of application connections.
                    You might want to disable this if you plan running a dedicated Tor relay'';

        transparentProxy.enable = lib.mkEnableOption "transparent proxy";
        dns.enable = lib.mkEnableOption "DNS resolver";

        socksListenAddress = lib.mkOption {
          type = optionSOCKSPort false;
          default = {
            addr = "127.0.0.1";
            port = 9050;
            IsolateDestAddr = true;
          };
          example = {
            addr = "192.168.0.1";
            port = 9090;
            IsolateDestAddr = true;
          };
          description = ''
            Bind to this address to listen for connections from
            Socks-speaking applications.
          '';
        };

        onionServices = lib.mkOption {
          description = (descriptionGeneric "HiddenServiceDir");
          default = { };
          example = {
            "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" = {
              clientAuthorizations = [ "/run/keys/tor/alice.prv.x25519" ];
            };
          };
          type = lib.types.attrsOf (
            lib.types.submodule (
              { ... }:
              {
                options.clientAuthorizations = lib.mkOption {
                  description = ''
                    Clients' authorizations for a v3 onion service,
                    as a list of files containing each one private key, in the format:
                    ```
                    descriptor:x25519:<base32-private-key>
                    ```
                    ${descriptionGeneric "_client_authorization"}
                  '';
                  type = with lib.types; listOf path;
                  default = [ ];
                  example = [ "/run/keys/tor/alice.prv.x25519" ];
                };
              }
            )
          );
        };
      };

      relay = {
        enable = lib.mkEnableOption "tor relaying" // {
          description = ''
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

        role = lib.mkOption {
          type = lib.types.enum [
            "exit"
            "relay"
            "bridge"
            "private-bridge"
          ];
          description = ''
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

        onionServices = lib.mkOption {
          description = (descriptionGeneric "HiddenServiceDir");
          default = { };
          example = {
            "example.org/www" = {
              map = [ 80 ];
              authorizedClients = [
                "descriptor:x25519:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
              ];
            };
          };
          type = lib.types.attrsOf (
            lib.types.submodule (
              { name, config, ... }:
              {
                options.path = lib.mkOption {
                  type = lib.types.path;
                  description = ''
                    Path where to store the data files of the hidden service.
                    If the {option}`secretKey` is null
                    this defaults to `${stateDir}/onion/$onion`,
                    otherwise to `${runDir}/onion/$onion`.
                  '';
                };
                options.secretKey = lib.mkOption {
                  type = with lib.types; nullOr path;
                  default = null;
                  example = "/run/keys/tor/onion/expyuzz4wqqyqhjn/hs_ed25519_secret_key";
                  description = ''
                    Secret key of the onion service.
                    If null, Tor reuses any preexisting secret key (in {option}`path`)
                    or generates a new one.
                    The associated public key and hostname are deterministically regenerated
                    from this file if they do not exist.
                  '';
                };
                options.authorizeClient = lib.mkOption {
                  description = (descriptionGeneric "HiddenServiceAuthorizeClient");
                  default = null;
                  type = lib.types.nullOr (
                    lib.types.submodule (
                      { ... }:
                      {
                        options = {
                          authType = lib.mkOption {
                            type = lib.types.enum [
                              "basic"
                              "stealth"
                            ];
                            description = ''
                              Either `"basic"` for a general-purpose authorization protocol
                              or `"stealth"` for a less scalable protocol
                              that also hides service activity from unauthorized clients.
                            '';
                          };
                          clientNames = lib.mkOption {
                            type = with lib.types; nonEmptyListOf (strMatching "[A-Za-z0-9+-_]+");
                            description = ''
                              Only clients that are listed here are authorized to access the hidden service.
                              Generated authorization data can be found in {file}`${stateDir}/onion/$name/hostname`.
                              Clients need to put this authorization data in their configuration file using
                              [](#opt-services.tor.settings.HidServAuth).
                            '';
                          };
                        };
                      }
                    )
                  );
                };
                options.authorizedClients = lib.mkOption {
                  description = ''
                    Authorized clients for a v3 onion service,
                    as a list of public key, in the format:
                    ```
                    descriptor:x25519:<base32-public-key>
                    ```
                    ${descriptionGeneric "_client_authorization"}
                  '';
                  type = with lib.types; listOf str;
                  default = [ ];
                  example = [ "descriptor:x25519:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" ];
                };
                options.map = lib.mkOption {
                  description = (descriptionGeneric "HiddenServicePort");
                  type =
                    with lib.types;
                    listOf (oneOf [
                      port
                      (submodule (
                        { ... }:
                        {
                          options = {
                            port = optionPort;
                            target = lib.mkOption {
                              default = null;
                              type = nullOr (
                                submodule (
                                  { ... }:
                                  {
                                    options = {
                                      unix = optionUnix;
                                      addr = optionAddress;
                                      port = optionPort;
                                    };
                                  }
                                )
                              );
                            };
                          };
                        }
                      ))
                    ]);
                  apply = map (
                    v:
                    if lib.isInt v then
                      {
                        port = v;
                        target = null;
                      }
                    else
                      v
                  );
                };
                options.version = lib.mkOption {
                  description = (descriptionGeneric "HiddenServiceVersion");
                  type =
                    with lib.types;
                    nullOr (enum [
                      2
                      3
                    ]);
                  default = null;
                };
                options.settings = lib.mkOption {
                  description = ''
                    Settings of the onion service.
                    ${descriptionGeneric "_hidden_service_options"}
                  '';
                  default = { };
                  type = lib.types.submodule {
                    freeformType =
                      with lib.types;
                      (attrsOf (
                        nullOr (oneOf [
                          str
                          int
                          bool
                          (listOf str)
                        ])
                      ))
                      // {
                        description = "settings option";
                      };
                    options.HiddenServiceAllowUnknownPorts = optionBool "HiddenServiceAllowUnknownPorts";
                    options.HiddenServiceDirGroupReadable = optionBool "HiddenServiceDirGroupReadable";
                    options.HiddenServiceExportCircuitID = lib.mkOption {
                      description = (descriptionGeneric "HiddenServiceExportCircuitID");
                      type = with lib.types; nullOr (enum [ "haproxy" ]);
                      default = null;
                    };
                    options.HiddenServiceMaxStreams = lib.mkOption {
                      description = (descriptionGeneric "HiddenServiceMaxStreams");
                      type = with lib.types; nullOr ints.u16;
                      default = null;
                    };
                    options.HiddenServiceMaxStreamsCloseCircuit = optionBool "HiddenServiceMaxStreamsCloseCircuit";
                    options.HiddenServiceNumIntroductionPoints = lib.mkOption {
                      description = (descriptionGeneric "HiddenServiceNumIntroductionPoints");
                      type = with lib.types; nullOr (ints.between 0 20);
                      default = null;
                    };
                    options.HiddenServiceSingleHopMode = optionBool "HiddenServiceSingleHopMode";
                    options.RendPostPeriod = optionString "RendPostPeriod";
                  };
                };
                config = {
                  path = lib.mkDefault ((if config.secretKey == null then stateDir else runDir) + "/onion/${name}");
                  settings.HiddenServiceVersion = config.version;
                  settings.HiddenServiceAuthorizeClient =
                    if config.authorizeClient != null then
                      config.authorizeClient.authType + " " + lib.concatStringsSep "," config.authorizeClient.clientNames
                    else
                      null;
                  settings.HiddenServicePort = map (
                    p: mkValueString "" p.port + " " + mkValueString "" p.target
                  ) config.map;
                };
              }
            )
          );
        };
      };

      settings = lib.mkOption {
        description = ''
          See [torrc manual](https://2019.www.torproject.org/docs/tor-manual.html.en)
          for documentation.
        '';
        default = { };
        type = lib.types.submodule {
          freeformType =
            with lib.types;
            (attrsOf (
              nullOr (oneOf [
                str
                int
                bool
                (listOf str)
              ])
            ))
            // {
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
            default = [
              ".onion"
              ".exit"
            ];
            example = [ ".onion" ];
          };
          options.BandwidthBurst = optionBandwidth "BandwidthBurst";
          options.BandwidthRate = optionBandwidth "BandwidthRate";
          options.BridgeAuthoritativeDir = optionBool "BridgeAuthoritativeDir";
          options.BridgeRecordUsageByCountry = optionBool "BridgeRecordUsageByCountry";
          options.BridgeRelay = optionBool "BridgeRelay" // {
            default = false;
          };
          options.CacheDirectory = optionPath "CacheDirectory";
          options.CacheDirectoryGroupReadable = optionBool "CacheDirectoryGroupReadable"; # default is null and like "auto"
          options.CellStatistics = optionBool "CellStatistics";
          options.ClientAutoIPv6ORPort = optionBool "ClientAutoIPv6ORPort";
          options.ClientDNSRejectInternalAddresses = optionBool "ClientDNSRejectInternalAddresses";
          options.ClientOnionAuthDir = lib.mkOption {
            description = (descriptionGeneric "ClientOnionAuthDir");
            default = null;
            type = with lib.types; nullOr path;
          };
          options.ClientPreferIPv6DirPort = optionBool "ClientPreferIPv6DirPort"; # default is null and like "auto"
          options.ClientPreferIPv6ORPort = optionBool "ClientPreferIPv6ORPort"; # default is null and like "auto"
          options.ClientRejectInternalAddresses = optionBool "ClientRejectInternalAddresses";
          options.ClientUseIPv4 = optionBool "ClientUseIPv4";
          options.ClientUseIPv6 = optionBool "ClientUseIPv6";
          options.ConnDirectionStatistics = optionBool "ConnDirectionStatistics";
          options.ConstrainedSockets = optionBool "ConstrainedSockets";
          options.ContactInfo = optionString "ContactInfo";
          options.ControlPort = lib.mkOption {
            description = (descriptionGeneric "ControlPort");
            default = [ ];
            example = [ { port = 9051; } ];
            type =
              with lib.types;
              oneOf [
                port
                (enum [ "auto" ])
                (listOf (oneOf [
                  port
                  (enum [ "auto" ])
                  (submodule (
                    { config, ... }:
                    let
                      flags = [
                        "GroupWritable"
                        "RelaxDirModeCheck"
                        "WorldWritable"
                      ];
                    in
                    {
                      options = {
                        unix = optionUnix;
                        flags = optionFlags;
                        addr = optionAddress;
                        port = optionPort;
                      }
                      // lib.genAttrs flags (
                        name:
                        lib.mkOption {
                          type = types.bool;
                          default = false;
                        }
                      );
                      config = {
                        flags = lib.filter (name: config.${name} == true) flags;
                      };
                    }
                  ))
                ]))
              ];
          };
          options.ControlPortFileGroupReadable = optionBool "ControlPortFileGroupReadable";
          options.ControlPortWriteToFile = optionPath "ControlPortWriteToFile";
          options.ControlSocket = optionPath "ControlSocket";
          options.ControlSocketsGroupWritable = optionBool "ControlSocketsGroupWritable";
          options.CookieAuthFile = optionPath "CookieAuthFile";
          options.CookieAuthFileGroupReadable = optionBool "CookieAuthFileGroupReadable";
          options.CookieAuthentication = optionBool "CookieAuthentication";
          options.DataDirectory = optionPath "DataDirectory" // {
            default = stateDir;
          };
          options.DataDirectoryGroupReadable = optionBool "DataDirectoryGroupReadable";
          options.DirPortFrontPage = optionPath "DirPortFrontPage";
          options.DirAllowPrivateAddresses = optionBool "DirAllowPrivateAddresses";
          options.DormantCanceledByStartup = optionBool "DormantCanceledByStartup";
          options.DormantOnFirstStartup = optionBool "DormantOnFirstStartup";
          options.DormantTimeoutDisabledByIdleStreams = optionBool "DormantTimeoutDisabledByIdleStreams";
          options.DirCache = optionBool "DirCache";
          options.DirPolicy = lib.mkOption {
            description = (descriptionGeneric "DirPolicy");
            type = with lib.types; listOf str;
            default = [ ];
            example = [ "accept *:*" ];
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
            default = [ "reject *:*" ];
            example = [ "accept *:*" ];
          };
          options.ExitPolicyRejectLocalInterfaces = optionBool "ExitPolicyRejectLocalInterfaces";
          options.ExitPolicyRejectPrivate = optionBool "ExitPolicyRejectPrivate";
          options.ExitPortStatistics = optionBool "ExitPortStatistics";
          options.ExitRelay = optionBool "ExitRelay"; # default is null and like "auto"
          options.ExtORPort = lib.mkOption {
            description = (descriptionGeneric "ExtORPort");
            default = null;
            type =
              with lib.types;
              nullOr (oneOf [
                port
                (enum [ "auto" ])
                (submodule (
                  { ... }:
                  {
                    options = {
                      addr = optionAddress;
                      port = optionPort;
                    };
                  }
                ))
              ]);
            apply = p: if lib.isInt p || lib.isString p then { port = p; } else p;
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
          options.HidServAuth = lib.mkOption {
            description = (descriptionGeneric "HidServAuth");
            default = [ ];
            type =
              with lib.types;
              listOf (oneOf [
                (submodule {
                  options = {
                    onion = lib.mkOption {
                      type = strMatching "[a-z2-7]{16}\\.onion";
                      description = "Onion address.";
                      example = "xxxxxxxxxxxxxxxx.onion";
                    };
                    auth = lib.mkOption {
                      type = strMatching "[A-Za-z0-9+/]{22}";
                      description = "Authentication cookie.";
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
          options.Nickname = lib.mkOption {
            type = with lib.types; nullOr (strMatching "^[a-zA-Z0-9]{1,19}$");
            default = null;
            description = (descriptionGeneric "Nickname");
          };
          options.ORPort = optionORPort "ORPort";
          options.OfflineMasterKey = optionBool "OfflineMasterKey";
          options.OptimisticData = optionBool "OptimisticData"; # default is null and like "auto"
          options.PaddingStatistics = optionBool "PaddingStatistics";
          options.PerConnBWBurst = optionBandwidth "PerConnBWBurst";
          options.PerConnBWRate = optionBandwidth "PerConnBWRate";
          options.PidFile = optionPath "PidFile";
          options.ProtocolWarnings = optionBool "ProtocolWarnings";
          options.PublishHidServDescriptors = optionBool "PublishHidServDescriptors";
          options.PublishServerDescriptor = lib.mkOption {
            description = (descriptionGeneric "PublishServerDescriptor");
            type =
              with lib.types;
              nullOr (enum [
                false
                true
                0
                1
                "0"
                "1"
                "v3"
                "bridge"
              ]);
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
          options.ServerTransportPlugin = lib.mkOption {
            description = (descriptionGeneric "ServerTransportPlugin");
            default = null;
            type =
              with lib.types;
              nullOr (
                submodule (
                  { ... }:
                  {
                    options = {
                      transports = lib.mkOption {
                        description = "List of pluggable transports.";
                        type = listOf str;
                        example = [
                          "obfs2"
                          "obfs3"
                          "obfs4"
                          "scramblesuit"
                        ];
                      };
                      exec = lib.mkOption {
                        type = types.str;
                        description = "Command of pluggable transport.";
                      };
                    };
                  }
                )
              );
          };
          options.ShutdownWaitLength = lib.mkOption {
            type = lib.types.int;
            default = 30;
            description = (descriptionGeneric "ShutdownWaitLength");
          };
          options.SocksPolicy = optionStrings "SocksPolicy" // {
            example = [ "accept *:*" ];
          };
          options.SOCKSPort = lib.mkOption {
            description = (descriptionGeneric "SOCKSPort");
            default = lib.optionals cfg.settings.HiddenServiceNonAnonymousMode [ { port = 0; } ];
            defaultText = lib.literalExpression ''
              if config.${opt.settings}.HiddenServiceNonAnonymousMode == true
              then [ { port = 0; } ]
              else [ ]
            '';
            example = [ { port = 9090; } ];
            type = lib.types.listOf (optionSOCKSPort true);
          };
          options.TestingTorNetwork = optionBool "TestingTorNetwork";
          options.TransPort = optionIsolablePorts "TransPort";
          options.TransProxyType = lib.mkOption {
            description = (descriptionGeneric "TransProxyType");
            type =
              with lib.types;
              nullOr (enum [
                "default"
                "TPROXY"
                "ipfw"
                "pf-divert"
              ]);
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

  config = lib.mkIf cfg.enable {
    # Not sure if `cfg.relay.role == "private-bridge"` helps as tor
    # sends a lot of stats
    warnings =
      lib.optional
        (
          cfg.settings.BridgeRelay
          && lib.flatten (lib.mapAttrsToList (n: o: o.map) cfg.relay.onionServices) != [ ]
        )
        ''
          Running Tor hidden services on a public relay makes the
          presence of hidden services visible through simple statistical
          analysis of publicly available data.
          See https://trac.torproject.org/projects/tor/ticket/8742

          You can safely ignore this warning if you don't intend to
          actually hide your hidden services. In either case, you can
          always create a container/VM with a separate Tor daemon instance.
        ''
      ++ lib.flatten (
        lib.mapAttrsToList (
          n: o:
          lib.optionals (o.settings.HiddenServiceVersion == 2) [
            (lib.optional (o.settings.HiddenServiceExportCircuitID != null) ''
              HiddenServiceExportCircuitID is used in the HiddenService: ${n}
              but this option is only for v3 hidden services.
            '')
          ]
          ++ lib.optionals (o.settings.HiddenServiceVersion != 2) [
            (lib.optional (o.settings.HiddenServiceAuthorizeClient != null) ''
              HiddenServiceAuthorizeClient is used in the HiddenService: ${n}
              but this option is only for v2 hidden services.
            '')
            (lib.optional (o.settings.RendPostPeriod != null) ''
              RendPostPeriod is used in the HiddenService: ${n}
              but this option is only for v2 hidden services.
            '')
          ]
        ) cfg.relay.onionServices
      );

    users.groups.tor.gid = config.ids.gids.tor;
    users.users.tor = {
      description = "Tor Daemon User";
      createHome = true;
      home = stateDir;
      group = "tor";
      uid = config.ids.uids.tor;
    };

    services.tor.settings = lib.mkMerge [
      (lib.mkIf cfg.enableGeoIP {
        GeoIPFile = "${cfg.package.geoip}/share/tor/geoip";
        GeoIPv6File = "${cfg.package.geoip}/share/tor/geoip6";
      })
      (lib.mkIf cfg.controlSocket.enable {
        ControlPort = [
          {
            unix = runDir + "/control";
            GroupWritable = true;
            RelaxDirModeCheck = true;
          }
        ];
      })
      (lib.mkIf cfg.relay.enable (
        lib.optionalAttrs (cfg.relay.role != "exit") {
          ExitPolicy = lib.mkForce [ "reject *:*" ];
        }
        //
          lib.optionalAttrs
            (lib.elem cfg.relay.role [
              "bridge"
              "private-bridge"
            ])
            {
              BridgeRelay = true;
              ExtORPort.port = lib.mkDefault "auto";
              ServerTransportPlugin.transports = lib.mkDefault [ "obfs4" ];
              ServerTransportPlugin.exec = lib.mkDefault "${lib.getExe cfg.obfs4Package} managed";
            }
        // lib.optionalAttrs (cfg.relay.role == "private-bridge") {
          ExtraInfoStatistics = false;
          PublishServerDescriptor = false;
        }
      ))
      (lib.mkIf (!cfg.relay.enable) {
        # Avoid surprises when leaving ORPort/DirPort configurations in cfg.settings,
        # because it would still enable Tor as a relay,
        # which can trigger all sort of problems when not carefully done,
        # like the blocklisting of the machine's IP addresses
        # by some hosting providers...
        DirPort = lib.mkForce [ ];
        ORPort = lib.mkForce [ ];
        PublishServerDescriptor = lib.mkForce false;
      })
      (lib.mkIf (!cfg.client.enable) {
        # Make sure application connections via SOCKS are disabled
        # when services.tor.client.enable is false
        SOCKSPort = lib.mkForce [ 0 ];
      })
      (lib.mkIf cfg.client.enable (
        {
          SOCKSPort = [ cfg.client.socksListenAddress ];
        }
        // lib.optionalAttrs cfg.client.transparentProxy.enable {
          TransPort = [
            {
              addr = "127.0.0.1";
              port = 9040;
            }
          ];
        }
        // lib.optionalAttrs cfg.client.dns.enable {
          DNSPort = [
            {
              addr = "127.0.0.1";
              port = 9053;
            }
          ];
          AutomapHostsOnResolve = true;
        }
        //
          lib.optionalAttrs
            (lib.flatten (lib.mapAttrsToList (n: o: o.clientAuthorizations) cfg.client.onionServices) != [ ])
            {
              ClientOnionAuthDir = runDir + "/ClientOnionAuthDir";
            }
      ))
    ];

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts =
        lib.concatMap
          (
            o:
            if lib.isInt o && o > 0 then
              [ o ]
            else
              lib.optionals (o ? "port" && lib.isInt o.port && o.port > 0) [ o.port ]
          )
          (
            lib.flatten [
              cfg.settings.ORPort
              cfg.settings.DirPort
            ]
          );
    };

    systemd.services.tor = {
      description = "Tor Daemon";
      documentation = [ "man:tor(8)" ];
      path = [ cfg.package ];

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      restartTriggers = [ torrc ];

      serviceConfig = {
        Type = "simple";
        User = "tor";
        Group = "tor";
        ExecStartPre = [
          "${cfg.package}/bin/tor -f ${torrc} --verify-config"
          # DOC: Appendix G of https://spec.torproject.org/rend-spec-v3
          (
            "+"
            + pkgs.writeShellScript "ExecStartPre" (
              lib.concatStringsSep "\n" (
                lib.flatten (
                  [ "set -eu" ]
                  ++ lib.mapAttrsToList (
                    name: onion:
                    lib.optional (onion.authorizedClients != [ ]) ''
                      rm -rf ${lib.escapeShellArg onion.path}/authorized_clients
                      install -d -o tor -g tor -m 0700 ${lib.escapeShellArg onion.path} ${lib.escapeShellArg onion.path}/authorized_clients
                    ''
                    ++ lib.imap0 (i: pubKey: ''
                      echo ${pubKey} |
                      install -o tor -g tor -m 0400 /dev/stdin ${lib.escapeShellArg onion.path}/authorized_clients/${toString i}.auth
                    '') onion.authorizedClients
                    ++ lib.optional (onion.secretKey != null) ''
                      install -d -o tor -g tor -m 0700 ${lib.escapeShellArg onion.path}
                      key="$(cut -f1 -d: ${lib.escapeShellArg onion.secretKey} | head -1)"
                      case "$key" in
                       ("== ed25519v"*"-secret")
                        install -o tor -g tor -m 0400 ${lib.escapeShellArg onion.secretKey} ${lib.escapeShellArg onion.path}/hs_ed25519_secret_key;;
                       (*) echo >&2 "NixOS does not (yet) support secret key type for onion: ${name}"; exit 1;;
                      esac
                    ''
                  ) cfg.relay.onionServices
                  ++ lib.mapAttrsToList (
                    name: onion:
                    lib.imap0 (
                      i: prvKeyPath:
                      let
                        hostname = lib.removeSuffix ".onion" name;
                      in
                      ''
                        printf "%s:" ${lib.escapeShellArg hostname} | cat - ${lib.escapeShellArg prvKeyPath} |
                        install -o tor -g tor -m 0700 /dev/stdin \
                         ${runDir}/ClientOnionAuthDir/${lib.escapeShellArg hostname}.${toString i}.auth_private
                      ''
                    ) onion.clientAuthorizations
                  ) cfg.client.onionServices
                )
              )
            )
          )
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
        ]
        ++ lib.flatten (
          lib.mapAttrsToList (
            name: onion: lib.optional (onion.secretKey == null) "tor/onion/${name}"
          ) cfg.relay.onionServices
        );
        # The following options are only to optimize:
        # systemd-analyze security tor
        RootDirectory = runDir + "/root";
        RootDirectoryStartOnly = true;
        #InaccessiblePaths = [ "-+${runDir}/root" ];
        UMask = "0066";
        BindPaths = [
          stateDir
        ]
        ++ lib.filter (x: x != null) (
          lib.catAttrs "unix" (
            lib.filter (x: x != null) (
              lib.catAttrs "target" (
                lib.concatMap (onionService: onionService.map) (lib.attrValues cfg.relay.onionServices)
              )
            )
          )
        );
        BindReadOnlyPaths = [
          builtins.storeDir
          "/etc"
        ]
        ++ lib.optionals config.services.resolved.enable [
          "/run/systemd/resolve/stub-resolv.conf"
          "/run/systemd/resolve/resolv.conf"
        ];
        AmbientCapabilities = [ "" ] ++ lib.optional bindsPrivilegedPort "CAP_NET_BIND_SERVICE";
        CapabilityBoundingSet = [ "" ] ++ lib.optional bindsPrivilegedPort "CAP_NET_BIND_SERVICE";
        # ProtectClock= adds DeviceAllow=char-rtc r
        DeviceAllow = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateNetwork = lib.mkDefault false;
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
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        # See also the finer but experimental option settings.Sandbox
        SystemCallFilter = [
          "@system-service"
          # Groups in @system-service which do not contain a syscall listed by:
          # perf stat -x, 2>perf.log -e 'syscalls:sys_enter_*' tor
          # in tests, and seem likely not necessary for tor.
          "~@aio"
          "~@chown"
          "~@keyring"
          "~@memlock"
          "~@resources"
          "~@setuid"
          "~@timer"
        ];
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
      };
    };

    environment.systemPackages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [ julm ];
}

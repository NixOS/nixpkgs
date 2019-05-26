{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tor;
  torDirectory = "/var/lib/tor";
  torRunDirectory = "/run/tor";

  opt    = name: value: optionalString (value != null) "${name} ${value}";
  optint = name: value: optionalString (value != null && value != 0)    "${name} ${toString value}";

  isolationOptions = {
    type = types.listOf (types.enum [
      "IsolateClientAddr"
      "IsolateSOCKSAuth"
      "IsolateClientProtocol"
      "IsolateDestPort"
      "IsolateDestAddr"
    ]);
    default = [];
    example = [
      "IsolateClientAddr"
      "IsolateSOCKSAuth"
      "IsolateClientProtocol"
      "IsolateDestPort"
      "IsolateDestAddr"
    ];
    description = "Tor isolation options";
  };


  torRc = ''
    User tor
    DataDirectory ${torDirectory}
    ${optionalString cfg.enableGeoIP ''
      GeoIPFile ${pkgs.tor.geoip}/share/tor/geoip
      GeoIPv6File ${pkgs.tor.geoip}/share/tor/geoip6
    ''}

    ${optint "ControlPort" cfg.controlPort}
    ${optionalString cfg.controlSocket.enable "ControlPort unix:${torRunDirectory}/control GroupWritable RelaxDirModeCheck"}
  ''
  # Client connection config
  + optionalString cfg.client.enable ''
    SOCKSPort ${cfg.client.socksListenAddress} ${toString cfg.client.socksIsolationOptions}
    SOCKSPort ${cfg.client.socksListenAddressFaster}
    ${opt "SocksPolicy" cfg.client.socksPolicy}

    ${optionalString cfg.client.transparentProxy.enable ''
    TransPort ${cfg.client.transparentProxy.listenAddress} ${toString cfg.client.transparentProxy.isolationOptions}
    ''}

    ${optionalString cfg.client.dns.enable ''
    DNSPort ${cfg.client.dns.listenAddress} ${toString cfg.client.dns.isolationOptions}
    AutomapHostsOnResolve 1
    AutomapHostsSuffixes ${concatStringsSep "," cfg.client.dns.automapHostsSuffixes}
    ''}
  ''
  # Explicitly disable the SOCKS server if the client is disabled.  In
  # particular, this makes non-anonymous hidden services possible.
  + optionalString (! cfg.client.enable) ''
  SOCKSPort 0
  ''
  # Relay config
  + optionalString cfg.relay.enable ''
    ORPort ${toString cfg.relay.port}
    ${opt "Address" cfg.relay.address}
    ${opt "Nickname" cfg.relay.nickname}
    ${opt "ContactInfo" cfg.relay.contactInfo}

    ${optint "RelayBandwidthRate" cfg.relay.bandwidthRate}
    ${optint "RelayBandwidthBurst" cfg.relay.bandwidthBurst}
    ${opt "AccountingMax" cfg.relay.accountingMax}
    ${opt "AccountingStart" cfg.relay.accountingStart}

    ${if (cfg.relay.role == "exit") then
        opt "ExitPolicy" cfg.relay.exitPolicy
      else
        "ExitPolicy reject *:*"}

    ${optionalString (elem cfg.relay.role ["bridge" "private-bridge"]) ''
      BridgeRelay 1
      ServerTransportPlugin ${concatStringsSep "," cfg.relay.bridgeTransports} exec ${obfs4}/bin/obfs4proxy managed
      ExtORPort auto
      ${optionalString (cfg.relay.role == "private-bridge") ''
        ExtraInfoStatistics 0
        PublishServerDescriptor 0
      ''}
    ''}
  ''
  # Hidden services
  + concatStrings (flip mapAttrsToList cfg.hiddenServices (n: v: ''
    HiddenServiceDir ${torDirectory}/onion/${v.name}
    ${optionalString (v.version != null) "HiddenServiceVersion ${toString v.version}"}
    ${flip concatMapStrings v.map (p: ''
      HiddenServicePort ${toString p.port} ${p.destination}
    '')}
    ${optionalString (v.authorizeClient != null) ''
      HiddenServiceAuthorizeClient ${v.authorizeClient.authType} ${concatStringsSep "," v.authorizeClient.clientNames}
    ''}
  ''))
  + cfg.extraConfig;

  torRcFile = pkgs.writeText "torrc" torRc;

in
{
  options = {
    services.tor = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable the Tor daemon. By default, the daemon is run without
          relay, exit, bridge or client connectivity.
        '';
      };

      enableGeoIP = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whenever to configure Tor daemon to use GeoIP databases.

          Disabling this will disable by-country statistics for
          bridges and relays and some client and third-party software
          functionality.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration. Contents will be added verbatim to the
          configuration file at the end.
        '';
      };

      controlPort = mkOption {
        type = types.nullOr (types.either types.int types.str);
        default = null;
        example = 9051;
        description = ''
          If set, Tor will accept connections on the specified port
          and allow them to control the tor process.
        '';
      };

      controlSocket = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Wheter to enable Tor control socket. Control socket is created
            in <literal>${torRunDirectory}/control</literal>
          '';
        };
      };

      client = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether to enable Tor daemon to route application
            connections.  You might want to disable this if you plan
            running a dedicated Tor relay.
          '';
        };

        socksListenAddress = mkOption {
          type = types.str;
          default = "127.0.0.1:9050";
          example = "192.168.0.1:9100";
          description = ''
            Bind to this address to listen for connections from
            Socks-speaking applications. Provides strong circuit
            isolation, separate circuit per IP address.
          '';
        };

        socksListenAddressFaster = mkOption {
          type = types.str;
          default = "127.0.0.1:9063";
          example = "192.168.0.1:9101";
          description = ''
            Bind to this address to listen for connections from
            Socks-speaking applications. Same as
            <option>socksListenAddress</option> but uses weaker
            circuit isolation to provide performance suitable for a
            web browser.
           '';
         };

        socksPolicy = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "accept 192.168.0.0/16, reject *";
          description = ''
            Entry policies to allow/deny SOCKS requests based on IP
            address. First entry that matches wins. If no SocksPolicy
            is set, we accept all (and only) requests from
            <option>socksListenAddress</option>.
          '';
        };

        socksIsolationOptions = mkOption (isolationOptions // {
          default = ["IsolateDestAddr"];
        });

        transparentProxy = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = "Whether to enable tor transparent proxy";
          };

          listenAddress = mkOption {
            type = types.str;
            default = "127.0.0.1:9040";
            example = "192.168.0.1:9040";
            description = ''
              Bind transparent proxy to this address.
            '';
          };

          isolationOptions = mkOption isolationOptions;
        };

        dns = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = "Whether to enable tor dns resolver";
          };

          listenAddress = mkOption {
            type = types.str;
            default = "127.0.0.1:9053";
            example = "192.168.0.1:9053";
            description = ''
              Bind tor dns to this address.
            '';
          };

          isolationOptions = mkOption isolationOptions;

          automapHostsSuffixes = mkOption {
            type = types.listOf types.str;
            default = [".onion" ".exit"];
            example = [".onion"];
            description = "List of suffixes to use with automapHostsOnResolve";
          };
        };

        privoxy.enable = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether to enable and configure the system Privoxy to use Tor's
            faster port, suitable for HTTP.

            To have anonymity, protocols need to be scrubbed of identifying
            information, and this can be accomplished for HTTP by Privoxy.

            Privoxy can also be useful for KDE torification. A good setup would be:
            setting SOCKS proxy to the default Tor port, providing maximum
            circuit isolation where possible; and setting HTTP proxy to Privoxy
            to route HTTP traffic over faster, but less isolated port.
          '';
        };
      };

      relay = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether to enable relaying TOR traffic for others.

            See <link xlink:href="https://www.torproject.org/docs/tor-doc-relay" />
            for details.

            Setting this to true requires setting
            <option>services.tor.relay.role</option>
            and
            <option>services.tor.relay.port</option>
            options.
          '';
        };

        role = mkOption {
          type = types.enum [ "exit" "relay" "bridge" "private-bridge" ];
          description = ''
            Your role in Tor network. There're several options:

            <variablelist>
            <varlistentry>
              <term><literal>exit</literal></term>
              <listitem>
                <para>
                  An exit relay. This allows Tor users to access regular
                  Internet services through your public IP.
                </para>

                <important><para>
                  Running an exit relay may expose you to abuse
                  complaints. See
                  <link xlink:href="https://www.torproject.org/faq.html.en#ExitPolicies" />
                  for more info.
                </para></important>

                <para>
                  You can specify which services Tor users may access via
                  your exit relay using <option>exitPolicy</option> option.
                </para>
              </listitem>
            </varlistentry>

            <varlistentry>
              <term><literal>relay</literal></term>
              <listitem>
                <para>
                  Regular relay. This allows Tor users to relay onion
                  traffic to other Tor nodes, but not to public
                  Internet.
                </para>

                <important><para>
                  Note that some misconfigured and/or disrespectful
                  towards privacy sites will block you even if your
                  relay is not an exit relay. That is, just being listed
                  in a public relay directory can have unwanted
                  consequences.

                  Which means you might not want to use
                  this role if you browse public Internet from the same
                  network as your relay, unless you want to write
                  e-mails to those sites (you should!).
                </para></important>

                <para>
                  See
                  <link xlink:href="https://www.torproject.org/docs/tor-doc-relay.html.en" />
                  for more info.
                </para>
              </listitem>
            </varlistentry>

            <varlistentry>
              <term><literal>bridge</literal></term>
              <listitem>
                <para>
                  Regular bridge. Works like a regular relay, but
                  doesn't list you in the public relay directory and
                  hides your Tor node behind obfs4proxy.
                </para>

                <para>
                  Using this option will make Tor advertise your bridge
                  to users through various mechanisms like
                  <link xlink:href="https://bridges.torproject.org/" />, though.
                </para>

                <important>
                  <para>
                    WARNING: THE FOLLOWING PARAGRAPH IS NOT LEGAL ADVICE.
                    Consult with your lawer when in doubt.
                  </para>

                  <para>
                    This role should be safe to use in most situations
                    (unless the act of forwarding traffic for others is
                    a punishable offence under your local laws, which
                    would be pretty insane as it would make ISP
                    illegal).
                  </para>
                </important>

                <para>
                  See <link xlink:href="https://www.torproject.org/docs/bridges.html.en" />
                  for more info.
                </para>
              </listitem>
            </varlistentry>

            <varlistentry>
              <term><literal>private-bridge</literal></term>
              <listitem>
                <para>
                  Private bridge. Works like regular bridge, but does
                  not advertise your node in any way.
                </para>

                <para>
                  Using this role means that you won't contribute to Tor
                  network in any way unless you advertise your node
                  yourself in some way.
                </para>

                <para>
                  Use this if you want to run a private bridge, for
                  example because you'll give out your bridge address
                  manually to your friends.
                </para>

                <para>
                  Switching to this role after measurable time in
                  "bridge" role is pretty useless as some Tor users
                  would have learned about your node already. In the
                  latter case you can still change
                  <option>port</option> option.
                </para>

                <para>
                  See <link xlink:href="https://www.torproject.org/docs/bridges.html.en" />
                  for more info.
                </para>
              </listitem>
            </varlistentry>
            </variablelist>
          '';
        };

        bridgeTransports = mkOption {
          type = types.listOf types.str;
          default = ["obfs4"];
          example = ["obfs2" "obfs3" "obfs4" "scramblesuit"];
          description = "List of pluggable transports";
        };

        nickname = mkOption {
          type = types.str;
          default = "anonymous";
          description = ''
            A unique handle for your TOR relay.
          '';
        };

        contactInfo = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "admin@relay.com";
          description = ''
            Contact information for the relay owner (e.g. a mail
            address and GPG key ID).
          '';
        };

        accountingMax = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "450 GBytes";
          description = ''
            Specify maximum bandwidth allowed during an accounting period. This
            allows you to limit overall tor bandwidth over some time period.
            See the <literal>AccountingMax</literal> option by looking at the
            tor manual <citerefentry><refentrytitle>tor</refentrytitle>
            <manvolnum>1</manvolnum></citerefentry> for more.

            Note this limit applies individually to upload and
            download; if you specify <literal>"500 GBytes"</literal>
            here, then you may transfer up to 1 TBytes of overall
            bandwidth (500 GB upload, 500 GB download).
          '';
        };

        accountingStart = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "month 1 1:00";
          description = ''
            Specify length of an accounting period. This allows you to limit
            overall tor bandwidth over some time period. See the
            <literal>AccountingStart</literal> option by looking at the tor
            manual <citerefentry><refentrytitle>tor</refentrytitle>
            <manvolnum>1</manvolnum></citerefentry> for more.
          '';
        };

        bandwidthRate = mkOption {
          type = types.nullOr types.int;
          default = null;
          example = 100;
          description = ''
            Specify this to limit the bandwidth usage of relayed (server)
            traffic. Your own traffic is still unthrottled. Units: bytes/second.
          '';
        };

        bandwidthBurst = mkOption {
          type = types.nullOr types.int;
          default = cfg.relay.bandwidthRate;
          example = 200;
          description = ''
            Specify this to allow bursts of the bandwidth usage of relayed (server)
            traffic. The average usage will still be as specified in relayBandwidthRate.
            Your own traffic is still unthrottled. Units: bytes/second.
          '';
        };

        address = mkOption {
          type    = types.nullOr types.str;
          default = null;
          example = "noname.example.com";
          description = ''
            The IP address or full DNS name for advertised address of your relay.
            Leave unset and Tor will guess.
          '';
        };

        port = mkOption {
          type    = types.either types.int types.str;
          example = 143;
          description = ''
            What port to advertise for Tor connections. This corresponds to the
            <literal>ORPort</literal> section in the Tor manual; see
            <citerefentry><refentrytitle>tor</refentrytitle>
            <manvolnum>1</manvolnum></citerefentry> for more details.

            At a minimum, you should just specify the port for the
            relay to listen on; a common one like 143, 22, 80, or 443
            to help Tor users who may have very restrictive port-based
            firewalls.
          '';
        };

        exitPolicy = mkOption {
          type    = types.nullOr types.str;
          default = null;
          example = "accept *:6660-6667,reject *:*";
          description = ''
            A comma-separated list of exit policies. They're
            considered first to last, and the first match wins. If you
            want to _replace_ the default exit policy, end this with
            either a reject *:* or an accept *:*. Otherwise, you're
            _augmenting_ (prepending to) the default exit policy.
            Leave commented to just use the default, which is
            available in the man page or at
            <link xlink:href="https://www.torproject.org/documentation.html" />.

            Look at
            <link xlink:href="https://www.torproject.org/faq-abuse.html#TypicalAbuses" />
            for issues you might encounter if you use the default
            exit policy.

            If certain IPs and ports are blocked externally, e.g. by
            your firewall, you should update your exit policy to
            reflect this -- otherwise Tor users will be told that
            those destinations are down.
          '';
        };
      };

      hiddenServices = mkOption {
        description = ''
          A set of static hidden services that terminate their Tor
          circuits at this node.

          Every element in this set declares a virtual onion host.

          You can specify your onion address by putting corresponding
          private key to an appropriate place in ${torDirectory}.

          For services without private keys in ${torDirectory} Tor
          daemon will generate random key pairs (which implies random
          onion addresses) on restart. The latter could take a while,
          please be patient.

          <note><para>
            Hidden services can be useful even if you don't intend to
            actually <emphasis>hide</emphasis> them, since they can
            also be seen as a kind of NAT traversal mechanism.

            E.g. the example will make your sshd, whatever runs on
            "8080" and your mail server available from anywhere where
            the Tor network is available (which, with the help from
            bridges, is pretty much everywhere), even if both client
            and server machines are behind NAT you have no control
            over.
          </para></note>
        '';
        default = {};
        example = literalExample ''
          { "my-hidden-service-example".map = [
              { port = 22; }                # map ssh port to this machine's ssh
              { port = 80; toPort = 8080; } # map http port to whatever runs on 8080
              { port = "sip"; toHost = "mail.example.com"; toPort = "imap"; } # because we can
            ];
          }
        '';
        type = types.loaOf (types.submodule ({name, ...}: {
          options = {

             name = mkOption {
               type = types.str;
               description = ''
                 Name of this tor hidden service.

                 This is purely descriptive.

                 After restarting Tor daemon you should be able to
                 find your .onion address in
                 <literal>${torDirectory}/onion/$name/hostname</literal>.
               '';
             };

             map = mkOption {
               default = [];
               description = "Port mapping for this hidden service.";
               type = types.listOf (types.submodule ({config, ...}: {
                 options = {

                   port = mkOption {
                     type = types.either types.int types.str;
                     example = 80;
                     description = ''
                       Hidden service port to "bind to".
                     '';
                   };

                   destination = mkOption {
                     internal = true;
                     type = types.str;
                     description = "Forward these connections where?";
                   };

                   toHost = mkOption {
                     type = types.str;
                     default = "127.0.0.1";
                     description = "Mapping destination host.";
                   };

                   toPort = mkOption {
                     type = types.either types.int types.str;
                     example = 8080;
                     description = "Mapping destination port.";
                   };

                 };

                 config = {
                   toPort = mkDefault config.port;
                   destination = mkDefault "${config.toHost}:${toString config.toPort}";
                 };
               }));
             };

             authorizeClient = mkOption {
               default = null;
               description = "If configured, the hidden service is accessible for authorized clients only.";
               type = types.nullOr (types.submodule ({...}: {

                 options = {

                   authType = mkOption {
                     type = types.enum [ "basic" "stealth" ];
                     description = ''
                       Either <literal>"basic"</literal> for a general-purpose authorization protocol
                       or <literal>"stealth"</literal> for a less scalable protocol
                       that also hides service activity from unauthorized clients.
                     '';
                   };

                   clientNames = mkOption {
                     type = types.nonEmptyListOf (types.strMatching "[A-Za-z0-9+-_]+");
                     description = ''
                       Only clients that are listed here are authorized to access the hidden service.
                       Generated authorization data can be found in <filename>${torDirectory}/onion/$name/hostname</filename>.
                       Clients need to put this authorization data in their configuration file using <literal>HidServAuth</literal>.
                     '';
                   };
                 };
               }));
             };

             version = mkOption {
               default = null;
               description = "Rendezvous service descriptor version to publish for the hidden service. Currently, versions 2 and 3 are supported. (Default: 2)";
               type = types.nullOr (types.enum [ 2 3 ]);
             };
          };

          config = {
            name = mkDefault name;
          };
        }));
      };
    };
  };

  config = mkIf cfg.enable {
    # Not sure if `cfg.relay.role == "private-bridge"` helps as tor
    # sends a lot of stats
    warnings = optional (cfg.relay.enable && cfg.hiddenServices != {})
      ''
        Running Tor hidden services on a public relay makes the
        presence of hidden services visible through simple statistical
        analysis of publicly available data.

        You can safely ignore this warning if you don't intend to
        actually hide your hidden services. In either case, you can
        always create a container/VM with a separate Tor daemon instance.
      '';

    users.groups.tor.gid = config.ids.gids.tor;
    users.users.tor =
      { description = "Tor Daemon User";
        createHome  = true;
        home        = torDirectory;
        group       = "tor";
        uid         = config.ids.uids.tor;
      };

    # We have to do this instead of using RuntimeDirectory option in
    # the service below because systemd has no way to set owners of
    # RuntimeDirectory and putting this into the service below
    # requires that service to relax it's sandbox since this needs
    # writable /run
    systemd.services.tor-init =
      { description = "Tor Daemon Init";
        wantedBy = [ "tor.service" ];
        after = [ "local-fs.target" ];
        script = ''
          install -m 0700 -o tor -g tor -d ${torDirectory} ${torDirectory}/onion
          install -m 0750 -o tor -g tor -d ${torRunDirectory}
        '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };

    systemd.services.tor =
      { description = "Tor Daemon";
        path = [ pkgs.tor ];

        wantedBy = [ "multi-user.target" ];
        after    = [ "tor-init.service" "network.target" ];
        restartTriggers = [ torRcFile ];

        serviceConfig =
          { Type         = "simple";
            # Translated from the upstream contrib/dist/tor.service.in
            ExecStartPre = "${pkgs.tor}/bin/tor -f ${torRcFile} --verify-config";
            ExecStart    = "${pkgs.tor}/bin/tor -f ${torRcFile}";
            ExecReload   = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
            KillSignal   = "SIGINT";
            TimeoutSec   = 30;
            Restart      = "on-failure";
            LimitNOFILE  = 32768;

            # Hardening
            # this seems to unshare /run despite what systemd.exec(5) says
            PrivateTmp              = mkIf (!cfg.controlSocket.enable) "yes";
            PrivateDevices          = "yes";
            ProtectHome             = "yes";
            ProtectSystem           = "strict";
            InaccessiblePaths       = "/home";
            ReadOnlyPaths           = "/";
            ReadWritePaths          = [ torDirectory torRunDirectory ];
            NoNewPrivileges         = "yes";

            # tor.service.in has this in, but this line it fails to spawn a namespace when using hidden services
            #CapabilityBoundingSet   = "CAP_SETUID CAP_SETGID CAP_NET_BIND_SERVICE";
          };
      };

    environment.systemPackages = [ pkgs.tor ];

    services.privoxy = mkIf (cfg.client.enable && cfg.client.privoxy.enable) {
      enable = true;
      extraConfig = ''
        forward-socks4a / ${cfg.client.socksListenAddressFaster} .
        toggle  1
        enable-remote-toggle 0
        enable-edit-actions 0
        enable-remote-http-toggle 0
      '';
    };
  };
}

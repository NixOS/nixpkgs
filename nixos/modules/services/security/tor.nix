{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tor;
  torDirectory = "/var/lib/tor";

  opt    = name: value: optionalString (value != null) "${name} ${value}";
  optint = name: value: optionalString (value != null && value != 0)    "${name} ${toString value}";

  torRc = ''
    User tor
    DataDirectory ${torDirectory}
    ${optionalString cfg.enableGeoIP ''
      GeoIPFile ${pkgs.tor.geoip}/share/tor/geoip
      GeoIPv6File ${pkgs.tor.geoip}/share/tor/geoip6
    ''}

    ${optint "ControlPort" cfg.controlPort}
  ''
  # Client connection config
  + optionalString cfg.client.enable  ''
    SOCKSPort ${cfg.client.socksListenAddress} IsolateDestAddr
    SOCKSPort ${cfg.client.socksListenAddressFaster}
    ${opt "SocksPolicy" cfg.client.socksPolicy}
  ''
  # Relay config
  + optionalString cfg.relay.enable ''
    ORPort ${cfg.relay.portSpec}
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
      ServerTransportPlugin obfs2,obfs3 exec ${pkgs.pythonPackages.obfsproxy}/bin/obfsproxy managed
      ExtORPort auto
      ${optionalString (cfg.relay.role == "private-bridge") ''
        ExtraInfoStatistics 0
        PublishServerDescriptor 0
      ''}
    ''}
  ''
  + hiddenServices
  + cfg.extraConfig;

  hiddenServices = concatStrings (mapAttrsToList (hiddenServiceDir: hs:
    let
      hsports = concatStringsSep "\n" (map mkHiddenServicePort hs.hiddenServicePorts);
    in
      "HiddenServiceDir ${hiddenServiceDir}\n${hsports}\n${hs.extraConfig}\n"
    ) cfg.hiddenServices);

    mkHiddenServicePort = hsport: let
      trgt = optionalString (hsport.target != null) (" " + hsport.target);
    in "HiddenServicePort ${toString hsport.virtualPort}${trgt}";

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
        type = types.nullOr types.int;
        default = null;
        example = 9051;
        description = ''
          If set, Tor will accept connections on the specified port
          and allow them to control the tor process.
        '';
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
            <option>services.tor.relay.portSpec</option>
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
                  hides your Tor node behind obfsproxy.
                </para>

                <para>
                  Using this option will make Tor advertise your bridge
                  to users through various mechanisms like
                  <link xlink:href="https://bridges.torproject.org/" />, though.
                </para>

                <important>
                  <para>
                    WARNING: THE FOLLOWING PARAGRAPH IS NOT LEGAL ADVISE.
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
                  "bridge" role is pretty useless as some Tor users would have
                  learned about your node already.
                  In the latter case you can still change
                  <option>portSpec</option> option.
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

        portSpec = mkOption {
          type    = types.str;
          example = "143";
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
        type = types.attrsOf (types.submodule ({
          options = {
            hiddenServicePorts = mkOption {
              type = types.listOf (types.submodule {
                options = {
                  virtualPort = mkOption {
                    type = types.int;
                    example = 80;
                    description = "Virtual port.";
                  };
                  target = mkOption {
                    type = types.nullOr types.str;
                    default = null;
                    example = "127.0.0.1:8080";
                    description = ''
                      Target virtual Port shall be mapped to.

                      You may override the target port, address, or both by
                      specifying a target of addr, port, addr:port, or
                      unix:path. (You can specify an IPv6 target as
                      [addr]:port. Unix paths may be quoted, and may use
                      standard C escapes.)
                    '';
                  };
                };
              });
              example = [ { virtualPort = 80; target = "127.0.0.1:8080"; } { virtualPort = 6667; } ];
              description = ''
                If target is <literal>null</literal> the virtual port is mapped
                to the same port on 127.0.0.1 over TCP. You may use
                <literal>target</literal> to overwrite this behaviour (see
                description of target).

                This corresponds to the <literal>HiddenServicePort VIRTPORT
                [TARGET]</literal> option by looking at the tor manual
                <citerefentry><refentrytitle>tor</refentrytitle>
                <manvolnum>1</manvolnum></citerefentry> for more information.
              '';
            };
            extraConfig = mkOption {
              type = types.str;
              default = "";
              description = ''
                Extra configuration. Contents will be added in the current
                hidden service context.
              '';
            };
          };
        }));
        default = {};
        example = {
          "/var/lib/tor/webserver" = {
            hiddenServicePorts = [ { virtualPort = 80; } ];
          };
        };
        description = ''
          Configure hidden services.

          Please consult the tor manual
          <citerefentry><refentrytitle>tor</refentrytitle>
          <manvolnum>1</manvolnum></citerefentry> for a more detailed
          explanation. (search for 'HIDDEN').
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.extraGroups.tor.gid = config.ids.gids.tor;
    users.extraUsers.tor =
      { description = "Tor Daemon User";
        createHome  = true;
        home        = torDirectory;
        group       = "tor";
        uid         = config.ids.uids.tor;
      };

    systemd.services.tor =
      { description = "Tor Daemon";
        path = [ pkgs.tor ];

        wantedBy = [ "multi-user.target" ];
        after    = [ "network.target" ];
        restartTriggers = [ torRcFile ];

        # Translated from the upstream contrib/dist/tor.service.in
        serviceConfig =
          { Type         = "simple";
            ExecStartPre = "${pkgs.tor}/bin/tor -f ${torRcFile} --verify-config";
            ExecStart    = "${pkgs.tor}/bin/tor -f ${torRcFile} --RunAsDaemon 0";
            ExecReload   = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
            KillSignal   = "SIGINT";
            TimeoutSec   = 30;
            Restart      = "on-failure";
            LimitNOFILE  = 32768;

            # Hardening
            # Note: DevicePolicy is set to 'closed', although the
            # minimal permissions are really:
            #   DeviceAllow /dev/null rw
            #   DeviceAllow /dev/urandom r
            # .. but we can't specify DeviceAllow multiple times. 'closed'
            # is close enough.
            PrivateTmp              = "yes";
            DevicePolicy            = "closed";
            InaccessibleDirectories = "/home";
            ReadOnlyDirectories     = "/";
            ReadWriteDirectories    = torDirectory;
            NoNewPrivileges         = "yes";
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

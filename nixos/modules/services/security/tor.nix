{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tor;
  torDirectory = "/var/lib/tor";

  opt    = name: value: optionalString (value != null) "${name} ${value}";
  optint = name: value: optionalString (value != 0)    "${name} ${toString value}";

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
    ${opt "Nickname" cfg.relay.nickname}
    ${opt "ContactInfo" cfg.relay.contactInfo}

    ${optint "RelayBandwidthRate" cfg.relay.bandwidthRate}
    ${optint "RelayBandwidthBurst" cfg.relay.bandwidthBurst}
    ${opt "AccountingMax" cfg.relay.accountingMax}
    ${opt "AccountingStart" cfg.relay.accountingStart}

    ${if cfg.relay.isExit then
        opt "ExitPolicy" cfg.relay.exitPolicy
      else
        "ExitPolicy reject *:*"}

    ${optionalString cfg.relay.isBridge ''
      BridgeRelay 1
      ServerTransportPlugin obfs2,obfs3 exec ${pkgs.pythonPackages.obfsproxy}/bin/obfsproxy managed
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
        type = types.int;
        default = 0;
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
            Socks-speaking applications. Same as socksListenAddress
            but uses weaker circuit isolation to provide performance
            suitable for a web browser.
           '';
         };

        socksPolicy = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "accept 192.168.0.0/16, reject *";
          description = ''
            Entry policies to allow/deny SOCKS requests based on IP
            address.  First entry that matches wins. If no SocksPolicy
            is set, we accept all (and only) requests from
            SocksListenAddress.
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

            See https://www.torproject.org/docs/tor-doc-relay for details.
          '';
        };

        isBridge = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Bridge relays (or "bridges") are Tor relays that aren't
            listed in the main directory. Since there is no complete
            public list of them, even if an ISP is filtering
            connections to all the known Tor relays, they probably
            won't be able to block all the bridges.

            A bridge relay can't be an exit relay.

            You need to set relay.enable to true for this option to
            take effect.

            The bridge is set up with an obfuscated transport proxy.

            See https://www.torproject.org/bridges.html.en for more info.
          '';
        };

        isExit = mkOption {
          type = types.bool;
          default = false;
          description = ''
            An exit relay allows Tor users to access regular Internet
            services.

            Unlike running a non-exit relay, running an exit relay may
            expose you to abuse complaints. See
            https://www.torproject.org/faq.html.en#ExitPolicies for
            more info.

            You can specify which services Tor users may access via
            your exit relay using exitPolicy option.
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
          type = types.int;
          default = 0;
          example = 100;
          description = ''
            Specify this to limit the bandwidth usage of relayed (server)
            traffic. Your own traffic is still unthrottled. Units: bytes/second.
          '';
        };

        bandwidthBurst = mkOption {
          type = types.int;
          default = cfg.relay.bandwidthRate;
          example = 200;
          description = ''
            Specify this to allow bursts of the bandwidth usage of relayed (server)
            traffic. The average usage will still be as specified in relayBandwidthRate.
            Your own traffic is still unthrottled. Units: bytes/second.
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
            _augmenting_ (prepending to) the default exit
            policy. Leave commented to just use the default, which is
            available in the man page or at
            https://www.torproject.org/documentation.html

            Look at https://www.torproject.org/faq-abuse.html#TypicalAbuses
            for issues you might encounter if you use the default exit policy.

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
    assertions = singleton
      { message = "Can't be both an exit and a bridge relay at the same time";
        assertion =
          cfg.relay.enable -> !(cfg.relay.isBridge && cfg.relay.isExit);
      };

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

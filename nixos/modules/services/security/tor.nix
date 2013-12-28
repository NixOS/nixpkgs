{ config, pkgs, ... }:

with pkgs.lib;

let

  inherit (pkgs) tor privoxy;

  stateDir = "/var/lib/tor";
  privoxyDir = stateDir+"/privoxy";

  cfg = config.services.tor;

  torUser = "tor";

  opt = name: value: if value != "" then "${name} ${value}" else "";
  optint = name: value: if value != 0 then "${name} ${toString value}" else "";

in

{

  ###### interface

  options = {

    services.tor = {

      config = mkOption {
        default = "";
        description = ''
          Extra configuration. Contents will be added verbatim to the
          configuration file.
        '';
      };

      client = {

        enable = mkOption {
          default = false;
          description = ''
            Whether to enable Tor daemon to route application connections.
            You might want to disable this if you plan running a dedicated Tor relay.
          '';
        };

        socksListenAddress = mkOption {
          default = "127.0.0.1:9050";
          example = "192.168.0.1:9100";
          description = ''
            Bind to this address to listen for connections from Socks-speaking
            applications.
          '';
        };

        socksListenAddressFaster = mkOption {
          default = "127.0.0.1:9063";
          description = ''
            Same as socksListenAddress but uses weaker circuit isolation to provide
            performance suitable for a web browser.
          '';
        };

        socksPolicy = mkOption {
          default = "";
          example = "accept 192.168.0.0/16, reject *";
          description = ''
            Entry policies to allow/deny SOCKS requests based on IP address.
            First entry that matches wins. If no SocksPolicy is set, we accept
            all (and only) requests from SocksListenAddress.
          '';
        };

        privoxy = {

          enable = mkOption {
            default = true;
            description = ''
              Whether to enable a special instance of privoxy dedicated to Tor.
              To have anonymity, protocols need to be scrubbed of identifying
              information.
              Most people using Tor want to anonymize their web traffic, so by
              default we enable an special instance of privoxy specifically for
              Tor.
              However, if you are only going to use Tor only for other kinds of
              traffic then you can disable this option.
            '';
          };

          listenAddress = mkOption {
            default = "127.0.0.1:8118";
            description = ''
              Address that Tor's instance of privoxy is listening to.
              *This does not configure the standard NixOS instance of privoxy.*
              This is for Tor connections only!
              See services.privoxy.listenAddress to configure the standard NixOS
              instace of privoxy.
            '';
          };

          config = mkOption {
            default = "";
            description = ''
              Extra configuration for Tor's instance of privoxy. Contents will be
              added verbatim to the configuration file.
              *This does not configure the standard NixOS instance of privoxy.*
              This is for Tor connections only!
              See services.privoxy.extraConfig to configure the standard NixOS
              instace of privoxy.
            '';
          };

        };

      };

      relay = {

        enable = mkOption {
          default = false;
          description = ''
            Whether to enable relaying TOR traffic for others.

            See https://www.torproject.org/docs/tor-doc-relay for details.
          '';
        };

        isBridge = mkOption {
          default = false;
          description = ''
            Bridge relays (or "bridges" ) are Tor relays that aren't listed in the
            main directory. Since there is no complete public list of them, even if an
            ISP is filtering connections to all the known Tor relays, they probably
            won't be able to block all the bridges.

            A bridge relay can't be an exit relay.

            You need to set relay.enable to true for this option to take effect.

            The bridge is set up with an obfuscated transport proxy.

            See https://www.torproject.org/bridges.html.en for more info.
          '';
        };

        isExit = mkOption {
          default = false;
          description = ''
            An exit relay allows Tor users to access regular Internet services.

            Unlike running a non-exit relay, running an exit relay may expose
            you to abuse complaints. See https://www.torproject.org/faq.html.en#ExitPolicies for more info.

            You can specify which services Tor users may access via your exit relay using exitPolicy option.
          '';
        };

        nickname = mkOption {
          default = "anonymous";
          description = ''
            A unique handle for your TOR relay.
          '';
        };

        bandwidthRate = mkOption {
          default = 0;
          example = 100;
          description = ''
            Specify this to limit the bandwidth usage of relayed (server)
            traffic. Your own traffic is still unthrottled. Units: bytes/second.
          '';
        };

        bandwidthBurst = mkOption {
          default = cfg.relay.bandwidthRate;
          example = 200;
          description = ''
            Specify this to allow bursts of the bandwidth usage of relayed (server)
            traffic. The average usage will still be as specified in relayBandwidthRate.
            Your own traffic is still unthrottled. Units: bytes/second.
          '';
        };

        port = mkOption {
          default = 9001;
          description = ''
            What port to advertise for Tor connections.
          '';
        };

        listenAddress = mkOption {
          default = "";
          example = "0.0.0.0:9090";
          description = ''
            Set this if you need to listen on a port other than the one advertised
            in relayPort (e.g. to advertise 443 but bind to 9090). You'll need to do
            ipchains or other port forwsarding yourself to make this work.
          '';
        };

        exitPolicy = mkOption {
          default = "";
          example = "accept *:6660-6667,reject *:*";
          description = ''
            A comma-separated list of exit policies. They're considered first
            to last, and the first match wins. If you want to _replace_
            the default exit policy, end this with either a reject *:* or an
            accept *:*. Otherwise, you're _augmenting_ (prepending to) the
            default exit policy. Leave commented to just use the default, which is
            available in the man page or at https://www.torproject.org/documentation.html

            Look at https://www.torproject.org/faq-abuse.html#TypicalAbuses
            for issues you might encounter if you use the default exit policy.

            If certain IPs and ports are blocked externally, e.g. by your firewall,
            you should update your exit policy to reflect this -- otherwise Tor
            users will be told that those destinations are down.
          '';
        };

      };

    };

  };


  ###### implementation

  config = mkIf (cfg.client.enable || cfg.relay.enable) {

    assertions = singleton
      { assertion = cfg.relay.enable -> !(cfg.relay.isBridge && cfg.relay.isExit);
        message = "Can't be both an exit and a bridge relay at the same time";
      };

    users.extraUsers = singleton
      { name = torUser;
        uid = config.ids.uids.tor;
        description = "Tor daemon user";
        home = stateDir;
      };

    jobs = {
      tor = { name = "tor";

              startOn = "started network-interfaces";
              stopOn = "stopping network-interfaces";

              preStart = ''
                mkdir -m 0755 -p ${stateDir}
                chown ${torUser} ${stateDir}
              '';
              exec = "${tor}/bin/tor -f ${pkgs.writeText "torrc" cfg.config}";
    }; }
    // optionalAttrs (cfg.client.privoxy.enable && cfg.client.enable) {
      torPrivoxy = { name = "tor-privoxy";

                     startOn = "started network-interfaces";
                     stopOn = "stopping network-interfaces";

                     preStart = ''
                       mkdir -m 0755 -p ${privoxyDir}
                       chown ${torUser} ${privoxyDir}
                     '';
                     exec = "${privoxy}/sbin/privoxy --no-daemon --user ${torUser} ${pkgs.writeText "torPrivoxy.conf" cfg.client.privoxy.config}";
    }; };

      services.tor.config = ''
        DataDirectory ${stateDir}
        User ${torUser}
      ''
      + optionalString cfg.client.enable  ''
        SOCKSPort ${cfg.client.socksListenAddress} IsolateDestAddr
        SOCKSPort ${cfg.client.socksListenAddressFaster}
        ${opt "SocksPolicy" cfg.client.socksPolicy}
      ''
      + optionalString cfg.relay.enable ''
        ORPort ${toString cfg.relay.port}
        ${opt "ORListenAddress" cfg.relay.listenAddress }
        ${opt "Nickname" cfg.relay.nickname}
        ${optint "RelayBandwidthRate" cfg.relay.bandwidthRate}
        ${optint "RelayBandwidthBurst" cfg.relay.bandwidthBurst}
        ${if cfg.relay.isExit then opt "ExitPolicy" cfg.relay.exitPolicy else "ExitPolicy reject *:*"}
        ${if cfg.relay.isBridge then ''
          BridgeRelay 1
          ServerTransportPlugin obfs2,obfs3 exec ${pkgs.pythonPackages.obfsproxy}/bin/obfsproxy managed
        '' else ""}
      '';

      services.tor.client.privoxy.config = ''
        # Generally, this file goes in /etc/privoxy/config
        #
        # Tor listens as a SOCKS4a proxy here:
        forward-socks4a / ${cfg.client.socksListenAddressFaster} .
        confdir ${privoxy}/etc
        logdir ${privoxyDir}
        # actionsfile standard  # Internal purpose, recommended
        actionsfile default.action   # Main actions file
        actionsfile user.action      # User customizations
        filterfile default.filter

        # Don't log interesting things, only startup messages, warnings and errors
        logfile logfile
        #jarfile jarfile
        #debug   0    # show each GET/POST/CONNECT request
        debug   4096 # Startup banner and warnings
        debug   8192 # Errors - *we highly recommended enabling this*

        user-manual ${privoxy}/doc/privoxy/user-manual
        listen-address  ${cfg.client.privoxy.listenAddress}
        toggle  1
        enable-remote-toggle 0
        enable-edit-actions 0
        enable-remote-http-toggle 0
        buffer-limit 4096

        # Extra config goes here
      '';

  };

}

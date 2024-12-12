{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.coturn;
  pidfile = "/run/turnserver/turnserver.pid";
  configFile = pkgs.writeText "turnserver.conf" ''
    listening-port=${toString cfg.listening-port}
    tls-listening-port=${toString cfg.tls-listening-port}
    alt-listening-port=${toString cfg.alt-listening-port}
    alt-tls-listening-port=${toString cfg.alt-tls-listening-port}
    ${lib.concatStringsSep "\n" (map (x: "listening-ip=${x}") cfg.listening-ips)}
    ${lib.concatStringsSep "\n" (map (x: "relay-ip=${x}") cfg.relay-ips)}
    min-port=${toString cfg.min-port}
    max-port=${toString cfg.max-port}
    ${lib.optionalString cfg.lt-cred-mech "lt-cred-mech"}
    ${lib.optionalString cfg.no-auth "no-auth"}
    ${lib.optionalString cfg.use-auth-secret "use-auth-secret"}
    ${lib.optionalString (
      cfg.static-auth-secret != null
    ) "static-auth-secret=${cfg.static-auth-secret}"}
    ${lib.optionalString (
      cfg.static-auth-secret-file != null
    ) "static-auth-secret=#static-auth-secret#"}
    realm=${cfg.realm}
    ${lib.optionalString cfg.no-udp "no-udp"}
    ${lib.optionalString cfg.no-tcp "no-tcp"}
    ${lib.optionalString cfg.no-tls "no-tls"}
    ${lib.optionalString cfg.no-dtls "no-dtls"}
    ${lib.optionalString cfg.no-udp-relay "no-udp-relay"}
    ${lib.optionalString cfg.no-tcp-relay "no-tcp-relay"}
    ${lib.optionalString (cfg.cert != null) "cert=${cfg.cert}"}
    ${lib.optionalString (cfg.pkey != null) "pkey=${cfg.pkey}"}
    ${lib.optionalString (cfg.dh-file != null) "dh-file=${cfg.dh-file}"}
    no-stdout-log
    syslog
    pidfile=${pidfile}
    ${lib.optionalString cfg.secure-stun "secure-stun"}
    ${lib.optionalString cfg.no-cli "no-cli"}
    cli-ip=${cfg.cli-ip}
    cli-port=${toString cfg.cli-port}
    ${lib.optionalString (cfg.cli-password != null) "cli-password=${cfg.cli-password}"}
    ${cfg.extraConfig}
  '';
in
{
  options = {
    services.coturn = {
      enable = lib.mkEnableOption "coturn TURN server";
      listening-port = lib.mkOption {
        type = lib.types.int;
        default = 3478;
        description = ''
          TURN listener port for UDP and TCP.
          Note: actually, TLS and DTLS sessions can connect to the
          "plain" TCP and UDP port(s), too - if allowed by configuration.
        '';
      };
      tls-listening-port = lib.mkOption {
        type = lib.types.int;
        default = 5349;
        description = ''
          TURN listener port for TLS.
          Note: actually, "plain" TCP and UDP sessions can connect to the TLS and
          DTLS port(s), too - if allowed by configuration. The TURN server
          "automatically" recognizes the type of traffic. Actually, two listening
          endpoints (the "plain" one and the "tls" one) are equivalent in terms of
          functionality; but we keep both endpoints to satisfy the RFC 5766 specs.
          For secure TCP connections, we currently support SSL version 3 and
          TLS version 1.0, 1.1 and 1.2.
          For secure UDP connections, we support DTLS version 1.
        '';
      };
      alt-listening-port = lib.mkOption {
        type = lib.types.int;
        default = cfg.listening-port + 1;
        defaultText = lib.literalExpression "listening-port + 1";
        description = ''
          Alternative listening port for UDP and TCP listeners;
          default (or zero) value means "listening port plus one".
          This is needed for RFC 5780 support
          (STUN extension specs, NAT behavior discovery). The TURN Server
          supports RFC 5780 only if it is started with more than one
          listening IP address of the same family (IPv4 or IPv6).
          RFC 5780 is supported only by UDP protocol, other protocols
          are listening to that endpoint only for "symmetry".
        '';
      };
      alt-tls-listening-port = lib.mkOption {
        type = lib.types.int;
        default = cfg.tls-listening-port + 1;
        defaultText = lib.literalExpression "tls-listening-port + 1";
        description = ''
          Alternative listening port for TLS and DTLS protocols.
        '';
      };
      listening-ips = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "203.0.113.42"
          "2001:DB8::42"
        ];
        description = ''
          Listener IP addresses of relay server.
          If no IP(s) specified in the config file or in the command line options,
          then all IPv4 and IPv6 system IPs will be used for listening.
        '';
      };
      relay-ips = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "203.0.113.42"
          "2001:DB8::42"
        ];
        description = ''
          Relay address (the local IP address that will be used to relay the
          packets to the peer).
          Multiple relay addresses may be used.
          The same IP(s) can be used as both listening IP(s) and relay IP(s).

          If no relay IP(s) specified, then the turnserver will apply the default
          policy: it will decide itself which relay addresses to be used, and it
          will always be using the client socket IP address as the relay IP address
          of the TURN session (if the requested relay address family is the same
          as the family of the client socket).
        '';
      };
      min-port = lib.mkOption {
        type = lib.types.int;
        default = 49152;
        description = ''
          Lower bound of UDP relay endpoints
        '';
      };
      max-port = lib.mkOption {
        type = lib.types.int;
        default = 65535;
        description = ''
          Upper bound of UDP relay endpoints
        '';
      };
      lt-cred-mech = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Use long-term credential mechanism.
        '';
      };
      no-auth = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          This option is opposite to lt-cred-mech.
          (TURN Server with no-auth option allows anonymous access).
          If neither option is defined, and no users are defined,
          then no-auth is default. If at least one user is defined,
          in this file or in command line or in usersdb file, then
          lt-cred-mech is default.
        '';
      };
      use-auth-secret = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          TURN REST API flag.
          Flag that sets a special authorization option that is based upon authentication secret.
          This feature can be used with the long-term authentication mechanism, only.
          This feature purpose is to support "TURN Server REST API", see
          "TURN REST API" link in the project's page
          https://github.com/coturn/coturn/

          This option is used with timestamp:

          usercombo -> "timestamp:userid"
          turn user -> usercombo
          turn password -> base64(hmac(secret key, usercombo))

          This allows TURN credentials to be accounted for a specific user id.
          If you don't have a suitable id, the timestamp alone can be used.
          This option is just turning on secret-based authentication.
          The actual value of the secret is defined either by option static-auth-secret,
          or can be found in the turn_secret table in the database.
        '';
      };
      static-auth-secret = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          'Static' authentication secret value (a string) for TURN REST API only.
          If not set, then the turn server
          will try to use the 'dynamic' value in turn_secret table
          in user database (if present). The database-stored  value can be changed on-the-fly
          by a separate program, so this is why that other mode is 'dynamic'.
        '';
      };
      static-auth-secret-file = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Path to the file containing the static authentication secret.
        '';
      };
      realm = lib.mkOption {
        type = lib.types.str;
        default = config.networking.hostName;
        defaultText = lib.literalExpression "config.networking.hostName";
        example = "example.com";
        description = ''
          The default realm to be used for the users when no explicit
          origin/realm relationship was found in the database, or if the TURN
          server is not using any database (just the commands-line settings
          and the userdb file). Must be used with long-term credentials
          mechanism or with TURN REST API.
        '';
      };
      cert = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/var/lib/acme/example.com/fullchain.pem";
        description = ''
          Certificate file in PEM format.
        '';
      };
      pkey = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/var/lib/acme/example.com/key.pem";
        description = ''
          Private key file in PEM format.
        '';
      };
      dh-file = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Use custom DH TLS key, stored in PEM format in the file.
        '';
      };
      secure-stun = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Require authentication of the STUN Binding request.
          By default, the clients are allowed anonymous access to the STUN Binding functionality.
        '';
      };
      no-cli = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Turn OFF the CLI support.
        '';
      };
      cli-ip = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = ''
          Local system IP address to be used for CLI server endpoint.
        '';
      };
      cli-port = lib.mkOption {
        type = lib.types.int;
        default = 5766;
        description = ''
          CLI server port.
        '';
      };
      cli-password = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          CLI access password.
          For the security reasons, it is recommended to use the encrypted
          for of the password (see the -P command in the turnadmin utility).
        '';
      };
      no-udp = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Disable UDP client listener";
      };
      no-tcp = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Disable TCP client listener";
      };
      no-tls = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Disable TLS client listener";
      };
      no-dtls = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Disable DTLS client listener";
      };
      no-udp-relay = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Disable UDP relay endpoints";
      };
      no-tcp-relay = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Disable TCP relay endpoints";
      };
      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Additional configuration options";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = cfg.static-auth-secret != null -> cfg.static-auth-secret-file == null;
            message = "static-auth-secret and static-auth-secret-file cannot be set at the same time";
          }
        ];
      }

      {
        users.users.turnserver = {
          uid = config.ids.uids.turnserver;
          group = "turnserver";
          description = "coturn TURN server user";
        };
        users.groups.turnserver = {
          gid = config.ids.gids.turnserver;
          members = [ "turnserver" ];
        };

        systemd.services.coturn =
          let
            runConfig = "/run/coturn/turnserver.cfg";
          in
          {
            description = "coturn TURN server";
            after = [ "network-online.target" ];
            wants = [ "network-online.target" ];
            wantedBy = [ "multi-user.target" ];

            unitConfig = {
              Documentation = "man:coturn(1) man:turnadmin(1) man:turnserver(1)";
            };

            preStart = ''
              cat ${configFile} > ${runConfig}
              ${lib.optionalString (cfg.static-auth-secret-file != null) ''
                ${pkgs.replace-secret}/bin/replace-secret \
                  "#static-auth-secret#" \
                  ${cfg.static-auth-secret-file} \
                  ${runConfig}
              ''}
              chmod 640 ${runConfig}
            '';
            serviceConfig = rec {
              Type = "simple";
              ExecStart = utils.escapeSystemdExecArgs [
                (lib.getExe' pkgs.coturn "turnserver")
                "-c"
                runConfig
              ];
              User = "turnserver";
              Group = "turnserver";
              RuntimeDirectory = [
                "coturn"
                "turnserver"
              ];
              RuntimeDirectoryMode = "0700";
              Restart = "on-abort";

              # Hardening
              AmbientCapabilities =
                if
                  cfg.listening-port < 1024
                  || cfg.alt-listening-port < 1024
                  || cfg.tls-listening-port < 1024
                  || cfg.alt-tls-listening-port < 1024
                  || cfg.min-port < 1024
                then
                  [ "CAP_NET_BIND_SERVICE" ]
                else
                  [ "" ];
              CapabilityBoundingSet = AmbientCapabilities;
              DevicePolicy = "closed";
              LockPersonality = true;
              MemoryDenyWriteExecute = true;
              NoNewPrivileges = true;
              PrivateDevices = true;
              PrivateTmp = true;
              PrivateUsers = true;
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
              RestrictAddressFamilies =
                [
                  "AF_INET"
                  "AF_INET6"
                ]
                ++ lib.optionals (cfg.listening-ips == [ ]) [
                  # only used for interface discovery when no listening ips are configured
                  "AF_NETLINK"
                ];
              RestrictNamespaces = true;
              RestrictRealtime = true;
              RestrictSUIDSGID = true;
              SystemCallArchitectures = "native";
              SystemCallFilter = [
                "@system-service"
                "~@privileged @resources"
              ];
              UMask = "0077";
            };
          };
      }
    ]
  );
}

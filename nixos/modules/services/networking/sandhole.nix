{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.sandhole;
  name = "sandhole";
  stateDir = "/var/lib/${name}";
  sshPort = if cfg.settings.sshPort != null then cfg.settings.sshPort else 2222;
  httpPort =
    if cfg.settings.disableHttp then
      null
    else if cfg.settings.httpPort == null then
      80
    else
      cfg.settings.httpPort;
  httpsPort =
    if cfg.settings.disableHttps then
      null
    else if cfg.settings.httpsPort == null then
      443
    else
      cfg.settings.httpsPort;
  needsPrivilegedPorts =
    sshPort < 1024 || (httpPort != null && httpPort < 1024) || (httpsPort != null && httpsPort < 1024);
in

{
  options = {
    services.sandhole = {
      enable = mkEnableOption "Sandhole, a reverse proxy that lets you expose HTTP/SSH/TCP services through SSH port forwarding";

      package = mkPackageOption pkgs "sandhole" { };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to automatically open the necessary ports in the firewall.

          Warning: If this option is true and `services.sandhole.settings.disableTcp` is false (by default),
          all unprivileged ports (i.e. >= 1024) will be opened.
        '';
        example = true;
      };

      # https://sandhole.com.br/cli.html
      settings = {
        domain = mkOption {
          type = types.str;
          description = "The root domain of the application.";
          example = "sandhole.com.br";
        };

        domainRedirect = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Where to redirect requests to the root domain.";
          example = "https://github.com/EpicEric/sandhole";
        };

        userKeysDirectory = mkOption {
          type = types.path;
          default = "${stateDir}/user_keys";
          description = ''
            Directory containing public keys of authorized users.
            Each file must contain at least one key.
          '';
          example = literalExpression "./deploy/user_keys/";
        };

        adminKeysDirectory = mkOption {
          type = types.path;
          default = "${stateDir}/admin_keys";
          description = ''
            Directory containing public keys of admin users.
            Each file must contain at least one key.
          '';
          example = literalExpression "./deploy/admin_keys/";
        };

        certificatesDirectory = mkOption {
          type = types.path;
          default = "${stateDir}/certificates";
          description = ''
            Directory containing SSL certificates and keys.
            Each sub-directory inside of this one must contain a certificate chain
            in a fullchain.pem file and its private key in a privkey.pem file.
          '';
          example = literalExpression "./deploy/certificates/";
        };

        acmeCacheDirectory = mkOption {
          type = types.path;
          default = "${stateDir}/acme_cache";
          description = ''
            Directory to use as a cache for Let's Encrypt's account and certificates.
            This will automatically be created for you.

            Note that this setting ignores the `disableDirectoryCreation` flag.
          '';
          example = literalExpression "./deploy/acme_cache/";
        };

        privateKeyFile = mkOption {
          type = types.path;
          default = "${stateDir}/server_keys/ssh";
          description = ''
            File path to the server's secret key.
            If missing, it will be created for you.
          '';
          example = literalExpression "./deploy/server_keys/ssh";
        };

        disableDirectoryCreation = mkOption {
          type = types.bool;
          default = false;
          description = ''
            If set, disables automatic creation of the directories expected by the application.
            This may result in application errors if the directories are missing.
          '';
          example = true;
        };

        listenAddress = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Address to listen for all client connections.
          '';
          example = "::";
        };

        sshPort = mkOption {
          type = types.nullOr types.port;
          default = null;
          description = "Port to listen for SSH connections.";
          example = 2222;
        };

        httpPort = mkOption {
          type = types.nullOr types.port;
          default = null;
          description = "Port to listen for HTTP connections.";
          example = 80;
        };

        httpsPort = mkOption {
          type = types.nullOr types.port;
          default = null;
          description = "Port to listen for HTTPS connections.";
          example = 443;
        };

        connectSshOnHttpsPort = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Allow connecting to SSH via the HTTPS port as well.
            This can be useful in networks that block binding to other ports.
          '';
          example = true;
        };

        forceHttps = mkOption {
          type = types.bool;
          default = false;
          description = "Always redirect HTTP requests to HTTPS.";
          example = true;
        };

        disableHttpLogs = mkOption {
          type = types.bool;
          default = false;
          description = "Disable sending HTTP logs to clients.";
          example = true;
        };

        disableTcpLogs = mkOption {
          type = types.bool;
          default = false;
          description = "Disable sending TCP/proxy logs to clients.";
          example = true;
        };

        acmeContactEmail = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Contact e-mail to use with Let's Encrypt.
            If set, enables ACME for HTTPS certificates.

            By providing your e-mail, you agree to the Let's Encrypt Subscriber Agreement.
          '';
          example = "your-email@domain.com";
        };

        acmeUseStaging = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Controls whether to use the staging directory for Let's Encrypt certificates (default is production).
            Only set this option for testing.
          '';
          example = true;
        };

        passwordAuthenticationUrl = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            If set, defines a URL which password authentication requests will be validated against.
            This is done by sending the following JSON payload via a POST request:

            `{"user": "...", "password": "...", "remote_address": "..."}`

            Any 2xx response indicates that the credentials are authorized.
          '';
          example = "https://login-service.com/authenticate";
        };

        bindHostnames = mkOption {
          type = types.nullOr (
            types.enum [
              "all"
              "cname"
              "txt"
              "none"
            ]
          );
          default = null;
          description = ''
            Policy on whether to allow binding specific hostnames.

            Beware that this can lead to domain takeovers if misused!

            Possible values:
            - all: Allow any hostnames unconditionally, including the main domain.
            - cname: Allow any hostnames with a CNAME record pointing to the main domain.
            - txt (default): Allow any hostnames with a TXT record containing a fingerprint, including the main domain.
            - none: Don't allow user-provided hostnames, enforce subdomains.
          '';
          example = "txt";
        };

        loadBalancing = mkOption {
          type = types.nullOr (
            types.enum [
              "allow"
              "replace"
              "deny"
            ]
          );
          default = null;
          description = ''
            Strategy for load-balancing when multiple services request the same hostname/port.

            By default, traffic towards matching hostnames/ports will be load-balanced.

            Possible values:
            - allow (default): Load-balance with all available handlers.
            - replace: Don't load-balance; When adding a new handler, replace the existing one.
            - deny: Don't load-balance; Deny the new handler if there's an existing one.
          '';
          example = "allow";
        };

        loadBalancingAlgorithm = mkOption {
          type = types.nullOr (
            types.enum [
              "random"
              "round-robin"
              "ip-hash"
            ]
          );
          default = null;
          description = ''
            Algorithm to use for service selection when load-balancing.

            By default, traffic will be randomly distributed between services.

            Possible values:
            - random (default): Choose randomly.
            - round-robin: Round robin.
            - ip-hash: Choose based on IP hash.
          '';
          example = "random";
        };

        txtRecordPrefix = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Prefix for TXT DNS records containing key fingerprints, for authorization to bind under a specific domain.

            In other words, valid records will be of the form:

            `TXT <PREFIX>.<DOMAIN> SHA256:...`
          '';
          example = "_sandhole";
        };

        allowRequestedSubdomains = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Allow user-requested subdomains.
            By default, subdomains are always random.
          '';
          example = true;
        };

        allowRequestedPorts = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Allow user-requested subdomains.
            By default, subdomains are always random.
          '';
          example = true;
        };

        disableHttp = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Disable all HTTP tunneling.
            By default, this is enabled globally.
          '';
          example = true;
        };

        disableHttps = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Disable all HTTPS tunneling.
            By default, this is enabled globally.
          '';
          example = true;
        };

        disableSni = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Disable SNI proxy tunneling.
            By default, this is enabled globally.
          '';
          example = true;
        };

        disableTcp = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Disable all TCP port tunneling except HTTP.
            By default, this is enabled globally.
          '';
          example = true;
        };

        disableAliasing = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Disable all aliasing (i.e. local forwarding).
            By default, this is enabled globally.
          '';
          example = true;
        };

        disablePrometheus = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Disable the admin-only alias for the Prometheus exporter.
            By default, it is enabled.
          '';
          example = true;
        };

        quotaPerUser = mkOption {
          type = types.nullOr types.ints.positive;
          default = null;
          description = ''
            How many services can be exposed for a single user at once.
            Doesn't apply to admin users.

            Each user is distinguished by their key fingerprint or, in the case of API logins, by their username.

            By default, no limit is set.
          '';
          example = 2;
        };

        rateLimitPerUser = mkOption {
          type = types.nullOr types.ints.positive;
          default = null;
          description = ''
            How many bytes per second a single user's services can transmit at once.
            Doesn't apply to admin users.

            Each user is distinguished by their key fingerprint or, in the case of API logins, by their username.

            By default, no rate limit is set. For better results, this should be a multiple of `bufferSize`.
          '';
          example = 10000000;
        };

        randomSubdomainValue = mkOption {
          type = types.nullOr types.ints.positive;
          default = null;
          description = ''
            Set a value for random subdomains for use in conjunction with `randomSubdomainSeed`
            to allow binding to the same random address between Sandhole restarts.

            Beware that this can lead to collisions if misused!

            If unset, defaults to a random value.
          '';
          example = 42;
        };

        randomSubdomainSeed = mkOption {
          type = types.nullOr (
            types.enum [
              "ip-and-user"
              "user"
              "fingerprint"
              "address"
            ]
          );
          default = null;
          description = ''
            Which value to seed with when generating random subdomains, for determinism.
            This allows binding to the same random address until Sandhole is restarted.

            Beware that this can lead to collisions if misused!

            If unset, defaults to a random seed.

            Possible values:
            - ip-and-user: From IP address, SSH user, and requested address. Recommended if unsure.
            - user: From SSH user and requested address.
            - fingerprint: From SSH user, key fingerprint, and requested address.
            - address: From SSH connection socket (address + port) and requested address.
          '';
          example = "ip-and-user";
        };

        randomSubdomainLength = mkOption {
          type = types.nullOr types.ints.positive;
          default = null;
          description = "The length of the string appended to the start of random subdomains.";
          example = 6;
        };

        randomSubdomainFilterProfanities = mkOption {
          type = types.bool;
          default = false;
          description = "Prevents random subdomains from containing profanities.";
          example = true;
        };

        requestedDomainFilterProfanities = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Prevents user-requested domains from containing profanities.

            Beware that this can lead to false positives being blocked!
          '';
          example = true;
        };

        requestedSubdomainFilterProfanities = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Prevents user-requested subdomains from containing profanities.

            Beware that this can lead to false positives being blocked!
          '';
          example = true;
        };

        ipAllowlist = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = ''
            List of IP networks to allow.
            Setting this will block unknown IPs from connecting.
          '';
          example = [
            "192.168.0.1"
            "2001:db1::/32"
          ];
        };

        ipBlocklist = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = ''
            List of IP networks to block.
            Setting this will allow unspecified IPs to connect, unless `ipAllowlist` is set.
          '';
          example = [
            "192.168.0.1"
            "2001:db1::/32"
          ];
        };

        bufferSize = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Size to use for bidirectional buffers, in bytes.

            A higher value will lead to higher memory consumption.
          '';
          example = "32768B";
        };

        sshKeepaliveInterval = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            How long to wait between each keepalive message that is sent to an unresponsive SSH connection.
          '';
          example = "15s";
        };

        sshKeepaliveMax = mkOption {
          type = types.nullOr types.ints.unsigned;
          default = null;
          description = ''
            How many keepalive messages are sent to an unresponsive SSH connection before it is dropped.

            A value of zero disables timeouts.

            The timeout is equal to this value plus one, times `sshKeepaliveInterval`.
          '';
          example = 3;
        };

        idleConnectionTimeout = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Grace period for dangling/unauthenticated connections before they are forcefully disconnected..

            A low value may cause valid connections to be erroneously removed.
          '';
          example = "2s";
        };

        unproxiedConnectionTimeout = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Grace period for unauthenticated SSH connections after closing
            the last proxy tunnel before they are forcefully disconnected.

            A low value may cause valid proxy/tunnel connections to be erroneously removed.

            If unset, this defaults to the value set by `idleConnectionTimeout`.
          '';
          example = "2s";
        };

        authenticationRequestTimeout = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Time until a user+password authentication request is canceled.
            Any timed out requests will not authenticate the user.
          '';
          example = "5s";
        };

        httpRequestTimeout = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Time until an outgoing HTTP request is automatically canceled.

            By default, outgoing requests are not terminated by Sandhole.
          '';
          example = "60s";
        };

        tcpConnectionTimeout = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            How long until TCP connections (including Websockets and
            local forwardings) are automatically garbage-collected.

            By default, these connections are not terminated by Sandhole.
          '';
          example = "60s";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];
    };

    systemd.services = {
      sandhole = {
        description = "Expose HTTP/SSH/TCP services through SSH port forwarding.";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          User = name;
          Group = name;
          ExecStart =
            let
              args = lib.cli.toGNUCommandLineShell { } (
                {
                  domain = cfg.settings.domain;
                  domain-redirect = cfg.settings.domainRedirect;
                  user-keys-directory = cfg.settings.userKeysDirectory;
                  admin-keys-directory = cfg.settings.adminKeysDirectory;
                  certificates-directory = cfg.settings.certificatesDirectory;
                  acme-cache-directory = cfg.settings.acmeCacheDirectory;
                  private-key-file = cfg.settings.privateKeyFile;
                  disable-directory-creation = cfg.settings.disableDirectoryCreation;
                  listen-address = cfg.settings.listenAddress;
                  ssh-port = cfg.settings.sshPort;
                  http-port = cfg.settings.httpPort;
                  https-port = cfg.settings.httpsPort;
                  connect-ssh-on-https-port = cfg.settings.connectSshOnHttpsPort;
                  force-https = cfg.settings.forceHttps;
                  disable-http-logs = cfg.settings.disableHttpLogs;
                  disable-tcp-logs = cfg.settings.disableTcpLogs;
                  acme-contact-email = cfg.settings.acmeContactEmail;
                  acme-use-staging = cfg.settings.acmeUseStaging;
                  password-authentication-url = cfg.settings.passwordAuthenticationUrl;
                  bind-hostnames = cfg.settings.bindHostnames;
                  load-balancing = cfg.settings.loadBalancing;
                  load-balancing-algorithm = cfg.settings.loadBalancingAlgorithm;
                  txt-record-prefix = cfg.settings.txtRecordPrefix;
                  allow-requested-subdomains = cfg.settings.allowRequestedSubdomains;
                  allow-requested-ports = cfg.settings.allowRequestedPorts;
                  disable-http = cfg.settings.disableHttp;
                  disable-https = cfg.settings.disableHttps;
                  disable-sni = cfg.settings.disableSni;
                  disable-tcp = cfg.settings.disableTcp;
                  disable-aliasing = cfg.settings.disableAliasing;
                  disable-prometheus = cfg.settings.disablePrometheus;
                  quota-per-user = cfg.settings.quotaPerUser;
                  rate-limit-per-user = cfg.settings.rateLimitPerUser;
                  random-subdomain-value = cfg.settings.randomSubdomainValue;
                  random-subdomain-seed = cfg.settings.randomSubdomainSeed;
                  random-subdomain-length = cfg.settings.randomSubdomainLength;
                  random-subdomain-filter-profanities = cfg.settings.randomSubdomainFilterProfanities;
                  requested-domain-filter-profanities = cfg.settings.requestedDomainFilterProfanities;
                  requested-subdomain-filter-profanities = cfg.settings.requestedSubdomainFilterProfanities;
                  buffer-size = cfg.settings.bufferSize;
                  ssh-keepalive-interval = cfg.settings.sshKeepaliveInterval;
                  ssh-keepalive-max = cfg.settings.sshKeepaliveMax;
                  idle-connection-timeout = cfg.settings.idleConnectionTimeout;
                  unproxied-connection-timeout = cfg.settings.unproxiedConnectionTimeout;
                  authentication-request-timeout = cfg.settings.authenticationRequestTimeout;
                  http-request-timeout = cfg.settings.httpRequestTimeout;
                  tcp-connection-timeout = cfg.settings.tcpConnectionTimeout;
                }
                // optionalAttrs (cfg.settings.ipAllowlist != [ ]) {
                  ip-allowlist = strings.concatStringsSep "," cfg.settings.ipAllowlist;
                }
                // optionalAttrs (cfg.settings.ipBlocklist != [ ]) {
                  ip-blocklist = strings.concatStringsSep "," cfg.settings.ipBlocklist;
                }
              );
            in
            "${lib.getExe cfg.package} ${args}";
          Type = "simple";
          Restart = "always";
          StateDirectory = name;
          StateDirectoryMode = "0750";
          WorkingDirectory = stateDir;
          AmbientCapabilities = optional needsPrivilegedPorts "CAP_NET_BIND_SERVICE";
          CapabilityBoundingSet = optional needsPrivilegedPorts "CAP_NET_BIND_SERVICE";
          # Hardening
          NoNewPrivileges = true;
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
            "~@resources"
          ];
          SystemCallArchitectures = "native";
          MemoryDenyWriteExecute = true;
          PrivateMounts = true;
          PrivateUsers = false; # Incompatible with CAP_NET_BIND_SERVICE
          PrivateTmp = true;
          PrivateDevices = true;
          ProtectHome = true;
          ProtectClock = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          ProtectControlGroups = "strict";
          LockPersonality = true;
          RemoveIPC = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RestrictNamespaces = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
          ];
        };
      };
    };

    users = {
      groups.${name} = { };
      users.${name} = {
        description = "Sandhole daemon user";
        group = name;
        isSystemUser = true;
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = lists.filter (port: port != null) [
        sshPort
        httpPort
        httpsPort
      ];
      allowedTCPPortRanges = optional (!cfg.settings.disableTcp) {
        from = 1024;
        to = 65535;
      };
    };
  };

  meta.maintainers = with maintainers; [ EpicEric ];
}

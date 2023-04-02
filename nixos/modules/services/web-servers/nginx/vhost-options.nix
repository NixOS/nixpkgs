# This file defines the options that can be used both for the Nginx
# main server configuration, and for the virtual hosts.  (The latter
# has additional options that affect the web server as a whole, like
# the user/group to run under.)

{ config, lib, ... }:

with lib;
{
  options = {
    serverName = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc ''
        Name of this virtual host. Defaults to attribute name in virtualHosts.
      '';
      example = "example.org";
    };

    serverAliases = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "www.example.org" "example.org" ];
      description = lib.mdDoc ''
        Additional names of virtual hosts served by this virtual host configuration.
      '';
    };

    listen = mkOption {
      type = with types; listOf (submodule { options = {
        addr = mkOption { type = str;  description = lib.mdDoc "IP address.";  };
        port = mkOption { type = port;  description = lib.mdDoc "Port number."; default = 80; };
        ssl  = mkOption { type = bool; description = lib.mdDoc "Enable SSL.";  default = false; };
        extraParameters = mkOption { type = listOf str; description = lib.mdDoc "Extra parameters of this listen directive."; default = []; example = [ "backlog=1024" "deferred" ]; };
      }; });
      default = [];
      example = [
        { addr = "195.154.1.1"; port = 443; ssl = true; }
        { addr = "192.154.1.1"; port = 80; }
      ];
      description = lib.mdDoc ''
        Listen addresses and ports for this virtual host.
        IPv6 addresses must be enclosed in square brackets.
        Note: this option overrides `addSSL`
        and `onlySSL`.

        If you only want to set the addresses manually and not
        the ports, take a look at `listenAddresses`
      '';
    };

    listenAddresses = mkOption {
      type = with types; listOf str;

      description = lib.mdDoc ''
        Listen addresses for this virtual host.
        Compared to `listen` this only sets the addresses
        and the ports are chosen automatically.

        Note: This option overrides `enableIPv6`
      '';
      default = [];
      example = [ "127.0.0.1" "[::1]" ];
    };

    enableACME = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to ask Let's Encrypt to sign a certificate for this vhost.
        Alternately, you can use an existing certificate through {option}`useACMEHost`.
      '';
    };

    useACMEHost = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc ''
        A host of an existing Let's Encrypt certificate to use.
        This is useful if you have many subdomains and want to avoid hitting the
        [rate limit](https://letsencrypt.org/docs/rate-limits).
        Alternately, you can generate a certificate through {option}`enableACME`.
        *Note that this option does not create any certificates, nor it does add subdomains to existing ones – you will need to create them manually using [](#opt-security.acme.certs).*
      '';
    };

    acmeRoot = mkOption {
      type = types.nullOr types.str;
      default = "/var/lib/acme/acme-challenge";
      description = lib.mdDoc ''
        Directory for the ACME challenge, which is **public**. Don't put certs or keys in here.
        Set to null to inherit from config.security.acme.
      '';
    };

    acmeFallbackHost = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc ''
        Host which to proxy requests to if ACME challenge is not found. Useful
        if you want multiple hosts to be able to verify the same domain name.

        With this option, you could request certificates for the present domain
        with an ACME client that is running on another host, which you would
        specify here.
      '';
    };

    addSSL = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable HTTPS in addition to plain HTTP. This will set defaults for
        `listen` to listen on all interfaces on the respective default
        ports (80, 443).
      '';
    };

    onlySSL = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable HTTPS and reject plain HTTP connections. This will set
        defaults for `listen` to listen on all interfaces on port 443.
      '';
    };

    enableSSL = mkOption {
      type = types.bool;
      visible = false;
      default = false;
    };

    forceSSL = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to add a separate nginx server block that permanently redirects (301)
        all plain HTTP traffic to HTTPS. This will set defaults for
        `listen` to listen on all interfaces on the respective default
        ports (80, 443), where the non-SSL listens are used for the redirect vhosts.
      '';
    };

    rejectSSL = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to listen for and reject all HTTPS connections to this vhost. Useful in
        [default](#opt-services.nginx.virtualHosts._name_.default)
        server blocks to avoid serving the certificate for another vhost. Uses the
        `ssl_reject_handshake` directive available in nginx versions
        1.19.4 and above.
      '';
    };

    kTLS = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable kTLS support.
        Implementing TLS in the kernel (kTLS) improves performance by significantly
        reducing the need for copying operations between user space and the kernel.
        Required Nginx version 1.21.4 or later.
      '';
    };

    sslCertificate = mkOption {
      type = types.path;
      example = "/var/host.cert";
      description = lib.mdDoc "Path to server SSL certificate.";
    };

    sslCertificateKey = mkOption {
      type = types.path;
      example = "/var/host.key";
      description = lib.mdDoc "Path to server SSL certificate key.";
    };

    sslTrustedCertificate = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = literalExpression ''"''${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"'';
      description = lib.mdDoc "Path to root SSL certificate for stapling and client certificates.";
    };

    http2 = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Whether to enable the HTTP/2 protocol.
        Note that (as of writing) due to nginx's implementation, to disable
        HTTP/2 you have to disable it on all vhosts that use a given
        IP address / port.
        If there is one server block configured to enable http2, then it is
        enabled for all server blocks on this IP.
        See https://stackoverflow.com/a/39466948/263061.
      '';
    };

    http3 = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Whether to enable the HTTP/3 protocol.
        This requires using `pkgs.nginxQuic` package
        which can be achieved by setting `services.nginx.package = pkgs.nginxQuic;`
        and activate the QUIC transport protocol
        `services.nginx.virtualHosts.<name>.quic = true;`.
        Note that HTTP/3 support is experimental and
        *not* yet recommended for production.
        Read more at https://quic.nginx.org/
      '';
    };

    http3_hq = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable the HTTP/0.9 protocol negotiation used in QUIC interoperability tests.
        This requires using `pkgs.nginxQuic` package
        which can be achieved by setting `services.nginx.package = pkgs.nginxQuic;`
        and activate the QUIC transport protocol
        `services.nginx.virtualHosts.<name>.quic = true;`.
        Note that special application protocol support is experimental and
        *not* yet recommended for production.
        Read more at https://quic.nginx.org/
      '';
    };

    quic = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable the QUIC transport protocol.
        This requires using `pkgs.nginxQuic` package
        which can be achieved by setting `services.nginx.package = pkgs.nginxQuic;`.
        Note that QUIC support is experimental and
        *not* yet recommended for production.
        Read more at https://quic.nginx.org/
      '';
    };

    reuseport = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Create an individual listening socket .
        It is required to specify only once on one of the hosts.
      '';
    };

    root = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/data/webserver/docs";
      description = lib.mdDoc ''
        The path of the web root directory.
      '';
    };

    default = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Makes this vhost the default.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = lib.mdDoc ''
        These lines go to the end of the vhost verbatim.
      '';
    };

    globalRedirect = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "newserver.example.org";
      description = lib.mdDoc ''
        If set, all requests for this host are redirected permanently to
        the given hostname.
      '';
    };

    basicAuth = mkOption {
      type = types.attrsOf types.str;
      default = {};
      example = literalExpression ''
        {
          user = "password";
        };
      '';
      description = lib.mdDoc ''
        Basic Auth protection for a vhost.

        WARNING: This is implemented to store the password in plain text in the
        Nix store.
      '';
    };

    basicAuthFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc ''
        Basic Auth password file for a vhost.
        Can be created via: {command}`htpasswd -c <filename> <username>`.

        WARNING: The generate file contains the users' passwords in a
        non-cryptographically-securely hashed way.
      '';
    };

    locations = mkOption {
      type = types.attrsOf (types.submodule (import ./location-options.nix {
        inherit lib config;
      }));
      default = {};
      example = literalExpression ''
        {
          "/" = {
            proxyPass = "http://localhost:3000";
          };
        };
      '';
      description = lib.mdDoc "Declarative location config";
    };
  };
}

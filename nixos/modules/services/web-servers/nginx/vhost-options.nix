# This file defines the options that can be used both for the Apache
# main server configuration, and for the virtual hosts.  (The latter
# has additional options that affect the web server as a whole, like
# the user/group to run under.)

{ lib, ... }:

with lib;
{
  options = {
    serverName = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Name of this virtual host. Defaults to attribute name in virtualHosts.
      '';
      example = "example.org";
    };

    serverAliases = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["www.example.org" "example.org"];
      description = ''
        Additional names of virtual hosts served by this virtual host configuration.
      '';
    };

    listen = mkOption {
      type = with types; listOf (submodule { options = {
        addr = mkOption { type = str;  description = "IP address.";  };
        port = mkOption { type = int;  description = "Port number."; default = 80; };
        ssl  = mkOption { type = bool; description = "Enable SSL.";  default = false; };
      }; });
      default = [];
      example = [
        { addr = "195.154.1.1"; port = 443; ssl = true;}
        { addr = "192.154.1.1"; port = 80; }
      ];
      description = ''
        Listen addresses and ports for this virtual host.
        IPv6 addresses must be enclosed in square brackets.
        Note: this option overrides <literal>addSSL</literal>
        and <literal>onlySSL</literal>.
      '';
    };

    enableACME = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to ask Let's Encrypt to sign a certificate for this vhost.
        Alternately, you can use an existing certificate through <option>useACMEHost</option>.
      '';
    };

    useACMEHost = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        A host of an existing Let's Encrypt certificate to use.
        This is useful if you have many subdomains and want to avoid hitting the
        <link xlink:href="https://letsencrypt.org/docs/rate-limits/">rate limit</link>.
        Alternately, you can generate a certificate through <option>enableACME</option>.
        <emphasis>Note that this option does not create any certificates, nor it does add subdomains to existing ones – you will need to create them manually using  <xref linkend="opt-security.acme.certs"/>.</emphasis>
      '';
    };

    acmeRoot = mkOption {
      type = types.str;
      default = "/var/lib/acme/acme-challenge";
      description = "Directory to store certificates and keys managed by the ACME service.";
    };

    acmeFallbackHost = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Host which to proxy requests to if acme challenge is not found. Useful
        if you want multiple hosts to be able to verify the same domain name.
      '';
    };

    addSSL = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable HTTPS in addition to plain HTTP. This will set defaults for
        <literal>listen</literal> to listen on all interfaces on the respective default
        ports (80, 443).
      '';
    };

    onlySSL = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable HTTPS and reject plain HTTP connections. This will set
        defaults for <literal>listen</literal> to listen on all interfaces on port 443.
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
      description = ''
        Whether to add a separate nginx server block that permanently redirects (301)
        all plain HTTP traffic to HTTPS. This will set defaults for
        <literal>listen</literal> to listen on all interfaces on the respective default
        ports (80, 443), where the non-SSL listens are used for the redirect vhosts.
      '';
    };

    sslCertificate = mkOption {
      type = types.path;
      example = "/var/host.cert";
      description = "Path to server SSL certificate.";
    };

    sslCertificateKey = mkOption {
      type = types.path;
      example = "/var/host.key";
      description = "Path to server SSL certificate key.";
    };

    sslTrustedCertificate = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/var/root.cert";
      description = "Path to root SSL certificate for stapling and client certificates.";
    };

    http2 = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to enable HTTP 2.
        Note that (as of writing) due to nginx's implementation, to disable
        HTTP 2 you have to disable it on all vhosts that use a given
        IP address / port.
        If there is one server block configured to enable http2,then it is
        enabled for all server blocks on this IP.
        See https://stackoverflow.com/a/39466948/263061.
      '';
    };

    root = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/data/webserver/docs";
      description = ''
        The path of the web root directory.
      '';
    };

    default = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Makes this vhost the default.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        These lines go to the end of the vhost verbatim.
      '';
    };

    globalRedirect = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "newserver.example.org";
      description = ''
        If set, all requests for this host are redirected permanently to
        the given hostname.
      '';
    };

    basicAuth = mkOption {
      type = types.attrsOf types.str;
      default = {};
      example = literalExample ''
        {
          user = "password";
        };
      '';
      description = ''
        Basic Auth protection for a vhost.

        WARNING: This is implemented to store the password in plain text in the
        nix store.
      '';
    };

    basicAuthFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Basic Auth password file for a vhost.
      '';
    };

    locations = mkOption {
      type = types.attrsOf (types.submodule (import ./location-options.nix {
        inherit lib;
      }));
      default = {};
      example = literalExample ''
        {
          "/" = {
            proxyPass = "http://localhost:3000";
          };
        };
      '';
      description = "Declarative location config";
    };
  };
}

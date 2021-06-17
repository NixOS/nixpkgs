{ config, lib, name, ... }:
let
  inherit (lib) literalExample mkOption types;
in
{
  options = {

    hostName = mkOption {
      type = types.str;
      default = name;
      description = "Canonical hostname for the server.";
    };

    serverAliases = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["www.example.org" "example.org"];
      description = ''
        Additional names of virtual hosts served by this virtual host configuration.
      '';
    };

    addSSL = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable HTTPS in addition to plain HTTP. This will set defaults for
        <link linkend="opt-services.tomcat.connectors">connectors</link> to listen on all interfaces on the respective default
        ports (80, 443).
      '';
    };

    onlySSL = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable HTTPS and reject plain HTTP connections. This will set
        defaults for <link linkend="opt-services.tomcat.connectors">connectors</link> to listen on all interfaces on port 443.
      '';
    };

    forceSSL = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to add a separate tomcat server block that permanently redirects (301)
        all plain HTTP traffic to HTTPS. This will set defaults for
        <link linkend="opt-services.tomcat.connectors">connectors</link> to listen on all interfaces on the respective default
        ports (80, 443), where the non-SSL listens are used for the redirect vhosts.
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
        <emphasis>Note that this option does not create any certificates, nor it does add subdomains to existing ones – you will need to create them manually using <xref linkend="opt-security.acme.certs"/>.</emphasis>
      '';
    };

    acmeRoot = mkOption {
      type = types.str;
      default = "/var/lib/acme/acme-challenges";
      description = "Directory for the acme challenge which is PUBLIC, don't put certs or keys in here";
    };

    sslHostConfig = mkOption {
      type = with types; attrsOf (oneOf [ bool int str ]);
      default = {};
      example = literalExample ''
        {
          disableCompression = false;
          disableSessionTickets = true;
          honorCipherOrder = false;
        }
      '';
      description = ''
        <link xlink:href="https://tomcat.apache.org/tomcat-9.0-doc/config/http.html#SSL_Support_-_SSLHostConfig"/>
      '';
    };

    sslServerCert = mkOption {
      type = types.path;
      example = "/var/host.cert";
      description = ''
        Name of the file that contains the server certificate. The format is PEM-encoded. Refer to
        <link xlink:href="https://tomcat.apache.org/tomcat-9.0-doc/config/http.html#SSL_Support_-_Certificate"/>
        for details.
      '';
    };

    sslServerKey = mkOption {
      type = types.path;
      example = "/var/host.key";
      description = ''
        Name of the file that contains the server private key. The format is PEM-encoded. Refer to
        <link xlink:href="https://tomcat.apache.org/tomcat-9.0-doc/config/http.html#SSL_Support_-_Certificate"/>
        for details.
      '';
    };

    sslServerChain = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/var/ca.pem";
      description = ''
        Name of the file that contains the certificate chain associated with the server certificate used. The format
        is PEM-encoded. The certificate chain used for Tomcat should not include the server certificate as its first
        element. Refer to
        <link xlink:href="https://tomcat.apache.org/tomcat-9.0-doc/config/http.html#SSL_Support_-_Certificate"/>
        for details.
      '';
    };

    appBase = mkOption {
      type = types.path;
      example = "/data/webserver/docs"; # TODO: better example
      description = ''
        The Application Base directory for this virtual host. This is the
        pathname of a directory that may contain web applications to be
        deployed on this virtual host.
      '';
    };

    settings = mkOption {
      type = with types; attrsOf (oneOf [ bool int str ]);
      default = {};
      example = literalExample ''
        {
          unpackWARs = false;
          autoDeploy = false;
        }
      '';
      description = ''
        <link xlink:href="https://tomcat.apache.org/tomcat-9.0-doc/config/host.html"/>
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      example = ''
        <Listener
          className="org.apache.catalina.startup.UserConfig"
          directoryName="public_html"
          userClass="org.apache.catalina.startup.PasswdUserDatabase"
        />
      '';
      description = ''
        These lines of xml are copied verbatim into the <literal>Host</literal>
        element of <literal>server.xml</literal>.
      '';
    };

    logFormat = mkOption {
      type = with types; nullOr str;
      default = "%h %l %u %t &quot;%r&quot; %s %b";
      example = "TODO: give a different example, post a link";
      description = ''
        Specify null to disable access logging.
      '';
    };

    robotsEntries = mkOption {
      type = types.lines;
      default = "";
      example = "Disallow: /foo/";
      description = ''
        Specification of pages to be ignored by web crawlers. See <link
        xlink:href='http://www.robotstxt.org/'/> for details.
      '';
    };

    # purely for proper error handling
    webapps = mkOption {
      type = with types; listOf path;
      description = ''
      '';
      default = [];
    };
  };
}

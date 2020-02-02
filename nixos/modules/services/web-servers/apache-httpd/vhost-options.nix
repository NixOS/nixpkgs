{ config, lib, name, ... }:
let
  inherit (lib) literalExample mkOption nameValuePair types;
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
      example = ["www.example.org" "www.example.org:8080" "example.org"];
      description = ''
        Additional names of virtual hosts served by this virtual host configuration.
      '';
    };

    listen = mkOption {
      type = with types; listOf (submodule ({
        options = {
          port = mkOption {
            type = types.port;
            description = "Port to listen on";
          };
          ip = mkOption {
            type = types.str;
            default = "*";
            description = "IP to listen on. 0.0.0.0 for IPv4 only, * for all.";
          };
          ssl = mkOption {
            type = types.bool;
            default = false;
            description = "Whether to enable SSL (https) support.";
          };
        };
      }));
      default = [];
      example = [
        { ip = "195.154.1.1"; port = 443; ssl = true;}
        { ip = "192.154.1.1"; port = 80; }
        { ip = "*"; port = 8080; }
      ];
      description = ''
        Listen addresses and ports for this virtual host.
        <note><para>
          This option overrides <literal>addSSL</literal>, <literal>forceSSL</literal> and <literal>onlySSL</literal>.
        </para></note>
      '';
    };

    enableSSL = mkOption {
      type = types.bool;
      visible = false;
      default = false;
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
      default = "/var/lib/acme/acme-challenges";
      description = "Directory for the acme challenge which is PUBLIC, don't put certs or keys in here";
    };

    sslServerCert = mkOption {
      type = types.path;
      example = "/var/host.cert";
      description = "Path to server SSL certificate.";
    };

    sslServerKey = mkOption {
      type = types.path;
      example = "/var/host.key";
      description = "Path to server SSL certificate key.";
    };

    sslServerChain = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/var/ca.pem";
      description = "Path to server SSL chain file.";
    };

    adminAddr = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "admin@example.org";
      description = "E-mail address of the server administrator.";
    };

    documentRoot = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/data/webserver/docs";
      description = ''
        The path of Apache's document root directory.  If left undefined,
        an empty directory in the Nix store will be used as root.
      '';
    };

    servedDirs = mkOption {
      type = types.listOf types.attrs;
      default = [];
      example = [
        { urlPath = "/nix";
          dir = "/home/eelco/Dev/nix-homepage";
        }
      ];
      description = ''
        This option provides a simple way to serve static directories.
      '';
    };

    servedFiles = mkOption {
      type = types.listOf types.attrs;
      default = [];
      example = [
        { urlPath = "/foo/bar.png";
          file = "/home/eelco/some-file.png";
        }
      ];
      description = ''
        This option provides a simple way to serve individual, static files.

        <note><para>
          This option has been deprecated and will be removed in a future
          version of NixOS. You can achieve the same result by making use of
          the <literal>locations.&lt;name&gt;.alias</literal> option.
        </para></note>
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      example = ''
        <Directory /home>
          Options FollowSymlinks
          AllowOverride All
        </Directory>
      '';
      description = ''
        These lines go to httpd.conf verbatim. They will go after
        directories and directory aliases defined by default.
      '';
    };

    enableUserDir = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable serving <filename>~/public_html</filename> as
        <literal>/~<replaceable>username</replaceable></literal>.
      '';
    };

    globalRedirect = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = http://newserver.example.org/;
      description = ''
        If set, all requests for this host are redirected permanently to
        the given URL.
      '';
    };

    logFormat = mkOption {
      type = types.str;
      default = "common";
      example = "combined";
      description = ''
        Log format for Apache's log files. Possible values are: combined, common, referer, agent.
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

    locations = mkOption {
      type = with types; attrsOf (submodule (import ./location-options.nix));
      default = {};
      example = literalExample ''
        {
          "/" = {
            proxyPass = "http://localhost:3000";
          };
          "/foo/bar.png" = {
            alias = "/home/eelco/some-file.png";
          };
        };
      '';
      description = ''
        Declarative location config. See <link
        xlink:href="https://httpd.apache.org/docs/2.4/mod/core.html#location"/> for details.
      '';
    };

  };

  config = {

    locations = builtins.listToAttrs (map (elem: nameValuePair elem.urlPath { alias = elem.file; }) config.servedFiles);

  };
}

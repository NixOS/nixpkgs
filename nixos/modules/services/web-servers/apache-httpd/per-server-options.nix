# This file defines the options that can be used both for the Apache
# main server configuration, and for the virtual hosts.  (The latter
# has additional options that affect the web server as a whole, like
# the user/group to run under.)

{ forMainServer, lib }:

with lib;

{

  hostName = mkOption {
    type = types.str;
    default = "localhost";
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

  port = mkOption {
    type = types.int;
    default = 0;
    description = ''
      Port for the server. Option will be removed, use <option>listen</option> instead.
  '';
  };

  listen = mkOption {
     type = types.listOf (types.submodule (
          {
            options = {
              port = mkOption {
                type = types.int;
                description = "port to listen on";
              };
              ip = mkOption {
                type = types.string;
                default = "*";
                description = "Ip to listen on. 0.0.0.0 for ipv4 only, * for all.";
              };
            };
          } ));
    description = ''
      List of { /* ip: "*"; */ port = 80;} to listen on
    '';

    default = [];
  };

  enableSSL = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable SSL (https) support.";
  };

  # Note: sslServerCert and sslServerKey can be left empty, but this
  # only makes sense for virtual hosts (they will inherit from the
  # main server).

  sslServerCert = mkOption {
    type = types.nullOr types.path;
    default = null;
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

  adminAddr = mkOption ({
    type = types.nullOr types.str;
    example = "admin@example.org";
    description = "E-mail address of the server administrator.";
  } // (if forMainServer then {} else {default = null;}));

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

  extraSubservices = mkOption {
    type = types.listOf types.unspecified;
    default = [];
    description = "Extra subservices to enable in the webserver.";
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

}

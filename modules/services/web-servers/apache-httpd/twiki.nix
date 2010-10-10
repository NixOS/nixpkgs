{ config, pkgs, serverInfo, ... }:

let

  inherit (pkgs.lib) mkOption;

  dataDir = config.dataDir; # "/data/pt-wiki/data";
  pubDir = config.pubDir; # "/data/pt-wiki/pub";

  scriptUrlPath = "/bin";
  pubUrlPath    = "/pub";
  absHostPath   = "/";

  # Hacks for proxying and rewriting
  dispPubUrlPath    = "/pub";
  dispScriptUrlPath = "";
  dispViewPath      = "";

  startWeb = config.startWeb;
  defaultUrlHost = "";

  # Build the TWiki CGI and configuration files.
  twikiRoot = (import /etc/nixos/services/twiki/twiki-instance.nix { inherit pkgs; }).twiki {
    name = "wiki-instance";
    pubdir = pubDir;
    datadir = dataDir;
    inherit scriptUrlPath pubUrlPath absHostPath
      dispPubUrlPath dispScriptUrlPath dispViewPath defaultUrlHost;
    twikiName = config.twikiName;
    registrationDomain = config.registrationDomain;
  };

  plugins = import /etc/nixos/services/twiki/server-pkgs/twiki-plugins.nix;

in {

  extraConfig = ''

    ScriptAlias ${scriptUrlPath} "${twikiRoot}/bin"
    Alias ${pubUrlPath} "${pubDir}"

    <Directory "${twikiRoot}/bin">
       Options +ExecCGI
       SetHandler cgi-script
       AllowOverride All
       Allow from all
    </Directory>
    <Directory "${twikiRoot}/templates">
       deny from all
    </Directory>
    <Directory "${twikiRoot}/lib">
       deny from all
    </Directory>
    <Directory "${pubDir}">
       Options None
       AllowOverride None
       Allow from all
       # Hardening suggested by http://twiki.org/cgi-bin/view/Codev/SecurityAlertSecureFileUploads.
       php_admin_flag engine off
       AddType text/plain .html .htm .shtml .php .php3 .phtml .phtm .pl .py .cgi
    </Directory>
    <Directory "${dataDir}">
       deny from all
    </Directory>

    Alias ${absHostPath} ${twikiRoot}/rewritestub/

    <Directory "${twikiRoot}/rewritestub">
      RewriteEngine On
      RewriteBase ${absHostPath}

      # complete bin path
      RewriteRule ^bin(.*)  bin/$1 [L]

      #@customRewriteRules@

      # Hack for restricted webs.
      RewriteRule ^pt/(.*)  $1

      # action / web / whatever
      RewriteRule ^([a-z]+)/([A-Z][^/]+)/(.*)  bin/$1/$2/$3 [L]

      # web / topic
      RewriteRule ^([A-Z][^/]+)/([^/]+)   bin/view/$1/$2 [L]

      # web
      RewriteRule ^([A-Z][^/]+)           bin/view/$1/WebHome [L]

      # web/
      RewriteRule ^([A-Z][^/]+)/          bin/view/$1/WebHome [L]

      RewriteRule ^index.html$            bin/view/${startWeb} [L]

      RewriteRule ^$                      bin/view/${startWeb} [L]
    </Directory>

  '';

  robotsEntries = ''
    User-agent: *
    Disallow: /rdiff/
    Disallow: /rename/
    Disallow: /edit/
    Disallow: /bin/
    Disallow: /oops/
    Disallow: /view/
    Disallow: /search/
    Disallow: /attach/
    Disallow: /pt/bin/
  '';

  options = {

    dataDir = mkOption {
      example = "/data/wiki/data";
      description = "
        Path to the directory that holds the Wiki data.
      ";
    };

    pubDir = mkOption {
      example = "/data/wiki/pub";
      description = "
        Path to the directory that holds uploaded files.
      ";
    };

    twikiName = mkOption {
      default = "Wiki";
      example = "Foobar Wiki";
      description = "
        Name of this Wiki.
      ";
    };

    registrationDomain = mkOption {
      example = "example.org";
      description = "
        Domain from which registrations are permitted.  Use `all' to
        permit registrations from anywhere.
      ";
    };

  };  

}

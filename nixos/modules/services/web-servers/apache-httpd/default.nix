{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.httpd;

  runtimeDir = "/run/httpd";

  pkg = cfg.package.out;

  httpdConf = cfg.configFile;

  php = cfg.phpPackage.override { apacheHttpd = pkg.dev; /* otherwise it only gets .out */ };

  phpMajorVersion = lib.versions.major (lib.getVersion php);

  mod_perl = pkgs.apacheHttpdPackages.mod_perl.override { apacheHttpd = pkg; };

  vhosts = attrValues cfg.virtualHosts;

  mkListenInfo = hostOpts:
    if hostOpts.listen != [] then hostOpts.listen
    else (
      optional (hostOpts.onlySSL || hostOpts.addSSL || hostOpts.forceSSL) { ip = "*"; port = 443; ssl = true; } ++
      optional (!hostOpts.onlySSL) { ip = "*"; port = 80; ssl = false; }
    );

  listenInfo = unique (concatMap mkListenInfo vhosts);

  enableHttp2 = any (vhost: vhost.http2) vhosts;
  enableSSL = any (listen: listen.ssl) listenInfo;
  enableUserDir = any (vhost: vhost.enableUserDir) vhosts;

  # NOTE: generally speaking order of modules is very important
  modules =
    [ # required apache modules our httpd service cannot run without
      "authn_core" "authz_core"
      "log_config"
      "mime" "autoindex" "negotiation" "dir"
      "alias" "rewrite"
      "unixd" "slotmem_shm" "socache_shmcb"
      "mpm_${cfg.multiProcessingModule}"
    ]
    ++ (if cfg.multiProcessingModule == "prefork" then [ "cgi" ] else [ "cgid" ])
    ++ optional enableHttp2 "http2"
    ++ optional enableSSL "ssl"
    ++ optional enableUserDir "userdir"
    ++ optional cfg.enableMellon { name = "auth_mellon"; path = "${pkgs.apacheHttpdPackages.mod_auth_mellon}/modules/mod_auth_mellon.so"; }
    ++ optional cfg.enablePHP { name = "php${phpMajorVersion}"; path = "${php}/modules/libphp${phpMajorVersion}.so"; }
    ++ optional cfg.enablePerl { name = "perl"; path = "${mod_perl}/modules/mod_perl.so"; }
    ++ cfg.extraModules;

  loggingConf = (if cfg.logFormat != "none" then ''
    ErrorLog ${cfg.logDir}/error.log

    LogLevel notice

    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    LogFormat "%h %l %u %t \"%r\" %>s %b" common
    LogFormat "%{Referer}i -> %U" referer
    LogFormat "%{User-agent}i" agent

    CustomLog ${cfg.logDir}/access.log ${cfg.logFormat}
  '' else ''
    ErrorLog /dev/null
  '');


  browserHacks = ''
    <IfModule mod_setenvif.c>
        BrowserMatch "Mozilla/2" nokeepalive
        BrowserMatch "MSIE 4\.0b2;" nokeepalive downgrade-1.0 force-response-1.0
        BrowserMatch "RealPlayer 4\.0" force-response-1.0
        BrowserMatch "Java/1\.0" force-response-1.0
        BrowserMatch "JDK/1\.0" force-response-1.0
        BrowserMatch "Microsoft Data Access Internet Publishing Provider" redirect-carefully
        BrowserMatch "^WebDrive" redirect-carefully
        BrowserMatch "^WebDAVFS/1.[012]" redirect-carefully
        BrowserMatch "^gnome-vfs" redirect-carefully
    </IfModule>
  '';


  sslConf = ''
    <IfModule mod_ssl.c>
        SSLSessionCache shmcb:${runtimeDir}/ssl_scache(512000)

        Mutex posixsem

        SSLRandomSeed startup builtin
        SSLRandomSeed connect builtin

        SSLProtocol ${cfg.sslProtocols}
        SSLCipherSuite ${cfg.sslCiphers}
        SSLHonorCipherOrder on
    </IfModule>
  '';


  mimeConf = ''
    TypesConfig ${pkg}/conf/mime.types

    AddType application/x-x509-ca-cert .crt
    AddType application/x-pkcs7-crl    .crl
    AddType application/x-httpd-php    .php .phtml

    <IfModule mod_mime_magic.c>
        MIMEMagicFile ${pkg}/conf/magic
    </IfModule>
  '';

  mkVHostConf = hostOpts:
    let
      adminAddr = if hostOpts.adminAddr != null then hostOpts.adminAddr else cfg.adminAddr;
      listen = filter (listen: !listen.ssl) (mkListenInfo hostOpts);
      listenSSL = filter (listen: listen.ssl) (mkListenInfo hostOpts);

      useACME = hostOpts.enableACME || hostOpts.useACMEHost != null;
      sslCertDir =
        if hostOpts.enableACME then config.security.acme.certs.${hostOpts.hostName}.directory
        else if hostOpts.useACMEHost != null then config.security.acme.certs.${hostOpts.useACMEHost}.directory
        else abort "This case should never happen.";

      sslServerCert = if useACME then "${sslCertDir}/full.pem" else hostOpts.sslServerCert;
      sslServerKey = if useACME then "${sslCertDir}/key.pem" else hostOpts.sslServerKey;
      sslServerChain = if useACME then "${sslCertDir}/fullchain.pem" else hostOpts.sslServerChain;

      acmeChallenge = optionalString useACME ''
        Alias /.well-known/acme-challenge/ "${hostOpts.acmeRoot}/.well-known/acme-challenge/"
        <Directory "${hostOpts.acmeRoot}">
            AllowOverride None
            Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
            Require method GET POST OPTIONS
            Require all granted
        </Directory>
      '';
    in
      optionalString (listen != []) ''
        <VirtualHost ${concatMapStringsSep " " (listen: "${listen.ip}:${toString listen.port}") listen}>
            ServerName ${hostOpts.hostName}
            ${concatMapStrings (alias: "ServerAlias ${alias}\n") hostOpts.serverAliases}
            ServerAdmin ${adminAddr}
            <IfModule mod_ssl.c>
                SSLEngine off
            </IfModule>
            ${acmeChallenge}
            ${if hostOpts.forceSSL then ''
              <IfModule mod_rewrite.c>
                  RewriteEngine on
                  RewriteCond %{REQUEST_URI} !^/.well-known/acme-challenge [NC]
                  RewriteCond %{HTTPS} off
                  RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI}
              </IfModule>
            '' else mkVHostCommonConf hostOpts}
        </VirtualHost>
      '' +
      optionalString (listenSSL != []) ''
        <VirtualHost ${concatMapStringsSep " " (listen: "${listen.ip}:${toString listen.port}") listenSSL}>
            ServerName ${hostOpts.hostName}
            ${concatMapStrings (alias: "ServerAlias ${alias}\n") hostOpts.serverAliases}
            ServerAdmin ${adminAddr}
            SSLEngine on
            SSLCertificateFile ${sslServerCert}
            SSLCertificateKeyFile ${sslServerKey}
            ${optionalString (sslServerChain != null) "SSLCertificateChainFile ${sslServerChain}"}
            ${optionalString hostOpts.http2 "Protocols h2 h2c http/1.1"}
            ${acmeChallenge}
            ${mkVHostCommonConf hostOpts}
        </VirtualHost>
      ''
  ;

  mkVHostCommonConf = hostOpts:
    let
      documentRoot = if hostOpts.documentRoot != null
        then hostOpts.documentRoot
        else pkgs.runCommand "empty" { preferLocalBuild = true; } "mkdir -p $out"
      ;

      mkLocations = locations: concatStringsSep "\n" (map (config: ''
        <Location ${config.location}>
          ${optionalString (config.proxyPass != null) ''
            <IfModule mod_proxy.c>
                ProxyPass ${config.proxyPass}
                ProxyPassReverse ${config.proxyPass}
            </IfModule>
          ''}
          ${optionalString (config.index != null) ''
            <IfModule mod_dir.c>
                DirectoryIndex ${config.index}
            </IfModule>
          ''}
          ${optionalString (config.alias != null) ''
            <IfModule mod_alias.c>
                Alias "${config.alias}"
            </IfModule>
          ''}
          ${config.extraConfig}
        </Location>
      '') (sortProperties (mapAttrsToList (k: v: v // { location = k; }) locations)));
    in
      ''
        ${optionalString cfg.logPerVirtualHost ''
          ErrorLog ${cfg.logDir}/error-${hostOpts.hostName}.log
          CustomLog ${cfg.logDir}/access-${hostOpts.hostName}.log ${hostOpts.logFormat}
        ''}

        ${optionalString (hostOpts.robotsEntries != "") ''
          Alias /robots.txt ${pkgs.writeText "robots.txt" hostOpts.robotsEntries}
        ''}

        DocumentRoot "${documentRoot}"

        <Directory "${documentRoot}">
            Options Indexes FollowSymLinks
            AllowOverride None
            Require all granted
        </Directory>

        ${optionalString hostOpts.enableUserDir ''
          UserDir public_html
          UserDir disabled root
          <Directory "/home/*/public_html">
              AllowOverride FileInfo AuthConfig Limit Indexes
              Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
              <Limit GET POST OPTIONS>
                  Require all granted
              </Limit>
              <LimitExcept GET POST OPTIONS>
                  Require all denied
              </LimitExcept>
          </Directory>
        ''}

        ${optionalString (hostOpts.globalRedirect != null && hostOpts.globalRedirect != "") ''
          RedirectPermanent / ${hostOpts.globalRedirect}
        ''}

        ${
          let makeDirConf = elem: ''
                Alias ${elem.urlPath} ${elem.dir}/
                <Directory ${elem.dir}>
                    Options +Indexes
                    Require all granted
                    AllowOverride All
                </Directory>
              '';
          in concatMapStrings makeDirConf hostOpts.servedDirs
        }

        ${mkLocations hostOpts.locations}
        ${hostOpts.extraConfig}
      ''
  ;


  confFile = pkgs.writeText "httpd.conf" ''

    ServerRoot ${pkg}
    ServerName ${config.networking.hostName}
    DefaultRuntimeDir ${runtimeDir}/runtime

    PidFile ${runtimeDir}/httpd.pid

    ${optionalString (cfg.multiProcessingModule != "prefork") ''
      # mod_cgid requires this.
      ScriptSock ${runtimeDir}/cgisock
    ''}

    <IfModule prefork.c>
        MaxClients           ${toString cfg.maxClients}
        MaxRequestsPerChild  ${toString cfg.maxRequestsPerChild}
    </IfModule>

    ${let
        toStr = listen: "Listen ${listen.ip}:${toString listen.port} ${if listen.ssl then "https" else "http"}";
        uniqueListen = uniqList {inputList = map toStr listenInfo;};
      in concatStringsSep "\n" uniqueListen
    }

    User ${cfg.user}
    Group ${cfg.group}

    ${let
        mkModule = module:
          if isString module then { name = module; path = "${pkg}/modules/mod_${module}.so"; }
          else if isAttrs module then { inherit (module) name path; }
          else throw "Expecting either a string or attribute set including a name and path.";
      in
        concatMapStringsSep "\n" (module: "LoadModule ${module.name}_module ${module.path}") (unique (map mkModule modules))
    }

    AddHandler type-map var

    <Files ~ "^\.ht">
        Require all denied
    </Files>

    ${mimeConf}
    ${loggingConf}
    ${browserHacks}

    Include ${pkg}/conf/extra/httpd-default.conf
    Include ${pkg}/conf/extra/httpd-autoindex.conf
    Include ${pkg}/conf/extra/httpd-multilang-errordoc.conf
    Include ${pkg}/conf/extra/httpd-languages.conf

    TraceEnable off

    ${sslConf}

    # Fascist default - deny access to everything.
    <Directory />
        Options FollowSymLinks
        AllowOverride None
        Require all denied
    </Directory>

    # But do allow access to files in the store so that we don't have
    # to generate <Directory> clauses for every generated file that we
    # want to serve.
    <Directory /nix/store>
        Require all granted
    </Directory>

    ${cfg.extraConfig}

    ${concatMapStringsSep "\n" mkVHostConf vhosts}
  '';

  # Generate the PHP configuration file.  Should probably be factored
  # out into a separate module.
  phpIni = pkgs.runCommand "php.ini"
    { options = cfg.phpOptions;
      preferLocalBuild = true;
    }
    ''
      cat ${php}/etc/php.ini > $out
      echo "$options" >> $out
    '';

in


{

  imports = [
    (mkRemovedOptionModule [ "services" "httpd" "extraSubservices" ] "Most existing subservices have been ported to the NixOS module system. Please update your configuration accordingly.")
    (mkRemovedOptionModule [ "services" "httpd" "stateDir" ] "The httpd module now uses /run/httpd as a runtime directory.")

    # virtualHosts options
    (mkRemovedOptionModule [ "services" "httpd" "documentRoot" ] "Please define a virtual host using `services.httpd.virtualHosts`.")
    (mkRemovedOptionModule [ "services" "httpd" "enableSSL" ] "Please define a virtual host using `services.httpd.virtualHosts`.")
    (mkRemovedOptionModule [ "services" "httpd" "enableUserDir" ] "Please define a virtual host using `services.httpd.virtualHosts`.")
    (mkRemovedOptionModule [ "services" "httpd" "globalRedirect" ] "Please define a virtual host using `services.httpd.virtualHosts`.")
    (mkRemovedOptionModule [ "services" "httpd" "hostName" ] "Please define a virtual host using `services.httpd.virtualHosts`.")
    (mkRemovedOptionModule [ "services" "httpd" "listen" ] "Please define a virtual host using `services.httpd.virtualHosts`.")
    (mkRemovedOptionModule [ "services" "httpd" "robotsEntries" ] "Please define a virtual host using `services.httpd.virtualHosts`.")
    (mkRemovedOptionModule [ "services" "httpd" "servedDirs" ] "Please define a virtual host using `services.httpd.virtualHosts`.")
    (mkRemovedOptionModule [ "services" "httpd" "servedFiles" ] "Please define a virtual host using `services.httpd.virtualHosts`.")
    (mkRemovedOptionModule [ "services" "httpd" "serverAliases" ] "Please define a virtual host using `services.httpd.virtualHosts`.")
    (mkRemovedOptionModule [ "services" "httpd" "sslServerCert" ] "Please define a virtual host using `services.httpd.virtualHosts`.")
    (mkRemovedOptionModule [ "services" "httpd" "sslServerChain" ] "Please define a virtual host using `services.httpd.virtualHosts`.")
    (mkRemovedOptionModule [ "services" "httpd" "sslServerKey" ] "Please define a virtual host using `services.httpd.virtualHosts`.")
  ];

  # interface

  options = {

    services.httpd = {

      enable = mkEnableOption "the Apache HTTP Server";

      package = mkOption {
        type = types.package;
        default = pkgs.apacheHttpd;
        defaultText = "pkgs.apacheHttpd";
        description = ''
          Overridable attribute of the Apache HTTP Server package to use.
        '';
      };

      configFile = mkOption {
        type = types.path;
        default = confFile;
        defaultText = "confFile";
        example = literalExample ''pkgs.writeText "httpd.conf" "# my custom config file ..."'';
        description = ''
          Override the configuration file used by Apache. By default,
          NixOS generates one automatically.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Configuration lines appended to the generated Apache
          configuration file. Note that this mechanism will not work
          when <option>configFile</option> is overridden.
        '';
      };

      extraModules = mkOption {
        type = types.listOf types.unspecified;
        default = [];
        example = literalExample ''
          [
            "proxy_connect"
            { name = "jk"; path = "''${pkgs.tomcat_connectors}/modules/mod_jk.so"; }
          ]
        '';
        description = ''
          Additional Apache modules to be used. These can be
          specified as a string in the case of modules distributed
          with Apache, or as an attribute set specifying the
          <varname>name</varname> and <varname>path</varname> of the
          module.
        '';
      };

      adminAddr = mkOption {
        type = types.str;
        example = "admin@example.org";
        description = "E-mail address of the server administrator.";
      };

      logFormat = mkOption {
        type = types.str;
        default = "common";
        example = "combined";
        description = ''
          Log format for log files. Possible values are: combined, common, referer, agent.
          See <link xlink:href="https://httpd.apache.org/docs/2.4/logs.html"/> for more details.
        '';
      };

      logPerVirtualHost = mkOption {
        type = types.bool;
        default = true;
        description = ''
          If enabled, each virtual host gets its own
          <filename>access.log</filename> and
          <filename>error.log</filename>, namely suffixed by the
          <option>hostName</option> of the virtual host.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "wwwrun";
        description = ''
          User account under which httpd runs.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "wwwrun";
        description = ''
          Group under which httpd runs.
        '';
      };

      logDir = mkOption {
        type = types.path;
        default = "/var/log/httpd";
        description = ''
          Directory for Apache's log files. It is created automatically.
        '';
      };

      virtualHosts = mkOption {
        type = with types; attrsOf (submodule (import ./vhost-options.nix));
        default = {
          localhost = {
            documentRoot = "${pkg}/htdocs";
          };
        };
        example = literalExample ''
          {
            "foo.example.com" = {
              forceSSL = true;
              documentRoot = "/var/www/foo.example.com"
            };
            "bar.example.com" = {
              addSSL = true;
              documentRoot = "/var/www/bar.example.com";
            };
          }
        '';
        description = ''
          Specification of the virtual hosts served by Apache. Each
          element should be an attribute set specifying the
          configuration of the virtual host.
        '';
      };

      enableMellon = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the mod_auth_mellon module.";
      };

      enablePHP = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the PHP module.";
      };

      phpPackage = mkOption {
        type = types.package;
        default = pkgs.php;
        defaultText = "pkgs.php";
        description = ''
          Overridable attribute of the PHP package to use.
        '';
      };

      enablePerl = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the Perl module (mod_perl).";
      };

      phpOptions = mkOption {
        type = types.lines;
        default = "";
        example =
          ''
            date.timezone = "CET"
          '';
        description = ''
          Options appended to the PHP configuration file <filename>php.ini</filename>.
        '';
      };

      multiProcessingModule = mkOption {
        type = types.enum [ "event" "prefork" "worker" ];
        default = "prefork";
        example = "worker";
        description =
          ''
            Multi-processing module to be used by Apache. Available
            modules are <literal>prefork</literal> (the default;
            handles each request in a separate child process),
            <literal>worker</literal> (hybrid approach that starts a
            number of child processes each running a number of
            threads) and <literal>event</literal> (a recent variant of
            <literal>worker</literal> that handles persistent
            connections more efficiently).
          '';
      };

      maxClients = mkOption {
        type = types.int;
        default = 150;
        example = 8;
        description = "Maximum number of httpd processes (prefork)";
      };

      maxRequestsPerChild = mkOption {
        type = types.int;
        default = 0;
        example = 500;
        description = ''
          Maximum number of httpd requests answered per httpd child (prefork), 0 means unlimited.
        '';
      };

      sslCiphers = mkOption {
        type = types.str;
        default = "HIGH:!aNULL:!MD5:!EXP";
        description = "Cipher Suite available for negotiation in SSL proxy handshake.";
      };

      sslProtocols = mkOption {
        type = types.str;
        default = "All -SSLv2 -SSLv3 -TLSv1 -TLSv1.1";
        example = "All -SSLv2 -SSLv3";
        description = "Allowed SSL/TLS protocol versions.";
      };
    };

  };

  # implementation

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = all (hostOpts: !hostOpts.enableSSL) vhosts;
        message = ''
          The option `services.httpd.virtualHosts.<name>.enableSSL` no longer has any effect; please remove it.
          Select one of `services.httpd.virtualHosts.<name>.addSSL`, `services.httpd.virtualHosts.<name>.forceSSL`,
          or `services.httpd.virtualHosts.<name>.onlySSL`.
        '';
      }
      {
        assertion = all (hostOpts: with hostOpts; !(addSSL && onlySSL) && !(forceSSL && onlySSL) && !(addSSL && forceSSL)) vhosts;
        message = ''
          Options `services.httpd.virtualHosts.<name>.addSSL`,
          `services.httpd.virtualHosts.<name>.onlySSL` and `services.httpd.virtualHosts.<name>.forceSSL`
          are mutually exclusive.
        '';
      }
      {
        assertion = all (hostOpts: !(hostOpts.enableACME && hostOpts.useACMEHost != null)) vhosts;
        message = ''
          Options `services.httpd.virtualHosts.<name>.enableACME` and
          `services.httpd.virtualHosts.<name>.useACMEHost` are mutually exclusive.
        '';
      }
    ];

    warnings =
      mapAttrsToList (name: hostOpts: ''
        Using config.services.httpd.virtualHosts."${name}".servedFiles is deprecated and will become unsupported in a future release. Your configuration will continue to work as is but please migrate your configuration to config.services.httpd.virtualHosts."${name}".locations before the 20.09 release of NixOS.
      '') (filterAttrs (name: hostOpts: hostOpts.servedFiles != []) cfg.virtualHosts);

    users.users = optionalAttrs (cfg.user == "wwwrun") {
      wwwrun = {
        group = cfg.group;
        description = "Apache httpd user";
        uid = config.ids.uids.wwwrun;
      };
    };

    users.groups = optionalAttrs (cfg.group == "wwwrun") {
      wwwrun.gid = config.ids.gids.wwwrun;
    };

    security.acme.certs = mapAttrs (name: hostOpts: {
      user = cfg.user;
      group = mkDefault cfg.group;
      email = if hostOpts.adminAddr != null then hostOpts.adminAddr else cfg.adminAddr;
      webroot = hostOpts.acmeRoot;
      extraDomains = genAttrs hostOpts.serverAliases (alias: null);
      postRun = "systemctl reload httpd.service";
    }) (filterAttrs (name: hostOpts: hostOpts.enableACME) cfg.virtualHosts);

    environment.systemPackages = [ pkg ];

    # required for "apachectl configtest"
    environment.etc."httpd/httpd.conf".source = httpdConf;

    services.httpd.phpOptions =
      ''
        ; Needed for PHP's mail() function.
        sendmail_path = sendmail -t -i

        ; Don't advertise PHP
        expose_php = off
      '' + optionalString (config.time.timeZone != null) ''

        ; Apparently PHP doesn't use $TZ.
        date.timezone = "${config.time.timeZone}"
      '';

    services.httpd.extraModules = mkBefore [
      # HTTP authentication mechanisms: basic and digest.
      "auth_basic" "auth_digest"

      # Authentication: is the user who he claims to be?
      "authn_file" "authn_dbm" "authn_anon"

      # Authorization: is the user allowed access?
      "authz_user" "authz_groupfile" "authz_host"

      # Other modules.
      "ext_filter" "include" "env" "mime_magic"
      "cern_meta" "expires" "headers" "usertrack" "setenvif"
      "dav" "status" "asis" "info" "dav_fs"
      "vhost_alias" "imagemap" "actions" "speling"
      "proxy" "proxy_http"
      "cache" "cache_disk"

      # For compatibility with old configurations, the new module mod_access_compat is provided.
      "access_compat"
    ];

    systemd.tmpfiles.rules =
      let
        svc = config.systemd.services.httpd.serviceConfig;
      in
        [
          "d '${cfg.logDir}' 0700 ${svc.User} ${svc.Group}"
          "Z '${cfg.logDir}' - ${svc.User} ${svc.Group}"
        ];

    systemd.services.httpd =
      let
        vhostsACME = filter (hostOpts: hostOpts.enableACME) vhosts;
      in
      { description = "Apache HTTPD";

        wantedBy = [ "multi-user.target" ];
        wants = concatLists (map (hostOpts: [ "acme-${hostOpts.hostName}.service" "acme-selfsigned-${hostOpts.hostName}.service" ]) vhostsACME);
        after = [ "network.target" "fs.target" ] ++ map (hostOpts: "acme-selfsigned-${hostOpts.hostName}.service") vhostsACME;

        path =
          [ pkg pkgs.coreutils pkgs.gnugrep ]
          ++ optional cfg.enablePHP pkgs.system-sendmail; # Needed for PHP's mail() function.

        environment =
          optionalAttrs cfg.enablePHP { PHPRC = phpIni; }
          // optionalAttrs cfg.enableMellon { LD_LIBRARY_PATH  = "${pkgs.xmlsec}/lib"; };

        preStart =
          ''
            # Get rid of old semaphores.  These tend to accumulate across
            # server restarts, eventually preventing it from restarting
            # successfully.
            for i in $(${pkgs.utillinux}/bin/ipcs -s | grep ' ${cfg.user} ' | cut -f2 -d ' '); do
                ${pkgs.utillinux}/bin/ipcrm -s $i
            done
          '';

        serviceConfig = {
          ExecStart = "@${pkg}/bin/httpd httpd -f ${httpdConf}";
          ExecStop = "${pkg}/bin/httpd -f ${httpdConf} -k graceful-stop";
          ExecReload = "${pkg}/bin/httpd -f ${httpdConf} -k graceful";
          User = "root";
          Group = cfg.group;
          Type = "forking";
          PIDFile = "${runtimeDir}/httpd.pid";
          Restart = "always";
          RestartSec = "5s";
          RuntimeDirectory = "httpd httpd/runtime";
          RuntimeDirectoryMode = "0750";
        };
      };

  };
}

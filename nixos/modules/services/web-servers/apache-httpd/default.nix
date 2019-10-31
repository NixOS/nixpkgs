{ config, lib, pkgs, ... }:

with lib;

let

  mainCfg = config.services.httpd;

  httpd = mainCfg.package.out;

  httpdConf = mainCfg.configFile;

  php = mainCfg.phpPackage.override { apacheHttpd = httpd.dev; /* otherwise it only gets .out */ };

  phpMajorVersion = lib.versions.major (lib.getVersion php);

  mod_perl = pkgs.apacheHttpdPackages.mod_perl.override { apacheHttpd = httpd; };

  defaultListen = cfg: if cfg.enableSSL
    then [{ip = "*"; port = 443;}]
    else [{ip = "*"; port = 80;}];

  getListen = cfg:
    if cfg.listen == []
      then defaultListen cfg
      else cfg.listen;

  listenToString = l: "${l.ip}:${toString l.port}";

  extraModules = attrByPath ["extraModules"] [] mainCfg;
  extraForeignModules = filter isAttrs extraModules;
  extraApacheModules = filter isString extraModules;

  allHosts = [mainCfg] ++ mainCfg.virtualHosts;

  enableSSL = any (vhost: vhost.enableSSL) allHosts;


  # Names of modules from ${httpd}/modules that we want to load.
  apacheModules =
    [ # HTTP authentication mechanisms: basic and digest.
      "auth_basic" "auth_digest"

      # Authentication: is the user who he claims to be?
      "authn_file" "authn_dbm" "authn_anon" "authn_core"

      # Authorization: is the user allowed access?
      "authz_user" "authz_groupfile" "authz_host" "authz_core"

      # Other modules.
      "ext_filter" "include" "log_config" "env" "mime_magic"
      "cern_meta" "expires" "headers" "usertrack" /* "unique_id" */ "setenvif"
      "mime" "dav" "status" "autoindex" "asis" "info" "dav_fs"
      "vhost_alias" "negotiation" "dir" "imagemap" "actions" "speling"
      "userdir" "alias" "rewrite" "proxy" "proxy_http"
      "unixd" "cache" "cache_disk" "slotmem_shm" "socache_shmcb"
      "mpm_${mainCfg.multiProcessingModule}"

      # For compatibility with old configurations, the new module mod_access_compat is provided.
      "access_compat"
    ]
    ++ (if mainCfg.multiProcessingModule == "prefork" then [ "cgi" ] else [ "cgid" ])
    ++ optional enableSSL "ssl"
    ++ extraApacheModules;


  allDenied = "Require all denied";
  allGranted = "Require all granted";


  loggingConf = (if mainCfg.logFormat != "none" then ''
    ErrorLog ${mainCfg.logDir}/error.log

    LogLevel notice

    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    LogFormat "%h %l %u %t \"%r\" %>s %b" common
    LogFormat "%{Referer}i -> %U" referer
    LogFormat "%{User-agent}i" agent

    CustomLog ${mainCfg.logDir}/access.log ${mainCfg.logFormat}
  '' else ''
    ErrorLog /dev/null
  '');


  browserHacks = ''
    BrowserMatch "Mozilla/2" nokeepalive
    BrowserMatch "MSIE 4\.0b2;" nokeepalive downgrade-1.0 force-response-1.0
    BrowserMatch "RealPlayer 4\.0" force-response-1.0
    BrowserMatch "Java/1\.0" force-response-1.0
    BrowserMatch "JDK/1\.0" force-response-1.0
    BrowserMatch "Microsoft Data Access Internet Publishing Provider" redirect-carefully
    BrowserMatch "^WebDrive" redirect-carefully
    BrowserMatch "^WebDAVFS/1.[012]" redirect-carefully
    BrowserMatch "^gnome-vfs" redirect-carefully
  '';


  sslConf = ''
    SSLSessionCache shmcb:${mainCfg.stateDir}/ssl_scache(512000)

    Mutex posixsem

    SSLRandomSeed startup builtin
    SSLRandomSeed connect builtin

    SSLProtocol ${mainCfg.sslProtocols}
    SSLCipherSuite ${mainCfg.sslCiphers}
    SSLHonorCipherOrder on
  '';


  mimeConf = ''
    TypesConfig ${httpd}/conf/mime.types

    AddType application/x-x509-ca-cert .crt
    AddType application/x-pkcs7-crl    .crl
    AddType application/x-httpd-php    .php .phtml

    <IfModule mod_mime_magic.c>
        MIMEMagicFile ${httpd}/conf/magic
    </IfModule>
  '';


  perServerConf = isMainServer: cfg: let

    # Canonical name must not include a trailing slash.
    canonicalNames =
      let defaultPort = (head (defaultListen cfg)).port; in
      map (port:
        (if cfg.enableSSL then "https" else "http") + "://" +
        cfg.hostName +
        (if port != defaultPort then ":${toString port}" else "")
        ) (map (x: x.port) (getListen cfg));

    maybeDocumentRoot = fold (svc: acc:
      if acc == null then svc.documentRoot else assert svc.documentRoot == null; acc
    ) null ([ cfg ]);

    documentRoot = if maybeDocumentRoot != null then maybeDocumentRoot else
      pkgs.runCommand "empty" { preferLocalBuild = true; } "mkdir -p $out";

    documentRootConf = ''
      DocumentRoot "${documentRoot}"

      <Directory "${documentRoot}">
          Options Indexes FollowSymLinks
          AllowOverride None
          ${allGranted}
      </Directory>
    '';

    # If this is a vhost, the include the entries for the main server as well.
    robotsTxt = concatStringsSep "\n" (filter (x: x != "") ([ cfg.robotsEntries ] ++ lib.optional (!isMainServer) mainCfg.robotsEntries));

  in ''
    ${concatStringsSep "\n" (map (n: "ServerName ${n}") canonicalNames)}

    ${concatMapStrings (alias: "ServerAlias ${alias}\n") cfg.serverAliases}

    ${if cfg.sslServerCert != null then ''
      SSLCertificateFile ${cfg.sslServerCert}
      SSLCertificateKeyFile ${cfg.sslServerKey}
      ${if cfg.sslServerChain != null then ''
        SSLCertificateChainFile ${cfg.sslServerChain}
      '' else ""}
    '' else ""}

    ${if cfg.enableSSL then ''
      SSLEngine on
    '' else if enableSSL then /* i.e., SSL is enabled for some host, but not this one */
    ''
      SSLEngine off
    '' else ""}

    ${if isMainServer || cfg.adminAddr != null then ''
      ServerAdmin ${cfg.adminAddr}
    '' else ""}

    ${if !isMainServer && mainCfg.logPerVirtualHost then ''
      ErrorLog ${mainCfg.logDir}/error-${cfg.hostName}.log
      CustomLog ${mainCfg.logDir}/access-${cfg.hostName}.log ${cfg.logFormat}
    '' else ""}

    ${optionalString (robotsTxt != "") ''
      Alias /robots.txt ${pkgs.writeText "robots.txt" robotsTxt}
    ''}

    ${if isMainServer || maybeDocumentRoot != null then documentRootConf else ""}

    ${if cfg.enableUserDir then ''

      UserDir public_html
      UserDir disabled root

      <Directory "/home/*/public_html">
          AllowOverride FileInfo AuthConfig Limit Indexes
          Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
          <Limit GET POST OPTIONS>
              ${allGranted}
          </Limit>
          <LimitExcept GET POST OPTIONS>
              ${allDenied}
          </LimitExcept>
      </Directory>

    '' else ""}

    ${if cfg.globalRedirect != null && cfg.globalRedirect != "" then ''
      RedirectPermanent / ${cfg.globalRedirect}
    '' else ""}

    ${
      let makeFileConf = elem: ''
            Alias ${elem.urlPath} ${elem.file}
          '';
      in concatMapStrings makeFileConf cfg.servedFiles
    }

    ${
      let makeDirConf = elem: ''
            Alias ${elem.urlPath} ${elem.dir}/
            <Directory ${elem.dir}>
                Options +Indexes
                ${allGranted}
                AllowOverride All
            </Directory>
          '';
      in concatMapStrings makeDirConf cfg.servedDirs
    }

    ${cfg.extraConfig}
  '';


  confFile = pkgs.writeText "httpd.conf" ''

    ServerRoot ${httpd}

    DefaultRuntimeDir ${mainCfg.stateDir}/runtime

    PidFile ${mainCfg.stateDir}/httpd.pid

    ${optionalString (mainCfg.multiProcessingModule != "prefork") ''
      # mod_cgid requires this.
      ScriptSock ${mainCfg.stateDir}/cgisock
    ''}

    <IfModule prefork.c>
        MaxClients           ${toString mainCfg.maxClients}
        MaxRequestsPerChild  ${toString mainCfg.maxRequestsPerChild}
    </IfModule>

    ${let
        listen = concatMap getListen allHosts;
        toStr = listen: "Listen ${listenToString listen}\n";
        uniqueListen = uniqList {inputList = map toStr listen;};
      in concatStrings uniqueListen
    }

    User ${mainCfg.user}
    Group ${mainCfg.group}

    ${let
        load = {name, path}: "LoadModule ${name}_module ${path}\n";
        allModules = map (name: {inherit name; path = "${httpd}/modules/mod_${name}.so";}) apacheModules
          ++ optional mainCfg.enableMellon { name = "auth_mellon"; path = "${pkgs.apacheHttpdPackages.mod_auth_mellon}/modules/mod_auth_mellon.so"; }
          ++ optional mainCfg.enablePHP { name = "php${phpMajorVersion}"; path = "${php}/modules/libphp${phpMajorVersion}.so"; }
          ++ optional mainCfg.enablePerl { name = "perl"; path = "${mod_perl}/modules/mod_perl.so"; }
          ++ extraForeignModules;
      in concatMapStrings load (unique allModules)
    }

    AddHandler type-map var

    <Files ~ "^\.ht">
        ${allDenied}
    </Files>

    ${mimeConf}
    ${loggingConf}
    ${browserHacks}

    Include ${httpd}/conf/extra/httpd-default.conf
    Include ${httpd}/conf/extra/httpd-autoindex.conf
    Include ${httpd}/conf/extra/httpd-multilang-errordoc.conf
    Include ${httpd}/conf/extra/httpd-languages.conf

    TraceEnable off

    ${if enableSSL then sslConf else ""}

    # Fascist default - deny access to everything.
    <Directory />
        Options FollowSymLinks
        AllowOverride None
        ${allDenied}
    </Directory>

    # But do allow access to files in the store so that we don't have
    # to generate <Directory> clauses for every generated file that we
    # want to serve.
    <Directory /nix/store>
        ${allGranted}
    </Directory>

    # Generate directives for the main server.
    ${perServerConf true mainCfg}

    ${let
        makeVirtualHost = vhost: ''
          <VirtualHost ${concatStringsSep " " (map listenToString (getListen vhost))}>
              ${perServerConf false vhost}
          </VirtualHost>
        '';
      in concatMapStrings makeVirtualHost mainCfg.virtualHosts
    }
  '';

  # Generate the PHP configuration file.  Should probably be factored
  # out into a separate module.
  phpIni = pkgs.runCommand "php.ini"
    { options = mainCfg.phpOptions;
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
  ];

  ###### interface

  options = {

    services.httpd = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the Apache HTTP Server.";
      };

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
          Cnfiguration lines appended to the generated Apache
          configuration file. Note that this mechanism may not work
          when <option>configFile</option> is overridden.
        '';
      };

      extraModules = mkOption {
        type = types.listOf types.unspecified;
        default = [];
        example = literalExample ''[ "proxy_connect" { name = "php5"; path = "''${pkgs.php}/modules/libphp5.so"; } ]'';
        description = ''
          Additional Apache modules to be used.  These can be
          specified as a string in the case of modules distributed
          with Apache, or as an attribute set specifying the
          <varname>name</varname> and <varname>path</varname> of the
          module.
        '';
      };

      logPerVirtualHost = mkOption {
        type = types.bool;
        default = false;
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
          User account under which httpd runs.  The account is created
          automatically if it doesn't exist.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "wwwrun";
        description = ''
          Group under which httpd runs.  The account is created
          automatically if it doesn't exist.
        '';
      };

      logDir = mkOption {
        type = types.path;
        default = "/var/log/httpd";
        description = ''
          Directory for Apache's log files.  It is created automatically.
        '';
      };

      stateDir = mkOption {
        type = types.path;
        default = "/run/httpd";
        description = ''
          Directory for Apache's transient runtime state (such as PID
          files).  It is created automatically.  Note that the default,
          <filename>/run/httpd</filename>, is deleted at boot time.
        '';
      };

      virtualHosts = mkOption {
        type = types.listOf (types.submodule (
          { options = import ./per-server-options.nix {
              inherit lib;
              forMainServer = false;
            };
          }));
        default = [];
        example = [
          { hostName = "foo";
            documentRoot = "/data/webroot-foo";
          }
          { hostName = "bar";
            documentRoot = "/data/webroot-bar";
          }
        ];
        description = ''
          Specification of the virtual hosts served by Apache.  Each
          element should be an attribute set specifying the
          configuration of the virtual host.  The available options
          are the non-global options permissible for the main host.
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
        description =
          "Options appended to the PHP configuration file <filename>php.ini</filename>.";
      };

      multiProcessingModule = mkOption {
        type = types.str;
        default = "prefork";
        example = "worker";
        description =
          ''
            Multi-processing module to be used by Apache.  Available
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
        description =
          "Maximum number of httpd requests answered per httpd child (prefork), 0 means unlimited";
      };

      sslCiphers = mkOption {
        type = types.str;
        default = "HIGH:!aNULL:!MD5:!EXP";
        description = "Cipher Suite available for negotiation in SSL proxy handshake.";
      };

      sslProtocols = mkOption {
        type = types.str;
        default = "All -SSLv2 -SSLv3 -TLSv1";
        example = "All -SSLv2 -SSLv3";
        description = "Allowed SSL/TLS protocol versions.";
      };
    }

    # Include the options shared between the main server and virtual hosts.
    // (import ./per-server-options.nix {
      inherit lib;
      forMainServer = true;
    });

  };


  ###### implementation

  config = mkIf config.services.httpd.enable {

    assertions = [ { assertion = mainCfg.enableSSL == true
                               -> mainCfg.sslServerCert != null
                                    && mainCfg.sslServerKey != null;
                     message = "SSL is enabled for httpd, but sslServerCert and/or sslServerKey haven't been specified."; }
                 ];

    users.users = optionalAttrs (mainCfg.user == "wwwrun") (singleton
      { name = "wwwrun";
        group = mainCfg.group;
        description = "Apache httpd user";
        uid = config.ids.uids.wwwrun;
      });

    users.groups = optionalAttrs (mainCfg.group == "wwwrun") (singleton
      { name = "wwwrun";
        gid = config.ids.gids.wwwrun;
      });

    environment.systemPackages = [httpd];

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

    systemd.services.httpd =
      { description = "Apache HTTPD";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" "fs.target" ];

        path =
          [ httpd pkgs.coreutils pkgs.gnugrep ]
          ++ optional mainCfg.enablePHP pkgs.system-sendmail; # Needed for PHP's mail() function.

        environment =
          optionalAttrs mainCfg.enablePHP { PHPRC = phpIni; }
          // optionalAttrs mainCfg.enableMellon { LD_LIBRARY_PATH  = "${pkgs.xmlsec}/lib"; };

        preStart =
          ''
            mkdir -m 0750 -p ${mainCfg.stateDir}
            [ $(id -u) != 0 ] || chown root.${mainCfg.group} ${mainCfg.stateDir}

            mkdir -m 0750 -p "${mainCfg.stateDir}/runtime"
            [ $(id -u) != 0 ] || chown root.${mainCfg.group} "${mainCfg.stateDir}/runtime"

            mkdir -m 0700 -p ${mainCfg.logDir}

            # Get rid of old semaphores.  These tend to accumulate across
            # server restarts, eventually preventing it from restarting
            # successfully.
            for i in $(${pkgs.utillinux}/bin/ipcs -s | grep ' ${mainCfg.user} ' | cut -f2 -d ' '); do
                ${pkgs.utillinux}/bin/ipcrm -s $i
            done
          '';

        serviceConfig.ExecStart = "@${httpd}/bin/httpd httpd -f ${httpdConf}";
        serviceConfig.ExecStop = "${httpd}/bin/httpd -f ${httpdConf} -k graceful-stop";
        serviceConfig.ExecReload = "${httpd}/bin/httpd -f ${httpdConf} -k graceful";
        serviceConfig.Type = "forking";
        serviceConfig.PIDFile = "${mainCfg.stateDir}/httpd.pid";
        serviceConfig.Restart = "always";
        serviceConfig.RestartSec = "5s";
      };

  };
}

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sympa;
  dataDir = "/var/lib/sympa";
  user = "sympa";
  group = "sympa";
  pkg = pkgs.sympa;
  fqdns = attrNames cfg.domains;
  usingNginx = cfg.web.enable && cfg.web.server == "nginx";
  mysqlLocal = cfg.database.createLocally && cfg.database.type == "MySQL";
  pgsqlLocal = cfg.database.createLocally && cfg.database.type == "PostgreSQL";

  sympaSubServices = [
    "sympa-archive.service"
    "sympa-bounce.service"
    "sympa-bulk.service"
    "sympa-task.service"
  ];

  # common for all services including wwsympa
  commonServiceConfig = {
    StateDirectory = "sympa";
    ProtectHome = true;
    ProtectSystem = "full";
    ProtectControlGroups = true;
  };

  # wwsympa has its own service config
  sympaServiceConfig = srv: {
    Type = "simple";
    Restart = "always";
    ExecStart = "${pkg}/bin/${srv}.pl --foreground";
    PIDFile = "/run/sympa/${srv}.pid";
    User = user;
    Group = group;

    # avoid duplicating log messageges in journal
    StandardError = "null";
  } // commonServiceConfig;

  configVal = value:
    if isBool value then
      if value then "on" else "off"
    else toString value;
  configGenerator = c: concatStrings (flip mapAttrsToList c (key: val: "${key}\t${configVal val}\n"));

  mainConfig = pkgs.writeText "sympa.conf" (configGenerator cfg.settings);
  robotConfig = fqdn: domain: pkgs.writeText "${fqdn}-robot.conf" (configGenerator domain.settings);

  transport = pkgs.writeText "transport.sympa" (concatStringsSep "\n" (flip map fqdns (domain: ''
    ${domain}                        error:User unknown in recipient table
    sympa@${domain}                  sympa:sympa@${domain}
    listmaster@${domain}             sympa:listmaster@${domain}
    bounce@${domain}                 sympabounce:sympa@${domain}
    abuse-feedback-report@${domain}  sympabounce:sympa@${domain}
  '')));

  virtual = pkgs.writeText "virtual.sympa" (concatStringsSep "\n" (flip map fqdns (domain: ''
    sympa-request@${domain}  postmaster@localhost
    sympa-owner@${domain}    postmaster@localhost
  '')));

  listAliases = pkgs.writeText "list_aliases.tt2" ''
    #--- [% list.name %]@[% list.domain %]: list transport map created at [% date %]
    [% list.name %]@[% list.domain %] sympa:[% list.name %]@[% list.domain %]
    [% list.name %]-request@[% list.domain %] sympa:[% list.name %]-request@[% list.domain %]
    [% list.name %]-editor@[% list.domain %] sympa:[% list.name %]-editor@[% list.domain %]
    #[% list.name %]-subscribe@[% list.domain %] sympa:[% list.name %]-subscribe@[%list.domain %]
    [% list.name %]-unsubscribe@[% list.domain %] sympa:[% list.name %]-unsubscribe@[% list.domain %]
    [% list.name %][% return_path_suffix %]@[% list.domain %] sympabounce:[% list.name %]@[% list.domain %]
  '';

  enabledFiles = filterAttrs (n: v: v.enable) cfg.settingsFile;
in
{

  ###### interface
  options.services.sympa = with types; {

    enable = mkEnableOption (lib.mdDoc "Sympa mailing list manager");

    lang = mkOption {
      type = str;
      default = "en_US";
      example = "cs";
      description = lib.mdDoc ''
        Default Sympa language.
        See <https://github.com/sympa-community/sympa/tree/sympa-6.2/po/sympa>
        for available options.
      '';
    };

    listMasters = mkOption {
      type = listOf str;
      example = [ "postmaster@sympa.example.org" ];
      description = lib.mdDoc ''
        The list of the email addresses of the listmasters
        (users authorized to perform global server commands).
      '';
    };

    mainDomain = mkOption {
      type = nullOr str;
      default = null;
      example = "lists.example.org";
      description = lib.mdDoc ''
        Main domain to be used in {file}`sympa.conf`.
        If `null`, one of the {option}`services.sympa.domains` is chosen for you.
      '';
    };

    domains = mkOption {
      type = attrsOf (submodule ({ name, config, ... }: {
        options = {
          webHost = mkOption {
            type = nullOr str;
            default = null;
            example = "archive.example.org";
            description = lib.mdDoc ''
              Domain part of the web interface URL (no web interface for this domain if `null`).
              DNS record of type A (or AAAA or CNAME) has to exist with this value.
            '';
          };
          webLocation = mkOption {
            type = str;
            default = "/";
            example = "/sympa";
            description = lib.mdDoc "URL path part of the web interface.";
          };
          settings = mkOption {
            type = attrsOf (oneOf [ str int bool ]);
            default = {};
            example = {
              default_max_list_members = 3;
            };
            description = lib.mdDoc ''
              The {file}`robot.conf` configuration file as key value set.
              See <https://sympa-community.github.io/gpldoc/man/sympa.conf.5.html>
              for list of configuration parameters.
            '';
          };
        };

        config.settings = mkIf (cfg.web.enable && config.webHost != null) {
          wwsympa_url = mkDefault "https://${config.webHost}${strings.removeSuffix "/" config.webLocation}";
        };
      }));

      description = lib.mdDoc ''
        Email domains handled by this instance. There have
        to be MX records for keys of this attribute set.
      '';
      example = literalExpression ''
        {
          "lists.example.org" = {
            webHost = "lists.example.org";
            webLocation = "/";
          };
          "sympa.example.com" = {
            webHost = "example.com";
            webLocation = "/sympa";
          };
        }
      '';
    };

    database = {
      type = mkOption {
        type = enum [ "SQLite" "PostgreSQL" "MySQL" ];
        default = "SQLite";
        example = "MySQL";
        description = lib.mdDoc "Database engine to use.";
      };

      host = mkOption {
        type = nullOr str;
        default = null;
        description = lib.mdDoc ''
          Database host address.

          For MySQL, use `localhost` to connect using Unix domain socket.

          For PostgreSQL, use path to directory (e.g. {file}`/run/postgresql`)
          to connect using Unix domain socket located in this directory.

          Use `null` to fall back on Sympa default, or when using
          {option}`services.sympa.database.createLocally`.
        '';
      };

      port = mkOption {
        type = nullOr port;
        default = null;
        description = lib.mdDoc "Database port. Use `null` for default port.";
      };

      name = mkOption {
        type = str;
        default = if cfg.database.type == "SQLite" then "${dataDir}/sympa.sqlite" else "sympa";
        defaultText = literalExpression ''if database.type == "SQLite" then "${dataDir}/sympa.sqlite" else "sympa"'';
        description = lib.mdDoc ''
          Database name. When using SQLite this must be an absolute
          path to the database file.
        '';
      };

      user = mkOption {
        type = nullOr str;
        default = user;
        description = lib.mdDoc "Database user. The system user name is used as a default.";
      };

      passwordFile = mkOption {
        type = nullOr path;
        default = null;
        example = "/run/keys/sympa-dbpassword";
        description = lib.mdDoc ''
          A file containing the password for {option}`services.sympa.database.name`.
        '';
      };

      createLocally = mkOption {
        type = bool;
        default = true;
        description = lib.mdDoc "Whether to create a local database automatically.";
      };
    };

    web = {
      enable = mkOption {
        type = bool;
        default = true;
        description = lib.mdDoc "Whether to enable Sympa web interface.";
      };

      server = mkOption {
        type = enum [ "nginx" "none" ];
        default = "nginx";
        description = lib.mdDoc ''
          The webserver used for the Sympa web interface. Set it to `none` if you want to configure it yourself.
          Further nginx configuration can be done by adapting
          {option}`services.nginx.virtualHosts.«name»`.
        '';
      };

      https = mkOption {
        type = bool;
        default = true;
        description = lib.mdDoc ''
          Whether to use HTTPS. When nginx integration is enabled, this option forces SSL and enables ACME.
          Please note that Sympa web interface always uses https links even when this option is disabled.
        '';
      };

      fcgiProcs = mkOption {
        type = ints.positive;
        default = 2;
        description = lib.mdDoc "Number of FastCGI processes to fork.";
      };
    };

    mta = {
      type = mkOption {
        type = enum [ "postfix" "none" ];
        default = "postfix";
        description = lib.mdDoc ''
          Mail transfer agent (MTA) integration. Use `none` if you want to configure it yourself.

          The `postfix` integration sets up local Postfix instance that will pass incoming
          messages from configured domains to Sympa. You still need to configure at least outgoing message
          handling using e.g. {option}`services.postfix.relayHost`.
        '';
      };
    };

    settings = mkOption {
      type = attrsOf (oneOf [ str int bool ]);
      default = {};
      example = literalExpression ''
        {
          default_home = "lists";
          viewlogs_page_size = 50;
        }
      '';
      description = lib.mdDoc ''
        The {file}`sympa.conf` configuration file as key value set.
        See <https://sympa-community.github.io/gpldoc/man/sympa.conf.5.html>
        for list of configuration parameters.
      '';
    };

    settingsFile = mkOption {
      type = attrsOf (submodule ({ name, config, ... }: {
        options = {
          enable = mkOption {
            type = bool;
            default = true;
            description = lib.mdDoc "Whether this file should be generated. This option allows specific files to be disabled.";
          };
          text = mkOption {
            default = null;
            type = nullOr lines;
            description = lib.mdDoc "Text of the file.";
          };
          source = mkOption {
            type = path;
            description = lib.mdDoc "Path of the source file.";
          };
        };

        config.source = mkIf (config.text != null) (mkDefault (pkgs.writeText "sympa-${baseNameOf name}" config.text));
      }));
      default = {};
      example = literalExpression ''
        {
          "list_data/lists.example.org/help" = {
            text = "subject This list provides help to users";
          };
        }
      '';
      description = lib.mdDoc "Set of files to be linked in {file}`${dataDir}`.";
    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    services.sympa.settings = (mapAttrs (_: v: mkDefault v) {
      domain     = if cfg.mainDomain != null then cfg.mainDomain else head fqdns;
      listmaster = concatStringsSep "," cfg.listMasters;
      lang       = cfg.lang;

      home        = "${dataDir}/list_data";
      arc_path    = "${dataDir}/arc";
      bounce_path = "${dataDir}/bounce";

      sendmail = "${pkgs.system-sendmail}/bin/sendmail";

      db_type = cfg.database.type;
      db_name = cfg.database.name;
      db_user = cfg.database.name;
    }
    // (optionalAttrs (cfg.database.host != null) {
      db_host = cfg.database.host;
    })
    // (optionalAttrs mysqlLocal {
      db_host = "localhost"; # use unix domain socket
    })
    // (optionalAttrs pgsqlLocal {
      db_host = "/run/postgresql"; # use unix domain socket
    })
    // (optionalAttrs (cfg.database.port != null) {
      db_port = cfg.database.port;
    })
    // (optionalAttrs (cfg.mta.type == "postfix") {
      sendmail_aliases = "${dataDir}/sympa_transport";
      aliases_program  = "${pkgs.postfix}/bin/postmap";
      aliases_db_type  = "hash";
    })
    // (optionalAttrs cfg.web.enable {
      static_content_path = "${dataDir}/static_content";
      css_path            = "${dataDir}/static_content/css";
      pictures_path       = "${dataDir}/static_content/pictures";
      mhonarc             = "${pkgs.perlPackages.MHonArc}/bin/mhonarc";
    }));

    services.sympa.settingsFile = {
      "virtual.sympa"        = mkDefault { source = virtual; };
      "transport.sympa"      = mkDefault { source = transport; };
      "etc/list_aliases.tt2" = mkDefault { source = listAliases; };
    }
    // (flip mapAttrs' cfg.domains (fqdn: domain:
          nameValuePair "etc/${fqdn}/robot.conf" (mkDefault { source = robotConfig fqdn domain; })));

    environment = {
      systemPackages = [ pkg ];
    };

    users.users.${user} = {
      description = "Sympa mailing list manager user";
      group = group;
      home = dataDir;
      createHome = false;
      isSystemUser = true;
    };

    users.groups.${group} = {};

    assertions = [
      { assertion = cfg.database.createLocally -> cfg.database.user == user && cfg.database.name == cfg.database.user;
        message = "services.sympa.database.user must be set to ${user} if services.sympa.database.createLocally is set to true";
      }
      { assertion = cfg.database.createLocally -> cfg.database.passwordFile == null;
        message = "a password cannot be specified if services.sympa.database.createLocally is set to true";
      }
    ];

    systemd.tmpfiles.rules = [
      "d  ${dataDir}                   0711 ${user} ${group} - -"
      "d  ${dataDir}/etc               0700 ${user} ${group} - -"
      "d  ${dataDir}/spool             0700 ${user} ${group} - -"
      "d  ${dataDir}/list_data         0700 ${user} ${group} - -"
      "d  ${dataDir}/arc               0700 ${user} ${group} - -"
      "d  ${dataDir}/bounce            0700 ${user} ${group} - -"
      "f  ${dataDir}/sympa_transport   0600 ${user} ${group} - -"

      # force-copy static_content so it's up to date with package
      # set permissions for wwsympa which needs write access (...)
      "R  ${dataDir}/static_content    -    -       -        - -"
      "C  ${dataDir}/static_content    0711 ${user} ${group} - ${pkg}/var/lib/sympa/static_content"
      "e  ${dataDir}/static_content/*  0711 ${user} ${group} - -"

      "d  /run/sympa                   0755 ${user} ${group} - -"
    ]
    ++ (flip concatMap fqdns (fqdn: [
      "d  ${dataDir}/etc/${fqdn}       0700 ${user} ${group} - -"
      "d  ${dataDir}/list_data/${fqdn} 0700 ${user} ${group} - -"
    ]))
    #++ (flip mapAttrsToList enabledFiles (k: v:
    #  "L+ ${dataDir}/${k}              -    -       -        - ${v.source}"
    #))
    ++ (concatLists (flip mapAttrsToList enabledFiles (k: v: [
      # sympa doesn't handle symlinks well (e.g. fails to create locks)
      # force-copy instead
      "R ${dataDir}/${k}              -    -       -        - -"
      "C ${dataDir}/${k}              0700 ${user}  ${group} - ${v.source}"
    ])));

    systemd.services.sympa = {
      description = "Sympa mailing list manager";

      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = sympaSubServices;
      before = sympaSubServices;
      serviceConfig = sympaServiceConfig "sympa_msg";

      preStart = ''
        umask 0077

        cp -f ${mainConfig} ${dataDir}/etc/sympa.conf
        ${optionalString (cfg.database.passwordFile != null) ''
          chmod u+w ${dataDir}/etc/sympa.conf
          echo -n "db_passwd " >> ${dataDir}/etc/sympa.conf
          cat ${cfg.database.passwordFile} >> ${dataDir}/etc/sympa.conf
        ''}

        ${optionalString (cfg.mta.type == "postfix") ''
          ${pkgs.postfix}/bin/postmap hash:${dataDir}/virtual.sympa
          ${pkgs.postfix}/bin/postmap hash:${dataDir}/transport.sympa
        ''}
        ${pkg}/bin/sympa_newaliases.pl
        ${pkg}/bin/sympa.pl --health_check
      '';
    };
    systemd.services.sympa-archive = {
      description = "Sympa mailing list manager (archiving)";
      bindsTo = [ "sympa.service" ];
      serviceConfig = sympaServiceConfig "archived";
    };
    systemd.services.sympa-bounce = {
      description = "Sympa mailing list manager (bounce processing)";
      bindsTo = [ "sympa.service" ];
      serviceConfig = sympaServiceConfig "bounced";
    };
    systemd.services.sympa-bulk = {
      description = "Sympa mailing list manager (message distribution)";
      bindsTo = [ "sympa.service" ];
      serviceConfig = sympaServiceConfig "bulk";
    };
    systemd.services.sympa-task = {
      description = "Sympa mailing list manager (task management)";
      bindsTo = [ "sympa.service" ];
      serviceConfig = sympaServiceConfig "task_manager";
    };

    systemd.services.wwsympa = mkIf usingNginx {
      wantedBy = [ "multi-user.target" ];
      after = [ "sympa.service" ];
      serviceConfig = {
        Type = "forking";
        PIDFile = "/run/sympa/wwsympa.pid";
        Restart = "always";
        ExecStart = ''${pkgs.spawn_fcgi}/bin/spawn-fcgi \
          -u ${user} \
          -g ${group} \
          -U nginx \
          -M 0600 \
          -F ${toString cfg.web.fcgiProcs} \
          -P /run/sympa/wwsympa.pid \
          -s /run/sympa/wwsympa.socket \
          -- ${pkg}/lib/sympa/cgi/wwsympa.fcgi
        '';

      } // commonServiceConfig;
    };

    services.nginx.enable = mkIf usingNginx true;
    services.nginx.virtualHosts = mkIf usingNginx (let
      vHosts = unique (remove null (mapAttrsToList (_k: v: v.webHost) cfg.domains));
      hostLocations = host: map (v: v.webLocation) (filter (v: v.webHost == host) (attrValues cfg.domains));
      httpsOpts = optionalAttrs cfg.web.https { forceSSL = mkDefault true; enableACME = mkDefault true; };
    in
    genAttrs vHosts (host: {
      locations = genAttrs (hostLocations host) (loc: {
        extraConfig = ''
          include ${config.services.nginx.package}/conf/fastcgi_params;

          fastcgi_pass unix:/run/sympa/wwsympa.socket;
        '';
      }) // {
        "/static-sympa/".alias = "${dataDir}/static_content/";
      };
    } // httpsOpts));

    services.postfix = mkIf (cfg.mta.type == "postfix") {
      enable = true;
      recipientDelimiter = "+";
      config = {
        virtual_alias_maps = [ "hash:${dataDir}/virtual.sympa" ];
        virtual_mailbox_maps = [
          "hash:${dataDir}/transport.sympa"
          "hash:${dataDir}/sympa_transport"
          "hash:${dataDir}/virtual.sympa"
        ];
        virtual_mailbox_domains = [ "hash:${dataDir}/transport.sympa" ];
        transport_maps = [
          "hash:${dataDir}/transport.sympa"
          "hash:${dataDir}/sympa_transport"
        ];
      };
      masterConfig = {
        "sympa" = {
          type = "unix";
          privileged = true;
          chroot = false;
          command = "pipe";
          args = [
            "flags=hqRu"
            "user=${user}"
            "argv=${pkg}/libexec/queue"
            "\${nexthop}"
          ];
        };
        "sympabounce" = {
          type = "unix";
          privileged = true;
          chroot = false;
          command = "pipe";
          args = [
            "flags=hqRu"
            "user=${user}"
            "argv=${pkg}/libexec/bouncequeue"
            "\${nexthop}"
          ];
        };
      };
    };

    services.mysql = optionalAttrs mysqlLocal {
      enable = true;
      package = mkDefault pkgs.mariadb;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        { name = cfg.database.user;
          ensurePermissions = { "${cfg.database.name}.*" = "ALL PRIVILEGES"; };
        }
      ];
    };

    services.postgresql = optionalAttrs pgsqlLocal {
      enable = true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        { name = cfg.database.user;
          ensureDBOwnership = true;
        }
      ];
    };

  };

  meta.maintainers = with maintainers; [ mmilata sorki ];
}

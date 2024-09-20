{ config, lib, pkgs, ... }:
let
  cfg = config.services.sympa;
  dataDir = "/var/lib/sympa";
  user = "sympa";
  group = "sympa";
  pkg = pkgs.sympa;
  fqdns = lib.attrNames cfg.domains;
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
    if lib.isBool value then
      if value then "on" else "off"
    else toString value;
  configGenerator = c: lib.concatStrings (lib.flip lib.mapAttrsToList c (key: val: "${key}\t${configVal val}\n"));

  mainConfig = pkgs.writeText "sympa.conf" (configGenerator cfg.settings);
  robotConfig = fqdn: domain: pkgs.writeText "${fqdn}-robot.conf" (configGenerator domain.settings);

  transport = pkgs.writeText "transport.sympa" (lib.concatStringsSep "\n" (lib.flip map fqdns (domain: ''
    ${domain}                        error:User unknown in recipient table
    sympa@${domain}                  sympa:sympa@${domain}
    listmaster@${domain}             sympa:listmaster@${domain}
    bounce@${domain}                 sympabounce:sympa@${domain}
    abuse-feedback-report@${domain}  sympabounce:sympa@${domain}
  '')));

  virtual = pkgs.writeText "virtual.sympa" (lib.concatStringsSep "\n" (lib.flip map fqdns (domain: ''
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

  enabledFiles = lib.filterAttrs (n: v: v.enable) cfg.settingsFile;
in
{

  ###### interface
  options.services.sympa = with lib.types; {

    enable = lib.mkEnableOption "Sympa mailing list manager";

    lang = lib.mkOption {
      type = str;
      default = "en_US";
      example = "cs";
      description = ''
        Default Sympa language.
        See <https://github.com/sympa-community/sympa/tree/sympa-6.2/po/sympa>
        for available options.
      '';
    };

    listMasters = lib.mkOption {
      type = listOf str;
      example = [ "postmaster@sympa.example.org" ];
      description = ''
        The list of the email addresses of the listmasters
        (users authorized to perform global server commands).
      '';
    };

    mainDomain = lib.mkOption {
      type = nullOr str;
      default = null;
      example = "lists.example.org";
      description = ''
        Main domain to be used in {file}`sympa.conf`.
        If `null`, one of the {option}`services.sympa.domains` is chosen for you.
      '';
    };

    domains = lib.mkOption {
      type = attrsOf (submodule ({ name, config, ... }: {
        options = {
          webHost = lib.mkOption {
            type = nullOr str;
            default = null;
            example = "archive.example.org";
            description = ''
              Domain part of the web interface URL (no web interface for this domain if `null`).
              DNS record of type A (or AAAA or CNAME) has to exist with this value.
            '';
          };
          webLocation = lib.mkOption {
            type = str;
            default = "/";
            example = "/sympa";
            description = "URL path part of the web interface.";
          };
          settings = lib.mkOption {
            type = attrsOf (oneOf [ str int bool ]);
            default = {};
            example = {
              default_max_list_members = 3;
            };
            description = ''
              The {file}`robot.conf` configuration file as key value set.
              See <https://sympa-community.github.io/gpldoc/man/sympa.conf.5.html>
              for list of configuration parameters.
            '';
          };
        };

        config.settings = lib.mkIf (cfg.web.enable && config.webHost != null) {
          wwsympa_url = lib.mkDefault "https://${config.webHost}${lib.removeSuffix "/" config.webLocation}";
        };
      }));

      description = ''
        Email domains handled by this instance. There have
        to be MX records for keys of this attribute set.
      '';
      example = lib.literalExpression ''
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
      type = lib.mkOption {
        type = enum [ "SQLite" "PostgreSQL" "MySQL" ];
        default = "SQLite";
        example = "MySQL";
        description = "Database engine to use.";
      };

      host = lib.mkOption {
        type = nullOr str;
        default = null;
        description = ''
          Database host address.

          For MySQL, use `localhost` to connect using Unix domain socket.

          For PostgreSQL, use path to directory (e.g. {file}`/run/postgresql`)
          to connect using Unix domain socket located in this directory.

          Use `null` to fall back on Sympa default, or when using
          {option}`services.sympa.database.createLocally`.
        '';
      };

      port = lib.mkOption {
        type = nullOr port;
        default = null;
        description = "Database port. Use `null` for default port.";
      };

      name = lib.mkOption {
        type = str;
        default = if cfg.database.type == "SQLite" then "${dataDir}/sympa.sqlite" else "sympa";
        defaultText = lib.literalExpression ''if database.type == "SQLite" then "${dataDir}/sympa.sqlite" else "sympa"'';
        description = ''
          Database name. When using SQLite this must be an absolute
          path to the database file.
        '';
      };

      user = lib.mkOption {
        type = nullOr str;
        default = user;
        description = "Database user. The system user name is used as a default.";
      };

      passwordFile = lib.mkOption {
        type = nullOr path;
        default = null;
        example = "/run/keys/sympa-dbpassword";
        description = ''
          A file containing the password for {option}`services.sympa.database.name`.
        '';
      };

      createLocally = lib.mkOption {
        type = bool;
        default = true;
        description = "Whether to create a local database automatically.";
      };
    };

    web = {
      enable = lib.mkOption {
        type = bool;
        default = true;
        description = "Whether to enable Sympa web interface.";
      };

      server = lib.mkOption {
        type = enum [ "nginx" "none" ];
        default = "nginx";
        description = ''
          The webserver used for the Sympa web interface. Set it to `none` if you want to configure it yourself.
          Further nginx configuration can be done by adapting
          {option}`services.nginx.virtualHosts.«name»`.
        '';
      };

      https = lib.mkOption {
        type = bool;
        default = true;
        description = ''
          Whether to use HTTPS. When nginx integration is enabled, this option forces SSL and enables ACME.
          Please note that Sympa web interface always uses https links even when this option is disabled.
        '';
      };

      fcgiProcs = lib.mkOption {
        type = ints.positive;
        default = 2;
        description = "Number of FastCGI processes to fork.";
      };
    };

    mta = {
      type = lib.mkOption {
        type = enum [ "postfix" "none" ];
        default = "postfix";
        description = ''
          Mail transfer agent (MTA) integration. Use `none` if you want to configure it yourself.

          The `postfix` integration sets up local Postfix instance that will pass incoming
          messages from configured domains to Sympa. You still need to configure at least outgoing message
          handling using e.g. {option}`services.postfix.relayHost`.
        '';
      };
    };

    settings = lib.mkOption {
      type = attrsOf (oneOf [ str int bool ]);
      default = {};
      example = lib.literalExpression ''
        {
          default_home = "lists";
          viewlogs_page_size = 50;
        }
      '';
      description = ''
        The {file}`sympa.conf` configuration file as key value set.
        See <https://sympa-community.github.io/gpldoc/man/sympa.conf.5.html>
        for list of configuration parameters.
      '';
    };

    settingsFile = lib.mkOption {
      type = attrsOf (submodule ({ name, config, ... }: {
        options = {
          enable = lib.mkOption {
            type = bool;
            default = true;
            description = "Whether this file should be generated. This option allows specific files to be disabled.";
          };
          text = lib.mkOption {
            default = null;
            type = nullOr lines;
            description = "Text of the file.";
          };
          source = lib.mkOption {
            type = path;
            description = "Path of the source file.";
          };
        };

        config.source = lib.mkIf (config.text != null) (lib.mkDefault (pkgs.writeText "sympa-${baseNameOf name}" config.text));
      }));
      default = {};
      example = lib.literalExpression ''
        {
          "list_data/lists.example.org/help" = {
            text = "subject This list provides help to users";
          };
        }
      '';
      description = "Set of files to be linked in {file}`${dataDir}`.";
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    services.sympa.settings = (lib.mapAttrs (_: v: lib.mkDefault v) {
      domain     = if cfg.mainDomain != null then cfg.mainDomain else lib.head fqdns;
      listmaster = lib.concatStringsSep "," cfg.listMasters;
      lang       = cfg.lang;

      home        = "${dataDir}/list_data";
      arc_path    = "${dataDir}/arc";
      bounce_path = "${dataDir}/bounce";

      sendmail = "${pkgs.system-sendmail}/bin/sendmail";

      db_type = cfg.database.type;
      db_name = cfg.database.name;
      db_user = cfg.database.name;
    }
    // (lib.optionalAttrs (cfg.database.host != null) {
      db_host = cfg.database.host;
    })
    // (lib.optionalAttrs mysqlLocal {
      db_host = "localhost"; # use unix domain socket
    })
    // (lib.optionalAttrs pgsqlLocal {
      db_host = "/run/postgresql"; # use unix domain socket
    })
    // (lib.optionalAttrs (cfg.database.port != null) {
      db_port = cfg.database.port;
    })
    // (lib.optionalAttrs (cfg.mta.type == "postfix") {
      sendmail_aliases = "${dataDir}/sympa_transport";
      aliases_program  = "${pkgs.postfix}/bin/postmap";
      aliases_db_type  = "hash";
    })
    // (lib.optionalAttrs cfg.web.enable {
      static_content_path = "${dataDir}/static_content";
      css_path            = "${dataDir}/static_content/css";
      pictures_path       = "${dataDir}/static_content/pictures";
      mhonarc             = "${pkgs.perlPackages.MHonArc}/bin/mhonarc";
    }));

    services.sympa.settingsFile = {
      "virtual.sympa"        = lib.mkDefault { source = virtual; };
      "transport.sympa"      = lib.mkDefault { source = transport; };
      "etc/list_aliases.tt2" = lib.mkDefault { source = listAliases; };
    }
    // (lib.flip lib.mapAttrs' cfg.domains (fqdn: domain:
          lib.nameValuePair "etc/${fqdn}/robot.conf" (lib.mkDefault { source = robotConfig fqdn domain; })));

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
    ++ (lib.flip lib.concatMap fqdns (fqdn: [
      "d  ${dataDir}/etc/${fqdn}       0700 ${user} ${group} - -"
      "d  ${dataDir}/list_data/${fqdn} 0700 ${user} ${group} - -"
    ]))
    #++ (lib.flip lib.mapAttrsToList enabledFiles (k: v:
    #  "L+ ${dataDir}/${k}              -    -       -        - ${v.source}"
    #))
    ++ (lib.concatLists (lib.flip lib.mapAttrsToList enabledFiles (k: v: [
      # sympa doesn't handle symlinks well (e.g. fails to create locks)
      # force-copy instead
      "R ${dataDir}/${k}              -    -       -        - -"
      "C ${dataDir}/${k}              0700 ${user}  ${group} - ${v.source}"
    ])));

    systemd.services.sympa = {
      description = "Sympa mailing list manager";

      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = sympaSubServices ++ [ "network-online.target" ];
      before = sympaSubServices;
      serviceConfig = sympaServiceConfig "sympa_msg";

      preStart = ''
        umask 0077

        cp -f ${mainConfig} ${dataDir}/etc/sympa.conf
        ${lib.optionalString (cfg.database.passwordFile != null) ''
          chmod u+w ${dataDir}/etc/sympa.conf
          echo -n "db_passwd " >> ${dataDir}/etc/sympa.conf
          cat ${cfg.database.passwordFile} >> ${dataDir}/etc/sympa.conf
        ''}

        ${lib.optionalString (cfg.mta.type == "postfix") ''
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

    systemd.services.wwsympa = lib.mkIf usingNginx {
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

    services.nginx.enable = lib.mkIf usingNginx true;
    services.nginx.virtualHosts = lib.mkIf usingNginx (let
      vHosts = lib.unique (lib.remove null (lib.mapAttrsToList (_k: v: v.webHost) cfg.domains));
      hostLocations = host: map (v: v.webLocation) (lib.filter (v: v.webHost == host) (lib.attrValues cfg.domains));
      httpsOpts = lib.optionalAttrs cfg.web.https { forceSSL = lib.mkDefault true; enableACME = lib.mkDefault true; };
    in
    lib.genAttrs vHosts (host: {
      locations = lib.genAttrs (hostLocations host) (loc: {
        extraConfig = ''
          include ${config.services.nginx.package}/conf/fastcgi_params;

          fastcgi_pass unix:/run/sympa/wwsympa.socket;
        '';
      }) // {
        "/static-sympa/".alias = "${dataDir}/static_content/";
      };
    } // httpsOpts));

    services.postfix = lib.mkIf (cfg.mta.type == "postfix") {
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

    services.mysql = lib.optionalAttrs mysqlLocal {
      enable = true;
      package = lib.mkDefault pkgs.mariadb;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        { name = cfg.database.user;
          ensurePermissions = { "${cfg.database.name}.*" = "ALL PRIVILEGES"; };
        }
      ];
    };

    services.postgresql = lib.optionalAttrs pgsqlLocal {
      enable = true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        { name = cfg.database.user;
          ensureDBOwnership = true;
        }
      ];
    };

  };

  meta.maintainers = with lib.maintainers; [ mmilata sorki ];
}

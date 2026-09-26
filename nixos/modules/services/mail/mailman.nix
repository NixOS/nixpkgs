{
  config,
  pkgs,
  lib,
  ...
}:
let

  cfg = config.services.mailman;

  inherit
    (cfg.packageSet.buildEnvs {
      withHyperkitty = cfg.hyperkitty.enable;
      withLDAP = cfg.ldap.enable;
    })
    mailmanEnv
    webEnv
    ;

  withPostgresql = config.services.postgresql.enable;

  # This deliberately doesn't use recursiveUpdate so users can
  # override the defaults.
  webSettings = {
    DEFAULT_FROM_EMAIL = cfg.siteOwner;
    SERVER_EMAIL = cfg.siteOwner;
    ALLOWED_HOSTS = [
      "localhost"
      "127.0.0.1"
    ]
    ++ cfg.webHosts;
    COMPRESS_OFFLINE = true;
    STATIC_ROOT = "/var/lib/mailman-web-static";
    MEDIA_ROOT = "/var/lib/mailman-web/media";
    LOGGING = {
      version = 1;
      disable_existing_loggers = true;
      handlers.console.class = "logging.StreamHandler";
      loggers.django = {
        handlers = [ "console" ];
        level = "INFO";
      };
    };
    HAYSTACK_CONNECTIONS.default = {
      ENGINE = "haystack.backends.whoosh_backend.WhooshEngine";
      PATH = "/var/lib/mailman-web/fulltext-index";
    };
  }
  // lib.optionalAttrs cfg.enablePostfix {
    EMAIL_BACKEND = "django.core.mail.backends.smtp.EmailBackend";
    EMAIL_HOST = "127.0.0.1";
    EMAIL_PORT = 25;
  }
  // cfg.webSettings;

  webSettingsJSON = pkgs.writeText "settings.json" (builtins.toJSON webSettings);

  # TODO: Should this be RFC42-ised so that users can set additional options without modifying the module?
  postfixMtaConfig = pkgs.writeText "mailman-postfix.cfg" ''
    [postfix]
    postmap_command: ${lib.getExe' config.services.postfix.package "postmap"}
    transport_file_type: hash
  '';

  mailmanCfg = lib.generators.toINI { } (
    lib.recursiveUpdate cfg.settings {
      webservice.admin_pass = "#NIXOS_MAILMAN_REST_API_PASS_SECRET#";
    }
  );

  mailmanCfgFile = pkgs.writeText "mailman-raw.cfg" mailmanCfg;

  mailmanHyperkittyCfg = pkgs.writeText "mailman-hyperkitty.cfg" ''
    [general]
    # This is your HyperKitty installation, preferably on the localhost. This
    # address will be used by Mailman to forward incoming emails to HyperKitty
    # for archiving. It does not need to be publicly available, in fact it's
    # better if it is not.
    base_url: ${cfg.hyperkitty.baseUrl}

    # Shared API key, must be the identical to the value in HyperKitty's
    # settings.
    api_key: @API_KEY@
  '';

in
{

  ###### interface

  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "mailman" "hyperkittyBaseUrl" ]
      [ "services" "mailman" "hyperkitty" "baseUrl" ]
    )

    (lib.mkRemovedOptionModule [ "services" "mailman" "hyperkittyApiKey" ] ''
      The Hyperkitty API key is now generated on first run, and not
      stored in the world-readable Nix store.  To continue using
      Hyperkitty, you must set services.mailman.hyperkitty.enable = true.
    '')
    (lib.mkRemovedOptionModule [ "services" "mailman" "package" ] ''
      Didn't have an effect for several years.
    '')
    (lib.mkRemovedOptionModule [ "services" "mailman" "extraPythonPackages" ] ''
      Didn't have an effect for several years.
    '')
  ];

  options = {

    services.mailman = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Mailman on this host. Requires an active MTA on the host (e.g. Postfix).";
      };

      packageSet = lib.mkPackageOption pkgs "mailmanPackages" { } // {
        type = lib.types.attrs;
      };

      ldap = {
        enable = lib.mkEnableOption "LDAP auth";
        serverUri = lib.mkOption {
          type = lib.types.str;
          example = "ldaps://ldap.host";
          description = ''
            LDAP host to connect against.
          '';
        };
        bindDn = lib.mkOption {
          type = lib.types.str;
          example = "cn=root,dc=nixos,dc=org";
          description = ''
            Service account to bind against.
          '';
        };
        bindPasswordFile = lib.mkOption {
          type = lib.types.str;
          example = "/run/secrets/ldap-bind";
          description = ''
            Path to the file containing the bind password of the service account
            defined by [](#opt-services.mailman.ldap.bindDn).
          '';
        };
        superUserGroup = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "cn=admin,ou=groups,dc=nixos,dc=org";
          description = ''
            Group where a user must be a member of to gain superuser rights.
          '';
        };
        userSearch = {
          query = lib.mkOption {
            type = lib.types.str;
            example = "(&(objectClass=inetOrgPerson)(|(uid=%(user)s)(mail=%(user)s)))";
            description = ''
              Query to find a user in the LDAP database.
            '';
          };
          ou = lib.mkOption {
            type = lib.types.str;
            example = "ou=users,dc=nixos,dc=org";
            description = ''
              Organizational unit to look up a user.
            '';
          };
        };
        groupSearch = {
          type = lib.mkOption {
            type = lib.types.enum [
              "posixGroup"
              "groupOfNames"
              "memberDNGroup"
              "nestedMemberDNGroup"
              "nestedGroupOfNames"
              "groupOfUniqueNames"
              "nestedGroupOfUniqueNames"
              "activeDirectoryGroup"
              "nestedActiveDirectoryGroup"
              "organizationalRoleGroup"
              "nestedOrganizationalRoleGroup"
            ];
            default = "posixGroup";
            apply = v: "${lib.toUpper (lib.substring 0 1 v)}${lib.substring 1 (lib.stringLength v) v}Type";
            description = ''
              Type of group to perform a group search against.
            '';
          };
          query = lib.mkOption {
            type = lib.types.str;
            example = "(objectClass=groupOfNames)";
            description = ''
              Query to find a group associated to a user in the LDAP database.
            '';
          };
          ou = lib.mkOption {
            type = lib.types.str;
            example = "ou=groups,dc=nixos,dc=org";
            description = ''
              Organizational unit to look up a group.
            '';
          };
        };
        attrMap = {
          username = lib.mkOption {
            default = "uid";
            type = lib.types.str;
            description = ''
              LDAP-attribute that corresponds to the `username`-attribute in mailman.
            '';
          };
          firstName = lib.mkOption {
            default = "givenName";
            type = lib.types.str;
            description = ''
              LDAP-attribute that corresponds to the `firstName`-attribute in mailman.
            '';
          };
          lastName = lib.mkOption {
            default = "sn";
            type = lib.types.str;
            description = ''
              LDAP-attribute that corresponds to the `lastName`-attribute in mailman.
            '';
          };
          email = lib.mkOption {
            default = "mail";
            type = lib.types.str;
            description = ''
              LDAP-attribute that corresponds to the `email`-attribute in mailman.
            '';
          };
        };
      };

      enablePostfix = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = ''
          Enable Postfix integration. Requires an active Postfix installation.

          If you want to use another MTA, set this option to false and configure
          settings in services.mailman.settings.mta.

          Refer to the Mailman manual for more info.
        '';
      };

      siteOwner = lib.mkOption {
        type = lib.types.str;
        example = "postmaster@example.org";
        description = ''
          Certain messages that must be delivered to a human, but which can't
          be delivered to a list owner (e.g. a bounce from a list owner), will
          be sent to this address. It should point to a human.
        '';
      };

      webHosts = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          The list of hostnames and/or IP addresses from which the Mailman Web
          UI will accept requests. By default, "localhost" and "127.0.0.1" are
          enabled. All additional names under which your web server accepts
          requests for the UI must be listed here or incoming requests will be
          rejected.
        '';
      };

      webUser = lib.mkOption {
        type = lib.types.str;
        default = "mailman-web";
        description = ''
          User to run mailman-web as
        '';
      };

      webSettings = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        description = ''
          Overrides for the default mailman-web Django settings.
        '';
      };

      restApiPassFile = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.str;
        description = ''
          Path to the file containing the value for `MAILMAN_REST_API_PASS`.
        '';
      };

      serve = {
        enable = lib.mkEnableOption "automatic nginx and uwsgi setup for mailman-web";

        uwsgiSettings = lib.mkOption {
          default = { };
          example = {
            uwsgi.buffer-size = 8192;
          };
          inherit (pkgs.formats.json { }) type;
          description = ''
            Extra configuration to merge into uwsgi config.
          '';
        };

        virtualRoot = lib.mkOption {
          default = "/";
          example = lib.literalExpression "/lists";
          type = lib.types.str;
          description = ''
            Path to mount the mailman-web django application on.
          '';
        };
      };

      settings = lib.mkOption {
        description = "Settings for mailman.cfg";
        type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
        default = { };
      };

      hyperkitty = {
        enable = lib.mkEnableOption "the Hyperkitty archiver for Mailman";

        baseUrl = lib.mkOption {
          type = lib.types.str;
          default = "http://localhost:18507/archives/";
          description = ''
            Where can Mailman connect to Hyperkitty's internal API, preferably on
            localhost?
          '';
        };
      };

    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    services.mailman.settings = {
      mailman.site_owner = lib.mkDefault cfg.siteOwner;
      mailman.layout = "fhs";

      "paths.fhs" = {
        bin_dir = "${cfg.packageSet.mailman}/bin";
        var_dir = "/var/lib/mailman";
        queue_dir = "$var_dir/queue";
        template_dir = "$var_dir/templates";
        log_dir = "/var/log/mailman";
        lock_dir = "/run/mailman/lock";
        etc_dir = "/etc";
        pid_file = "/run/mailman/master.pid";
      };

      mta.configuration = lib.mkDefault (
        if cfg.enablePostfix then
          "${postfixMtaConfig}"
        else
          throw "When Mailman Postfix integration is disabled, set `services.mailman.settings.mta.configuration` to the path of the config file required to integrate with your MTA."
      );

      "archiver.hyperkitty" = lib.mkIf cfg.hyperkitty.enable {
        class = "mailman_hyperkitty.Archiver";
        enable = "yes";
        configuration = "/var/lib/mailman/mailman-hyperkitty.cfg";
      };
    }
    // (
      let
        loggerNames = [
          "root"
          "archiver"
          "bounce"
          "config"
          "database"
          "debug"
          "error"
          "fromusenet"
          "http"
          "locks"
          "mischief"
          "plugins"
          "runner"
          "smtp"
        ];
        loggerSectionNames = map (n: "logging.${n}") loggerNames;
      in
      lib.genAttrs loggerSectionNames (name: {
        handler = "stderr";
      })
    );

    assertions =
      let
        inherit (config.services) postfix;

        requirePostfixHash =
          optionPath: dataFile:
          let
            expected = "hash:/var/lib/mailman/data/${dataFile}";
            value = lib.attrByPath optionPath [ ] postfix;
          in
          {
            assertion = postfix.enable -> lib.isList value && lib.elem expected value;
            message = ''
              services.postfix.${lib.concatStringsSep "." optionPath} must contain
              "${expected}".
              See <https://mailman.readthedocs.io/en/latest/src/mailman/docs/mta.html>.
            '';
          };
      in
      [
        {
          assertion = cfg.webHosts != [ ];
          message = ''
            services.mailman.serve.enable requires there to be at least one entry
            in services.mailman.webHosts.
          '';
        }
      ]
      ++ (lib.optionals cfg.enablePostfix [
        {
          assertion = postfix.enable;
          message = ''
            Mailman's default NixOS configuration requires Postfix to be enabled.

            If you want to use another MTA, set services.mailman.enablePostfix
            to false and configure settings in services.mailman.settings.mta.

            Refer to <https://mailman.readthedocs.io/en/latest/src/mailman/docs/mta.html>
            for more info.
          '';
        }
        (requirePostfixHash [ "settings" "main" "relay_domains" ] "postfix_domains")
        (requirePostfixHash [ "settings" "main" "transport_maps" ] "postfix_lmtp")
        (requirePostfixHash [ "settings" "main" "local_recipient_maps" ] "postfix_lmtp")
      ]);

    users.users.mailman = {
      description = "GNU Mailman";
      isSystemUser = true;
      group = "mailman";
    };
    users.users.mailman-web = lib.mkIf (cfg.webUser == "mailman-web") {
      description = "GNU Mailman web interface";
      isSystemUser = true;
      group = "mailman";
    };
    users.groups.mailman = { };

    environment.etc."mailman3/settings.py".text = ''
      import os
      from configparser import ConfigParser

      # Required by mailman_web.settings, but will be overridden when
      # settings_local.json is loaded.
      os.environ["SECRET_KEY"] = ""

      from mailman_web.settings.base import *
      from mailman_web.settings.mailman import *

      import json

      with open('${webSettingsJSON}') as f:
          globals().update(json.load(f))

      with open('/var/lib/mailman-web/settings_local.json') as f:
          globals().update(json.load(f))

      with open('/etc/mailman.cfg') as f:
          config = ConfigParser()
          config.read_file(f)
          MAILMAN_REST_API_PASS = config['webservice']['admin_pass']

      ${lib.optionalString (cfg.ldap.enable) ''
        import ldap
        from django_auth_ldap.config import LDAPSearch, ${cfg.ldap.groupSearch.type}
        AUTH_LDAP_SERVER_URI = "${cfg.ldap.serverUri}"
        AUTH_LDAP_BIND_DN = "${cfg.ldap.bindDn}"
        with open("${cfg.ldap.bindPasswordFile}") as f:
            AUTH_LDAP_BIND_PASSWORD = f.read().rstrip('\n')
        AUTH_LDAP_USER_SEARCH = LDAPSearch("${cfg.ldap.userSearch.ou}",
            ldap.SCOPE_SUBTREE, "${cfg.ldap.userSearch.query}")
        AUTH_LDAP_GROUP_TYPE = ${cfg.ldap.groupSearch.type}()
        AUTH_LDAP_GROUP_SEARCH = LDAPSearch("${cfg.ldap.groupSearch.ou}",
            ldap.SCOPE_SUBTREE, "${cfg.ldap.groupSearch.query}")
        AUTH_LDAP_USER_ATTR_MAP = {
          ${lib.concatStrings (
            lib.flip lib.mapAttrsToList cfg.ldap.attrMap (
              key: value: ''
                "${key}": "${value}",
              ''
            )
          )}
        }
        ${lib.optionalString (cfg.ldap.superUserGroup != null) ''
          AUTH_LDAP_USER_FLAGS_BY_GROUP = {
            "is_superuser": "${cfg.ldap.superUserGroup}"
          }
        ''}
        AUTHENTICATION_BACKENDS = (
            "django_auth_ldap.backend.LDAPBackend",
            "django.contrib.auth.backends.ModelBackend"
        )
      ''}
    '';

    services.nginx = lib.mkIf (cfg.serve.enable && cfg.webHosts != [ ]) {
      enable = lib.mkDefault true;
      virtualHosts = lib.genAttrs cfg.webHosts (webHost: {
        locations = {
          ${cfg.serve.virtualRoot}.uwsgiPass = "unix:/run/mailman-web.socket";
          "${lib.removeSuffix "/" cfg.serve.virtualRoot}/static/".alias = webSettings.STATIC_ROOT + "/";
        };
      });
      proxyTimeout = lib.mkDefault "120s";
    };

    environment.systemPackages = [
      (pkgs.buildEnv {
        name = "mailman-tools";
        # We don't want to pollute the system PATH with a python
        # interpreter etc. so let's pick only the stuff we actually
        # want from {web,mailman}Env
        pathsToLink = [ "/bin" ];
        paths = [
          mailmanEnv
          webEnv
        ];
        # Only mailman-related stuff is installed, the rest is removed
        # in `postBuild`.
        ignoreCollisions = true;
        postBuild = ''
          find $out/bin/ -mindepth 1 -not -name "mailman*" -delete
        ''
        + lib.optionalString config.security.sudo.enable ''
          mv $out/bin/mailman $out/bin/.mailman-wrapped
          echo '#!${pkgs.runtimeShell}
          sudo=exec
          if [[ "$USER" != mailman ]]; then
            sudo="exec /run/wrappers/bin/sudo -u mailman"
          fi
          $sudo ${placeholder "out"}/bin/.mailman-wrapped "$@"
          ' > $out/bin/mailman
          chmod +x $out/bin/mailman
        '';
      })
    ];

    services.postfix = lib.mkIf cfg.enablePostfix {
      settings.main = {
        owner_request_special = "no"; # Mailman handles -owner addresses on its own
        recipient_delimiter = "+"; # bake recipient addresses in mail envelopes via VERP
      };
    };

    systemd.sockets.mailman-uwsgi = lib.mkIf cfg.serve.enable {
      wantedBy = [ "sockets.target" ];
      before = [ "nginx.service" ];
      socketConfig.ListenStream = "/run/mailman-web.socket";
    };
    systemd.services = {
      mailman = {
        description = "GNU Mailman Master Process";
        before = lib.optional cfg.enablePostfix "postfix.service";
        after = [
          "network.target"
        ]
        ++ lib.optional cfg.enablePostfix "postfix-setup.service"
        ++ lib.optional withPostgresql "postgresql.target";
        restartTriggers = [ mailmanCfgFile ];
        requires = lib.optional withPostgresql "postgresql.target";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${mailmanEnv}/bin/mailman start";
          ExecStop = "${mailmanEnv}/bin/mailman stop";
          User = "mailman";
          Group = "mailman";
          Type = "forking";
          RuntimeDirectory = "mailman";
          LogsDirectory = "mailman";
          PIDFile = "/run/mailman/master.pid";
          Restart = "on-failure";
          TimeoutStartSec = 180;
          TimeoutStopSec = 180;
        };
      };

      mailman-settings = {
        description = "Generate settings files (including secrets) for Mailman";
        before = [
          "mailman.service"
          "mailman-web-setup.service"
          "mailman-uwsgi.service"
          "hyperkitty.service"
        ];
        requiredBy = [
          "mailman.service"
          "mailman-web-setup.service"
          "mailman-uwsgi.service"
          "hyperkitty.service"
        ];
        path = with pkgs; [ jq ];
        after = lib.optional withPostgresql "postgresql.target";
        requires = lib.optional withPostgresql "postgresql.target";
        serviceConfig.RemainAfterExit = true;
        serviceConfig.Type = "oneshot";
        script = ''
          install -m0750 -o mailman -g mailman ${mailmanCfgFile} /etc/mailman.cfg
          ${
            if cfg.restApiPassFile == null then
              ''
                sed -i "s/#NIXOS_MAILMAN_REST_API_PASS_SECRET#/$(tr -dc A-Za-z0-9 < /dev/urandom | head -c 64)/g" \
                  /etc/mailman.cfg
              ''
            else
              ''
                ${pkgs.replace-secret}/bin/replace-secret \
                  '#NIXOS_MAILMAN_REST_API_PASS_SECRET#' \
                  ${cfg.restApiPassFile} \
                  /etc/mailman.cfg
              ''
          }

          mailmanDir=/var/lib/mailman
          mailmanWebDir=/var/lib/mailman-web

          mailmanCfg=$mailmanDir/mailman-hyperkitty.cfg
          mailmanWebCfg=$mailmanWebDir/settings_local.json

          install -m 0775 -o mailman -g mailman -d /var/lib/mailman-web-static
          install -m 0770 -o mailman -g mailman -d $mailmanDir
          install -m 0770 -o ${cfg.webUser} -g mailman -d $mailmanWebDir

          if [ ! -e $mailmanWebCfg ]; then
              hyperkittyApiKey=$(tr -dc A-Za-z0-9 < /dev/urandom | head -c 64)
              secretKey=$(tr -dc A-Za-z0-9 < /dev/urandom | head -c 64)

              install -m 0440 -o root -g mailman \
                <(jq -n '.MAILMAN_ARCHIVER_KEY=$archiver_key | .SECRET_KEY=$secret_key' \
                  --arg archiver_key "$hyperkittyApiKey" \
                  --arg secret_key "$secretKey") \
                "$mailmanWebCfg"
          fi

          hyperkittyApiKey="$(jq -r .MAILMAN_ARCHIVER_KEY "$mailmanWebCfg")"
          mailmanCfgTmp=$(mktemp)
          sed "s/@API_KEY@/$hyperkittyApiKey/g" ${mailmanHyperkittyCfg} >"$mailmanCfgTmp"
          chown mailman:mailman "$mailmanCfgTmp"
          mv "$mailmanCfgTmp" "$mailmanCfg"
        '';
      };

      mailman-web-setup = {
        description = "Prepare mailman-web files and database";
        before = [
          "hyperkitty.service"
          "mailman-uwsgi.service"
        ];
        requiredBy = [
          "hyperkitty.service"
          "mailman-uwsgi.service"
        ];
        restartTriggers = [ config.environment.etc."mailman3/settings.py".source ];
        script = ''
          [[ -e "${webSettings.STATIC_ROOT}" ]] && find "${webSettings.STATIC_ROOT}/" -mindepth 1 -delete
          ${webEnv}/bin/mailman-web migrate
          ${webEnv}/bin/mailman-web collectstatic
          ${webEnv}/bin/mailman-web compress
        '';
        serviceConfig = {
          User = cfg.webUser;
          Group = "mailman";
          Type = "oneshot";
          WorkingDirectory = "/var/lib/mailman-web";
        };
      };

      mailman-uwsgi = lib.mkIf cfg.serve.enable (
        let
          uwsgiConfig = lib.recursiveUpdate {
            uwsgi = {
              type = "normal";
              plugins = [ "python3" ];
              home = webEnv;
              http = "127.0.0.1:18507";
              buffer-size = 8192;
            }
            // (
              if cfg.serve.virtualRoot == "/" then
                { module = "mailman_web.wsgi:application"; }
              else
                {
                  mount = "${cfg.serve.virtualRoot}=mailman_web.wsgi:application";
                  manage-script-name = true;
                }
            );
          } cfg.serve.uwsgiSettings;
          uwsgiConfigFile = pkgs.writeText "uwsgi-mailman.json" (builtins.toJSON uwsgiConfig);
        in
        {
          wantedBy = [ "multi-user.target" ];
          after = lib.optional withPostgresql "postgresql.target";
          requires = [
            "mailman-uwsgi.socket"
            "mailman-web-setup.service"
          ]
          ++ lib.optional withPostgresql "postgresql.target";
          restartTriggers = [ config.environment.etc."mailman3/settings.py".source ];
          serviceConfig = {
            # Since the mailman-web settings.py obstinately creates a logs
            # dir in the cwd, change to the (writable) runtime directory before
            # starting uwsgi.
            ExecStart = "${pkgs.coreutils}/bin/env -C $RUNTIME_DIRECTORY ${
              pkgs.uwsgi.override {
                plugins = [ "python3" ];
                python3 = webEnv.python;
              }
            }/bin/uwsgi --json ${uwsgiConfigFile}";
            User = cfg.webUser;
            Group = "mailman";
            RuntimeDirectory = "mailman-uwsgi";
            Restart = "on-failure";
          };
        }
      );

      mailman-daily = {
        description = "Trigger daily Mailman events";
        startAt = "daily";
        restartTriggers = [ mailmanCfgFile ];
        serviceConfig = {
          ExecStart = "${mailmanEnv}/bin/mailman digests --send";
          User = "mailman";
          Group = "mailman";
        };
      };

      hyperkitty = lib.mkIf cfg.hyperkitty.enable {
        description = "GNU Hyperkitty QCluster Process";
        after = [ "network.target" ];
        restartTriggers = [ config.environment.etc."mailman3/settings.py".source ];
        wantedBy = [
          "mailman.service"
          "multi-user.target"
        ];
        serviceConfig = {
          ExecStart = "${webEnv}/bin/mailman-web qcluster";
          User = cfg.webUser;
          Group = "mailman";
          WorkingDirectory = "/var/lib/mailman-web";
          Restart = "on-failure";
        };
      };
    }
    //
      lib.flip lib.mapAttrs'
        {
          "minutely" = "minutely";
          "quarter_hourly" = "*:00/15";
          "hourly" = "hourly";
          "daily" = "daily";
          "weekly" = "weekly";
          "yearly" = "yearly";
        }
        (
          name: startAt:
          lib.nameValuePair "hyperkitty-${name}" (
            lib.mkIf cfg.hyperkitty.enable {
              description = "Trigger ${name} Hyperkitty events";
              inherit startAt;
              restartTriggers = [ config.environment.etc."mailman3/settings.py".source ];
              serviceConfig = {
                ExecStart = "${webEnv}/bin/mailman-web runjobs ${name}";
                User = cfg.webUser;
                Group = "mailman";
                WorkingDirectory = "/var/lib/mailman-web";
              };
            }
          )
        );
  };

  meta = {
    maintainers = with lib.maintainers; [ qyliss ];
    doc = ./mailman.md;
  };

}

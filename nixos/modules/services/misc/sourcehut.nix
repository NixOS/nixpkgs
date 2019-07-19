{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.sourcehut;

  # Specialized python containing all the modules
  python = pkgs.sourcehut.python.withPackages (ps: with ps; [
    gunicorn
    # Sourcehut services
    buildsrht dispatchsrht gitsrht hgsrht listssrht mansrht
    metasrht pastesrht todosrht
  ]);

  baseSrHtServiceOpts = service: {
    user = mkOption {
      type = types.str;
      default = service;
      description = ''
        The user for ${service}.
      '';
    };
  };
in {
  options.services.sourcehut = {
    buildsrht = baseSrHtServiceOpts "buildsrht";
    dispatchsrht = baseSrHtServiceOpts "dispatchsrht";
    gitsrht = baseSrHtServiceOpts "gitsrht";
    hgsrht = baseSrHtServiceOpts "hgsrht";
    listssrht = baseSrHtServiceOpts "listssrht";
    mansrht = baseSrHtServiceOpts "mansrht";
    metasrht = baseSrHtServiceOpts "metasrht";
    pastesrht = baseSrHtServiceOpts "pastesrht";
    todosrht = baseSrHtServiceOpts "todosrht";

    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable sourcehut - git hosting, continuous integration, mailing list, ticket tracking,
        task dispatching, wiki and account management services.
      '';
    };

    services = mkOption {
      type = types.nonEmptyListOf (types.enum [ "build" "dispatch" "git" "hg" "lists" "man" "meta" "paste" "todo" ]);
      default = [ "meta" ];
      # default = [ "builds" "dispatch" "git" "hg" "lists" "man" "meta" "paste" "todo" ];
      description = ''
        Services to enable on the sourcehut network.
      '';
    };

    statePath = mkOption {
      type = types.path;
      default = "/var/sourcehut";
      description = ''
        The root state directory for the sourcehut network.
      '';
    };

    migrateOnUpgrade = mkOption {
      type = types.enum [ "yes" "no" ];
      default = "yes";
      description = ''
        Automatically run migrations on package upgrades.
      '';
    };

    settings = mkOption {
      type = with types; attrsOf (attrsOf (nullOr (either bool (either int (either float (either str path))))));
      default = {};
      description = ''
        The configuration for the sourcehut network.
      '';
    };
  };

  config = let
    pgSuperUser = config.services.postgresql.superUser;
  in mkMerge [
    (mkIf cfg.enable {
      assertions =
        [
          { assertion = cfg.enable -> elem "meta" cfg.services;
            message = "The sourcehut network needs the meta service."; }
        ];

      environment.etc."sr.ht/config.ini".text = let
        mkKeyValue = key: v: let
          isPath = v: builtins.typeOf v == "path";

          value =
            if null == v        then ""
            else if true == v   then "yes"
            else if false == v  then "no"
            else if isInt v     then toString v
            else if isString v  then toString v
            else if isPath v    then toString v
            else abort "sourcehut.mkKeyValue: unexpected type (v = ${v})";
        in "${toString key}=${value}";
      in generators.toINI { inherit mkKeyValue; } config.services.sourcehut.settings;

      services = {
        # PostgreSQL server
        postgresql.enable = true;
        # Mail server
        postfix.enable = true;
        # Cron daemon
        cron.enable = true;
        # Redis server
        redis = {
          enable = true;
          port = 6379;
          # TODO: localhost
          bind = "127.0.0.1";
          # TODO: More like 2?
          databases = 8;
        };

        sourcehut.settings = {
          # The name of your network of sr.ht-based sites
          "sr.ht".site-name = "sourcehut";
          # The top-level info page for your site
          "sr.ht".site-info = "https://sourcehut.org";
          # {{ site-name }}, {{ site-blurb }}
          "sr.ht".site-blurb = "the hacker's forge";
          # If this != production, we add a banner to each page
          "sr.ht".environment = "development";
          # Contact information for the site owners
          "sr.ht".owner-name = "Drew DeVault";
          "sr.ht".owner-email = "sir@cmpwn.com";
          # The source code for your fork of sr.ht
          "sr.ht".source-url = "https://git.sr.ht/~sircmpwn/srht";
          # A secret key to encrypt session cookies with
          "sr.ht".secret-key = "CHANGEME";

          # Outgoing SMTP settings
          mail.smtp-host = null;
          mail.smtp-port = null;
          mail.smtp-user = null;
          mail.smtp-password = null;
          mail.smtp-from = null;
          # Application exceptions are emailed to this address
          mail.error-to = null;
          mail.error-from = null;
          # Your PGP key information (DO NOT mix up pub and priv here)
          # You must remove the password from your secret key, if present.
          # You can do this with gpg --edit-key [key-id], then use the passwd
          # command and do not enter a new password.
          mail.pgp-privkey = null;
          mail.pgp-pubkey = null;
          mail.pgp-key-id = null;

          # base64-encoded Ed25519 key for signing webhook payloads. This should be
          # consistent for all *.sr.ht sites, as we'll use this key to verify signatures
          # from other sites in your network.
          #
          # Use the srht-webhook-keygen command to generate a key.
          webhooks.private-key = null;

          # URL builds.sr.ht is being served at (protocol://domain)
          "builds.sr.ht".origin = "http://builds.sr.ht.local";
          # Address and port to bind the debug server to
          "builds.sr.ht".debug-host = "0.0.0.0";
          "builds.sr.ht".debug-port = 5002;
          # Configures the SQLAlchemy connection string for the database.
          "builds.sr.ht".connection-string = "postgresql://postgres@localhost/builds.sr.ht";
          # Set to "yes" to automatically run migrations on package upgrade.
          # "builds.sr.ht".migrate-on-upgrade = "yes";
          "builds.sr.ht".migrate-on-upgrade = mkDefault cfg.migrateOnUpgrade;
          # The redis connection used for the Celery worker (configure this on both the
          # master and workers)
          "builds.sr.ht".redis = "redis://localhost:6379/0";
          # builds.sr.ht's OAuth client ID and secret for meta.sr.ht
          # Register your client at meta.example.org/oauth
          "builds.sr.ht".oauth-client-id = null;
          "builds.sr.ht".oauth-client-secret = null;

          # These config options are only necessary for systems running a build runner
          # Name of this build runner
          "builds.sr.ht::worker".name = "runner.sr.ht.local";
          # Path to write build logs
          "builds.sr.ht::worker".buildlogs = ./logs;
          # Path to the build images
          "builds.sr.ht::worker".images = ./images;
          # In production you should NOT put the build user in the docker group. Instead,
          # make a scratch user who is and write a sudoers or doas.conf file that allows
          # them to execute just the control command, then update this config option. For
          # example:
          #
          #   doas -u docker /var/lib/images/control
          #
          # Assuming doas.conf looks something like this:
          #
          #   permit nopass builds as docker cmd /var/lib/images/control
          #
          # For more information about the security model of builds.sr.ht, visit the wiki:
          #
          #   https://man.sr.ht/builds.sr.ht/security
          "builds.sr.ht::worker".controlcmd = ./images/control;
          # Max build duration. See https://golang.org/pkg/time/#ParseDuration
          "builds.sr.ht::worker".timeout = "45m";

          # URL dispatch.sr.ht is being served at (protocol://domain)
          "dispatch.sr.ht".origin = "http://dispatch.sr.ht.local";
          # Address and port to bind the debug server to
          "dispatch.sr.ht".debug-host = "0.0.0.0";
          "dispatch.sr.ht".debug-port = 5005;
          # Configures the SQLAlchemy connection string for the database.
          "dispatch.sr.ht".connection-string = "postgresql://postgres@localhost/dispatch.sr.ht";
          # Set to "yes" to automatically run migrations on package upgrade.
          # "dispatch.sr.ht".migrate-on-upgrade = "yes";
          "dispatch.sr.ht".migrate-on-upgrade = cfg.migrateOnUpgrade;
          # dispatch.sr.ht's OAuth client ID and secret for meta.sr.ht
          # Register your client at meta.example.org/oauth
          "dispatch.sr.ht".oauth-client-id = null;
          "dispatch.sr.ht".oauth-client-secret = null;

          # Fill this in with a registered GitHub OAuth client to enable GitHub
          # integration
          "dispatch.sr.ht::github".oauth-client-id = null;
          "dispatch.sr.ht::github".oauth-client-secret = null;

          # URL git.sr.ht is being served at (protocol://domain)
          "git.sr.ht".origin = "http://git.sr.ht.local";
          # Address and port to bind the debug server to
          "git.sr.ht".debug-host = "0.0.0.0";
          "git.sr.ht".debug-port = 5001;
          # Configures the SQLAlchemy connection string for the database.
          "git.sr.ht".connection-string = "postgresql://postgres@localhost/git.sr.ht";
          # Set to "yes" to automatically run migrations on package upgrade.
          # "git.sr.ht".migrate-on-upgrade = "yes";
          "git.sr.ht".migrate-on-upgrade = cfg.migrateOnUpgrade;
          # The redis connection used for the webhooks worker
          "git.sr.ht".webhooks = "redis://localhost:6379/1";
          # A post-update script which is installed in every git repo.
          "git.sr.ht".post-update-script = /usr/bin/gitsrht-update-hook;
          # git.sr.ht's OAuth client ID and secret for meta.sr.ht
          # Register your client at meta.example.org/oauth
          "git.sr.ht".oauth-client-id = "CHANGEME";
          "git.sr.ht".oauth-client-secret = "CHANGEME";
          # Path to git repositories on disk
          "git.sr.ht".repos = /var/lib/git;

          # The authorized keys hook uses this to dispatch to various handlers
          # The format is a program to exec into as the key, and the user to match as the
          # value. When someone tries to log in as this user, this program is executed
          # and is expected to omit an AuthorizedKeys file.
          #
          # Uncomment the relevant lines to enable the various sr.ht dispatchers.
          "git.sr.ht::dispatch"."/usr/bin/gitsrht-keys" = "git:git";
          # "git.sr.ht::dispatch"."/usr/bin/man-srht-keys" = "man:man";

          # URL hg.sr.ht is being served at (protocol://domain)
          "hg.sr.ht".origin = "http://hg.sr.ht.local";
          # Address and port to bind the debug server to
          "hg.sr.ht".debug-host = "0.0.0.0";
          "hg.sr.ht".debug-port = 5010;
          # Configures the SQLAlchemy connection string for the database.
          "hg.sr.ht".connection-string = "postgresql://postgres@localhost/hg.sr.ht";
          # The redis connection used for the webhooks worker
          "hg.sr.ht".webhooks = "redis://localhost:6379/1";
          # A post-update script which is installed in every mercurial repo.
          "hg.sr.ht".changegroup-script = /usr/bin/hgsrht-hook-changegroup;
          # hg.sr.ht's OAuth client ID and secret for meta.sr.ht
          # Register your client at meta.example.org/oauth
          "hg.sr.ht".oauth-client-id = "CHANGEME";
          "hg.sr.ht".oauth-client-secret = "CHANGEME";
          # Path to mercurial repositories on disk
          "hg.sr.ht".repos = /var/lib/hg;
          # Path to the srht mercurial extension
          # (defaults to where the hgsrht code is)
          # "hg.sr.ht".srhtext = null;
          # .hg/store size (in MB) past which the nightly job generates clone bundles.
          # "hg.sr.ht".clone_bundle_threshold = 50;
          # Path to hg-ssh (if not in $PATH)
          # "hg.sr.ht".hg_ssh = /path/to/hg-ssh;

          # The authorized keys hook uses this to dispatch to various handlers
          # The format is a program to exec into as the key, and the user to match as the
          # value. When someone tries to log in as this user, this program is executed
          # and is expected to omit an AuthorizedKeys file.
          #
          # Uncomment the relevant lines to enable the various sr.ht dispatchers.
          "hg.sr.ht::dispatch"."/usr/bin/hgsrht-keys" = "hg:hg";

          # URL lists.sr.ht is being served at (protocol://domain)
          "lists.sr.ht".origin = "http://lists.sr.ht.local";
          # Address and port to bind the debug server to
          "lists.sr.ht".debug-host = "0.0.0.0";
          "lists.sr.ht".debug-port = 5006;
          # Configures the SQLAlchemy connection string for the database.
          "lists.sr.ht".connection-string = "postgresql://postgres@localhost/lists.sr.ht";
          # Set to "yes" to automatically run migrations on package upgrade.
          # "lists.sr.ht".migrate-on-upgrade = "yes";
          "lists.sr.ht".migrate-on-upgrade = cfg.migrateOnUpgrade;
          # The redis connection used for the webhooks worker
          "lists.sr.ht".webhooks = "redis://localhost:6379/1";
          # The redis connection used for the Celery worker (configure this on both the
          # master and workers)
          "lists.sr.ht".redis = "redis://localhost:6379/0";
          # The domain that incoming email should be sent to. Forward mail sent here to
          # the LTMP socket.
          "lists.sr.ht".posting-domain = "lists.sr.ht.local";
          # lists.sr.ht's OAuth client ID and secret for meta.sr.ht
          # Register your client at meta.example.org/oauth
          "lists.sr.ht".oauth-client-id = null;
          "lists.sr.ht".oauth-client-secret = null;
          # Trusted upstream SMTP server generating Authentication-Results header fields
          "lists.sr.ht".msgauth-server = "mail.sr.ht.local";
          # If "no", prevents non-admins from creating new lists
          "lists.sr.ht".allow-new-lists = "yes";

          # Path for the lmtp daemon's unix socket. Direct incoming mail to this socket.
          # Alternatively, specify IP:PORT and an SMTP server will be run instead.
          "lists.sr.ht::worker".sock = /tmp/lists.sr.ht-lmtp.sock;
          # The lmtp daemon will make the unix socket group-read/write for users in this
          # group.
          "lists.sr.ht::worker".sock-group = "postfix";
          # Link to include in the rejection message where senders can get help
          # correcting their email.
          "lists.sr.ht::worker".reject-url = "https://man.sr.ht/lists.sr.ht/how-to-send.md";

          # Redirects for migrating old mailing lists to new ones. This just sets up the
          # redirect for incoming emails.
          # "lists.sr.ht::redirects"."old-address" = "~example/new-name";

          # URL man.sr.ht is being served at (protocol://domain)
          "man.sr.ht".origin = "http://man.sr.ht.local";
          # Address and port to bind the debug server to
          "man.sr.ht".debug-host = "0.0.0.0";
          "man.sr.ht".debug-port = 5004;
          # Configures the SQLAlchemy connection string for the database.
          "man.sr.ht".connection-string = "postgresql://postgres@localhost/man.sr.ht";
          # Set to "yes" to automatically run migrations on package upgrade.
          # "man.sr.ht".migrate-on-upgrade = "yes";
          "man.sr.ht".migrate-on-upgrade = cfg.migrateOnUpgrade;
          # Local account users can git push to over ssh
          "man.sr.ht".git-user = "man:man";
          # Path to git repositories on disk
          "man.sr.ht".repo-path = /var/lib/man;
          # man.sr.ht's OAuth client ID and secret for meta.sr.ht
          # Register your client at meta.example.org/oauth
          "man.sr.ht".oauth-client-id = "CHANGEME";
          "man.sr.ht".oauth-client-secret = "CHANGEME";

          # URL meta.sr.ht is being served at (protocol://domain)
          "meta.sr.ht".origin = "http://meta.sr.ht.local";
          # Address and port to bind the debug server to
          "meta.sr.ht".debug-host = "0.0.0.0";
          "meta.sr.ht".debug-port = 5000;
          # Configures the SQLAlchemy connection string for the database.
          "meta.sr.ht".connection-string = "postgresql://postgres@localhost/meta.sr.ht";
          # Set to "yes" to automatically run migrations on package upgrade.
          # "meta.sr.ht".migrate-on-upgrade = "yes";
          "meta.sr.ht".migrate-on-upgrade = cfg.migrateOnUpgrade;
          # If "yes", the user will be sent the stock sourcehut welcome emails after
          # signup (requires cron to be configured properly). These are specific to the
          # sr.ht instance so you probably want to patch these before enabling this.
          "meta.sr.ht".welcome-emails = "no";

          # If "no", public registration will not be permitted.
          "meta.sr.ht::settings".registration = "no";
          # Where to redirect new users upon registration
          "meta.sr.ht::settings".onboarding-redirect = "http://example.org";
          # How many invites each user is issued upon registration (only applicable if
          # open registration is disabled)
          "meta.sr.ht::settings".user-invites = 5;

          # You can add aliases for the client IDs of commonly used OAuth clients here.
          #
          # Example:
          # "meta.sr.ht::aliases"."git.sr.ht" = 12345;

          # "yes" to enable the billing system
          "meta.sr.ht::billing".enabled = "no";
          # Get your keys at https://dashboard.stripe.com/account/apikeys
          "meta.sr.ht::billing".stripe-public-key = null;
          "meta.sr.ht::billing".stripe-secret-key = null;

          # URL todo.sr.ht is being served at (protocol://domain)
          "todo.sr.ht".origin = "http://todo.sr.ht.local";
          # Address and port to bind the debug server to
          "todo.sr.ht".debug-host = "0.0.0.0";
          "todo.sr.ht".debug-port = 5003;
          # Configures the SQLAlchemy connection string for the database.
          "todo.sr.ht".connection-string = "postgresql://postgres@localhost/todo.sr.ht";
          # Set to "yes" to automatically run migrations on package upgrade.
          # "todo.sr.ht".migrate-on-upgrade = "yes";
          "todo.sr.ht".migrate-on-upgrade = cfg.migrateOnUpgrade;
          # todo.sr.ht's OAuth client ID and secret for meta.sr.ht
          # Register your client at meta.example.org/oauth
          "todo.sr.ht".oauth-client-id = "CHANGEME";
          "todo.sr.ht".oauth-client-secret = "CHANGEME";
          # Outgoing email for notifications generated by users
          "todo.sr.ht".notify-from = "CHANGEME@example.org";
          # The redis connection used for the webhooks worker
          "todo.sr.ht".webhooks = "redis://localhost:6379/1";

          # Path for the lmtp daemon's unix socket. Direct incoming mail to this socket.
          # Alternatively, specify IP:PORT and an SMTP server will be run instead.
          "todo.sr.ht::mail".sock = /tmp/todo.sr.ht-lmtp.sock;
          # The lmtp daemon will make the unix socket group-read/write for users in this
          # group.
          "todo.sr.ht::mail".sock-group = "postfix";

          "todo.sr.ht::mail".posting-domain = "example.org";
        };
      };

      systemd = {
        # Generate the $HOME directories for each service
        tmpfiles.rules = map
          (service: "d ${cfg.statePath}/${service}/home 0750 ${service} ${service} -")
          cfg.services;

        # Generate a basic template for each enabled service
        # Polyfilled in the specific mkIf expression
        services = let
          serviceConfig = service: let
            statePath = "${cfg.statePath}/${service}";
            servicePythonModule = "${service}srht";
            servicePythonDrv = pkgs.sourcehut."${servicePythonModule}";

            setupDB = pkgs.writeScript "${servicePythonModule}-gen-db" ''
              #! ${python}/bin/python
              from ${servicePythonModule}.app import db
              db.create()
            '';
          in with cfg."${servicePythonModule}"; {
            environment.HOME = "${statePath}/home";
            path = [ python config.services.postgresql.package ] ++ (with pkgs; [ git sudo ]);
            serviceConfig = {
              Type = "simple";
              User = user;
              Group = user;
              Restart = "always";
              WorkingDirectory = "${statePath}/home";
              # NOTE: preStart only works as root - at least through nixops libvirtd
              PermissionsStartOnly = true;
            };

            preStart = ''
              if ! test -e ${statePath}/db; then
                # Setup the initial database
                sudo -u ${pgSuperUser} psql postgres -c "CREATE ROLE ${user} WITH LOGIN NOCREATEDB NOCREATEROLE"
                sudo -u ${pgSuperUser} createdb --owner ${user} ${servicePythonModule}
                sudo -u ${user} ${setupDB}

                # Set the initial state of the database for future database upgrades
                if test -e ${python}/bin/${servicePythonModule}-migrate; then
                  # Run alembic stamp head once to tell alembic the schema is up-to-date
                  sudo -u ${service} ${python}/bin/${servicePythonModule}-migrate stamp head
                fi

                printf "%s" "${servicePythonDrv.version}" > ${statePath}/db
              fi

              ${optionalString (cfg.migrateOnUpgrade == "yes") ''
                if [ "$(cat ${statePath}/db)" != "${servicePythonDrv.version}" ]; then
                  # Manage schema migrations using alembic
                  sudo -u ${service} ${python}/bin/${servicePythonModule}-migrate -a upgrade head

                  # Mark down current package version
                  printf "%s" "${servicePythonDrv.version}" > ${statePath}/db
                fi
              ''}
            '';
          };
        in builtins.listToAttrs (map
          (service: nameValuePair "${service}srht" (serviceConfig service))
          cfg.services);
      };
    })

    # METASRHT
    (let
      mcfg = cfg.metasrht;
      settings = cfg.settings."meta.sr.ht";
      statePath = "${cfg.statePath}/metasrht";
    in mkIf (cfg.enable && elem "meta" cfg.services) {
      users = {
        users = singleton {
          name = mcfg.user;
          group = mcfg.user;
          description = "metasrht user";
        };

        groups = singleton {
          name = mcfg.user;
        };
      };

      services.cron.systemCronJobs = singleton "0 0 * * * ${python}/bin/metasrht-daily";

      systemd.services = {
        "meta.sr.ht" = {
          after = [ "postgresql.service" "network.target" ];
          requires = [ "postgresql.service" ];
          wantedBy = [ "multi-user.target" ];

          description = "meta.sr.ht website service";

          # preStart = ''
          #   # FIXME:
          #   # The process is fairly simple: run srht-update-profile <service>, where
          #   # <service> is e.g. "git.sr.ht", for each sourcehut service you run on
          #   # your host.
          #   # Update copy of each users' profile to the latest
          #   # See https://lists.sr.ht/~sircmpwn/sr.ht-admins/<20190302181207.GA13778%40cirno.my.domain>
          #   ${concatMapStringsSep "\n\n"
          #     (service: ''
          #       if ! test -e ${statePath}/${service}/webhook; then
          #         # Update ${service}'s users' profile copy to the latest
          #         ${python}/bin/srht-update-profile ${service}.sr.ht

          #         touch ${statePath}/${service}/webhook
          #       fi
          #     '')
          #     cfg.services}

          #   # FIXME:
          #   # Configure client(s) as "preauthorized"
          #   ${concatMapStringsSep "\n\n"
          #     (service: let
          #       serviceConfig = cfg."${service}";
          #     in ''
          #       if ! test -e ${mecfg.statePath}/${service}/oauth || [ "$(cat ${mecfg.statePath}/${service}/oauth)" != "${serviceConfig.oauth.clientId}" ]; then
          #         # Configure ${service}'s OAuth client as "preauthorized"
          #         sudo -u ${pgSuperUser} psql ${mecfg.database.dbname} \
          #           -c "UPDATE oauthclient SET preauthorized = true WHERE client_id = '${serviceConfig.oauth.clientId}'"

          #         printf "%s" "${serviceConfig.oauth.clientId}" > ${mecfg.statePath}/${service}/oauth
          #       fi
          #     '')
          #     (filter
          #       (service: builtins.hasAttr "oauth" cfg."${service}" && cfg."${service}".oauth.clientId != "")
          #       cfg.services)}
          # '';

          script = ''
            gunicorn metasrht.app:app -b 127.0.0.1:5000
          '';
              # -b ${settings.address}:${toString settings.port}
        };

        "meta.sr.ht-webhooks" = {
          after = [ "postgresql.service" "network.target" ];
          requires = [ "postgresql.service" ];
          wantedBy = [ "multi-user.target" ];

          description = "meta.sr.ht webhooks service";
          path = [ python ];
          serviceConfig = {
            Type = "simple";
            User = mcfg.user;
            Restart = "always";
          };

          script = ''
            celery \
              -A metasrht.webhooks worker \
              --loglevel=info
          '';
        };
      };
    })
  ];
}

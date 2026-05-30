{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (builtins) head tail;
  inherit (lib) generators maintainers types;
  inherit (lib.attrsets)
    attrValues
    filterAttrs
    mapAttrs
    mapAttrsToList
    recursiveUpdate
    ;
  inherit (lib.lists) flatten optional optionals;
  inherit (lib.options)
    literalExpression
    mkEnableOption
    mkOption
    mkPackageOption
    ;
  inherit (lib.strings)
    concatMapStringsSep
    concatStringsSep
    optionalString
    versionOlder
    ;
  inherit (lib.trivial) mapNullable;
  inherit (lib.modules)
    mkBefore
    mkDefault
    mkForce
    mkIf
    mkMerge
    mkRemovedOptionModule
    mkRenamedOptionModule
    ;
  inherit (config.services)
    nginx
    postfix
    postgresql
    redis
    ;
  inherit (config.users) users groups;
  cfg = config.services.sourcehut;
  domain = cfg.settings."sr.ht".global-domain;
  settingsFormat = pkgs.formats.ini {
    listToValue = concatMapStringsSep "," (generators.mkValueStringDefault { });
    mkKeyValue =
      k: v:
      optionalString (v != null) (
        generators.mkKeyValueDefault {
          mkValueString =
            v:
            if v == true then
              "yes"
            else if v == false then
              "no"
            else
              generators.mkValueStringDefault { } v;
        } "=" k v
      );
  };
  configIniOfService =
    srv:
    settingsFormat.generate "sourcehut-${srv}-config.ini"
      # Each service needs access to only a subset of sections (and secrets).
      (
        filterAttrs (k: v: v != null) (
          mapAttrs
            (
              section: v:
              let
                srvMatch = builtins.match "^([a-z]*)\\.sr\\.ht(::.*)?$" section;
              in
              if
                srvMatch == null # Include sections shared by all services
                || head srvMatch == srv # Include sections for the service being configured
              then
                v
              # Enable Web links and integrations between services.
              else if tail srvMatch == [ null ] && cfg.${head srvMatch}.enable then
                {
                  inherit (v) origin;
                  # mansrht crashes without it
                  oauth-client-id = v.oauth-client-id or null;
                }
              # Drop sub-sections of other services
              else
                null
            )
            (
              recursiveUpdate cfg.settings {
                # Those paths are mounted using BindPaths= or BindReadOnlyPaths=
                # for services needing access to them.
                "builds.sr.ht::worker".buildlogs = "/var/log/sourcehut/buildsrht-worker";
                "git.sr.ht".post-update-script = "/usr/bin/git.sr.ht-update-hook";
                "git.sr.ht".repos = cfg.settings."git.sr.ht".repos;
                # Making this a per service option despite being in a global section,
                # so that it uses the redis-server used by the service.
                "sr.ht".redis-host = cfg.${srv}.redis.host;
                "sr.ht".assets = "${cfg.${srv}.package}/share/sourcehut";
              }
            )
        )
      );
  commonServiceSettings = srv: {
    origin = mkOption {
      description = "URL ${srv}.sr.ht is being served at (protocol://domain)";
      type = types.str;
      default = "https://${srv}.${domain}";
      defaultText = "https://${srv}.example.com";
    };
    debug-host = mkOption {
      description = "Address to bind the debug server to.";
      type = with types; nullOr str;
      default = null;
    };
    debug-port = mkOption {
      description = "Port to bind the debug server to.";
      type = with types; nullOr str;
      default = null;
    };
    connection-string = mkOption {
      description = "SQLAlchemy connection string for the database.";
      type = types.str;
      default = "postgresql:///localhost?user=${srv}srht&host=/run/postgresql";
    };
    migrate-on-upgrade = mkEnableOption "automatic migrations on package upgrade" // {
      default = true;
    };
    oauth-client-id = mkOption {
      description = "${srv}.sr.ht's OAuth client id for meta.sr.ht.";
      type = types.str;
    };
    oauth-client-secret = mkOption {
      description = "${srv}.sr.ht's OAuth client secret for meta.sr.ht.";
      type = types.path;
      apply = s: "<" + toString s;
    };
    api-origin = mkOption {
      description = "Origin URL for the API";
      type = types.str;
      default = "http://${cfg.listenAddress}:${toString (cfg.${srv}.port + 100)}";
      defaultText = lib.literalMD ''
        `"http://''${`[](#opt-services.sourcehut.listenAddress)`}:''${toString (`[](#opt-services.sourcehut.${srv}.port)` + 100)}"`
      '';
    };
  };

  # Specialized python containing all the modules
  python = pkgs.sourcehut.python.withPackages (
    ps: with ps; [
      gunicorn
      eventlet
      # For monitoring Celery: sudo -u listssrht celery --app listssrht.process -b redis+socket:///run/redis-sourcehut/redis.sock?virtual_host=1 flower
      flower
      # Sourcehut services
      srht
      buildsrht
      gitsrht
      hubsrht
      listssrht
      mansrht
      metasrht
      # Not a python package
      #pagessrht
      pastesrht
      todosrht
    ]
  );
  mkOptionNullOrStr =
    description:
    mkOption {
      description = description;
      type = with types; nullOr str;
      default = null;
    };
in
{
  options.services.sourcehut = {
    enable = mkEnableOption ''
      sourcehut - git hosting, continuous integration, mailing list, ticket tracking, wiki
      and account management services
    '';

    listenAddress = mkOption {
      type = types.str;
      default = "localhost";
      description = "Address to bind to.";
    };

    python = mkOption {
      internal = true;
      type = types.package;
      default = python;
      description = ''
        The python package to use. It should contain references to the *srht modules and also
        gunicorn.
      '';
    };

    minio = {
      enable = mkEnableOption "local minio integration";
    };

    nginx = {
      enable = mkEnableOption "local nginx integration";
      virtualHost = mkOption {
        type = types.attrs;
        default = { };
        description = "Virtual-host configuration merged with all Sourcehut's virtual-hosts.";
      };
    };

    postfix = {
      enable = mkEnableOption "local postfix integration";
    };

    postgresql = {
      enable = mkEnableOption "local postgresql integration";
    };

    redis = {
      enable = mkEnableOption "local redis integration in a dedicated redis-server";
    };

    settings = mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options."sr.ht" = {
          global-domain = mkOption {
            description = "Global domain name.";
            type = types.str;
            example = "example.com";
          };
          environment = mkOption {
            description = "Values other than \"production\" adds a banner to each page.";
            type = types.enum [
              "development"
              "production"
            ];
            default = "development";
          };
          network-key = mkOption {
            description = ''
              An absolute file path (which should be outside the Nix-store)
              to a secret key to encrypt internal messages with. Use `srht-keygen network` to
              generate this key. It must be consistent between all services and nodes.
            '';
            type = types.path;
            apply = s: "<" + toString s;
          };
          owner-email = mkOption {
            description = "Owner's email.";
            type = types.str;
            default = "contact@example.com";
          };
          owner-name = mkOption {
            description = "Owner's name.";
            type = types.str;
            default = "John Doe";
          };
          site-blurb = mkOption {
            description = "Blurb for your site.";
            type = types.str;
            default = "the hacker's forge";
          };
          site-info = mkOption {
            description = "The top-level info page for your site.";
            type = types.str;
            default = "https://sourcehut.org";
          };
          service-key = mkOption {
            description = ''
              An absolute file path (which should be outside the Nix-store)
              to a key used for encrypting session cookies. Use `srht-keygen service` to
              generate the service key. This must be shared between each node of the same
              service (e.g. git1.sr.ht and git2.sr.ht), but different services may use
              different keys. If you configure all of your services with the same
              config.ini, you may use the same service-key for all of them.
            '';
            type = types.path;
            apply = s: "<" + toString s;
          };
          site-name = mkOption {
            description = "The name of your network of sr.ht-based sites.";
            type = types.str;
            default = "sourcehut";
          };
          source-url = mkOption {
            description = "The source code for your fork of sr.ht.";
            type = types.str;
            default = "https://git.sr.ht/~sircmpwn/srht";
          };
        };
        options.mail = {
          smtp-host = mkOptionNullOrStr "Outgoing SMTP host.";
          smtp-port = mkOption {
            description = "Outgoing SMTP port.";
            type = with types; nullOr port;
            default = null;
          };
          smtp-user = mkOptionNullOrStr "Outgoing SMTP user.";
          smtp-password = mkOptionNullOrStr "Outgoing SMTP password.";
          smtp-from = mkOption {
            type = types.str;
            description = "Outgoing SMTP FROM.";
          };
          error-to = mkOptionNullOrStr "Address receiving application exceptions";
          error-from = mkOptionNullOrStr "Address sending application exceptions";
          pgp-privkey = mkOption {
            type = types.str;
            description = ''
              An absolute file path (which should be outside the Nix-store)
              to an OpenPGP private key.

              Your PGP key information (DO NOT mix up pub and priv here)
              You must remove the password from your secret key, if present.
              You can do this with `gpg --edit-key [key-id]`,
              then use the `passwd` command and do not enter a new password.
            '';
          };
          pgp-pubkey = mkOption {
            type = with types; either path str;
            description = "OpenPGP public key.";
          };
          pgp-key-id = mkOption {
            type = types.str;
            description = "OpenPGP key identifier.";
          };
        };
        options.objects = {
          s3-upstream = mkOption {
            description = "Configure the S3-compatible object storage service.";
            type = with types; nullOr str;
            default = null;
          };
          s3-access-key = mkOption {
            description = "Access key to the S3-compatible object storage service";
            type = with types; nullOr str;
            default = null;
          };
          s3-secret-key = mkOption {
            description = ''
              An absolute file path (which should be outside the Nix-store)
              to the secret key of the S3-compatible object storage service.
            '';
            type = with types; nullOr path;
            default = null;
            apply = mapNullable (s: "<" + toString s);
          };
        };
        options.webhooks = {
          private-key = mkOption {
            description = ''
              An absolute file path (which should be outside the Nix-store)
              to a base64-encoded Ed25519 key for signing webhook payloads.
              This should be consistent for all *.sr.ht sites,
              as this key will be used to verify signatures
              from other sites in your network.
              Use the `srht-keygen webhook` command to generate a key.
            '';
            type = types.path;
            apply = s: "<" + toString s;
          };
        };

        options."builds.sr.ht" = commonServiceSettings "builds" // {
          allow-free = mkEnableOption "nonpaying users to submit builds";
          redis = mkOption {
            description = "The Redis connection used for the Celery worker.";
            type = types.str;
            default = "redis+socket:///run/redis-sourcehut-builds.sr.ht/redis.sock?virtual_host=2";
          };
          shell = mkOption {
            description = ''
              Scripts used to launch on SSH connection.
              `/usr/bin/master-shell` on master,
              `/usr/bin/runner-shell` on runner.
              If master and worker are on the same system
              set to `/usr/bin/runner-shell`.
            '';
            type = types.enum [
              "/usr/bin/master-shell"
              "/usr/bin/runner-shell"
            ];
            default = "/usr/bin/master-shell";
          };
        };
        options."builds.sr.ht::worker" = {
          bind-address = mkOption {
            description = ''
              HTTP bind address for serving local build information/monitoring.
            '';
            type = types.str;
            default = "localhost:8080";
          };
          buildlogs = mkOption {
            description = "Path to write build logs.";
            type = types.str;
            default = "/var/log/sourcehut/buildsrht-worker";
          };
          name = mkOption {
            description = ''
              Listening address and listening port
              of the build runner (with HTTP port if not 80).
            '';
            type = types.str;
            default = "localhost:5020";
          };
          timeout = mkOption {
            description = ''
              Max build duration.
              See <https://golang.org/pkg/time/#ParseDuration>.
            '';
            type = types.str;
            default = "3m";
          };
        };

        options."git.sr.ht" = commonServiceSettings "git" // {
          outgoing-domain = mkOption {
            description = "Outgoing domain.";
            type = types.str;
            default = "https://git.localhost.localdomain";
          };
          post-update-script = mkOption {
            description = ''
              A post-update script which is installed in every git repo.
              This setting is propagated to newer and existing repositories.
            '';
            type = types.path;
            default = "${cfg.git.package}/bin/git.sr.ht-update-hook";
            defaultText = "\${pkgs.sourcehut.gitsrht}/bin/git.sr.ht-update-hook";
          };
          repos = mkOption {
            description = ''
              Path to git repositories on disk.
              If changing the default, you must ensure that
              the gitsrht's user as read and write access to it.
            '';
            type = types.str;
            default = "/var/lib/sourcehut/git.sr.ht/repos";
          };
          webhooks = mkOption {
            description = "The Redis connection used for the webhooks worker.";
            type = types.str;
            default = "redis+socket:///run/redis-sourcehut-git.sr.ht/redis.sock?virtual_host=1";
          };
        };
        options."git.sr.ht::api" = {
          internal-ipnet = mkOption {
            description = ''
              Set of IP subnets which are permitted to utilize internal API
              authentication. This should be limited to the subnets
              from which your *.sr.ht services are running.
              See [](#opt-services.sourcehut.listenAddress).
            '';
            type = with types; listOf str;
            default = [
              "127.0.0.0/8"
              "::1/128"
            ];
          };
        };

        options."hub.sr.ht" = commonServiceSettings "hub" // {
        };

        options."lists.sr.ht" = commonServiceSettings "lists" // {
          allow-new-lists = mkEnableOption "creation of new lists";
          notify-from = mkOption {
            description = "Outgoing email for notifications generated by users.";
            type = types.str;
            default = "lists-notify@localhost.localdomain";
          };
          posting-domain = mkOption {
            description = "Posting domain.";
            type = types.str;
            default = "lists.localhost.localdomain";
          };
          redis = mkOption {
            description = "The Redis connection used for the Celery worker.";
            type = types.str;
            default = "redis+socket:///run/redis-sourcehut-lists.sr.ht/redis.sock?virtual_host=2";
          };
          webhooks = mkOption {
            description = "The Redis connection used for the webhooks worker.";
            type = types.str;
            default = "redis+socket:///run/redis-sourcehut-lists.sr.ht/redis.sock?virtual_host=1";
          };
        };
        options."lists.sr.ht::worker" = {
          reject-mimetypes = mkOption {
            description = ''
              Comma-delimited list of Content-Types to reject. Messages with Content-Types
              included in this list are rejected. Multipart messages are always supported,
              and each part is checked against this list.

              Uses fnmatch for wildcard expansion.
            '';
            type = with types; listOf str;
            default = [ "text/html" ];
          };
          reject-url = mkOption {
            description = "Reject URL.";
            type = types.str;
            default = "https://man.sr.ht/lists.sr.ht/etiquette.md";
          };
          sock = mkOption {
            description = ''
              Path for the lmtp daemon's unix socket. Direct incoming mail to this socket.
              Alternatively, specify IP:PORT and an SMTP server will be run instead.
            '';
            type = types.str;
            default = "/tmp/lists.sr.ht-lmtp.sock";
          };
          sock-group = mkOption {
            description = ''
              The lmtp daemon will make the unix socket group-read/write
              for users in this group.
            '';
            type = types.str;
            default = "postfix";
          };
        };

        options."man.sr.ht" = commonServiceSettings "man" // {
        };

        options."meta.sr.ht" =
          removeAttrs (commonServiceSettings "meta") [
            "oauth-client-id"
            "oauth-client-secret"
          ]
          // {
            webhooks = mkOption {
              description = "The Redis connection used for the webhooks worker.";
              type = types.str;
              default = "redis+socket:///run/redis-sourcehut-meta.sr.ht/redis.sock?virtual_host=1";
            };
            welcome-emails = mkEnableOption "sending stock sourcehut welcome emails after signup";
          };
        options."meta.sr.ht::api" = {
          internal-ipnet = mkOption {
            description = ''
              Set of IP subnets which are permitted to utilize internal API
              authentication. This should be limited to the subnets
              from which your *.sr.ht services are running.
              See [](#opt-services.sourcehut.listenAddress).
            '';
            type = with types; listOf str;
            default = [
              "127.0.0.0/8"
              "::1/128"
            ];
          };
        };
        options."meta.sr.ht::aliases" = mkOption {
          description = "Aliases for the client IDs of commonly used OAuth clients.";
          type = with types; attrsOf int;
          default = { };
          example = {
            "git.sr.ht" = 12345;
          };
        };
        options."meta.sr.ht::billing" = {
          enabled = mkEnableOption "the billing system";
          stripe-public-key = mkOptionNullOrStr "Public key for Stripe. Get your keys at <https://dashboard.stripe.com/account/apikeys>";
          stripe-secret-key =
            mkOptionNullOrStr ''
              An absolute file path (which should be outside the Nix-store)
              to a secret key for Stripe. Get your keys at <https://dashboard.stripe.com/account/apikeys>
            ''
            // {
              apply = mapNullable (s: "<" + toString s);
            };
        };
        options."meta.sr.ht::settings" = {
          registration = mkEnableOption "public registration";
          onboarding-redirect = mkOption {
            description = "Where to redirect new users upon registration.";
            type = types.str;
            default = "https://meta.localhost.localdomain";
          };
          user-invites = mkOption {
            description = ''
              How many invites each user is issued upon registration
              (only applicable if open registration is disabled).
            '';
            type = types.ints.unsigned;
            default = 5;
          };
        };

        options."pages.sr.ht" = commonServiceSettings "pages" // {
          gemini-certs = mkOption {
            description = ''
              An absolute file path (which should be outside the Nix-store)
              to Gemini certificates.
            '';
            type = with types; nullOr path;
            default = null;
          };
          max-site-size = mkOption {
            description = "Maximum size of any given site (post-gunzip), in MiB.";
            type = types.int;
            default = 1024;
          };
          user-domain = mkOption {
            description = ''
              Configures the user domain, if enabled.
              All users are given \<username\>.this.domain.
            '';
            type = with types; nullOr str;
            default = null;
          };
        };
        options."pages.sr.ht::api" = {
          internal-ipnet = mkOption {
            description = ''
              Set of IP subnets which are permitted to utilize internal API
              authentication. This should be limited to the subnets
              from which your *.sr.ht services are running.
              See [](#opt-services.sourcehut.listenAddress).
            '';
            type = with types; listOf str;
            default = [
              "127.0.0.0/8"
              "::1/128"
            ];
          };
        };

        options."paste.sr.ht" = commonServiceSettings "paste" // {
        };

        options."todo.sr.ht" = commonServiceSettings "todo" // {
          notify-from = mkOption {
            description = "Outgoing email for notifications generated by users.";
            type = types.str;
            default = "todo-notify@localhost.localdomain";
          };
          webhooks = mkOption {
            description = "The Redis connection used for the webhooks worker.";
            type = types.str;
            default = "redis+socket:///run/redis-sourcehut-todo.sr.ht/redis.sock?virtual_host=1";
          };
        };
        options."todo.sr.ht::mail" = {
          posting-domain = mkOption {
            description = "Posting domain.";
            type = types.str;
            default = "todo.localhost.localdomain";
          };
          sock = mkOption {
            description = ''
              Path for the lmtp daemon's unix socket. Direct incoming mail to this socket.
              Alternatively, specify IP:PORT and an SMTP server will be run instead.
            '';
            type = types.str;
            default = "/tmp/todo.sr.ht-lmtp.sock";
          };
          sock-group = mkOption {
            description = ''
              The lmtp daemon will make the unix socket group-read/write
              for users in this group.
            '';
            type = types.str;
            default = "postfix";
          };
        };
      };
      default = { };
      description = ''
        The configuration for the sourcehut network.
      '';
    };

    builds = {
      enableWorker = mkEnableOption ''
        worker for builds.sr.ht

        ::: {.warning}
        For smaller deployments, job runners can be installed alongside the master server
        but even if you only build your own software, integration with other services
        may cause you to run untrusted builds
        (e.g. automatic testing of patches via listssrht).
        See <https://man.sr.ht/builds.sr.ht/configuration.md#security-model>.
        :::
      '';

      images = mkOption {
        type = with types; attrsOf (attrsOf (attrsOf package));
        default = { };
        example = lib.literalExpression ''
          (let
                      # Pinning unstable to allow usage with flakes and limit rebuilds.
                      pkgs_unstable = builtins.fetchGit {
                          url = "https://github.com/NixOS/nixpkgs";
                          rev = "ff96a0fa5635770390b184ae74debea75c3fd534";
                          ref = "nixos-unstable";
                      };
                      image_from_nixpkgs = (import ("''${pkgs.sourcehut.buildsrht}/lib/images/nixos/image.nix") {
                        pkgs = (import pkgs_unstable {});
                      });
                    in
                    {
                      nixos.unstable.x86_64 = image_from_nixpkgs;
                    }
                  )'';
        description = ''
          Images for builds.sr.ht. Each package should be distro.release.arch and point to a /nix/store/package/root.img.qcow2.
        '';
      };
    };

    git = {
      gitPackage = mkPackageOption pkgs "git" {
        example = "gitFull";
      };
      fcgiwrap.preforkProcess = mkOption {
        description = "Number of fcgiwrap processes to prefork.";
        type = types.int;
        default = 4;
      };
    };

    lists = {
      process = {
        extraArgs = mkOption {
          type = with types; listOf str;
          default = [
            "--loglevel DEBUG"
            "--pool eventlet"
            "--without-heartbeat"
          ];
          description = "Extra arguments passed to the Celery responsible for processing mails.";
        };
        celeryConfig = mkOption {
          type = types.lines;
          default = "";
          description = "Content of the `celeryconfig.py` used by the Celery of `listssrht-process`.";
        };
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      # TODO: make configurable
      environment.systemPackages = [ pkgs.sourcehut.coresrht ];

      services.sourcehut.settings = {
        "git.sr.ht".outgoing-domain = mkDefault "https://git.${domain}";
        "lists.sr.ht".notify-from = mkDefault "lists-notify@${domain}";
        "lists.sr.ht".posting-domain = mkDefault "lists.${domain}";
        "meta.sr.ht::settings".onboarding-redirect = mkDefault "https://meta.${domain}";
        "todo.sr.ht".notify-from = mkDefault "todo-notify@${domain}";
        "todo.sr.ht::mail".posting-domain = mkDefault "todo.${domain}";
      };
    }
    (mkIf cfg.postgresql.enable {
      assertions = [
        {
          assertion = postgresql.enable;
          message = "postgresql must be enabled and configured";
        }
      ];
    })
    (mkIf cfg.postfix.enable {
      assertions = [
        {
          assertion = postfix.enable;
          message = "postfix must be enabled and configured";
        }
      ];
      # Needed for sharing the LMTP sockets with JoinsNamespaceOf=
      systemd.services.postfix.serviceConfig.PrivateTmp = true;
    })
    (mkIf cfg.redis.enable {
      services.redis.vmOverCommit = mkDefault true;
    })
    (mkIf cfg.nginx.enable {
      assertions = [
        {
          assertion = nginx.enable;
          message = "nginx must be enabled and configured";
        }
      ];
      # For proxyPass= in virtual-hosts for Sourcehut services.
      services.nginx.recommendedProxySettings = mkDefault true;
    })
    (mkIf (cfg.builds.enable || cfg.git.enable) {
      services.openssh = {
        # Note that sshd will continue to honor AuthorizedKeysFile.
        authorizedKeysCommand = ''/etc/ssh/sourcehut/subdir/srht-dispatch "%u" "%h" "%t" "%k"'';
        # srht-dispatch will setuid/setgid according to [git.sr.ht::dispatch]
        authorizedKeysCommandUser = "root";
        extraConfig = ''
          PermitUserEnvironment SRHT_*
        '';
        startWhenNeeded = false;
      };
      environment.etc."ssh/sourcehut/config.ini".source =
        settingsFormat.generate "sourcehut-dispatch-config.ini"
          (filterAttrs (k: v: k == "git.sr.ht::dispatch") cfg.settings);
      environment.etc."ssh/sourcehut/subdir/srht-dispatch" = {
        # sshd_config(5): The program must be owned by root, not writable by group or others
        mode = "0755";
        source = pkgs.writeShellScript "srht-dispatch-wrapper" ''
          set -e
          set -x
          cd /etc/ssh/sourcehut/subdir
          ${cfg.git.package}/bin/git.sr.ht-shell "$@"
        '';
      };
      systemd.tmpfiles.settings."10-sourcehut-gitsrht" = mkIf cfg.git.enable (mkMerge [
        (builtins.listToAttrs (
          map
            (name: {
              name = "/var/log/sourcehut/git.sr.ht-${name}";
              value.f = {
                inherit (cfg.git) user group;
                mode = "0644";
              };
            })
            [
              "shell"
              "update-hook"
            ]
        ))
        {
          ${cfg.settings."git.sr.ht".repos}.d = {
            inherit (cfg.git) user group;
            mode = "0644";
          };
        }
      ]);
      systemd.services.sshd = {
        serviceConfig = {
          LogsDirectory = "sourcehut";
          BindReadOnlyPaths =
            # Note that those /usr/bin/* paths are hardcoded in multiple places in *.sr.ht,
            # for instance to get the user from the [git.sr.ht::dispatch] settings.
            # Using this has the side effect of creating empty files in /usr/bin/
            optionals cfg.builds.enable [
              "${pkgs.writeShellScript "buildsrht-keys-wrapper" ''
                set -e
                cd /run/sourcehut/buildsrht/subdir
                exec -a "$0" ${cfg.builds.package}/bin/builds.sr.ht-keys "$@"
              ''}:/usr/bin/buildsrht-keys"
              "${cfg.builds.package}/bin/master-shell:/usr/bin/master-shell"
              "${cfg.builds.package}/bin/runner-shell:/usr/bin/runner-shell"
            ]
            ++ optionals cfg.git.enable [
              "${pkgs.writeShellScript "gitsrht-shell-wrapper" ''
                set -e
                cd /run/sourcehut/git.sr.ht/subdir
                export PATH="${cfg.git.gitPackage}/bin:$PATH"
                export SRHT_CONFIG=/run/sourcehut/git.sr.ht/config.ini
                exec -a "$0" ${cfg.git.package}/bin/git.sr.ht-shell "$@"
              ''}:/usr/bin/git.sr.ht-shell"
              "${pkgs.writeShellScript "gitsrht-update-hook" ''
                set -e
                export SRHT_CONFIG=/run/sourcehut/git.sr.ht/config.ini
                # hooks/post-update calls /usr/bin/gitsrht-update-hook as hooks/stage-3
                # but this wrapper being a bash script, it overrides $0 with /usr/bin/gitsrht-update-hook
                # hence this hack to put hooks/stage-3 back into gitsrht-update-hook's $0
                if test "''${STAGE3:+set}"
                then
                  exec -a hooks/stage-3 ${cfg.git.package}/bin/git.sr.ht-update-hook "$@"
                else
                  export STAGE3=set
                  exec -a "$0" ${cfg.git.package}/bin/git.sr.ht-update-hook "$@"
                fi
              ''}:/usr/bin/git.sr.ht-update-hook"
            ];
        };
      };
    })
  ]);

  imports = [

    (import ./service.nix "builds" {
      inherit configIniOfService;
      pkgname = "buildsrht";
      port = 5002;
      extraServices."build.sr.ht-api" = {
        serviceConfig.Restart = "always";
        serviceConfig.RestartSec = "5s";
        serviceConfig.ExecStart = "${cfg.builds.package}/bin/builds.sr.ht-api -b ${cfg.listenAddress}:${
          toString (cfg.builds.port + 100)
        }";
      };
      # TODO: a celery worker on the master and worker are apparently needed
      extraServices."build.sr.ht-worker" =
        let
          qemuPackage = pkgs.qemu_kvm;
          serviceName = "buildsrht-worker";
          statePath = "/var/lib/sourcehut/${serviceName}";
        in
        mkIf cfg.builds.enableWorker {
          path = [
            pkgs.openssh
            pkgs.docker
          ];
          preStart = ''
            set -x
            if test -z "$(docker images -q qemu:latest 2>/dev/null)" \
            || test "$(cat ${statePath}/docker-image-qemu)" != "${qemuPackage.version}"
            then
              # Create and import qemu:latest image for docker
              ${
                pkgs.dockerTools.streamLayeredImage {
                  name = "qemu";
                  tag = "latest";
                  contents = [ qemuPackage ];
                }
              } | docker load
              # Mark down current package version
              echo '${qemuPackage.version}' >${statePath}/docker-image-qemu
            fi
          '';
          serviceConfig = {
            ExecStart = "${cfg.builds.package}/bin/builds.sr.ht-worker";
            BindPaths = [ cfg.settings."builds.sr.ht::worker".buildlogs ];
            LogsDirectory = [ "sourcehut/${serviceName}" ];
            RuntimeDirectory = [ "sourcehut/${serviceName}/subdir" ];
            StateDirectory = [ "sourcehut/${serviceName}" ];
            TimeoutStartSec = "1800s";
            # buildsrht-worker looks up ../config.ini
            WorkingDirectory = "-" + "/run/sourcehut/${serviceName}/subdir";
          };
        };
      extraConfig =
        let
          image_dirs = flatten (
            mapAttrsToList (
              distro: revs:
              mapAttrsToList (
                rev: archs:
                mapAttrsToList (
                  arch: image:
                  pkgs.runCommand "buildsrht-images" { } ''
                    mkdir -p $out/${distro}/${rev}/${arch}
                    ln -s ${image}/*.qcow2 $out/${distro}/${rev}/${arch}/root.img.qcow2
                  ''
                ) archs
              ) revs
            ) cfg.builds.images
          );
          image_dir_pre = pkgs.symlinkJoin {
            name = "buildsrht-worker-images-pre";
            paths = image_dirs;
          };
          image_dir = pkgs.runCommand "buildsrht-worker-images" { } ''
            mkdir -p $out/images
            cp -Lr ${image_dir_pre}/* $out/images
          '';
        in
        mkMerge [
          {
            users.users.${cfg.builds.user}.shell = pkgs.bash;

            virtualisation.docker.enable = true;

            services.sourcehut.settings = mkMerge [
              {
                # Note that git.sr.ht::dispatch is not a typo,
                # gitsrht-dispatch always use this section
                "git.sr.ht::dispatch"."/usr/bin/builds.sr.ht-keys" =
                  mkDefault "${cfg.builds.user}:${cfg.builds.group}";
              }
              (mkIf cfg.builds.enableWorker {
                "builds.sr.ht::worker".shell = "/usr/bin/runner-shell";
                "builds.sr.ht::worker".images = mkDefault "${image_dir}/images";
                "builds.sr.ht::worker".controlcmd = mkDefault "${image_dir}/images/control";
              })
            ];
          }
          (mkIf cfg.builds.enableWorker {
            users.groups = {
              docker.members = [ cfg.builds.user ];
            };
          })
          (mkIf (cfg.builds.enableWorker && cfg.nginx.enable) {
            # Allow nginx access to buildlogs
            users.users.${nginx.user}.extraGroups = [ cfg.builds.group ];
            systemd.services.nginx = {
              serviceConfig.BindReadOnlyPaths = [ cfg.settings."builds.sr.ht::worker".buildlogs ];
            };
            services.nginx.virtualHosts."logs.${domain}" = mkMerge [
              {
                locations."/logs/".alias = cfg.settings."builds.sr.ht::worker".buildlogs + "/";
              }
              cfg.nginx.virtualHost
            ];
          })
        ];
    })

    (import ./service.nix "git" (
      let
        baseService = {
          path = [ cfg.git.gitPackage ];
          serviceConfig.BindPaths = [
            "${cfg.settings."git.sr.ht".repos}:/var/lib/sourcehut/git.sr.ht/repos"
          ];
        };
      in
      {
        inherit configIniOfService;
        mainService = mkMerge [
          baseService
          {
            serviceConfig.StateDirectory = [
              "sourcehut/git.sr.ht"
              "sourcehut/git.sr.ht/repos"
            ];
            preStart = mkIf (versionOlder config.system.stateVersion "22.05") (mkBefore ''
              # Fix Git hooks of repositories pre-dating https://github.com/NixOS/nixpkgs/pull/133984
              (
              set +f
              shopt -s nullglob
              for h in /var/lib/sourcehut/git.sr.ht/repos/~*/*/hooks/{pre-receive,update,post-update}
              do ln -fnsv /usr/bin/git.sr.ht-update-hook "$h"; done
              )
            '');
          }
        ];
        port = 5001;
        webhooks = true;
        extraTimers."git.sr.ht-periodic" = {
          service = baseService;
          timerConfig.OnCalendar = [ "*:0/20" ];
        };
        extraConfig = mkMerge [
          {
            # https://stackoverflow.com/questions/22314298/git-push-results-in-fatal-protocol-error-bad-line-length-character-this
            # Probably could use gitsrht-shell if output is restricted to just parameters...
            users.users.${cfg.git.user}.shell = pkgs.bash;
            services.sourcehut.settings = {
              "git.sr.ht::dispatch"."/usr/bin/git.sr.ht-shell" = mkDefault "${cfg.git.user}:${cfg.git.group}";
            };
            systemd.services.sshd = baseService;
          }
          (mkIf cfg.nginx.enable {
            services.nginx.virtualHosts."git.${domain}" = {
              locations."/authorize" = {
                proxyPass = "http://${cfg.listenAddress}:${toString cfg.git.port}";
                extraConfig = ''
                  proxy_pass_request_body off;
                  proxy_set_header Content-Length "";
                  proxy_set_header X-Original-URI $request_uri;
                '';
              };
              locations."~ ^/([^/]+)/([^/]+)/(HEAD|info/refs|objects/info/.*|git-upload-pack).*$" = {
                root = "/var/lib/sourcehut/git.sr.ht/repos";
                fastcgiParams = {
                  GIT_HTTP_EXPORT_ALL = "";
                  GIT_PROJECT_ROOT = "$document_root";
                  PATH_INFO = "$uri";
                  SCRIPT_FILENAME = "${cfg.git.gitPackage}/bin/git-http-backend";
                };
                extraConfig = ''
                  auth_request /authorize;
                  fastcgi_read_timeout 500s;
                  fastcgi_pass unix:/run/git.sr.ht-fcgiwrap.sock;
                  gzip off;
                '';
              };
            };
            systemd.sockets."git.sr.ht-fcgiwrap" = {
              before = [ "nginx.service" ];
              wantedBy = [
                "sockets.target"
                "git.sr.ht.service"
              ];
              # This path remains accessible to nginx.service, which has no RootDirectory=
              socketConfig.ListenStream = "/run/git.sr.ht-fcgiwrap.sock";
              socketConfig.SocketUser = nginx.user;
              socketConfig.SocketMode = "600";
            };
          })
        ];
        extraServices."git.sr.ht-api".serviceConfig = {
          Restart = "always";
          RestartSec = "5s";
          ExecStart = "${cfg.git.package}/bin/git.sr.ht-api -b ${cfg.listenAddress}:${toString (cfg.git.port + 100)}";
          BindPaths = [ "${cfg.settings."git.sr.ht".repos}:/var/lib/sourcehut/git.sr.ht/repos" ];
        };
        extraServices."git.sr.ht-fcgiwrap" = mkIf cfg.nginx.enable {
          serviceConfig = {
            # Socket is passed by gitsrht-fcgiwrap.socket
            ExecStart = "${pkgs.fcgiwrap}/bin/fcgiwrap -c ${toString cfg.git.fcgiwrap.preforkProcess}";
            # No need for config.ini
            ExecStartPre = mkForce [ ];
            # FIXME: Fails to start with dynamic user
            # User = null;
            # DynamicUser = true;
            BindReadOnlyPaths = [ "${cfg.settings."git.sr.ht".repos}:/var/lib/sourcehut/git.sr.ht/repos" ];
            IPAddressDeny = "any";
            InaccessiblePaths = [
              "-+/run/postgresql"
              "-+/run/redis-sourcehut"
            ];
            PrivateNetwork = true;
            RestrictAddressFamilies = mkForce [ "none" ];
            SystemCallFilter = mkForce [
              "@system-service"
              "~@aio"
              "~@keyring"
              "~@memlock"
              "~@privileged"
              "~@resources"
              "~@setuid"
              # @timer is needed for alarm()
            ];
          };
        };
      }
    ))

    (import ./service.nix "hub" {
      inherit configIniOfService;
      port = 5014;
      extraServices."hub.sr.ht-api" = {
        serviceConfig.Restart = "always";
        serviceConfig.RestartSec = "5s";
        serviceConfig.ExecStart = "${cfg.hub.package}/bin/hub.sr.ht-api -b ${cfg.listenAddress}:${toString (cfg.hub.port + 100)}";
      };
      extraConfig = {
        services.nginx = mkIf cfg.nginx.enable {
          virtualHosts."hub.${domain}" = mkMerge [
            {
              serverAliases = [ domain ];
            }
            cfg.nginx.virtualHost
          ];
        };
      };
    })

    (import ./service.nix "lists" (
      let
        srvsrht = "listssrht";
      in
      {
        inherit configIniOfService;
        port = 5006;
        webhooks = true;
        extraServices."lists.sr.ht-api" = {
          serviceConfig.Restart = "always";
          serviceConfig.RestartSec = "5s";
          serviceConfig.ExecStart = "${cfg.lists.package}/bin/lists.sr.ht-api -b ${cfg.listenAddress}:${
            toString (cfg.lists.port + 100)
          }";
        };
        extraServices."lists.sr.ht-ingress" = {
          wants = [ "postfix.service" ];
          unitConfig.JoinsNamespaceOf = optional cfg.postfix.enable "postfix.service";
          serviceConfig.ExecStart = "${cfg.lists.package}/bin/lists.sr.ht-ingress";
          # Avoid crashing: os.chown(sock, os.getuid(), sock_gid)
          serviceConfig.PrivateUsers = mkForce false;
        };
        # Dequeue the mails from Redis and dispatch them
        extraServices."lists.sr.ht-process" = {
          serviceConfig = {
            preStart = ''
              cp ${pkgs.writeText "${srvsrht}-webhooks-celeryconfig.py" cfg.lists.process.celeryConfig} \
                 /run/sourcehut/${srvsrht}-webhooks/celeryconfig.py
            '';
            ExecStart =
              "${cfg.python}/bin/celery --app listssrht.process worker --hostname listssrht-process@%%h "
              + concatStringsSep " " cfg.lists.process.extraArgs;
            # Avoid crashing: os.getloadavg()
            ProcSubset = mkForce "all";
          };
        };
        extraConfig = mkIf cfg.postfix.enable {
          users.groups.${postfix.group}.members = [ cfg.lists.user ];
          services.sourcehut.settings."lists.sr.ht::mail".sock-group = postfix.group;
          services.postfix = {
            destination = [ "lists.${domain}" ];
            # FIXME: an accurate recipient list should be queried
            # from the lists.sr.ht PostgreSQL database to avoid backscattering.
            # But usernames are unfortunately not in that database but in meta.sr.ht.
            # Note that two syntaxes are allowed:
            # - ~username/list-name@lists.${domain}
            # - u.username.list-name@lists.${domain}
            localRecipients = [ "@lists.${domain}" ];
            transport = ''
              lists.${domain} lmtp:unix:${cfg.settings."lists.sr.ht::worker".sock}
            '';
          };
        };
      }
    ))

    (import ./service.nix "man" {
      inherit configIniOfService;
      port = 5004;
      extraServices."man.sr.ht-api" = {
        serviceConfig.Restart = "always";
        serviceConfig.RestartSec = "5s";
        serviceConfig.ExecStart = "${cfg.man.package}/bin/man.sr.ht-api -b ${cfg.listenAddress}:${toString (cfg.man.port + 100)}";
      };
    })

    (import ./service.nix "meta" {
      inherit configIniOfService;
      port = 5000;
      webhooks = true;
      extraTimers.metasrht-daily.timerConfig = {
        OnCalendar = [ "daily" ];
        AccuracySec = "1h";
      };
      extraServices."meta.sr.ht-api" = {
        serviceConfig.Restart = "always";
        serviceConfig.RestartSec = "5s";
        preStart =
          "set -x\n"
          + concatStringsSep "\n\n" (
            attrValues (
              mapAttrs (
                k: s:
                let
                  srvMatch = builtins.match "^([a-z]*)\\.sr\\.ht$" k;
                  srv = head srvMatch;
                in
                # Configure client(s) as "preauthorized"
                optionalString (srvMatch != null && cfg.${srv}.enable && ((s.oauth-client-id or null) != null)) ''
                  # Configure ${srv}'s OAuth client as "preauthorized"
                  ${postgresql.package}/bin/psql '${cfg.settings."meta.sr.ht".connection-string}' \
                    -c "UPDATE oauthclient SET preauthorized = true WHERE client_id = '${s.oauth-client-id}'"
                ''
              ) cfg.settings
            )
          );
        serviceConfig.ExecStart = "${cfg.meta.package}/bin/meta.sr.ht-api -b ${cfg.listenAddress}:${toString (cfg.meta.port + 100)}";
      };
      extraConfig = {
        assertions = [
          {
            assertion =
              let
                s = cfg.settings."meta.sr.ht::billing";
              in
              s.enabled == "yes" -> (s.stripe-public-key != null && s.stripe-secret-key != null);
            message = "If meta.sr.ht::billing is enabled, the keys must be defined.";
          }
        ];
        environment.systemPackages = optional cfg.meta.enable (
          pkgs.writeShellScriptBin "meta.sr.ht-manageuser" ''
            set -eux
            if test "$(${pkgs.coreutils}/bin/id -n -u)" != '${cfg.meta.user}'
            then exec sudo -u '${cfg.meta.user}' "$0" "$@"
            else
              # In order to load config.ini
              if cd /run/sourcehut/meta.sr.ht
              then exec ${cfg.meta.package}/bin/meta.sr.ht-manageuser "$@"
              else cat <<EOF
                Please run: sudo systemctl start metasrht
            EOF
                exit 1
              fi
            fi
          ''
        );
      };
    })

    (import ./service.nix "pages" {
      inherit configIniOfService;
      port = 5112;
      mainService =
        let
          package = cfg.pages.package;
          srvsrht = "pagessrht";
          version = package.version;
          stateDir = "/var/lib/sourcehut/${srvsrht}";
          iniKey = "pages.sr.ht";
        in
        {
          preStart = mkBefore ''
            set -x
            # Use the /run/sourcehut/${srvsrht}/config.ini
            # installed by a previous ExecStartPre= in baseService
            cd /run/sourcehut/${srvsrht}

            if test ! -e ${stateDir}/db; then
              ${postgresql.package}/bin/psql '${
                cfg.settings.${iniKey}.connection-string
              }' -f ${cfg.pages.package}/share/sql/schema.sql
              echo ${version} >${stateDir}/db
            fi

            ${optionalString cfg.settings.${iniKey}.migrate-on-upgrade ''
              # Just try all the migrations because they're not linked to the version
              for sql in ${package}/share/sql/migrations/*.sql; do
                ${postgresql.package}/bin/psql '${cfg.settings.${iniKey}.connection-string}' -f "$sql" || true
              done
            ''}

            # Disable webhook
            touch ${stateDir}/webhook
          '';
          serviceConfig = {
            ExecStart = mkForce "${cfg.pages.package}/bin/pages.sr.ht -b ${cfg.listenAddress}:${toString cfg.pages.port}";
          };
        };
    })

    (import ./service.nix "paste" {
      inherit configIniOfService;
      port = 5011;
      extraServices."paste.sr.ht-api" = {
        serviceConfig.Restart = "always";
        serviceConfig.RestartSec = "5s";
        serviceConfig.ExecStart = "${cfg.paste.package}/bin/paste.sr.ht-api -b ${cfg.listenAddress}:${
          toString (cfg.paste.port + 100)
        }";
      };
    })

    (import ./service.nix "todo" {
      inherit configIniOfService;
      port = 5003;
      webhooks = true;
      extraServices."todo.sr.ht-api" = {
        serviceConfig.Restart = "always";
        serviceConfig.RestartSec = "5s";
        serviceConfig.ExecStart = "${cfg.todo.package}/bin/todo.sr.ht-api -b ${cfg.listenAddress}:${toString (cfg.todo.port + 100)}";
      };
      extraServices."todo.sr.ht-lmtp" = {
        wants = [ "postfix.service" ];
        unitConfig.JoinsNamespaceOf = optional cfg.postfix.enable "postfix.service";
        serviceConfig.ExecStart = "${cfg.todo.package}/bin/todo.sr.ht-lmtp";
        # Avoid crashing: os.chown(sock, os.getuid(), sock_gid)
        serviceConfig.PrivateUsers = mkForce false;
      };
      extraConfig = mkIf cfg.postfix.enable {
        users.groups.${postfix.group}.members = [ cfg.todo.user ];
        services.sourcehut.settings."todo.sr.ht::mail".sock-group = postfix.group;
        services.postfix = {
          destination = [ "todo.${domain}" ];
          # FIXME: an accurate recipient list should be queried
          # from the todo.sr.ht PostgreSQL database to avoid backscattering.
          # But usernames are unfortunately not in that database but in meta.sr.ht.
          # Note that two syntaxes are allowed:
          # - ~username/tracker-name@todo.${domain}
          # - u.username.tracker-name@todo.${domain}
          localRecipients = [ "@todo.${domain}" ];
          transport = ''
            todo.${domain} lmtp:unix:${cfg.settings."todo.sr.ht::mail".sock}
          '';
        };
      };
    })

    (mkRenamedOptionModule
      [ "services" "sourcehut" "originBase" ]
      [ "services" "sourcehut" "settings" "sr.ht" "global-domain" ]
    )
    (mkRenamedOptionModule
      [ "services" "sourcehut" "address" ]
      [ "services" "sourcehut" "listenAddress" ]
    )

    (mkRemovedOptionModule [ "services" "sourcehut" "dispatch" ] ''
      dispatch is deprecated. See https://sourcehut.org/blog/2022-08-01-dispatch-deprecation-plans/
      for more information.
    '')

    (mkRemovedOptionModule [ "services" "sourcehut" "services" ] ''
      This option was removed in favor of individual <service>.enable flags.
    '')

    (mkRemovedOptionModule [ "services" "sourcehut" "hg" ] ''
      hg.sr.ht has been removed as the upstream repository is abandoned.
    '')
  ];

  meta.doc = ./default.md;
  meta.maintainers = [ ];
}

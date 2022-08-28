{ config, pkgs, lib, ... }:
with lib;
let
  inherit (config.services) nginx postfix postgresql redis;
  inherit (config.users) users groups;
  cfg = config.services.sourcehut;
  domain = cfg.settings."sr.ht".global-domain;
  settingsFormat = pkgs.formats.ini {
    listToValue = concatMapStringsSep "," (generators.mkValueStringDefault {});
    mkKeyValue = k: v:
      if v == null then ""
      else generators.mkKeyValueDefault {
        mkValueString = v:
          if v == true then "yes"
          else if v == false then "no"
          else generators.mkValueStringDefault {} v;
      } "=" k v;
  };
  configIniOfService = srv: settingsFormat.generate "sourcehut-${srv}-config.ini"
    # Each service needs access to only a subset of sections (and secrets).
    (filterAttrs (k: v: v != null)
    (mapAttrs (section: v:
      let srvMatch = builtins.match "^([a-z]*)\\.sr\\.ht(::.*)?$" section; in
      if srvMatch == null # Include sections shared by all services
      || head srvMatch == srv # Include sections for the service being configured
      then v
      # Enable Web links and integrations between services.
      else if tail srvMatch == [ null ] && elem (head srvMatch) cfg.services
      then {
        inherit (v) origin;
        # mansrht crashes without it
        oauth-client-id = v.oauth-client-id or null;
      }
      # Drop sub-sections of other services
      else null)
    (recursiveUpdate cfg.settings {
      # Those paths are mounted using BindPaths= or BindReadOnlyPaths=
      # for services needing access to them.
      "builds.sr.ht::worker".buildlogs = "/var/log/sourcehut/buildsrht-worker";
      "git.sr.ht".post-update-script = "/usr/bin/gitsrht-update-hook";
      "git.sr.ht".repos = "/var/lib/sourcehut/gitsrht/repos";
      "hg.sr.ht".changegroup-script = "/usr/bin/hgsrht-hook-changegroup";
      "hg.sr.ht".repos = "/var/lib/sourcehut/hgsrht/repos";
      # Making this a per service option despite being in a global section,
      # so that it uses the redis-server used by the service.
      "sr.ht".redis-host = cfg.${srv}.redis.host;
    })));
  commonServiceSettings = srv: {
    origin = mkOption {
      description = lib.mdDoc "URL ${srv}.sr.ht is being served at (protocol://domain)";
      type = types.str;
      default = "https://${srv}.${domain}";
      defaultText = "https://${srv}.example.com";
    };
    debug-host = mkOption {
      description = lib.mdDoc "Address to bind the debug server to.";
      type = with types; nullOr str;
      default = null;
    };
    debug-port = mkOption {
      description = lib.mdDoc "Port to bind the debug server to.";
      type = with types; nullOr str;
      default = null;
    };
    connection-string = mkOption {
      description = lib.mdDoc "SQLAlchemy connection string for the database.";
      type = types.str;
      default = "postgresql:///localhost?user=${srv}srht&host=/run/postgresql";
    };
    migrate-on-upgrade = mkEnableOption (lib.mdDoc "automatic migrations on package upgrade") // { default = true; };
    oauth-client-id = mkOption {
      description = lib.mdDoc "${srv}.sr.ht's OAuth client id for meta.sr.ht.";
      type = types.str;
    };
    oauth-client-secret = mkOption {
      description = lib.mdDoc "${srv}.sr.ht's OAuth client secret for meta.sr.ht.";
      type = types.path;
      apply = s: "<" + toString s;
    };
  };

  # Specialized python containing all the modules
  python = pkgs.sourcehut.python.withPackages (ps: with ps; [
    gunicorn
    eventlet
    # For monitoring Celery: sudo -u listssrht celery --app listssrht.process -b redis+socket:///run/redis-sourcehut/redis.sock?virtual_host=1 flower
    flower
    # Sourcehut services
    srht
    buildsrht
    dispatchsrht
    gitsrht
    hgsrht
    hubsrht
    listssrht
    mansrht
    metasrht
    # Not a python package
    #pagessrht
    pastesrht
    todosrht
  ]);
  mkOptionNullOrStr = description: mkOption {
    inherit description;
    type = with types; nullOr str;
    default = null;
  };
in
{
  options.services.sourcehut = {
    enable = mkEnableOption (lib.mdDoc ''
      sourcehut - git hosting, continuous integration, mailing list, ticket tracking,
      task dispatching, wiki and account management services
    '');

    services = mkOption {
      type = with types; listOf (enum
        [ "builds" "dispatch" "git" "hg" "hub" "lists" "man" "meta" "pages" "paste" "todo" ]);
      defaultText = "locally enabled services";
      description = lib.mdDoc ''
        Services that may be displayed as links in the title bar of the Web interface.
      '';
    };

    listenAddress = mkOption {
      type = types.str;
      default = "localhost";
      description = lib.mdDoc "Address to bind to.";
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
      enable = mkEnableOption (lib.mdDoc ''local minio integration'');
    };

    nginx = {
      enable = mkEnableOption (lib.mdDoc ''local nginx integration'');
      virtualHost = mkOption {
        type = types.attrs;
        default = {};
        description = lib.mdDoc "Virtual-host configuration merged with all Sourcehut's virtual-hosts.";
      };
    };

    postfix = {
      enable = mkEnableOption (lib.mdDoc ''local postfix integration'');
    };

    postgresql = {
      enable = mkEnableOption (lib.mdDoc ''local postgresql integration'');
    };

    redis = {
      enable = mkEnableOption (lib.mdDoc ''local redis integration in a dedicated redis-server'');
    };

    settings = mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options."sr.ht" = {
          global-domain = mkOption {
            description = lib.mdDoc "Global domain name.";
            type = types.str;
            example = "example.com";
          };
          environment = mkOption {
            description = lib.mdDoc "Values other than \"production\" adds a banner to each page.";
            type = types.enum [ "development" "production" ];
            default = "development";
          };
          network-key = mkOption {
            description = lib.mdDoc ''
              An absolute file path (which should be outside the Nix-store)
              to a secret key to encrypt internal messages with. Use `srht-keygen network` to
              generate this key. It must be consistent between all services and nodes.
            '';
            type = types.path;
            apply = s: "<" + toString s;
          };
          owner-email = mkOption {
            description = lib.mdDoc "Owner's email.";
            type = types.str;
            default = "contact@example.com";
          };
          owner-name = mkOption {
            description = lib.mdDoc "Owner's name.";
            type = types.str;
            default = "John Doe";
          };
          site-blurb = mkOption {
            description = lib.mdDoc "Blurb for your site.";
            type = types.str;
            default = "the hacker's forge";
          };
          site-info = mkOption {
            description = lib.mdDoc "The top-level info page for your site.";
            type = types.str;
            default = "https://sourcehut.org";
          };
          service-key = mkOption {
            description = lib.mdDoc ''
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
            description = lib.mdDoc "The name of your network of sr.ht-based sites.";
            type = types.str;
            default = "sourcehut";
          };
          source-url = mkOption {
            description = lib.mdDoc "The source code for your fork of sr.ht.";
            type = types.str;
            default = "https://git.sr.ht/~sircmpwn/srht";
          };
        };
        options.mail = {
          smtp-host = mkOptionNullOrStr "Outgoing SMTP host.";
          smtp-port = mkOption {
            description = lib.mdDoc "Outgoing SMTP port.";
            type = with types; nullOr port;
            default = null;
          };
          smtp-user = mkOptionNullOrStr "Outgoing SMTP user.";
          smtp-password = mkOptionNullOrStr "Outgoing SMTP password.";
          smtp-from = mkOption {
            type = types.str;
            description = lib.mdDoc "Outgoing SMTP FROM.";
          };
          error-to = mkOptionNullOrStr "Address receiving application exceptions";
          error-from = mkOptionNullOrStr "Address sending application exceptions";
          pgp-privkey = mkOption {
            type = types.str;
            description = lib.mdDoc ''
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
            description = lib.mdDoc "OpenPGP public key.";
          };
          pgp-key-id = mkOption {
            type = types.str;
            description = lib.mdDoc "OpenPGP key identifier.";
          };
        };
        options.objects = {
          s3-upstream = mkOption {
            description = lib.mdDoc "Configure the S3-compatible object storage service.";
            type = with types; nullOr str;
            default = null;
          };
          s3-access-key = mkOption {
            description = lib.mdDoc "Access key to the S3-compatible object storage service";
            type = with types; nullOr str;
            default = null;
          };
          s3-secret-key = mkOption {
            description = lib.mdDoc ''
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
            description = lib.mdDoc ''
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

        options."dispatch.sr.ht" = commonServiceSettings "dispatch" // {
        };
        options."dispatch.sr.ht::github" = {
          oauth-client-id = mkOptionNullOrStr "OAuth client id.";
          oauth-client-secret = mkOptionNullOrStr "OAuth client secret.";
        };
        options."dispatch.sr.ht::gitlab" = {
          enabled = mkEnableOption (lib.mdDoc "GitLab integration");
          canonical-upstream = mkOption {
            type = types.str;
            description = lib.mdDoc "Canonical upstream.";
            default = "gitlab.com";
          };
          repo-cache = mkOption {
            type = types.str;
            description = lib.mdDoc "Repository cache directory.";
            default = "./repo-cache";
          };
          "gitlab.com" = mkOption {
            type = with types; nullOr str;
            description = lib.mdDoc "GitLab id and secret.";
            default = null;
            example = "GitLab:application id:secret";
          };
        };

        options."builds.sr.ht" = commonServiceSettings "builds" // {
          allow-free = mkEnableOption (lib.mdDoc "nonpaying users to submit builds");
          redis = mkOption {
            description = lib.mdDoc "The Redis connection used for the Celery worker.";
            type = types.str;
            default = "redis+socket:///run/redis-sourcehut-buildsrht/redis.sock?virtual_host=2";
          };
          shell = mkOption {
            description = lib.mdDoc ''
              Scripts used to launch on SSH connection.
              `/usr/bin/master-shell` on master,
              `/usr/bin/runner-shell` on runner.
              If master and worker are on the same system
              set to `/usr/bin/runner-shell`.
            '';
            type = types.enum ["/usr/bin/master-shell" "/usr/bin/runner-shell"];
            default = "/usr/bin/master-shell";
          };
        };
        options."builds.sr.ht::worker" = {
          bind-address = mkOption {
            description = lib.mdDoc ''
              HTTP bind address for serving local build information/monitoring.
            '';
            type = types.str;
            default = "localhost:8080";
          };
          buildlogs = mkOption {
            description = lib.mdDoc "Path to write build logs.";
            type = types.str;
            default = "/var/log/sourcehut/buildsrht-worker";
          };
          name = mkOption {
            description = lib.mdDoc ''
              Listening address and listening port
              of the build runner (with HTTP port if not 80).
            '';
            type = types.str;
            default = "localhost:5020";
          };
          timeout = mkOption {
            description = lib.mdDoc ''
              Max build duration.
              See <https://golang.org/pkg/time/#ParseDuration>.
            '';
            type = types.str;
            default = "3m";
          };
        };

        options."git.sr.ht" = commonServiceSettings "git" // {
          outgoing-domain = mkOption {
            description = lib.mdDoc "Outgoing domain.";
            type = types.str;
            default = "https://git.localhost.localdomain";
          };
          post-update-script = mkOption {
            description = lib.mdDoc ''
              A post-update script which is installed in every git repo.
              This setting is propagated to newer and existing repositories.
            '';
            type = types.path;
            default = "${pkgs.sourcehut.gitsrht}/bin/gitsrht-update-hook";
            defaultText = "\${pkgs.sourcehut.gitsrht}/bin/gitsrht-update-hook";
          };
          repos = mkOption {
            description = lib.mdDoc ''
              Path to git repositories on disk.
              If changing the default, you must ensure that
              the gitsrht's user as read and write access to it.
            '';
            type = types.str;
            default = "/var/lib/sourcehut/gitsrht/repos";
          };
          webhooks = mkOption {
            description = lib.mdDoc "The Redis connection used for the webhooks worker.";
            type = types.str;
            default = "redis+socket:///run/redis-sourcehut-gitsrht/redis.sock?virtual_host=1";
          };
        };
        options."git.sr.ht::api" = {
          internal-ipnet = mkOption {
            description = lib.mdDoc ''
              Set of IP subnets which are permitted to utilize internal API
              authentication. This should be limited to the subnets
              from which your *.sr.ht services are running.
              See [](#opt-services.sourcehut.listenAddress).
            '';
            type = with types; listOf str;
            default = [ "127.0.0.0/8" "::1/128" ];
          };
        };

        options."hg.sr.ht" = commonServiceSettings "hg" // {
          changegroup-script = mkOption {
            description = lib.mdDoc ''
              A changegroup script which is installed in every mercurial repo.
              This setting is propagated to newer and existing repositories.
            '';
            type = types.str;
            default = "${cfg.python}/bin/hgsrht-hook-changegroup";
            defaultText = "\${cfg.python}/bin/hgsrht-hook-changegroup";
          };
          repos = mkOption {
            description = lib.mdDoc ''
              Path to mercurial repositories on disk.
              If changing the default, you must ensure that
              the hgsrht's user as read and write access to it.
            '';
            type = types.str;
            default = "/var/lib/sourcehut/hgsrht/repos";
          };
          srhtext = mkOptionNullOrStr ''
            Path to the srht mercurial extension
            (defaults to where the hgsrht code is)
          '';
          clone_bundle_threshold = mkOption {
            description = lib.mdDoc ".hg/store size (in MB) past which the nightly job generates clone bundles.";
            type = types.ints.unsigned;
            default = 50;
          };
          hg_ssh = mkOption {
            description = lib.mdDoc "Path to hg-ssh (if not in $PATH).";
            type = types.str;
            default = "${pkgs.mercurial}/bin/hg-ssh";
            defaultText = "\${pkgs.mercurial}/bin/hg-ssh";
          };
          webhooks = mkOption {
            description = lib.mdDoc "The Redis connection used for the webhooks worker.";
            type = types.str;
            default = "redis+socket:///run/redis-sourcehut-hgsrht/redis.sock?virtual_host=1";
          };
        };

        options."hub.sr.ht" = commonServiceSettings "hub" // {
        };

        options."lists.sr.ht" = commonServiceSettings "lists" // {
          allow-new-lists = mkEnableOption (lib.mdDoc "Allow creation of new lists.");
          notify-from = mkOption {
            description = lib.mdDoc "Outgoing email for notifications generated by users.";
            type = types.str;
            default = "lists-notify@localhost.localdomain";
          };
          posting-domain = mkOption {
            description = lib.mdDoc "Posting domain.";
            type = types.str;
            default = "lists.localhost.localdomain";
          };
          redis = mkOption {
            description = lib.mdDoc "The Redis connection used for the Celery worker.";
            type = types.str;
            default = "redis+socket:///run/redis-sourcehut-listssrht/redis.sock?virtual_host=2";
          };
          webhooks = mkOption {
            description = lib.mdDoc "The Redis connection used for the webhooks worker.";
            type = types.str;
            default = "redis+socket:///run/redis-sourcehut-listssrht/redis.sock?virtual_host=1";
          };
        };
        options."lists.sr.ht::worker" = {
          reject-mimetypes = mkOption {
            description = lib.mdDoc ''
              Comma-delimited list of Content-Types to reject. Messages with Content-Types
              included in this list are rejected. Multipart messages are always supported,
              and each part is checked against this list.

              Uses fnmatch for wildcard expansion.
            '';
            type = with types; listOf str;
            default = ["text/html"];
          };
          reject-url = mkOption {
            description = lib.mdDoc "Reject URL.";
            type = types.str;
            default = "https://man.sr.ht/lists.sr.ht/etiquette.md";
          };
          sock = mkOption {
            description = lib.mdDoc ''
              Path for the lmtp daemon's unix socket. Direct incoming mail to this socket.
              Alternatively, specify IP:PORT and an SMTP server will be run instead.
            '';
            type = types.str;
            default = "/tmp/lists.sr.ht-lmtp.sock";
          };
          sock-group = mkOption {
            description = lib.mdDoc ''
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
          removeAttrs (commonServiceSettings "meta")
            ["oauth-client-id" "oauth-client-secret"] // {
          api-origin = mkOption {
            description = lib.mdDoc "Origin URL for API, 100 more than web.";
            type = types.str;
            default = "http://${cfg.listenAddress}:${toString (cfg.meta.port + 100)}";
            defaultText = ''http://<xref linkend="opt-services.sourcehut.listenAddress"/>:''${toString (<xref linkend="opt-services.sourcehut.meta.port"/> + 100)}'';
          };
          webhooks = mkOption {
            description = lib.mdDoc "The Redis connection used for the webhooks worker.";
            type = types.str;
            default = "redis+socket:///run/redis-sourcehut-metasrht/redis.sock?virtual_host=1";
          };
          welcome-emails = mkEnableOption (lib.mdDoc "sending stock sourcehut welcome emails after signup");
        };
        options."meta.sr.ht::api" = {
          internal-ipnet = mkOption {
            description = lib.mdDoc ''
              Set of IP subnets which are permitted to utilize internal API
              authentication. This should be limited to the subnets
              from which your *.sr.ht services are running.
              See [](#opt-services.sourcehut.listenAddress).
            '';
            type = with types; listOf str;
            default = [ "127.0.0.0/8" "::1/128" ];
          };
        };
        options."meta.sr.ht::aliases" = mkOption {
          description = lib.mdDoc "Aliases for the client IDs of commonly used OAuth clients.";
          type = with types; attrsOf int;
          default = {};
          example = { "git.sr.ht" = 12345; };
        };
        options."meta.sr.ht::billing" = {
          enabled = mkEnableOption (lib.mdDoc "the billing system");
          stripe-public-key = mkOptionNullOrStr "Public key for Stripe. Get your keys at https://dashboard.stripe.com/account/apikeys";
          stripe-secret-key = mkOptionNullOrStr ''
            An absolute file path (which should be outside the Nix-store)
            to a secret key for Stripe. Get your keys at https://dashboard.stripe.com/account/apikeys
          '' // {
            apply = mapNullable (s: "<" + toString s);
          };
        };
        options."meta.sr.ht::settings" = {
          registration = mkEnableOption (lib.mdDoc "public registration");
          onboarding-redirect = mkOption {
            description = lib.mdDoc "Where to redirect new users upon registration.";
            type = types.str;
            default = "https://meta.localhost.localdomain";
          };
          user-invites = mkOption {
            description = lib.mdDoc ''
              How many invites each user is issued upon registration
              (only applicable if open registration is disabled).
            '';
            type = types.ints.unsigned;
            default = 5;
          };
        };

        options."pages.sr.ht" = commonServiceSettings "pages" // {
          gemini-certs = mkOption {
            description = lib.mdDoc ''
              An absolute file path (which should be outside the Nix-store)
              to Gemini certificates.
            '';
            type = with types; nullOr path;
            default = null;
          };
          max-site-size = mkOption {
            description = lib.mdDoc "Maximum size of any given site (post-gunzip), in MiB.";
            type = types.int;
            default = 1024;
          };
          user-domain = mkOption {
            description = lib.mdDoc ''
              Configures the user domain, if enabled.
              All users are given \<username\>.this.domain.
            '';
            type = with types; nullOr str;
            default = null;
          };
        };
        options."pages.sr.ht::api" = {
          internal-ipnet = mkOption {
            description = lib.mdDoc ''
              Set of IP subnets which are permitted to utilize internal API
              authentication. This should be limited to the subnets
              from which your *.sr.ht services are running.
              See [](#opt-services.sourcehut.listenAddress).
            '';
            type = with types; listOf str;
            default = [ "127.0.0.0/8" "::1/128" ];
          };
        };

        options."paste.sr.ht" = commonServiceSettings "paste" // {
        };

        options."todo.sr.ht" = commonServiceSettings "todo" // {
          notify-from = mkOption {
            description = lib.mdDoc "Outgoing email for notifications generated by users.";
            type = types.str;
            default = "todo-notify@localhost.localdomain";
          };
          webhooks = mkOption {
            description = lib.mdDoc "The Redis connection used for the webhooks worker.";
            type = types.str;
            default = "redis+socket:///run/redis-sourcehut-todosrht/redis.sock?virtual_host=1";
          };
        };
        options."todo.sr.ht::mail" = {
          posting-domain = mkOption {
            description = lib.mdDoc "Posting domain.";
            type = types.str;
            default = "todo.localhost.localdomain";
          };
          sock = mkOption {
            description = lib.mdDoc ''
              Path for the lmtp daemon's unix socket. Direct incoming mail to this socket.
              Alternatively, specify IP:PORT and an SMTP server will be run instead.
            '';
            type = types.str;
            default = "/tmp/todo.sr.ht-lmtp.sock";
          };
          sock-group = mkOption {
            description = lib.mdDoc ''
              The lmtp daemon will make the unix socket group-read/write
              for users in this group.
            '';
            type = types.str;
            default = "postfix";
          };
        };
      };
      default = { };
      description = lib.mdDoc ''
        The configuration for the sourcehut network.
      '';
    };

    builds = {
      enableWorker = mkEnableOption ''
        worker for builds.sr.ht

        <warning><para>
        For smaller deployments, job runners can be installed alongside the master server
        but even if you only build your own software, integration with other services
        may cause you to run untrusted builds
        (e.g. automatic testing of patches via listssrht).
        See <link xlink:href="https://man.sr.ht/builds.sr.ht/configuration.md#security-model"/>.
        </para></warning>
      '';

      images = mkOption {
        type = with types; attrsOf (attrsOf (attrsOf package));
        default = { };
        example = lib.literalExpression ''(let
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
        description = lib.mdDoc ''
          Images for builds.sr.ht. Each package should be distro.release.arch and point to a /nix/store/package/root.img.qcow2.
        '';
      };
    };

    git = {
      package = mkOption {
        type = types.package;
        default = pkgs.git;
        defaultText = literalExpression "pkgs.git";
        example = literalExpression "pkgs.gitFull";
        description = lib.mdDoc ''
          Git package for git.sr.ht. This can help silence collisions.
        '';
      };
      fcgiwrap.preforkProcess = mkOption {
        description = lib.mdDoc "Number of fcgiwrap processes to prefork.";
        type = types.int;
        default = 4;
      };
    };

    hg = {
      package = mkOption {
        type = types.package;
        default = pkgs.mercurial;
        defaultText = literalExpression "pkgs.mercurial";
        description = lib.mdDoc ''
          Mercurial package for hg.sr.ht. This can help silence collisions.
        '';
      };
      cloneBundles = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Generate clonebundles (which require more disk space but dramatically speed up cloning large repositories).
        '';
      };
    };

    lists = {
      process = {
        extraArgs = mkOption {
          type = with types; listOf str;
          default = [ "--loglevel DEBUG" "--pool eventlet" "--without-heartbeat" ];
          description = lib.mdDoc "Extra arguments passed to the Celery responsible for processing mails.";
        };
        celeryConfig = mkOption {
          type = types.lines;
          default = "";
          description = lib.mdDoc "Content of the `celeryconfig.py` used by the Celery of `listssrht-process`.";
        };
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
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
        { assertion = postgresql.enable;
          message = "postgresql must be enabled and configured";
        }
      ];
    })
    (mkIf cfg.postfix.enable {
      assertions = [
        { assertion = postfix.enable;
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
        { assertion = nginx.enable;
          message = "nginx must be enabled and configured";
        }
      ];
      # For proxyPass= in virtual-hosts for Sourcehut services.
      services.nginx.recommendedProxySettings = mkDefault true;
    })
    (mkIf (cfg.builds.enable || cfg.git.enable || cfg.hg.enable) {
      services.openssh = {
        # Note that sshd will continue to honor AuthorizedKeysFile.
        # Note that you may want automatically rotate
        # or link to /dev/null the following log files:
        # - /var/log/gitsrht-dispatch
        # - /var/log/{build,git,hg}srht-keys
        # - /var/log/{git,hg}srht-shell
        # - /var/log/gitsrht-update-hook
        authorizedKeysCommand = ''/etc/ssh/sourcehut/subdir/srht-dispatch "%u" "%h" "%t" "%k"'';
        # srht-dispatch will setuid/setgid according to [git.sr.ht::dispatch]
        authorizedKeysCommandUser = "root";
        extraConfig = ''
          PermitUserEnvironment SRHT_*
        '';
      };
      environment.etc."ssh/sourcehut/config.ini".source =
        settingsFormat.generate "sourcehut-dispatch-config.ini"
          (filterAttrs (k: v: k == "git.sr.ht::dispatch")
          cfg.settings);
      environment.etc."ssh/sourcehut/subdir/srht-dispatch" = {
        # sshd_config(5): The program must be owned by root, not writable by group or others
        mode = "0755";
        source = pkgs.writeShellScript "srht-dispatch" ''
          set -e
          cd /etc/ssh/sourcehut/subdir
          ${cfg.python}/bin/gitsrht-dispatch "$@"
        '';
      };
      systemd.services.sshd = {
        #path = optional cfg.git.enable [ cfg.git.package ];
        serviceConfig = {
          BindReadOnlyPaths =
            # Note that those /usr/bin/* paths are hardcoded in multiple places in *.sr.ht,
            # for instance to get the user from the [git.sr.ht::dispatch] settings.
            # *srht-keys needs to:
            # - access a redis-server in [sr.ht] redis-host,
            # - access the PostgreSQL server in [*.sr.ht] connection-string,
            # - query metasrht-api (through the HTTP API).
            # Using this has the side effect of creating empty files in /usr/bin/
            optionals cfg.builds.enable [
              "${pkgs.writeShellScript "buildsrht-keys-wrapper" ''
                set -e
                cd /run/sourcehut/buildsrht/subdir
                set -x
                exec -a "$0" ${pkgs.sourcehut.buildsrht}/bin/buildsrht-keys "$@"
              ''}:/usr/bin/buildsrht-keys"
              "${pkgs.sourcehut.buildsrht}/bin/master-shell:/usr/bin/master-shell"
              "${pkgs.sourcehut.buildsrht}/bin/runner-shell:/usr/bin/runner-shell"
            ] ++
            optionals cfg.git.enable [
              # /path/to/gitsrht-keys calls /path/to/gitsrht-shell,
              # or [git.sr.ht] shell= if set.
              "${pkgs.writeShellScript "gitsrht-keys-wrapper" ''
                set -e
                cd /run/sourcehut/gitsrht/subdir
                set -x
                exec -a "$0" ${pkgs.sourcehut.gitsrht}/bin/gitsrht-keys "$@"
              ''}:/usr/bin/gitsrht-keys"
              "${pkgs.writeShellScript "gitsrht-shell-wrapper" ''
                set -e
                cd /run/sourcehut/gitsrht/subdir
                set -x
                exec -a "$0" ${pkgs.sourcehut.gitsrht}/bin/gitsrht-shell "$@"
              ''}:/usr/bin/gitsrht-shell"
              "${pkgs.writeShellScript "gitsrht-update-hook" ''
                set -e
                test -e "''${PWD%/*}"/config.ini ||
                # Git hooks are run relative to their repository's directory,
                # but gitsrht-update-hook looks up ../config.ini
                ln -s /run/sourcehut/gitsrht/config.ini "''${PWD%/*}"/config.ini
                # hooks/post-update calls /usr/bin/gitsrht-update-hook as hooks/stage-3
                # but this wrapper being a bash script, it overrides $0 with /usr/bin/gitsrht-update-hook
                # hence this hack to put hooks/stage-3 back into gitsrht-update-hook's $0
                if test "''${STAGE3:+set}"
                then
                  set -x
                  exec -a hooks/stage-3 ${pkgs.sourcehut.gitsrht}/bin/gitsrht-update-hook "$@"
                else
                  export STAGE3=set
                  set -x
                  exec -a "$0" ${pkgs.sourcehut.gitsrht}/bin/gitsrht-update-hook "$@"
                fi
              ''}:/usr/bin/gitsrht-update-hook"
            ] ++
            optionals cfg.hg.enable [
              # /path/to/hgsrht-keys calls /path/to/hgsrht-shell,
              # or [hg.sr.ht] shell= if set.
              "${pkgs.writeShellScript "hgsrht-keys-wrapper" ''
                set -e
                cd /run/sourcehut/hgsrht/subdir
                set -x
                exec -a "$0" ${pkgs.sourcehut.hgsrht}/bin/hgsrht-keys "$@"
              ''}:/usr/bin/hgsrht-keys"
              "${pkgs.writeShellScript "hgsrht-shell-wrapper" ''
                set -e
                cd /run/sourcehut/hgsrht/subdir
                set -x
                exec -a "$0" ${pkgs.sourcehut.hgsrht}/bin/hgsrht-shell "$@"
              ''}:/usr/bin/hgsrht-shell"
              # Mercurial's changegroup hooks are run relative to their repository's directory,
              # but hgsrht-hook-changegroup looks up ./config.ini
              "${pkgs.writeShellScript "hgsrht-hook-changegroup" ''
                set -e
                test -e "''$PWD"/config.ini ||
                ln -s /run/sourcehut/hgsrht/config.ini "''$PWD"/config.ini
                set -x
                exec -a "$0" ${cfg.python}/bin/hgsrht-hook-changegroup "$@"
              ''}:/usr/bin/hgsrht-hook-changegroup"
            ];
        };
      };
    })
  ]);

  imports = [

    (import ./service.nix "builds" {
      inherit configIniOfService;
      srvsrht = "buildsrht";
      port = 5002;
      extraServices.buildsrht-api = {
        serviceConfig.Restart = "always";
        serviceConfig.RestartSec = "5s";
        serviceConfig.ExecStart = "${pkgs.sourcehut.buildsrht}/bin/buildsrht-api -b ${cfg.listenAddress}:${toString (cfg.builds.port + 100)}";
      };
      # TODO: a celery worker on the master and worker are apparently needed
      extraServices.buildsrht-worker = let
        qemuPackage = pkgs.qemu_kvm;
        serviceName = "buildsrht-worker";
        statePath = "/var/lib/sourcehut/${serviceName}";
        in mkIf cfg.builds.enableWorker {
        path = [ pkgs.openssh pkgs.docker ];
        preStart = ''
          set -x
          if test -z "$(docker images -q qemu:latest 2>/dev/null)" \
          || test "$(cat ${statePath}/docker-image-qemu)" != "${qemuPackage.version}"
          then
            # Create and import qemu:latest image for docker
            ${pkgs.dockerTools.streamLayeredImage {
              name = "qemu";
              tag = "latest";
              contents = [ qemuPackage ];
            }} | docker load
            # Mark down current package version
            echo '${qemuPackage.version}' >${statePath}/docker-image-qemu
          fi
        '';
        serviceConfig = {
          ExecStart = "${pkgs.sourcehut.buildsrht}/bin/buildsrht-worker";
          BindPaths = [ cfg.settings."builds.sr.ht::worker".buildlogs ];
          LogsDirectory = [ "sourcehut/${serviceName}" ];
          RuntimeDirectory = [ "sourcehut/${serviceName}/subdir" ];
          StateDirectory = [ "sourcehut/${serviceName}" ];
          TimeoutStartSec = "1800s";
          # buildsrht-worker looks up ../config.ini
          WorkingDirectory = "-"+"/run/sourcehut/${serviceName}/subdir";
        };
      };
      extraConfig = let
        image_dirs = flatten (
          mapAttrsToList (distro: revs:
            mapAttrsToList (rev: archs:
              mapAttrsToList (arch: image:
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
            # FIXME: not working, apparently because ubuntu/latest is a broken link
            # ++ [ "${pkgs.sourcehut.buildsrht}/lib/images" ];
        };
        image_dir = pkgs.runCommand "buildsrht-worker-images" { } ''
          mkdir -p $out/images
          cp -Lr ${image_dir_pre}/* $out/images
        '';
        in mkMerge [
        {
          users.users.${cfg.builds.user}.shell = pkgs.bash;

          virtualisation.docker.enable = true;

          services.sourcehut.settings = mkMerge [
            { # Note that git.sr.ht::dispatch is not a typo,
              # gitsrht-dispatch always use this section
              "git.sr.ht::dispatch"."/usr/bin/buildsrht-keys" =
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
          services.nginx.virtualHosts."logs.${domain}" = mkMerge [ {
            /* FIXME: is a listen needed?
            listen = with builtins;
              # FIXME: not compatible with IPv6
              let address = split ":" cfg.settings."builds.sr.ht::worker".name; in
              [{ addr = elemAt address 0; port = lib.toInt (elemAt address 2); }];
            */
            locations."/logs/".alias = cfg.settings."builds.sr.ht::worker".buildlogs + "/";
          } cfg.nginx.virtualHost ];
        })
      ];
    })

    (import ./service.nix "dispatch" {
      inherit configIniOfService;
      port = 5005;
    })

    (import ./service.nix "git" (let
      baseService = {
        path = [ cfg.git.package ];
        serviceConfig.BindPaths = [ "${cfg.settings."git.sr.ht".repos}:/var/lib/sourcehut/gitsrht/repos" ];
      };
      in {
      inherit configIniOfService;
      mainService = mkMerge [ baseService {
        serviceConfig.StateDirectory = [ "sourcehut/gitsrht" "sourcehut/gitsrht/repos" ];
        preStart = mkIf (versionOlder config.system.stateVersion "22.05") (mkBefore ''
          # Fix Git hooks of repositories pre-dating https://github.com/NixOS/nixpkgs/pull/133984
          (
          set +f
          shopt -s nullglob
          for h in /var/lib/sourcehut/gitsrht/repos/~*/*/hooks/{pre-receive,update,post-update}
          do ln -fnsv /usr/bin/gitsrht-update-hook "$h"; done
          )
        '');
      } ];
      port = 5001;
      webhooks = true;
      extraTimers.gitsrht-periodic = {
        service = baseService;
        timerConfig.OnCalendar = ["*:0/20"];
      };
      extraConfig = mkMerge [
        {
          # https://stackoverflow.com/questions/22314298/git-push-results-in-fatal-protocol-error-bad-line-length-character-this
          # Probably could use gitsrht-shell if output is restricted to just parameters...
          users.users.${cfg.git.user}.shell = pkgs.bash;
          services.sourcehut.settings = {
            "git.sr.ht::dispatch"."/usr/bin/gitsrht-keys" =
              mkDefault "${cfg.git.user}:${cfg.git.group}";
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
              root = "/var/lib/sourcehut/gitsrht/repos";
              fastcgiParams = {
                GIT_HTTP_EXPORT_ALL = "";
                GIT_PROJECT_ROOT = "$document_root";
                PATH_INFO = "$uri";
                SCRIPT_FILENAME = "${cfg.git.package}/bin/git-http-backend";
              };
              extraConfig = ''
                auth_request /authorize;
                fastcgi_read_timeout 500s;
                fastcgi_pass unix:/run/gitsrht-fcgiwrap.sock;
                gzip off;
              '';
            };
          };
          systemd.sockets.gitsrht-fcgiwrap = {
            before = [ "nginx.service" ];
            wantedBy = [ "sockets.target" "gitsrht.service" ];
            # This path remains accessible to nginx.service, which has no RootDirectory=
            socketConfig.ListenStream = "/run/gitsrht-fcgiwrap.sock";
            socketConfig.SocketUser = nginx.user;
            socketConfig.SocketMode = "600";
          };
        })
      ];
      extraServices.gitsrht-api = {
        serviceConfig.Restart = "always";
        serviceConfig.RestartSec = "5s";
        serviceConfig.ExecStart = "${pkgs.sourcehut.gitsrht}/bin/gitsrht-api -b ${cfg.listenAddress}:${toString (cfg.git.port + 100)}";
      };
      extraServices.gitsrht-fcgiwrap = mkIf cfg.nginx.enable {
        serviceConfig = {
          # Socket is passed by gitsrht-fcgiwrap.socket
          ExecStart = "${pkgs.fcgiwrap}/sbin/fcgiwrap -c ${toString cfg.git.fcgiwrap.preforkProcess}";
          # No need for config.ini
          ExecStartPre = mkForce [];
          User = null;
          DynamicUser = true;
          BindReadOnlyPaths = [ "${cfg.settings."git.sr.ht".repos}:/var/lib/sourcehut/gitsrht/repos" ];
          IPAddressDeny = "any";
          InaccessiblePaths = [ "-+/run/postgresql" "-+/run/redis-sourcehut" ];
          PrivateNetwork = true;
          RestrictAddressFamilies = mkForce [ "none" ];
          SystemCallFilter = mkForce [
            "@system-service"
            "~@aio" "~@keyring" "~@memlock" "~@privileged" "~@resources" "~@setuid"
            # @timer is needed for alarm()
          ];
        };
      };
    }))

    (import ./service.nix "hg" (let
      baseService = {
        path = [ cfg.hg.package ];
        serviceConfig.BindPaths = [ "${cfg.settings."hg.sr.ht".repos}:/var/lib/sourcehut/hgsrht/repos" ];
      };
      in {
      inherit configIniOfService;
      mainService = mkMerge [ baseService {
        serviceConfig.StateDirectory = [ "sourcehut/hgsrht" "sourcehut/hgsrht/repos" ];
      } ];
      port = 5010;
      webhooks = true;
      extraTimers.hgsrht-periodic = {
        service = baseService;
        timerConfig.OnCalendar = ["*:0/20"];
      };
      extraTimers.hgsrht-clonebundles = mkIf cfg.hg.cloneBundles {
        service = baseService;
        timerConfig.OnCalendar = ["daily"];
        timerConfig.AccuracySec = "1h";
      };
      extraServices.hgsrht-api = {
        serviceConfig.Restart = "always";
        serviceConfig.RestartSec = "5s";
        serviceConfig.ExecStart = "${pkgs.sourcehut.hgsrht}/bin/hgsrht-api -b ${cfg.listenAddress}:${toString (cfg.hg.port + 100)}";
      };
      extraConfig = mkMerge [
        {
          users.users.${cfg.hg.user}.shell = pkgs.bash;
          services.sourcehut.settings = {
            # Note that git.sr.ht::dispatch is not a typo,
            # gitsrht-dispatch always uses this section.
            "git.sr.ht::dispatch"."/usr/bin/hgsrht-keys" =
              mkDefault "${cfg.hg.user}:${cfg.hg.group}";
          };
          systemd.services.sshd = baseService;
        }
        (mkIf cfg.nginx.enable {
          # Allow nginx access to repositories
          users.users.${nginx.user}.extraGroups = [ cfg.hg.group ];
          services.nginx.virtualHosts."hg.${domain}" = {
            locations."/authorize" = {
              proxyPass = "http://${cfg.listenAddress}:${toString cfg.hg.port}";
              extraConfig = ''
                proxy_pass_request_body off;
                proxy_set_header Content-Length "";
                proxy_set_header X-Original-URI $request_uri;
              '';
            };
            # Let clients reach pull bundles. We don't really need to lock this down even for
            # private repos because the bundles are named after the revision hashes...
            # so someone would need to know or guess a SHA value to download anything.
            # TODO: proxyPass to an hg serve service?
            locations."~ ^/[~^][a-z0-9_]+/[a-zA-Z0-9_.-]+/\\.hg/bundles/.*$" = {
              root = "/var/lib/nginx/hgsrht/repos";
              extraConfig = ''
                auth_request /authorize;
                gzip off;
              '';
            };
          };
          systemd.services.nginx = {
            serviceConfig.BindReadOnlyPaths = [ "${cfg.settings."hg.sr.ht".repos}:/var/lib/nginx/hgsrht/repos" ];
          };
        })
      ];
    }))

    (import ./service.nix "hub" {
      inherit configIniOfService;
      port = 5014;
      extraConfig = {
        services.nginx = mkIf cfg.nginx.enable {
          virtualHosts."hub.${domain}" = mkMerge [ {
            serverAliases = [ domain ];
          } cfg.nginx.virtualHost ];
        };
      };
    })

    (import ./service.nix "lists" (let
      srvsrht = "listssrht";
      in {
      inherit configIniOfService;
      port = 5006;
      webhooks = true;
      extraServices.listssrht-api = {
        serviceConfig.Restart = "always";
        serviceConfig.RestartSec = "5s";
        serviceConfig.ExecStart = "${pkgs.sourcehut.listssrht}/bin/listssrht-api -b ${cfg.listenAddress}:${toString (cfg.lists.port + 100)}";
      };
      # Receive the mail from Postfix and enqueue them into Redis and PostgreSQL
      extraServices.listssrht-lmtp = {
        wants = [ "postfix.service" ];
        unitConfig.JoinsNamespaceOf = optional cfg.postfix.enable "postfix.service";
        serviceConfig.ExecStart = "${cfg.python}/bin/listssrht-lmtp";
        # Avoid crashing: os.chown(sock, os.getuid(), sock_gid)
        serviceConfig.PrivateUsers = mkForce false;
      };
      # Dequeue the mails from Redis and dispatch them
      extraServices.listssrht-process = {
        serviceConfig = {
          preStart = ''
            cp ${pkgs.writeText "${srvsrht}-webhooks-celeryconfig.py" cfg.lists.process.celeryConfig} \
               /run/sourcehut/${srvsrht}-webhooks/celeryconfig.py
          '';
          ExecStart = "${cfg.python}/bin/celery --app listssrht.process worker --hostname listssrht-process@%%h " + concatStringsSep " " cfg.lists.process.extraArgs;
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
    }))

    (import ./service.nix "man" {
      inherit configIniOfService;
      port = 5004;
    })

    (import ./service.nix "meta" {
      inherit configIniOfService;
      port = 5000;
      webhooks = true;
      extraTimers.metasrht-daily.timerConfig = {
        OnCalendar = ["daily"];
        AccuracySec = "1h";
      };
      extraServices.metasrht-api = {
        serviceConfig.Restart = "always";
        serviceConfig.RestartSec = "5s";
        preStart = "set -x\n" + concatStringsSep "\n\n" (attrValues (mapAttrs (k: s:
          let srvMatch = builtins.match "^([a-z]*)\\.sr\\.ht$" k;
              srv = head srvMatch;
          in
          # Configure client(s) as "preauthorized"
          optionalString (srvMatch != null && cfg.${srv}.enable && ((s.oauth-client-id or null) != null)) ''
            # Configure ${srv}'s OAuth client as "preauthorized"
            ${postgresql.package}/bin/psql '${cfg.settings."meta.sr.ht".connection-string}' \
              -c "UPDATE oauthclient SET preauthorized = true WHERE client_id = '${s.oauth-client-id}'"
          ''
          ) cfg.settings));
        serviceConfig.ExecStart = "${pkgs.sourcehut.metasrht}/bin/metasrht-api -b ${cfg.listenAddress}:${toString (cfg.meta.port + 100)}";
      };
      extraConfig = mkMerge [
        {
          assertions = [
            { assertion = let s = cfg.settings."meta.sr.ht::billing"; in
                          s.enabled == "yes" -> (s.stripe-public-key != null && s.stripe-secret-key != null);
              message = "If meta.sr.ht::billing is enabled, the keys must be defined.";
            }
          ];
          environment.systemPackages = optional cfg.meta.enable
            (pkgs.writeShellScriptBin "metasrht-manageuser" ''
              set -eux
              if test "$(${pkgs.coreutils}/bin/id -n -u)" != '${cfg.meta.user}'
              then exec sudo -u '${cfg.meta.user}' "$0" "$@"
              else
                # In order to load config.ini
                if cd /run/sourcehut/metasrht
                then exec ${cfg.python}/bin/metasrht-manageuser "$@"
                else cat <<EOF
                  Please run: sudo systemctl start metasrht
              EOF
                  exit 1
                fi
              fi
            '');
        }
        (mkIf cfg.nginx.enable {
          services.nginx.virtualHosts."meta.${domain}" = {
            locations."/query" = {
              proxyPass = cfg.settings."meta.sr.ht".api-origin;
              extraConfig = ''
                if ($request_method = 'OPTIONS') {
                  add_header 'Access-Control-Allow-Origin' '*';
                  add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
                  add_header 'Access-Control-Allow-Headers' 'User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range';
                  add_header 'Access-Control-Max-Age' 1728000;
                  add_header 'Content-Type' 'text/plain; charset=utf-8';
                  add_header 'Content-Length' 0;
                  return 204;
                }

                add_header 'Access-Control-Allow-Origin' '*';
                add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
                add_header 'Access-Control-Allow-Headers' 'User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range';
                add_header 'Access-Control-Expose-Headers' 'Content-Length,Content-Range';
              '';
            };
          };
        })
      ];
    })

    (import ./service.nix "pages" {
      inherit configIniOfService;
      port = 5112;
      mainService = let
        srvsrht = "pagessrht";
        version = pkgs.sourcehut.${srvsrht}.version;
        stateDir = "/var/lib/sourcehut/${srvsrht}";
        iniKey = "pages.sr.ht";
        in {
        preStart = mkBefore ''
          set -x
          # Use the /run/sourcehut/${srvsrht}/config.ini
          # installed by a previous ExecStartPre= in baseService
          cd /run/sourcehut/${srvsrht}

          if test ! -e ${stateDir}/db; then
            ${postgresql.package}/bin/psql '${cfg.settings.${iniKey}.connection-string}' -f ${pkgs.sourcehut.pagessrht}/share/sql/schema.sql
            echo ${version} >${stateDir}/db
          fi

          ${optionalString cfg.settings.${iniKey}.migrate-on-upgrade ''
            # Just try all the migrations because they're not linked to the version
            for sql in ${pkgs.sourcehut.pagessrht}/share/sql/migrations/*.sql; do
              ${postgresql.package}/bin/psql '${cfg.settings.${iniKey}.connection-string}' -f "$sql" || true
            done
          ''}

          # Disable webhook
          touch ${stateDir}/webhook
        '';
        serviceConfig = {
          ExecStart = mkForce "${pkgs.sourcehut.pagessrht}/bin/pages.sr.ht -b ${cfg.listenAddress}:${toString cfg.pages.port}";
        };
      };
    })

    (import ./service.nix "paste" {
      inherit configIniOfService;
      port = 5011;
    })

    (import ./service.nix "todo" {
      inherit configIniOfService;
      port = 5003;
      webhooks = true;
      extraServices.todosrht-api = {
        serviceConfig.Restart = "always";
        serviceConfig.RestartSec = "5s";
        serviceConfig.ExecStart = "${pkgs.sourcehut.todosrht}/bin/todosrht-api -b ${cfg.listenAddress}:${toString (cfg.todo.port + 100)}";
      };
      extraServices.todosrht-lmtp = {
        wants = [ "postfix.service" ];
        unitConfig.JoinsNamespaceOf = optional cfg.postfix.enable "postfix.service";
        serviceConfig.ExecStart = "${cfg.python}/bin/todosrht-lmtp";
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

    (mkRenamedOptionModule [ "services" "sourcehut" "originBase" ]
                           [ "services" "sourcehut" "settings" "sr.ht" "global-domain" ])
    (mkRenamedOptionModule [ "services" "sourcehut" "address" ]
                           [ "services" "sourcehut" "listenAddress" ])

  ];

  meta.doc = ./sourcehut.xml;
  meta.maintainers = with maintainers; [ julm tomberek ];
}

{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.services.public-inbox;
  stateDir = "/var/lib/public-inbox";

  gitIni = pkgs.formats.gitIni { listsAsDuplicateKeys = true; };
  iniAtom = elemAt gitIni.type/*attrsOf*/.functor.wrapped/*attrsOf*/.functor.wrapped/*either*/.functor.wrapped 0;

  useSpamAssassin = cfg.settings.publicinboxmda.spamcheck == "spamc" ||
                    cfg.settings.publicinboxwatch.spamcheck == "spamc";

  publicInboxDaemonOptions = proto: defaultPort: {
    args = mkOption {
      type = with types; listOf str;
      default = [];
      description = "Command-line arguments to pass to {manpage}`public-inbox-${proto}d(1)`.";
    };
    port = mkOption {
      type = with types; nullOr (either str port);
      default = defaultPort;
      description = ''
        Listening port.
        Beware that public-inbox uses well-known ports number to decide whether to enable TLS or not.
        Set to null and use `systemd.sockets.public-inbox-${proto}d.listenStreams`
        if you need a more advanced listening.
      '';
    };
    cert = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "/path/to/fullchain.pem";
      description = "Path to TLS certificate to use for connections to {manpage}`public-inbox-${proto}d(1)`.";
    };
    key = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "/path/to/key.pem";
      description = "Path to TLS key to use for connections to {manpage}`public-inbox-${proto}d(1)`.";
    };
  };

  serviceConfig = srv:
    let proto = removeSuffix "d" srv;
        needNetwork = builtins.hasAttr proto cfg && cfg.${proto}.port == null;
    in {
    serviceConfig = {
      # Enable JIT-compiled C (via Inline::C)
      Environment = [ "PERL_INLINE_DIRECTORY=/run/public-inbox-${srv}/perl-inline" ];
      # NonBlocking is REQUIRED to avoid a race condition
      # if running simultaneous services.
      NonBlocking = true;
      #LimitNOFILE = 30000;
      User = config.users.users."public-inbox".name;
      Group = config.users.groups."public-inbox".name;
      RuntimeDirectory = [
          "public-inbox-${srv}/perl-inline"
        ];
      RuntimeDirectoryMode = "700";
      # This is for BindPaths= and BindReadOnlyPaths=
      # to allow traversal of directories they create inside RootDirectory=
      UMask = "0066";
      StateDirectory = ["public-inbox"];
      StateDirectoryMode = "0750";
      WorkingDirectory = stateDir;
      BindReadOnlyPaths = [
          "/etc"
          "/run/systemd"
          "${config.i18n.glibcLocales}"
        ] ++
        mapAttrsToList (name: inbox: inbox.description) cfg.inboxes ++
        # Without confinement the whole Nix store
        # is made available to the service
        optionals (!config.systemd.services."public-inbox-${srv}".confinement.enable) [
          "${pkgs.dash}/bin/dash:/bin/sh"
          builtins.storeDir
        ];
      # The following options are only for optimizing:
      # systemd-analyze security public-inbox-'*'
      AmbientCapabilities = "";
      CapabilityBoundingSet = "";
      # ProtectClock= adds DeviceAllow=char-rtc r
      DeviceAllow = "";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateNetwork = mkDefault (!needNetwork);
      ProcSubset = "pid";
      ProtectClock = true;
      ProtectHome = "tmpfs";
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectProc = "invisible";
      #ProtectSystem = "strict";
      RemoveIPC = true;
      RestrictAddressFamilies = [ "AF_UNIX" ] ++
        optionals needNetwork [ "AF_INET" "AF_INET6" ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallFilter = [
        "@system-service"
        "~@aio" "~@chown" "~@keyring" "~@memlock" "~@resources"
        # Not removing @setuid and @privileged because Inline::C needs them.
        # Not removing @timer because git upload-pack needs it.
      ];
      SystemCallArchitectures = "native";

      # The following options are redundant when confinement is enabled
      RootDirectory = "/var/empty";
      TemporaryFileSystem = "/";
      PrivateMounts = true;
      MountAPIVFS = true;
      PrivateDevices = true;
      PrivateTmp = true;
      PrivateUsers = true;
      ProtectControlGroups = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
    };
    confinement = {
      # Until we agree upon doing it directly here in NixOS
      # https://github.com/NixOS/nixpkgs/pull/104457#issuecomment-1115768447
      # let the user choose to enable the confinement with:
      # systemd.services.public-inbox-httpd.confinement.enable = true;
      # systemd.services.public-inbox-imapd.confinement.enable = true;
      # systemd.services.public-inbox-init.confinement.enable = true;
      # systemd.services.public-inbox-nntpd.confinement.enable = true;
      #enable = true;
      mode = "full-apivfs";
      # Inline::C needs a /bin/sh, and dash is enough
      binSh = "${pkgs.dash}/bin/dash";
      packages = [
          pkgs.iana-etc
          (getLib pkgs.nss)
          pkgs.tzdata
        ];
    };
  };
in

{
  options.services.public-inbox = {
    enable = mkEnableOption "the public-inbox mail archiver";
    package = mkPackageOption pkgs "public-inbox" { };
    path = mkOption {
      type = with types; listOf package;
      default = [];
      example = literalExpression "with pkgs; [ spamassassin ]";
      description = ''
        Additional packages to place in the path of public-inbox-mda,
        public-inbox-watch, etc.
      '';
    };
    inboxes = mkOption {
      description = ''
        Inboxes to configure, where attribute names are inbox names.
      '';
      default = {};
      type = types.attrsOf (types.submodule ({name, ...}: {
        freeformType = types.attrsOf iniAtom;
        options.inboxdir = mkOption {
          type = types.str;
          default = "${stateDir}/inboxes/${name}";
          description = "The absolute path to the directory which hosts the public-inbox.";
        };
        options.address = mkOption {
          type = with types; listOf str;
          example = "example-discuss@example.org";
          description = "The email addresses of the public-inbox.";
        };
        options.url = mkOption {
          type = types.nonEmptyStr;
          example = "https://example.org/lists/example-discuss";
          description = "URL where this inbox can be accessed over HTTP.";
        };
        options.description = mkOption {
          type = types.str;
          example = "user/dev discussion of public-inbox itself";
          description = "User-visible description for the repository.";
          apply = pkgs.writeText "public-inbox-description-${name}";
        };
        options.newsgroup = mkOption {
          type = with types; nullOr str;
          default = null;
          description = "NNTP group name for the inbox.";
        };
        options.watch = mkOption {
          type = with types; listOf str;
          default = [];
          description = "Paths for {manpage}`public-inbox-watch(1)` to monitor for new mail.";
          example = [ "maildir:/path/to/test.example.com.git" ];
        };
        options.watchheader = mkOption {
          type = with types; nullOr str;
          default = null;
          example = "List-Id:<test@example.com>";
          description = ''
            If specified, {manpage}`public-inbox-watch(1)` will only process
            mail containing a matching header.
          '';
        };
        options.coderepo = mkOption {
          type = (types.listOf (types.enum (attrNames cfg.settings.coderepo))) // {
            description = "list of coderepo names";
          };
          default = [];
          description = "Nicknames of a 'coderepo' section associated with the inbox.";
        };
      }));
    };
    imap = {
      enable = mkEnableOption "the public-inbox IMAP server";
    } // publicInboxDaemonOptions "imap" 993;
    http = {
      enable = mkEnableOption "the public-inbox HTTP server";
      mounts = mkOption {
        type = with types; listOf str;
        default = [ "/" ];
        example = [ "/lists/archives" ];
        description = ''
          Root paths or URLs that public-inbox will be served on.
          If domain parts are present, only requests to those
          domains will be accepted.
        '';
      };
      args = (publicInboxDaemonOptions "http" 80).args;
      port = mkOption {
        type = with types; nullOr (either str port);
        default = 80;
        example = "/run/public-inbox-httpd.sock";
        description = ''
          Listening port or systemd's ListenStream= entry
          to be used as a reverse proxy, eg. in nginx:
          `locations."/inbox".proxyPass = "http://unix:''${config.services.public-inbox.http.port}:/inbox";`
          Set to null and use `systemd.sockets.public-inbox-httpd.listenStreams`
          if you need a more advanced listening.
        '';
      };
    };
    mda = {
      enable = mkEnableOption "the public-inbox Mail Delivery Agent";
      args = mkOption {
        type = with types; listOf str;
        default = [];
        description = "Command-line arguments to pass to {manpage}`public-inbox-mda(1)`.";
      };
    };
    postfix.enable = mkEnableOption "the integration into Postfix";
    nntp = {
      enable = mkEnableOption "the public-inbox NNTP server";
    } // publicInboxDaemonOptions "nntp" 563;
    spamAssassinRules = mkOption {
      type = with types; nullOr path;
      default = "${cfg.package.sa_config}/user/.spamassassin/user_prefs";
      defaultText = literalExpression "\${cfg.package.sa_config}/user/.spamassassin/user_prefs";
      description = "SpamAssassin configuration specific to public-inbox.";
    };
    settings = mkOption {
      description = ''
        Settings for the [public-inbox config file](https://public-inbox.org/public-inbox-config.html).
      '';
      default = {};
      type = types.submodule {
        freeformType = gitIni.type;
        options.publicinbox = mkOption {
          default = {};
          description = "public inboxes";
          type = types.submodule {
            # Support both global options like `services.public-inbox.settings.publicinbox.imapserver`
            # and inbox specific options like `services.public-inbox.settings.publicinbox.foo.address`.
            freeformType = with types; attrsOf (oneOf [ iniAtom (attrsOf iniAtom) ]);

            options.css = mkOption {
              type = with types; listOf str;
              default = [];
              description = "The local path name of a CSS file for the PSGI web interface.";
            };
            options.imapserver = mkOption {
              type = with types; listOf str;
              default = [];
              example = [ "imap.public-inbox.org" ];
              description = "IMAP URLs to this public-inbox instance";
            };
            options.nntpserver = mkOption {
              type = with types; listOf str;
              default = [];
              example = [ "nntp://news.public-inbox.org" "nntps://news.public-inbox.org" ];
              description = "NNTP URLs to this public-inbox instance";
            };
            options.pop3server = mkOption {
              type = with types; listOf str;
              default = [];
              example = [ "pop.public-inbox.org" ];
              description = "POP3 URLs to this public-inbox instance";
            };
            options.wwwlisting = mkOption {
              type = with types; enum [ "all" "404" "match=domain" ];
              default = "404";
              description = ''
                Controls which lists (if any) are listed for when the root
                public-inbox URL is accessed over HTTP.
              '';
            };
          };
        };
        options.publicinboxmda.spamcheck = mkOption {
          type = with types; enum [ "spamc" "none" ];
          default = "none";
          description = ''
            If set to spamc, {manpage}`public-inbox-watch(1)` will filter spam
            using SpamAssassin.
          '';
        };
        options.publicinboxwatch.spamcheck = mkOption {
          type = with types; enum [ "spamc" "none" ];
          default = "none";
          description = ''
            If set to spamc, {manpage}`public-inbox-watch(1)` will filter spam
            using SpamAssassin.
          '';
        };
        options.publicinboxwatch.watchspam = mkOption {
          type = with types; nullOr str;
          default = null;
          example = "maildir:/path/to/spam";
          description = ''
            If set, mail in this maildir will be trained as spam and
            deleted from all watched inboxes
          '';
        };
        options.coderepo = mkOption {
          default = {};
          description = "code repositories";
          type = types.attrsOf (types.submodule {
            freeformType = types.attrsOf iniAtom;
            options.cgitUrl = mkOption {
              type = types.str;
              description = "URL of a cgit instance";
            };
            options.dir = mkOption {
              type = types.str;
              description = "Path to a git repository";
            };
          });
        };
      };
    };
    openFirewall = mkEnableOption "opening the firewall when using a port option";
  };
  config = mkIf cfg.enable {
    assertions = [
      { assertion = config.services.spamassassin.enable || !useSpamAssassin;
        message = ''
          public-inbox is configured to use SpamAssassin, but
          services.spamassassin.enable is false.  If you don't need
          spam checking, set `services.public-inbox.settings.publicinboxmda.spamcheck' and
          `services.public-inbox.settings.publicinboxwatch.spamcheck' to null.
        '';
      }
      { assertion = cfg.path != [] || !useSpamAssassin;
        message = ''
          public-inbox is configured to use SpamAssassin, but there is
          no spamc executable in services.public-inbox.path.  If you
          don't need spam checking, set
          `services.public-inbox.settings.publicinboxmda.spamcheck' and
          `services.public-inbox.settings.publicinboxwatch.spamcheck' to null.
        '';
      }
    ];
    services.public-inbox.settings =
      filterAttrsRecursive (n: v: v != null) {
        publicinbox = mapAttrs (n: filterAttrs (n: v: n != "description")) cfg.inboxes;
    };
    users = {
      users.public-inbox = {
        home = stateDir;
        group = "public-inbox";
        isSystemUser = true;
      };
      groups.public-inbox = {};
    };
    networking.firewall = mkIf cfg.openFirewall
      { allowedTCPPorts = mkMerge
        (map (proto: (mkIf (cfg.${proto}.enable && types.port.check cfg.${proto}.port) [ cfg.${proto}.port ]))
        ["imap" "http" "nntp"]);
      };
    services.postfix = mkIf (cfg.postfix.enable && cfg.mda.enable) {
      # Not sure limiting to 1 is necessary, but better safe than sorry.
      config.public-inbox_destination_recipient_limit = "1";

      # Register the addresses as existing
      virtual =
        concatStringsSep "\n" (mapAttrsToList (_: inbox:
          concatMapStringsSep "\n" (address:
            "${address} ${address}"
          ) inbox.address
        ) cfg.inboxes);

      # Deliver the addresses with the public-inbox transport
      transport =
        concatStringsSep "\n" (mapAttrsToList (_: inbox:
          concatMapStringsSep "\n" (address:
            "${address} public-inbox:${address}"
          ) inbox.address
        ) cfg.inboxes);

      # The public-inbox transport
      masterConfig.public-inbox = {
        type = "unix";
        privileged = true; # Required for user=
        command = "pipe";
        args = [
          "flags=X" # Report as a final delivery
          "user=${with config.users; users."public-inbox".name + ":" + groups."public-inbox".name}"
          # Specifying a nexthop when using the transport
          # (eg. test public-inbox:test) allows to
          # receive mails with an extension (eg. test+foo).
          "argv=${pkgs.writeShellScript "public-inbox-transport" ''
            export HOME="${stateDir}"
            export ORIGINAL_RECIPIENT="''${2:-1}"
            export PATH="${makeBinPath cfg.path}:$PATH"
            exec ${cfg.package}/bin/public-inbox-mda ${escapeShellArgs cfg.mda.args}
          ''} \${original_recipient} \${nexthop}"
        ];
      };
    };
    systemd.sockets = mkMerge (map (proto:
      mkIf (cfg.${proto}.enable && cfg.${proto}.port != null)
        { "public-inbox-${proto}d" = {
            listenStreams = [ (toString cfg.${proto}.port) ];
            wantedBy = [ "sockets.target" ];
          };
        }
      ) [ "imap" "http" "nntp" ]);
    systemd.services = mkMerge [
      (mkIf cfg.imap.enable
        { public-inbox-imapd = mkMerge [(serviceConfig "imapd") {
          after = [ "public-inbox-init.service" "public-inbox-watch.service" ];
          requires = [ "public-inbox-init.service" ];
          serviceConfig = {
            ExecStart = escapeShellArgs (
              [ "${cfg.package}/bin/public-inbox-imapd" ] ++
              cfg.imap.args ++
              optionals (cfg.imap.cert != null) [ "--cert" cfg.imap.cert ] ++
              optionals (cfg.imap.key != null) [ "--key" cfg.imap.key ]
            );
          };
        }];
      })
      (mkIf cfg.http.enable
        { public-inbox-httpd = mkMerge [(serviceConfig "httpd") {
          after = [ "public-inbox-init.service" "public-inbox-watch.service" ];
          requires = [ "public-inbox-init.service" ];
          serviceConfig = {
            BindPathsReadOnly =
              map (c: c.dir) (lib.attrValues cfg.settings.coderepo);
            ExecStart = escapeShellArgs (
              [ "${cfg.package}/bin/public-inbox-httpd" ] ++
              cfg.http.args ++
              # See https://public-inbox.org/public-inbox.git/tree/examples/public-inbox.psgi
              # for upstream's example.
              [ (pkgs.writeText "public-inbox.psgi" ''
                #!${cfg.package.fullperl} -w
                use strict;
                use warnings;
                use Plack::Builder;
                use PublicInbox::WWW;

                my $www = PublicInbox::WWW->new;
                $www->preload;

                builder {
                  # If reached through a reverse proxy,
                  # make it transparent by resetting some HTTP headers
                  # used by public-inbox to generate URIs.
                  enable 'ReverseProxy';

                  # No need to send a response body if it's an HTTP HEAD requests.
                  enable 'Head';

                  # Route according to configured domains and root paths.
                  ${concatMapStrings (path: ''
                  mount q(${path}) => sub { $www->call(@_); };
                  '') cfg.http.mounts}
                }
              '') ]
            );
          };
        }];
      })
      (mkIf cfg.nntp.enable
        { public-inbox-nntpd = mkMerge [(serviceConfig "nntpd") {
          after = [ "public-inbox-init.service" "public-inbox-watch.service" ];
          requires = [ "public-inbox-init.service" ];
          serviceConfig = {
            ExecStart = escapeShellArgs (
              [ "${cfg.package}/bin/public-inbox-nntpd" ] ++
              cfg.nntp.args ++
              optionals (cfg.nntp.cert != null) [ "--cert" cfg.nntp.cert ] ++
              optionals (cfg.nntp.key != null) [ "--key" cfg.nntp.key ]
            );
          };
        }];
      })
      (mkIf (any (inbox: inbox.watch != []) (attrValues cfg.inboxes)
        || cfg.settings.publicinboxwatch.watchspam != null)
        { public-inbox-watch = mkMerge [(serviceConfig "watch") {
          inherit (cfg) path;
          wants = [ "public-inbox-init.service" ];
          requires = [ "public-inbox-init.service" ] ++
            optional (cfg.settings.publicinboxwatch.spamcheck == "spamc") "spamassassin.service";
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = "${cfg.package}/bin/public-inbox-watch";
            ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          };
        }];
      })
      ({ public-inbox-init = let
          PI_CONFIG = gitIni.generate "public-inbox.ini"
            (filterAttrsRecursive (n: v: v != null) cfg.settings);
          in mkMerge [(serviceConfig "init") {
          wantedBy = [ "multi-user.target" ];
          restartIfChanged = true;
          restartTriggers = [ PI_CONFIG ];
          script = ''
            set -ux
            install -D -p ${PI_CONFIG} ${stateDir}/.public-inbox/config
            '' + optionalString useSpamAssassin ''
              install -m 0700 -o spamd -d ${stateDir}/.spamassassin
              ${optionalString (cfg.spamAssassinRules != null) ''
                ln -sf ${cfg.spamAssassinRules} ${stateDir}/.spamassassin/user_prefs
              ''}
            '' + concatStrings (mapAttrsToList (name: inbox: ''
              if [ ! -e ${stateDir}/inboxes/${escapeShellArg name} ]; then
                # public-inbox-init creates an inbox and adds it to a config file.
                # It tries to atomically write the config file by creating
                # another file in the same directory, and renaming it.
                # This has the sad consequence that we can't use
                # /dev/null, or it would try to create a file in /dev.
                conf_dir="$(mktemp -d)"

                PI_CONFIG=$conf_dir/conf \
                ${cfg.package}/bin/public-inbox-init -V2 \
                  ${escapeShellArgs ([ name "${stateDir}/inboxes/${name}" inbox.url ] ++ inbox.address)}

                rm -rf $conf_dir
              fi

              ln -sf ${inbox.description} \
                ${stateDir}/inboxes/${escapeShellArg name}/description

              export GIT_DIR=${stateDir}/inboxes/${escapeShellArg name}/all.git
              if test -d "$GIT_DIR"; then
                # Config is inherited by each epoch repository,
                # so just needs to be set for all.git.
                ${pkgs.git}/bin/git config core.sharedRepository 0640
              fi
            '') cfg.inboxes
            );
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            StateDirectory = [
              "public-inbox/.public-inbox"
              "public-inbox/.public-inbox/emergency"
              "public-inbox/inboxes"
            ];
          };
        }];
      })
    ];
    environment.systemPackages = with pkgs; [ cfg.package ];
  };
  meta.maintainers = with lib.maintainers; [ julm qyliss ];
}

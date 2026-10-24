{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.imapgoose;

  # scfg tokens are whitespace-separated; any token containing whitespace or
  # special characters must be double-quoted with backslashes escaped. Quoting
  # every token unconditionally is always valid scfg and keeps rendering simple.
  quoteToken = token: ''"${lib.escape [ "\\" "\"" ] token}"'';

  # Where an instance's SQLite status databases live, and whether that directory
  # is a systemd-managed StateDirectory (the default) or a caller-chosen path.
  stateLocationOf =
    name: inst:
    if inst.stateDir == null then
      {
        path = "/var/lib/imapgoose/${name}";
        managed = true;
      }
    else
      {
        path = inst.stateDir;
        managed = false;
      };

  renderAccount =
    name: account:
    let
      lines = [
        "server ${quoteToken "${account.server}:${toString account.port}"}"
        "username ${quoteToken account.username}"
        "password-cmd ${lib.concatMapStringsSep " " quoteToken account.passwordCommand}"
        "local-path ${quoteToken account.localPath}"
        "max-connections ${toString account.maxConnections}"
      ]
      ++
        lib.optional (account.postSyncCommand != [ ])
          "post-sync-cmd ${lib.concatMapStringsSep " " quoteToken account.postSyncCommand}"

      ++ map (regex: "ignore ${quoteToken regex}") account.ignore
      ++ lib.optional account.disableTLS "plaintext true";
    in
    ''
      account ${quoteToken name} {
      ${lib.concatMapStringsSep "\n" (line: "\t${line}") lines}
      }
    '';

  configFileFor =
    name: inst:
    pkgs.writeText "imapgoose-${name}.scfg" (
      lib.concatStringsSep "\n" (lib.mapAttrsToList renderAccount inst.accounts)
    );

  accountOpts =
    { ... }:
    {
      options = {
        server = lib.mkOption {
          type = lib.types.nonEmptyStr;
          example = "imap.example.com";
          description = "Hostname of the IMAP server. imapgoose connects over TLS on the given port unless {option}`services.imapgoose.instances.<name>.accounts.<name>.disableTLS` is set.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 993;
          description = "Port of the IMAP server.";
        };

        username = lib.mkOption {
          type = lib.types.nonEmptyStr;
          example = "alice@example.com";
          description = "Username to authenticate with.";
        };

        passwordCommand = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          example = [
            "pass"
            "show"
            "email/personal"
          ];
          description = ''
            Command whose standard output (trimmed) is used as the account's
            password. Given as a list of tokens (command and arguments). This
            avoids storing the password in the world-readable Nix store.
          '';
        };

        localPath = lib.mkOption {
          type = lib.types.str;
          # Strip trailing slashes so builtins.dirOf (used for the tmpfiles
          # parent) computes the true parent rather than the path itself.
          apply = lib.converge (lib.removeSuffix "/");
          example = "/home/alice/mail/personal";
          description = ''
            Absolute path of the local Maildir directory to synchronise. The
            Maildir and its immediate parent directory are created automatically
            (owned by the instance's
            {option}`services.imapgoose.instances.<name>.user`) if they do not
            exist. The immediate parent directory's ownership is also set to the
            instance user, so `localPath` should not sit directly inside a
            directory whose ownership matters — place the Maildir at
            `~/mail/<account>` rather than directly in `$HOME`. If this path is
            nested more than one level below an existing directory, you must
            create the intervening directories yourself.
          '';
        };

        maxConnections = lib.mkOption {
          type = lib.types.ints.positive;
          default = 3;
          description = "Maximum number of concurrent IMAP connections. Must be at least 2.";
        };

        postSyncCommand = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [
            "notmuch"
            "new"
          ];
          description = ''
            Command to run after each sync, given as a list of tokens (command
            and arguments). Leave empty to disable.
          '';
        };

        ignore = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [ "^Junk$" ];
          description = "Regular expressions of mailbox names to skip. May be given multiple times.";
        };

        disableTLS = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Connect in plaintext instead of over TLS. This is typically quite
            insecure, but necessary for situations like email-oauth2-proxy.

            Requires imapgoose >= 0.5.4.
          '';
        };
      };
    };

  instanceOpts =
    { name, ... }:
    {
      options = {
        user = lib.mkOption {
          type = lib.types.nonEmptyStr;
          default = name;
          defaultText = lib.literalMD "the instance name";
          example = "alice";
          description = ''
            Existing user whose Maildir directories are synchronised and as whom
            this instance's daemon (including
            {option}`services.imapgoose.instances.<name>.accounts.<name>.passwordCommand`
            and
            {option}`services.imapgoose.instances.<name>.accounts.<name>.postSyncCommand`)
            runs.
          '';
        };

        group = lib.mkOption {
          type = lib.types.nullOr lib.types.nonEmptyStr;
          default = null;
          example = "users";
          description = ''
            Group the daemon runs as. When null, systemd uses the primary group
            of {option}`services.imapgoose.instances.<name>.user`.
          '';
        };

        stateDir = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          # Strip trailing slashes for the same reason as localPath: a stable
          # ReadWritePaths entry and correct builtins.dirOf/tmpfiles hygiene.
          apply = v: if v == null then null else lib.converge (lib.removeSuffix "/") v;
          defaultText = lib.literalMD "`/var/lib/imapgoose/<name>` (a systemd `StateDirectory`)";
          example = "/home/alice/.imapgoose-state";
          description = ''
            Directory holding imapgoose's per-account SQLite status databases for
            this instance. When null, the databases live under
            `/var/lib/imapgoose/<name>`, managed as a systemd StateDirectory. Set
            this to relocate them — for example onto an encrypted filesystem
            mounted alongside the Maildir, so the sync state is stored at rest
            with the mail it describes. The directory is created if missing, owned
            by the instance's user. Within it, imapgoose writes each account's
            database as `<stateDir>/imapgoose/<account>-<hash>.db`, deriving the
            filename from the account name. As with
            {option}`services.imapgoose.instances.<name>.accounts.<name>.localPath`,
            only one parent level is created: if this path is nested more than one
            directory below an existing path, you must create the intervening
            directories yourself.
          '';
        };

        verbose = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to enable verbose logging.";
        };

        accounts = lib.mkOption {
          type = lib.types.attrsOf (lib.types.submodule accountOpts);
          default = { };
          example = lib.literalExpression ''
            {
              personal = {
                server = "imap.example.com";
                username = "alice@example.com";
                passwordCommand = [ "pass" "show" "email/personal" ];
                localPath = "/home/alice/mail/personal";
                postSyncCommand = [ "notmuch" "new" ];
              };
            }
          '';
          description = "IMAP accounts to synchronise for this instance. The attribute name is the account name.";
        };
      };
    };
in
{
  options.services.imapgoose = {
    package = lib.mkPackageOption pkgs "imapgoose" { };

    instances = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule instanceOpts);
      default = { };
      example = lib.literalExpression ''
        {
          alice.accounts.personal = {
            server = "imap.example.com";
            username = "alice@example.com";
            passwordCommand = [ "pass" "show" "email/personal" ];
            localPath = "/home/alice/mail/personal";
          };

          bob = {
            group = "users";
            accounts.work = {
              server = "imap.example.org";
              username = "bob@example.org";
              passwordCommand = [ "pass" "show" "email/work" ];
              localPath = "/home/bob/mail/work";
            };
          };
        }
      '';
      description = ''
        imapgoose instances, keyed by name. Each instance runs as its own
        systemd service under its own OS user (defaulting to the instance name)
        and synchronises that user's set of IMAP accounts. An empty attrset (the
        default) generates nothing.
      '';
    };
  };

  config = lib.mkIf (cfg.instances != { }) {
    assertions = lib.concatLists (
      lib.mapAttrsToList (
        name: inst:
        [
          {
            assertion = inst.accounts != { };
            message = "services.imapgoose.instances.${name}.accounts must contain at least one account.";
          }
          {
            assertion = inst.stateDir == null || lib.hasPrefix "/" inst.stateDir;
            message = "services.imapgoose.instances.${name}.stateDir must be an absolute path.";
          }
        ]
        ++ lib.concatLists (
          lib.mapAttrsToList (acct: account: [
            {
              assertion = account.passwordCommand != [ ];
              message = "services.imapgoose.instances.${name}.accounts.${acct}.passwordCommand must not be empty.";
            }
            {
              assertion = account.maxConnections >= 2;
              message = "services.imapgoose.instances.${name}.accounts.${acct}.maxConnections must be at least 2.";
            }
            {
              assertion = lib.hasPrefix "/" account.localPath;
              message = "services.imapgoose.instances.${name}.accounts.${acct}.localPath must be an absolute path.";
            }
            {
              assertion = !account.disableTLS || lib.versionAtLeast cfg.package.version "0.5.4";
              message = "services.imapgoose.instances.${name}.accounts.${acct}.disableTLS requires imapgoose >= 0.5.4, but services.imapgoose.package is version ${cfg.package.version}.";
            }
          ]) inst.accounts
        )
      ) cfg.instances
    );

    # Ensure each account's Maildir exists and is owned by the daemon's user, so
    # imapgoose can populate it and ReadWritePaths= can bind-mount it. The
    # immediate parent is created with the same ownership too, otherwise
    # systemd-tmpfiles refuses the root->user "unsafe path transition" when the
    # Maildir lives under a user-owned home directory.
    #
    # The leaf (Maildir) rule uses mode 0700 because imapgoose manages that dir.
    # The parent rule uses mode "-" so an *existing* directory (e.g. a shared
    # ~/mail also used by another tool) keeps its current mode instead of being
    # force-chmod'd to 0700; a newly-created parent gets the tmpfiles default
    # mode. The parent's owner is still set to the instance user (tmpfiles
    # requires this to allow the user-owned leaf beneath it without an "unsafe
    # path transition" refusal), so this rule will chown an existing parent — it
    # only avoids clobbering its mode. Limitation: only one parent level is
    # created. If localPath is nested more than one directory below an existing
    # path, the intervening directories must already exist.
    #
    # Each instance gets its own namespaced tmpfiles key so instances never
    # collide on a shared config key; within an instance, mkMerge lets accounts
    # that share a parent directory coexist cleanly.
    systemd.tmpfiles.settings = lib.mapAttrs' (
      name: inst:
      let
        group = if inst.group != null then inst.group else "-";
        leafRule = {
          d = {
            user = inst.user;
            inherit group;
            mode = "0700";
          };
        };
        # Wrap the parent rule's attributes in mkDefault so that if another
        # account's leaf rule (a concrete localPath/stateDir with mode 0700)
        # resolves to the same path, the leaf's concrete values win instead of
        # mkMerge throwing a "conflicting definition values" error.
        parentRule = {
          d = {
            user = lib.mkDefault inst.user;
            group = lib.mkDefault group;
            mode = lib.mkDefault "-";
          };
        };
        stateLocation = stateLocationOf name inst;
      in
      lib.nameValuePair "imapgoose-${name}" (
        lib.mkMerge (
          # When stateDir is set, imapgoose's SQLite databases live at a
          # caller-chosen path instead of a systemd StateDirectory. Exposing this
          # is the whole point of the option: it lets the sync state be placed on
          # encrypted storage alongside the Maildir it describes. Create that dir
          # (owned by the instance user, mode 0700) so the hardened unit can write
          # to it; imapgoose creates the "imapgoose/" subdir beneath it itself.
          lib.optional (!stateLocation.managed) { ${stateLocation.path} = leafRule; }
          ++ lib.concatLists (
            lib.mapAttrsToList (_: account: [
              { ${builtins.dirOf account.localPath} = parentRule; }
              { ${account.localPath} = leafRule; }
            ]) inst.accounts
          )
        )
      )
    ) cfg.instances;

    systemd.services = lib.mapAttrs' (
      name: inst:
      let
        stateLocation = stateLocationOf name inst;
      in
      lib.nameValuePair "imapgoose-${name}" {
        description = "imapgoose IMAP synchronisation for ${inst.user}";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        # imapgoose stores one SQLite db per account under
        # $XDG_STATE_HOME/imapgoose/ with flat account-name filenames, so two
        # instances sharing a state dir would collide. Give each instance its
        # own StateDirectory and point XDG_STATE_HOME at it; imapgoose then
        # writes /var/lib/imapgoose/${name}/imapgoose/<account>.db (the extra
        # "imapgoose/" component is imposed by imapgoose itself).
        #
        # When stateDir is set the databases move to a caller-chosen absolute
        # path (e.g. encrypted storage next to the Maildir), which cannot be a
        # systemd StateDirectory: XDG_STATE_HOME points there instead, the dir is
        # created via tmpfiles above, and it is added to ReadWritePaths so the
        # hardened unit (ProtectSystem=strict) may write to it.
        environment.XDG_STATE_HOME = stateLocation.path;

        serviceConfig = {
          ExecStart =
            "${lib.getExe cfg.package} -c ${configFileFor name inst}" + lib.optionalString inst.verbose " -v";
          User = inst.user;
          Restart = "on-failure";
          RestartSec = 5;

          # Hardening. ProtectHome is deliberately not set because Maildirs live
          # under the user's home; each localPath is added to ReadWritePaths.
          ProtectSystem = "strict";
          ReadWritePaths =
            (map (a: a.localPath) (lib.attrValues inst.accounts))
            ++ lib.optional (!stateLocation.managed) stateLocation.path;
          NoNewPrivileges = true;
          PrivateTmp = true;
          ProtectKernelTunables = true;
          ProtectControlGroups = true;
          LockPersonality = true;
          RestrictRealtime = true;
          RestrictNamespaces = true;
          ProtectProc = "invisible";
          ProcSubset = "pid";
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
            # glibc getaddrinfo() opens an AF_NETLINK (NETLINK_ROUTE) socket to
            # enumerate local addresses for RFC 3484 source-address selection;
            # without it DNS resolution against real IMAP hosts degrades or fails.
            "AF_NETLINK"
          ];
          SystemCallFilter = [ "@system-service" ];
          SystemCallErrorNumber = "EPERM";
          CapabilityBoundingSet = [ "" ];
        }
        // lib.optionalAttrs stateLocation.managed {
          StateDirectory = "imapgoose/${name}";
          StateDirectoryMode = "0700";
        }
        // lib.optionalAttrs (inst.group != null) { Group = inst.group; };
      }
    ) cfg.instances;
  };

  meta.maintainers = with lib.maintainers; [ bobberb ];
}

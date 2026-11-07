{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  inherit (utils.systemdUtils.unitOptions) unitOption;
  cfg = config.services.plakar.server;
  isLocalRepo = repo: lib.hasPrefix "/" repo;
  yamlFormat = pkgs.formats.yaml { };
  plakarCfg = config.services.plakar;

  hasDeclarativeConfig =
    plakarCfg.stores != { }
    || plakarCfg.sources != { }
    || plakarCfg.destinations != { }
    || plakarCfg.defaultStore != null;

  plakarConfigDir = pkgs.runCommand "plakar-config" { } ''
    mkdir -p "$out/plakar"
    cp ${
      yamlFormat.generate "stores.yml" (
        {
          version = "v1.0.0";
          stores = plakarCfg.stores;
        }
        // lib.optionalAttrs (plakarCfg.defaultStore != null) { default = plakarCfg.defaultStore; }
      )
    } "$out/plakar/stores.yml"
    cp ${
      yamlFormat.generate "sources.yml" {
        version = "v1.0.0";
        sources = plakarCfg.sources;
      }
    } "$out/plakar/sources.yml"
    cp ${
      yamlFormat.generate "destinations.yml" {
        version = "v1.0.0";
        destinations = plakarCfg.destinations;
      }
    } "$out/plakar/destinations.yml"
  '';

  configEnv = lib.optionalAttrs hasDeclarativeConfig { XDG_CONFIG_HOME = "${plakarConfigDir}"; };

  linkPlugins =
    home: plugins:
    lib.optionalString (plugins != [ ]) (
      lib.concatMapStringsSep "\n" (p: ''
        for dir in ${p}/share/plakar/plugins/*/*/; do
          api=$(basename "$(dirname "$dir")")
          pkg=$(basename "$dir")
          install -d "${home}/.local/share/plakar/plugins/$api" "${home}/.cache/plakar/plugins/$api"
          ln -sfT "$dir" "${home}/.local/share/plakar/plugins/$api/$pkg.ptar"
          ln -sfT "$dir" "${home}/.cache/plakar/plugins/$api/$pkg"
        done
      '') plugins
    );

  keyfileArg =
    file: lib.optionalString (file != null) " -keyfile \"$CREDENTIALS_DIRECTORY/passphrase\"";

  serverFlags = [
    "-listen"
    cfg.listenAddress
  ]
  ++ lib.optional cfg.allowDelete "-allow-delete"
  ++ lib.optionals (cfg.certFile != null) [
    "-cert"
    cfg.certFile
  ]
  ++ lib.optionals (cfg.keyFile != null) [
    "-key"
    cfg.keyFile
  ]
  ++ cfg.extraFlags;

  uiFlagsFor =
    ui:
    [
      "-addr"
      ui.listenAddress
      "-no-spawn"
    ]
    ++ lib.optional ui.noAuth "-no-auth"
    ++ lib.optional ui.cors "-cors"
    ++ lib.optionals (ui.certFile != null) [
      "-cert"
      ui.certFile
    ]
    ++ lib.optionals (ui.keyFile != null) [
      "-key"
      ui.keyFile
    ]
    ++ ui.extraFlags;

  pluginsOption = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [ ];
    example = lib.literalExpression "[ pkgs.plakar-plugin-s3 pkgs.plakar-plugin-sftp ]";
    description = ''
      Plakar integration packages to make available (e.g.
      `pkgs.plakar-plugin-s3`). Needed for store or source protocols that
      are not built into plakar itself (`s3://`, `sftp://`, ...). Each is
      symlinked into plakar's plugin directories before the service runs.
    '';
  };
in
{
  options.services.plakar = {
    stores = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
      default = { };
      example = lib.literalExpression ''
        {
          main = {
            location = "s3://minio.local:9000/backups";
            passphrase_cmd = "cat /run/secrets/plakar-pass";
          };
        }
      '';
      description = ''
        Named Kloset stores, written to stores.yml and referenceable as
        `@name` in any `repository` option. Values are freeform per the
        plakar config format. Keep secrets out of the Nix store by using
        `passphrase_cmd` (e.g. `cat /run/secrets/...`) instead of an
        inline `passphrase`, and connector credentials via
        {option}`environmentFile`.
      '';
    };

    defaultStore = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      description = "Name of the store in {option}`stores` to use when no repository is given.";
    };

    sources = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
      default = { };
      description = "Named backup sources, written to sources.yml.";
    };

    destinations = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
      default = { };
      description = "Named restore destinations, written to destinations.yml.";
    };

    server = {
      enable = lib.mkEnableOption "Plakar server, serving a Kloset store over the network";

      package = lib.mkPackageOption pkgs "plakar" { };

      repository = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/plakar/store";
        example = "s3://minio.example.org:9000/backups";
        description = ''
          The Kloset store to serve: a local path, a store URL (`s3://`,
          `sftp://`, ... via {option}`plugins`) or a `@name` reference.
        '';
      };

      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1:9876";
        example = "0.0.0.0:9876";
        description = "Address and port to listen on.";
      };

      allowDelete = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Allow destructive object-level operations (as performed by
          `plakar maintenance`). Disabled by default so a compromised
          client cannot reclaim space; clients can still mark snapshots
          as deleted. Run `plakar maintenance` on the server instead.
        '';
      };

      passphraseFile = lib.mkOption {
        type = with lib.types; nullOr path;
        default = null;
        example = "/run/secrets/plakar-passphrase";
        description = ''
          File containing the store passphrase, exposed as
          `-keyfile` from a systemd credential (never via the process
          environment). Only used by
          {option}`initialize` to create an encrypted store; the server
          never decrypts data. If null, the store is created plaintext.
        '';
      };

      environmentFile = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          EnvironmentFile with extra credentials needed to open the store
          (e.g. S3 keys for an `s3://` repository), see
          {manpage}`systemd.exec(5)`.
        '';
      };

      initialize = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Create the store on first start if it does not exist. Applies to local paths and `@name` references (not literal remote URLs).";
      };

      plaintext = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Create the store unencrypted (`-plaintext`) when
          {option}`initialize` runs. When false (the default), the store
          is encrypted using the passphrase from its `passphrase_cmd`
          (declarative {option}`stores`) or {option}`passphraseFile`.
        '';
      };

      certFile = lib.mkOption {
        type = with lib.types; nullOr path;
        default = null;
        description = "PEM certificate chain, enabling HTTPS together with {option}`keyFile`.";
      };

      keyFile = lib.mkOption {
        type = with lib.types; nullOr path;
        default = null;
        description = "PEM private key for {option}`certFile`.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open the {option}`listenAddress` port in the firewall.";
      };

      plugins = pluginsOption;

      extraFlags = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Extra arguments for `plakar server`.";
      };
    };

    ui = lib.mkOption {
      default = { };
      description = "Web UI instances, one per Kloset store.";
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            package = lib.mkPackageOption pkgs "plakar" { };

            repository = lib.mkOption {
              type = lib.types.str;
              default = "/var/lib/plakar/store";
              description = "The Kloset store to browse. Unlike the server, the UI decrypts data and thus needs {option}`passphraseFile`.";
            };

            listenAddress = lib.mkOption {
              type = lib.types.str;
              example = "127.0.0.1:8080";
              description = "Address and port for this UI to listen on. Must be unique across instances.";
            };

            passphraseFile = lib.mkOption {
              type = with lib.types; nullOr path;
              default = null;
              description = "File with the store passphrase, passed via `-keyfile` from a systemd credential. Required for encrypted stores, since the UI decrypts snapshots.";
            };

            tokenFile = lib.mkOption {
              type = with lib.types; nullOr path;
              default = null;
              description = ''
                File containing the API auth token, exposed as
                `PLAKAR_UI_TOKEN`. Recommended for a headless service. If
                null and {option}`noAuth` is false, plakar generates a
                random token only printed at startup (inaccessible).
              '';
            };

            noAuth = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Disable the auth token (`-no-auth`). Only sensible behind a trusted reverse proxy.";
            };

            cors = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Enable CORS (`-cors`).";
            };

            environmentFile = lib.mkOption {
              type = with lib.types; nullOr str;
              default = null;
              description = "EnvironmentFile with extra credentials to open the store (e.g. S3 keys).";
            };

            certFile = lib.mkOption {
              type = with lib.types; nullOr path;
              default = null;
              description = "PEM certificate chain, enabling HTTPS together with {option}`keyFile`.";
            };

            keyFile = lib.mkOption {
              type = with lib.types; nullOr path;
              default = null;
              description = "PEM private key for {option}`certFile`.";
            };

            openFirewall = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Open the {option}`listenAddress` port in the firewall.";
            };

            plugins = pluginsOption;

            extraFlags = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "Extra arguments for `plakar ui`.";
            };
          };
        }
      );
    };

    backups = lib.mkOption {
      default = { };
      description = "Periodic backups to create with Plakar.";
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              repository = lib.mkOption {
                type = lib.types.str;
                example = "http://backup-server:9876";
                description = "Kloset store to back up to.";
              };

              passphraseFile = lib.mkOption {
                type = with lib.types; nullOr path;
                default = null;
                description = "File with the store passphrase, passed via `-keyfile` from a systemd credential. Prefer a declarative store with `passphrase_cmd` instead.";
              };

              environmentFile = lib.mkOption {
                type = with lib.types; nullOr str;
                default = null;
                description = "EnvironmentFile with extra credentials (e.g. S3 keys), see {manpage}`systemd.exec(5)`.";
              };

              paths = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                example = [ "/home" ];
                description = "Paths to back up into a single snapshot. Empty means no backup (prune/maintenance-only job).";
              };

              excludes = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                example = [ "*/.cache" ];
                description = "Gitignore-style patterns, passed as repeated `-ignore` flags.";
              };

              tags = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = "Tags to apply to the snapshot.";
              };

              initialize = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Create the store with `plakar create` if it cannot be opened.";
              };

              plaintext = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Create stores unencrypted (`-plaintext`). When false, encryption uses the store's `passphrase_cmd` or {option}`passphraseFile`.";
              };

              checkAfterBackup = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Pass `-check` to `plakar backup` to verify the snapshot.";
              };

              pruneOpts = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                example = [ "-days 30" ];
                description = ''
                  Options for `plakar prune -apply`, run after the backup.
                  Pruning only marks snapshots deleted; space is reclaimed
                  by {option}`runMaintenance`.
                '';
              };

              runMaintenance = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = ''
                  Run `plakar maintenance` after the backup to reclaim
                  space. Requires the store directly or a server started
                  with `allowDelete = true`.
                '';
              };

              syncTo = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                example = [ "@s3" ];
                description = ''
                  Peer repositories to replicate to after the backup,
                  each via `plakar at <repository> sync to <peer>`. Use
                  `@name` references so the peer's passphrase
                  (`passphrase_cmd`) is resolved from {option}`stores` —
                  no separate passphrase handling needed. With
                  {option}`initialize`, a missing peer is created first
                  (it must have a `passphrase_cmd`). A job may set only
                  `syncTo` (no {option}`paths`) to act as a pure
                  replication job.
                '';
              };

              timerConfig = lib.mkOption {
                type = with lib.types; nullOr (attrsOf unitOption);
                default = {
                  OnCalendar = "daily";
                  Persistent = true;
                };
                example = {
                  OnCalendar = "00:05";
                  RandomizedDelaySec = "5h";
                };
                description = "When to run, see {manpage}`systemd.timer(5)`. Null disables the timer.";
              };

              user = lib.mkOption {
                type = lib.types.str;
                default = "root";
                description = "User the backup runs as.";
              };

              inhibitsSleep = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Prevent the system from sleeping while backing up.";
              };

              extraBackupArgs = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = "Extra arguments for `plakar backup`.";
              };

              plugins = pluginsOption;

              backupPrepareCommand = lib.mkOption {
                type = with lib.types; nullOr str;
                default = null;
                description = "Script to run before the backup.";
              };

              backupCleanupCommand = lib.mkOption {
                type = with lib.types; nullOr str;
                default = null;
                description = "Script to run after the backup.";
              };

              package = lib.mkPackageOption pkgs "plakar" { };

              createWrapper = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Generate a `plakar-${name}` wrapper with the same repository and passphrase environment.";
              };
            };
          }
        )
      );
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = (cfg.certFile == null) == (cfg.keyFile == null);
          message = "services.plakar.server: certFile and keyFile must be set together.";
        }
      ];

      systemd.services.plakar-server = {
        description = "Plakar Server";
        after = [ "network.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        path = [ config.programs.ssh.package ];

        environment = {
          HOME = "/var/lib/plakar";
        }
        // configEnv;

        preStart = ''
          ${linkPlugins "/var/lib/plakar" cfg.plugins}
        ''
        +
          lib.optionalString
            (cfg.initialize && (isLocalRepo cfg.repository || lib.hasPrefix "@" cfg.repository))
            ''
              if ! ${lib.getExe cfg.package} at ${lib.escapeShellArg cfg.repository} info >/dev/null 2>&1; then
                ${lib.getExe cfg.package}${keyfileArg cfg.passphraseFile} at ${lib.escapeShellArg cfg.repository} create \
                  ${lib.optionalString cfg.plaintext "-plaintext"}
              fi
            '';

        script = ''
          exec ${lib.getExe cfg.package} at ${lib.escapeShellArg cfg.repository} \
            server ${lib.escapeShellArgs serverFlags}
        '';

        serviceConfig = {
          Type = "exec";
          User = "plakar";
          Group = "plakar";
          Restart = "on-failure";
          StateDirectory = "plakar";
          LoadCredential = lib.optional (cfg.passphraseFile != null) "passphrase:${cfg.passphraseFile}";
          EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;

          CapabilityBoundingSet = "";
          LockPersonality = true;
          NoNewPrivileges = true;
          PrivateTmp = true;
          PrivateDevices = true;
          ProtectClock = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectControlGroups = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          ReadWritePaths = lib.optional (isLocalRepo cfg.repository) cfg.repository;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
          ];
          UMask = "0027";
        };
      };

      systemd.tmpfiles.rules = lib.mkIf (isLocalRepo cfg.repository) [
        "d ${cfg.repository} 0750 plakar plakar -"
      ];

      networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
        (lib.toInt (lib.last (lib.splitString ":" cfg.listenAddress)))
      ];

      users.users.plakar = {
        isSystemUser = true;
        group = "plakar";
        home = "/var/lib/plakar";
      };
      users.groups.plakar = { };
    })

    {
      assertions = lib.mapAttrsToList (name: ui: {
        assertion = (ui.certFile == null) == (ui.keyFile == null);
        message = "services.plakar.ui.${name}: certFile and keyFile must be set together.";
      }) config.services.plakar.ui;

      systemd.services = lib.mapAttrs' (
        name: ui:
        lib.nameValuePair "plakar-ui-${name}" {
          description = "Plakar Web UI: ${name}";
          after = [ "network.target" ];
          wants = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];

          path = [ config.programs.ssh.package ];

          environment = {
            HOME = "/var/lib/plakar";
          }
          // configEnv;

          preStart = linkPlugins "/var/lib/plakar" ui.plugins;

          script = ''
            ${lib.optionalString (ui.tokenFile != null) ''
              PLAKAR_UI_TOKEN="$(cat "$CREDENTIALS_DIRECTORY/token")"
              export PLAKAR_UI_TOKEN
            ''}
            exec ${lib.getExe ui.package}${keyfileArg ui.passphraseFile} at ${lib.escapeShellArg ui.repository} \
              ui ${lib.escapeShellArgs (uiFlagsFor ui)}
          '';

          serviceConfig = {
            Type = "exec";
            User = "plakar";
            Group = "plakar";
            Restart = "on-failure";
            StateDirectory = "plakar";
            LoadCredential =
              lib.optional (ui.passphraseFile != null) "passphrase:${ui.passphraseFile}"
              ++ lib.optional (ui.tokenFile != null) "token:${ui.tokenFile}";
            EnvironmentFile = lib.mkIf (ui.environmentFile != null) ui.environmentFile;

            CapabilityBoundingSet = "";
            LockPersonality = true;
            NoNewPrivileges = true;
            PrivateTmp = true;
            PrivateDevices = true;
            ProtectClock = true;
            ProtectHome = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectControlGroups = true;
            ProtectProc = "invisible";
            ProtectSystem = "strict";
            ReadWritePaths = lib.optional (isLocalRepo ui.repository) ui.repository;
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
              "AF_UNIX"
            ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            SystemCallArchitectures = "native";
            SystemCallFilter = [
              "@system-service"
              "~@privileged"
            ];
            UMask = "0027";
          };
        }
      ) config.services.plakar.ui;

      networking.firewall.allowedTCPPorts = lib.pipe config.services.plakar.ui [
        (lib.filterAttrs (_: ui: ui.openFirewall))
        (lib.mapAttrsToList (_: ui: lib.toInt (lib.last (lib.splitString ":" ui.listenAddress))))
      ];

      users.users.plakar = lib.mkIf (config.services.plakar.ui != { }) {
        isSystemUser = true;
        group = "plakar";
        home = "/var/lib/plakar";
      };
      users.groups.plakar = lib.mkIf (config.services.plakar.ui != { }) { };
    }

    {
      systemd.services = lib.mapAttrs' (
        name: backup:
        let
          home = "/var/lib/plakar-backups-${name}";
          backupFlags =
            lib.optional backup.checkAfterBackup "-check"
            ++ lib.optionals (backup.tags != [ ]) [
              "-tag"
              (lib.concatStringsSep "," backup.tags)
            ]
            ++ lib.concatMap (p: [
              "-ignore"
              p
            ]) backup.excludes
            ++ backup.extraBackupArgs;
          plakarBin = "${lib.getExe backup.package}${keyfileArg backup.passphraseFile}";
          plakarAt = "${plakarBin} at ${lib.escapeShellArg backup.repository}";
          inhibit = lib.optionalString backup.inhibitsSleep "${pkgs.systemd}/bin/systemd-inhibit --who=plakar --why=${lib.escapeShellArg "Backup ${name}"} ";
        in
        lib.nameValuePair "plakar-backups-${name}" {
          description = "Plakar backup: ${name}";
          wants = [ "network-online.target" ];
          after = [ "network-online.target" ];
          restartIfChanged = false;

          path = [ config.programs.ssh.package ];

          environment = {
            HOME = home;
          }
          // configEnv;

          serviceConfig = {
            Type = "oneshot";
            User = backup.user;
            StateDirectory = "plakar-backups-${name}";
            StateDirectoryMode = "0700";
            PrivateTmp = true;
            LoadCredential = lib.optional (backup.passphraseFile != null) "passphrase:${backup.passphraseFile}";
          }
          // lib.optionalAttrs (backup.environmentFile != null) {
            EnvironmentFile = backup.environmentFile;
          };

          script = ''
            set -eu
            ${linkPlugins home backup.plugins}
            ${lib.optionalString (backup.backupPrepareCommand != null) (
              pkgs.writeShellScript "plakar-${name}-prepare" backup.backupPrepareCommand
            )}
            ${lib.optionalString backup.initialize ''
              if ! ${plakarAt} info >/dev/null 2>&1; then
                ${plakarAt} create ${lib.optionalString backup.plaintext "-plaintext"}
              fi
            ''}
            ${lib.optionalString (backup.paths != [ ]) ''
              ${inhibit}${plakarAt} backup ${lib.escapeShellArgs backupFlags} ${lib.escapeShellArgs backup.paths}
            ''}
            ${lib.optionalString (backup.pruneOpts != [ ]) ''
              ${plakarAt} prune -apply ${lib.concatStringsSep " " backup.pruneOpts}
            ''}
            ${lib.optionalString backup.runMaintenance ''
              ${plakarAt} maintenance
            ''}
            ${lib.concatMapStringsSep "\n" (peer: ''
              ${lib.optionalString backup.initialize ''
                ${plakarBin} at ${lib.escapeShellArg peer} info >/dev/null 2>&1 \
                  || ${plakarBin} at ${lib.escapeShellArg peer} create ${lib.optionalString backup.plaintext "-plaintext"}
              ''}
              ${plakarAt} sync to ${lib.escapeShellArg peer}
            '') backup.syncTo}
          '';

          postStop = lib.optionalString (backup.backupCleanupCommand != null) (
            pkgs.writeShellScript "plakar-${name}-cleanup" backup.backupCleanupCommand
          );
        }
      ) config.services.plakar.backups;

      systemd.timers = lib.mapAttrs' (
        name: backup:
        lib.nameValuePair "plakar-backups-${name}" {
          wantedBy = [ "timers.target" ];
          inherit (backup) timerConfig;
          unitConfig.X-OnlyManualStart = true;
        }
      ) (lib.filterAttrs (_: b: b.timerConfig != null) config.services.plakar.backups);

      environment.systemPackages = lib.mapAttrsToList (
        name: backup:
        pkgs.writeShellScriptBin "plakar-${name}" ''
          set -eu
          ${lib.optionalString (backup.environmentFile != null) "source ${backup.environmentFile}"}
          ${lib.pipe config.systemd.services."plakar-backups-${name}".environment [
            (lib.filterAttrs (n: v: v != null && n != "PATH"))
            (lib.mapAttrsToList (n: v: "export ${n}=${lib.escapeShellArg (toString v)}"))
            (lib.concatStringsSep "\n")
          ]}
          export PATH=${config.systemd.services."plakar-backups-${name}".environment.PATH}:$PATH
          exec ${lib.getExe backup.package}${
            lib.optionalString (
              backup.passphraseFile != null
            ) " -keyfile ${lib.escapeShellArg (toString backup.passphraseFile)}"
          } at ${lib.escapeShellArg backup.repository} "$@"
        ''
      ) (lib.filterAttrs (_: v: v.createWrapper) config.services.plakar.backups);
    }
  ];

  meta.maintainers = with lib.maintainers; [ liberodark ];
}

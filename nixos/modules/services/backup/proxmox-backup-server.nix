{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.proxmox-backup-server;
  package = cfg.package;

  # When a custom cert is configured, install it at the paths PBS reads
  # (/etc/proxmox-backup/proxy.{pem,key}). proxmox-backup-api only generates a
  # self-signed cert when those are missing, so placing them before it starts
  # makes PBS use ours; leaving them unset falls back to the self-signed cert.
  tlsManaged = cfg.sslCertificate != null;
  installCert = pkgs.writeShellApplication {
    name = "proxmox-backup-install-cert";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      install -m 0640 -o proxmox-backup-server -g proxmox-backup-server \
        ${lib.escapeShellArg (toString cfg.sslCertificate)} /etc/proxmox-backup/proxy.pem
      install -m 0600 -o proxmox-backup-server -g proxmox-backup-server \
        ${lib.escapeShellArg (toString cfg.sslCertificateKey)} /etc/proxmox-backup/proxy.key
    '';
  };

  # Freeform escape hatch: any extra `--flag value` pairs PBS accepts that the
  # module does not expose as a first-class option. Keys are used verbatim as the
  # flag name (so use the kebab-case PBS spelling, e.g. `keep-daily`).
  settingsType = lib.types.attrsOf (
    lib.types.nullOr (
      lib.types.oneOf [
        lib.types.bool
        lib.types.int
        lib.types.str
      ]
    )
  );

  settingsOption = lib.mkOption {
    type = settingsType;
    default = { };
    example = {
      keep-daily = 7;
      keep-weekly = 4;
    };
    description = ''
      Extra options passed verbatim to `proxmox-backup-manager <res> create/update`
      as `--<key> <value>`. Use the kebab-case spelling PBS expects. A `null`
      value drops the flag; a boolean renders as `--<key> true|false`.
    '';
  };

  datastoreModule = lib.types.submodule {
    options = {
      path = lib.mkOption {
        type = lib.types.str;
        example = "/mnt/backup/main";
        description = ''
          Absolute filesystem path for the datastore's chunk store. The parent
          directory must already exist (e.g. mounted via `fileSystems`). The path
          is only applied at creation time; it cannot be changed afterward.
        '';
      };
      comment = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Optional description shown in the UI.";
      };
      gcSchedule = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "daily";
        description = "Garbage-collection schedule (systemd calendar event), e.g. `daily`.";
      };
      settings = settingsOption;
    };
  };

  jobModule = lib.types.submodule {
    options = {
      datastore = lib.mkOption {
        type = lib.types.str;
        description = "Datastore this job operates on (passed as `--store`).";
      };
      schedule = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "daily";
        description = "Run schedule (systemd calendar event).";
      };
      comment = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Optional description shown in the UI.";
      };
      disable = lib.mkOption {
        type = lib.types.nullOr lib.types.bool;
        default = null;
        description = "Whether the job is disabled.";
      };
      settings = settingsOption;
    };
  };

  # Render a {flag = value} set into shell-escaped `--flag value` array elements,
  # dropping nulls. Booleans become `--flag true|false`.
  renderArgs =
    flags:
    lib.concatStringsSep " " (
      lib.flatten (
        lib.mapAttrsToList (
          flag: val:
          if val == null then
            [ ]
          else if lib.isBool val then
            [
              "--${flag}"
              (lib.boolToString val)
            ]
          else
            [
              "--${flag}"
              (lib.escapeShellArg (toString val))
            ]
        ) flags
      )
    );

  # Ensure-and-update: create the resource if `show` fails, otherwise update it to
  # match. PBS `update` is idempotent, so re-running is a no-op when nothing drifted.
  mkBlock =
    {
      kind,
      id,
      positional,
      flags,
    }:
    let
      idArg = lib.escapeShellArg id;
      argsStr = renderArgs flags;
    in
    ''
      args=( ${argsStr} )
      if proxmox-backup-manager ${kind} show ${idArg} >/dev/null 2>&1; then
        echo "  update ${kind} ${id}"
        proxmox-backup-manager ${kind} update ${idArg} "''${args[@]}"
      else
        echo "  create ${kind} ${id}"
        proxmox-backup-manager ${kind} create ${positional} "''${args[@]}"
      fi
    '';

  datastoreBlocks = lib.mapAttrsToList (
    name: d:
    mkBlock {
      kind = "datastore";
      id = name;
      positional = "${lib.escapeShellArg name} ${lib.escapeShellArg d.path}";
      flags = {
        comment = d.comment;
        "gc-schedule" = d.gcSchedule;
      }
      // d.settings;
    }
  ) cfg.ensureDatastores;

  mkJobBlocks =
    kind: jobs:
    lib.mapAttrsToList (
      name: j:
      mkBlock {
        inherit kind;
        id = name;
        positional = lib.escapeShellArg name;
        flags = {
          store = j.datastore;
          schedule = j.schedule;
          comment = j.comment;
          disable = j.disable;
        }
        // j.settings;
      }
    ) jobs;

  # Datastores first (jobs reference them), then the job types.
  reconcileBlocks =
    datastoreBlocks
    ++ mkJobBlocks "prune-job" cfg.ensurePruneJobs
    ++ mkJobBlocks "verify-job" cfg.ensureVerifyJobs
    ++ mkJobBlocks "sync-job" cfg.ensureSyncJobs;

  hasDeclaredConfig = reconcileBlocks != [ ];

  reconcileScript = pkgs.writeShellApplication {
    name = "proxmox-backup-setup";
    runtimeInputs = [ package ];
    text = ''
      # The API daemon (proxmox-backup.service) sends sd_notify(READY) before this
      # oneshot runs, but give it a few retries in case it is still warming up.
      for ((i = 0; i < 30; i++)); do
        if proxmox-backup-manager datastore list >/dev/null 2>&1; then
          break
        fi
        sleep 1
      done

      ${lib.concatStringsSep "\n" reconcileBlocks}
    '';
  };

  # Warn (don't fail) when a job points at a datastore the module doesn't manage:
  # it might be created in the GUI, so this is informational only.
  declaredStores = lib.attrNames cfg.ensureDatastores;
  jobStoreRefs =
    lib.mapAttrsToList (name: j: {
      inherit name;
      kind = "prune";
      store = j.datastore;
    }) cfg.ensurePruneJobs
    ++ lib.mapAttrsToList (name: j: {
      inherit name;
      kind = "verify";
      store = j.datastore;
    }) cfg.ensureVerifyJobs
    ++ lib.mapAttrsToList (name: j: {
      inherit name;
      kind = "sync";
      store = j.datastore;
    }) cfg.ensureSyncJobs;
  danglingJobs = lib.filter (r: !(lib.elem r.store declaredStores)) jobStoreRefs;
in
{
  options.services.proxmox-backup-server = {
    enable = lib.mkEnableOption "Proxmox Backup Server";

    package = lib.mkPackageOption pkgs "proxmox-backup-server" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open TCP port 8007 for the Proxmox Backup web/API proxy.";
    };

    sslCertificate = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/pbs/cert.pem";
      description = ''
        Path to a PEM certificate (chain) to serve on the web/API port. When set
        (together with {option}`sslCertificateKey`) it is copied to
        `/etc/proxmox-backup/proxy.pem` before the daemons start. When `null`, PBS
        falls back to the self-signed certificate it generates on first start.
      '';
    };

    sslCertificateKey = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/pbs/key.pem";
      description = ''
        Path to the PEM private key matching {option}`sslCertificate`, copied to
        `/etc/proxmox-backup/proxy.key`. Reference a path managed by your secrets
        tooling (agenix/sops-nix); do not point at a file in the world-readable
        Nix store.
      '';
    };

    ensureDatastores = lib.mkOption {
      type = lib.types.attrsOf datastoreModule;
      default = { };
      example = lib.literalExpression ''
        {
          main = {
            path = "/mnt/backup/main";
            comment = "Primary store";
            gcSchedule = "daily";
          };
        }
      '';
      description = ''
        Datastores to reconcile on activation. Each entry is created (chunk store
        and config) if missing, otherwise updated to match. Datastores you create
        in the GUI but do not declare here are left untouched.
      '';
    };

    ensurePruneJobs = lib.mkOption {
      type = lib.types.attrsOf jobModule;
      default = { };
      example = lib.literalExpression ''
        {
          main-prune = {
            datastore = "main";
            schedule = "daily";
            settings = { keep-daily = 7; keep-weekly = 4; };
          };
        }
      '';
      description = "Prune jobs to reconcile on activation (`proxmox-backup-manager prune-job`).";
    };

    ensureVerifyJobs = lib.mkOption {
      type = lib.types.attrsOf jobModule;
      default = { };
      example = lib.literalExpression ''
        {
          main-verify = {
            datastore = "main";
            schedule = "sun 02:00";
          };
        }
      '';
      description = "Verification jobs to reconcile on activation (`proxmox-backup-manager verify-job`).";
    };

    ensureSyncJobs = lib.mkOption {
      type = lib.types.attrsOf jobModule;
      default = { };
      example = lib.literalExpression ''
        {
          main-sync = {
            datastore = "main";
            schedule = "03:00";
            settings = { remote = "site-b"; remote-store = "main"; };
          };
        }
      '';
      description = ''
        Sync jobs to reconcile on activation (`proxmox-backup-manager sync-job`).
        Remote-backed jobs require their `remote` to already exist (remotes are not
        managed by this module yet); set it via `settings.remote` /
        `settings."remote-store"`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.proxmox-backup-server = { };
    users.users.proxmox-backup-server = {
      isSystemUser = true;
      group = "proxmox-backup-server";
      extraGroups = [ "tape" ];
      home = "/var/lib/proxmox-backup";
      createHome = true;
    };

    environment.systemPackages = [ package ];

    security.pam.services.proxmox-backup-auth = { };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ 8007 ];

    systemd.tmpfiles.rules = [
      "d /etc/proxmox-backup 0700 proxmox-backup-server proxmox-backup-server - -"
      "d /var/lib/proxmox-backup 0750 proxmox-backup-server proxmox-backup-server - -"
      "d /var/log/proxmox-backup 0750 proxmox-backup-server proxmox-backup-server - -"
      "d /var/log/proxmox-backup/api 0750 proxmox-backup-server proxmox-backup-server - -"
      "d /var/cache/proxmox-backup 0750 proxmox-backup-server proxmox-backup-server - -"
      "d /run/proxmox-backup 0750 proxmox-backup-server proxmox-backup-server - -"
    ];

    systemd.services.proxmox-backup = {
      description = "Proxmox Backup API Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      # Re-copy + restart (so PBS re-reads the cert) when the source files change.
      restartTriggers = lib.mkIf tlsManaged [
        cfg.sslCertificate
        cfg.sslCertificateKey
      ];
      serviceConfig = {
        Type = "notify";
        # The daemon is FHS-wrapped (bwrap) by the package, so the process that
        # sends sd_notify(READY=1) is a child of the ExecStart process; allow it.
        NotifyAccess = "all";
        # Copy the custom cert into place (as root, before the daemon starts) so
        # proxmox-backup-api uses it instead of generating a self-signed one.
        ExecStartPre = lib.mkIf tlsManaged (lib.getExe installCert);
        ExecStart = "${package}/libexec/proxmox-backup/proxmox-backup-api";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        PIDFile = "/run/proxmox-backup/api.pid";
        Restart = "on-failure";
      };
    };

    systemd.services.proxmox-backup-proxy = {
      description = "Proxmox Backup API Proxy Server";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "proxmox-backup.service"
      ];
      requires = [ "proxmox-backup.service" ];
      # proxmox-backup.service copies the cert in its ExecStartPre and is ordered
      # first; restart the proxy too so it re-reads a renewed cert.
      restartTriggers = lib.mkIf tlsManaged [
        cfg.sslCertificate
        cfg.sslCertificateKey
      ];
      serviceConfig = {
        Type = "notify";
        NotifyAccess = "all";
        ExecStart = "${package}/libexec/proxmox-backup/proxmox-backup-proxy";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        PIDFile = "/run/proxmox-backup/proxy.pid";
        Restart = "on-failure";
        User = "proxmox-backup-server";
        Group = "proxmox-backup-server";
      };
    };

    systemd.services.proxmox-backup-daily-update = {
      description = "Proxmox Backup daily update jobs";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${package}/libexec/proxmox-backup/proxmox-daily-update";
      };
    };

    systemd.timers.proxmox-backup-daily-update = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-* 02:15:00";
        RandomizedDelaySec = "1h";
        Persistent = true;
      };
    };

    # Reconcile declared datastores and prune/verify/sync jobs once the API daemon
    # is up. Runs as root: proxmox-backup-manager connects to the local API daemon
    # using the privileged auth key in /etc/proxmox-backup.
    systemd.services.proxmox-backup-setup = lib.mkIf hasDeclaredConfig {
      description = "Reconcile declarative Proxmox Backup config";
      wantedBy = [ "multi-user.target" ];
      after = [ "proxmox-backup.service" ];
      requires = [ "proxmox-backup.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = lib.getExe reconcileScript;
      };
    };

    assertions = [
      {
        assertion = (cfg.sslCertificate == null) == (cfg.sslCertificateKey == null);
        message = "services.proxmox-backup-server: set both sslCertificate and sslCertificateKey, or neither.";
      }
    ];

    warnings = map (
      r:
      "services.proxmox-backup-server: ${r.kind} job '${r.name}' references datastore "
      + "'${r.store}', which is not declared in services.proxmox-backup-server.ensureDatastores; "
      + "assuming it is managed externally."
    ) danglingJobs;
  };

  meta.maintainers = with lib.maintainers; [ awildleon ];
}

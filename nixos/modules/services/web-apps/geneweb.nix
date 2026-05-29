{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.geneweb;
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    mkPackageOption
    types
    getExe'
    optional
    optionals
    optionalString
    flatten
    escapeShellArg
    escapeShellArgs
    mapAttrsToList
    concatStringsSep
    literalExpression
    ;

  defaultGwFile = pkgs.writeText "geneweb.gw" "";

  # Shared systemd hardening for both the server and the init service.
  #
  # gwd needs AF_UNIX for syslog (logs-syslog) on top of AF_INET/AF_INET6 for the
  # listener.
  #
  # MemoryDenyWriteExecute is intentionally left out: PCRE2 JIT (via the pcre2
  # dependency) may allocate W+X memory and trip it. UMask is left at the default
  # 0022: gwd requires its counter dir (<baseDir>/cnt) to be mode 755, and a
  # stricter umask makes it create that dir as 700 and abort at startup. The data
  # stays private through baseDir being 0750 (no traversal for "other").
  hardening = {
    NoNewPrivileges = true;
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateTmp = true;
    PrivateDevices = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectClock = true;
    ProtectHostname = true;
    ProtectProc = "invisible";
    RestrictAddressFamilies = [
      "AF_INET"
      "AF_INET6"
      "AF_UNIX"
    ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    LockPersonality = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = [ "@system-service" ];
    CapabilityBoundingSet = [ ];
    RemoveIPC = true;
  };
in
{
  options.services.geneweb = {
    enable = mkEnableOption "GeneWeb genealogy web server";

    package = mkPackageOption pkgs "geneweb" { };

    user = mkOption {
      type = types.str;
      default = "geneweb";
      description = "User account under which GeneWeb runs.";
    };

    group = mkOption {
      type = types.str;
      default = "geneweb";
      description = "Group account under which GeneWeb runs.";
    };

    baseDir = mkOption {
      type = types.path;
      default = "/var/lib/geneweb";
      description = "Directory where GeneWeb databases are stored.";
    };

    port = mkOption {
      type = types.port;
      default = 2317;
      description = "TCP port for the HTTP server.";
    };

    interface = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Network interface to bind to.";
    };

    defaultLang = mkOption {
      type = types.str;
      default = "en";
      description = "Default language for the web interface.";
    };

    cacheDatabases = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Databases to load in memory before starting the server.";
    };

    authorizationFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to authorization file (user:password lines).";
    };

    wizardPassword = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Password for administrative wizard access. This value ends up
        world-readable in the Nix store; prefer {option}`wizardPasswordFile`.
      '';
    };

    wizardPasswordFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        File holding the wizard password, staged through systemd
        `LoadCredential` and read at service start. Suitable for sops-nix or
        agenix. Note: gwd only accepts the password on its command line, so it
        remains visible in the process list, but it never enters the Nix store.
      '';
    };

    friendPassword = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Password for friend access. This value ends up world-readable in the
        Nix store; prefer {option}`friendPasswordFile`.
      '';
    };

    friendPasswordFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        File holding the friend password. See {option}`wizardPasswordFile` for
        the staging mechanism and caveats.
      '';
    };

    verbosity = mkOption {
      type = types.int;
      default = 6;
      description = "Logging detail level (higher = more verbose).";
    };

    nWorkers = mkOption {
      type = types.int;
      default = 20;
      description = "Number of worker processes.";
    };

    banThreshold = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "100,60";
      description = "Ban threshold: max requests, window in seconds.";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Extra command-line arguments passed to gwd.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open the HTTP port in the firewall.";
    };

    databases = mkOption {
      default = { };
      example = literalExpression ''
        {
          family = { };
          imported = { source = ./tree.gw; };
        }
      '';
      description = ''
        Databases to create declaratively. The attribute name is the base name
        (served at `?b=<name>`). An existing base is never modified.
      '';
      type = types.attrsOf (
        types.submodule {
          options.source = mkOption {
            type = types.nullOr types.path;
            default = null;
            description = ''
              A `.gw` file to import when creating the base. When null, an empty
              base is created.
            '';
          };
        }
      );
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.wizardPassword != null && cfg.wizardPasswordFile != null);
        message = "services.geneweb: set either wizardPassword or wizardPasswordFile, not both.";
      }
      {
        assertion = !(cfg.friendPassword != null && cfg.friendPasswordFile != null);
        message = "services.geneweb: set either friendPassword or friendPasswordFile, not both.";
      }
    ];

    users.users.${cfg.user} = {
      inherit (cfg) group;
      uid = config.ids.uids.${cfg.user} or null;
      home = cfg.baseDir;
      isSystemUser = true;
    };

    users.groups.${cfg.group} = { };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    systemd.tmpfiles.settings."10-geneweb".${cfg.baseDir}.d = {
      inherit (cfg) user group;
      mode = "0750";
    };

    systemd.services.geneweb = {
      description = "GeneWeb genealogy web server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = hardening // {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.baseDir;
        ReadWritePaths = [ cfg.baseDir ];
        LoadCredential =
          optional (cfg.wizardPasswordFile != null) "wizard-password:${cfg.wizardPasswordFile}"
          ++ optional (cfg.friendPasswordFile != null) "friend-password:${cfg.friendPasswordFile}";
        Restart = "on-failure";
        RestartSec = "5s";
        AmbientCapabilities = optional (cfg.port < 1024) "CAP_NET_BIND_SERVICE";
        CapabilityBoundingSet = optional (cfg.port < 1024) "CAP_NET_BIND_SERVICE";
      };

      script =
        let
          args = [
            "--base-dir"
            cfg.baseDir
            "--port"
            (toString cfg.port)
            "--default-lang"
            cfg.defaultLang
            "--verbosity"
            (toString cfg.verbosity)
            "--n-workers"
            (toString cfg.nWorkers)
          ]
          ++ optionals (cfg.interface != null) [
            "--interface"
            cfg.interface
          ]
          ++ optionals (cfg.authorizationFile != null) [
            "--authorization-file"
            cfg.authorizationFile
          ]
          ++ optionals (cfg.wizardPassword != null) [
            "--wizard-password"
            cfg.wizardPassword
          ]
          ++ optionals (cfg.friendPassword != null) [
            "--friend-password"
            cfg.friendPassword
          ]
          ++ optionals (cfg.banThreshold != null) [
            "--ban-threshold"
            cfg.banThreshold
          ]
          ++ flatten (
            map (db: [
              "--cache-database"
              db
            ]) cfg.cacheDatabases
          )
          ++ cfg.extraArgs;

          credentialArgs =
            optionalString (
              cfg.wizardPasswordFile != null
            ) " --wizard-password \"$(cat \"$CREDENTIALS_DIRECTORY/wizard-password\")\""
            + optionalString (
              cfg.friendPasswordFile != null
            ) " --friend-password \"$(cat \"$CREDENTIALS_DIRECTORY/friend-password\")\"";
        in
        ''
          exec ${getExe' cfg.package "gwd"} ${escapeShellArgs args}${credentialArgs}
        '';
    };

    systemd.services.geneweb-init = mkIf (cfg.databases != { }) {
      description = "Create declarative GeneWeb databases";
      before = [ "geneweb.service" ];
      requiredBy = [ "geneweb.service" ];
      after = [ "systemd-tmpfiles-setup.service" ];

      serviceConfig = hardening // {
        Type = "oneshot";
        RemainAfterExit = true;
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.baseDir;
        ReadWritePaths = [ cfg.baseDir ];
      };

      script =
        let
          # gwc looks up particles.txt relative to its own binary, which does
          # not match the dune-site install layout; point it at the real file.
          particlesFile = "${cfg.package}/share/geneweb/hd/etc/particles.txt";
        in
        concatStringsSep "\n" (
          mapAttrsToList (
            name: db:
            let
              source = if db.source != null then db.source else defaultGwFile;
            in
            ''
              if [ ! -e ${escapeShellArg "${cfg.baseDir}/${name}.gwb"} ]; then
                ${getExe' cfg.package "gwc"} -bd ${escapeShellArg cfg.baseDir} -o ${escapeShellArg name} -particles ${escapeShellArg particlesFile} ${escapeShellArg source}
              fi
            ''
          ) cfg.databases
        );
    };
  };
}

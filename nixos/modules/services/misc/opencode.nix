{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.opencode;

  inherit (lib)
    concatMap
    escapeShellArg
    escapeShellArgs
    filterAttrs
    mkIf
    mkOption
    mkPackageOption
    mkEnableOption
    nameValuePair
    optional
    types
    ;

  # opencode's configuration is JSONC, so the freeform option type and the
  # generator both come from the same format declaration.
  settingsFormat = pkgs.formats.json { };

  # Who the instance runs as, and whether this module owns that identity.
  # One rule, stated once: the unit, users.users and users.groups all read it from here.
  identityOf =
    name: server:
    let
      serviceName = "opencode-${name}";
      managedUser = server.user == null;
    in
    {
      user = if managedUser then serviceName else server.user;

      group =
        if server.group != null then
          server.group
        else if managedUser then
          serviceName
        else
          server.user;

      managedUser = managedUser;
      managedGroup = managedUser && server.group == null;

      stateDir = "/var/lib/opencode-${name}";
    };

  # opencode 2.x accepts exactly these, in lower case. null means "omit the flag".
  logLevels = [
    "all"
    "trace"
    "debug"
    "info"
    "warn"
    "warning"
    "error"
    "fatal"
    "none"
  ];

  mkLogLevelArg =
    name: level:
    if level == null then
      [ ]
    else
      let
        normalised = lib.toLower level;
      in
      if builtins.elem normalised logLevels then
        [ "--log-level" normalised ]
      else
        builtins.throw
          "services.opencode.servers.${name}.logLevel: \"${level}\" is not a log level opencode 2.x accepts. Use one of ${toString logLevels}, case-insensitively, or null for opencode's default.";

  mkArgv =
    name: server:
    [
      "serve"
      "--port" (toString server.port)
      "--hostname" server.bindHost
    ]
    ++ mkLogLevelArg name server.logLevel
    ++ optional server.printLogs "--print-logs"
    ++ concatMap (origin: [ "--cors" origin ]) server.corsOrigins;

  # opencode reads OPENCODE_PASSWORD and has no way to read a file itself.
  # One of the two sources must be turned into that variable before the process starts.
  mkSecret =
    server:
    let
      auth = server.authentication;
    in
    if auth.passwordFile != null then
      {
        export = "OPENCODE_PASSWORD";
        from.file = "$CREDENTIALS_DIRECTORY/opencode-password";
      }
    else
      {
        export = "OPENCODE_PASSWORD";
        from.literal = auth.password;
      };

  mkCredential =
    server:
    if server.authentication.passwordFile != null then
      {
        name = "opencode-password";
        path = server.authentication.passwordFile;
      }
    else
      null;

  # Credential delivery: one seam with two adapters chosen by precedence.
  # The unit never has to know which mode is in play.
  mkDelivery =
    name: command: secret: credential:
    let
      candidates = [
        {
          accepts = secret ? from.file;
          run = pkgs.writeShellScript "opencode-${name}" ''
            export ${secret.export}="$(cat "${secret.from.file}")"
            exec ${command}
          '';
          credential = credential;
        }
        {
          accepts = secret ? from.literal;
          # escapeShellArg prevents a single quote in the password from breaking the assignment.
          run = pkgs.writeShellScript "opencode-${name}" ''
            export ${secret.export}=${escapeShellArg secret.from.literal}
            exec ${command}
          '';
          credential = null;
        }
      ];
      chosen = lib.findFirst (a: a.accepts) (builtins.head candidates) candidates;
    in
    {
      execStart = toString chosen.run;
      loadCredential = chosen.credential;
    };

  # Environment as an ordered list so PATH is guaranteed last.
  # PATH=/run/current-system/sw/bin lets MCP servers find `nix`; it cannot be shadowed.
  # HOME is the state directory: opencode creates cache/config there, and a system
  # user's home (/var/empty) is not writable. The state directory is created by systemd.
  mkEnv =
    name: server: identity:
    let
      configDir = "/etc/opencode-${name}";
    in
    [ "XDG_DATA_HOME=${identity.stateDir}" ]
    ++ optional (server.settings != { }) "XDG_CONFIG_HOME=${configDir}"
    ++ [ "HOME=${identity.stateDir}" ]
    ++ concatMap (k: [ "${k}=${server.extraEnv.${k}}" ]) (builtins.attrNames server.extraEnv)
    ++ [ "PATH=/run/current-system/sw/bin" ];

  # Failing loudly beats a unit that starts and quietly serves nothing:
  # without a password opencode 2.x invents a random one and never prints it.
  mkAssertions = name: server: [
    {
      assertion = server.authentication.password != null || server.authentication.passwordFile != null;
      message = "services.opencode.servers.${name}: opencode 2.x always authenticates and has no unauthenticated mode, so set authentication.password or authentication.passwordFile. Without one the server invents a random password and never prints it, which locks every request out of it.";
    }
  ];

in
{
  options.services.opencode =
    let
      # Defaults for options that are facts about the install, not about one instance.
      # enable, user, group, authentication, settings are deliberately not shareable.
      shared = {
        workspaceDir = mkOption {
          type = types.path;
          default = "/";
          description = "Default project root for all server instances.";
        };

        port = mkOption {
          type = types.port;
          default = 4096;
          description = "Default HTTP listen port for all server instances.";
        };

        bindHost = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = "Default network interface for all server instances.";
        };

        corsOrigins = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Default allowed CORS origins for all server instances.";
        };

        logLevel = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Default log level for all server instances. Accepted values,
            case-insensitively: all, trace, debug, info, warn, warning, error,
            fatal, none. null uses opencode's own default.

            Anything else fails evaluation rather than the unit: opencode
            rejects an unknown level with an InvalidValue error, which
            crash-loops the service.
          '';
        };

        printLogs = mkOption {
          type = types.bool;
          default = false;
          description = "Default stderr logging for all server instances.";
        };

        extraEnv = mkOption {
          type = types.attrsOf types.str;
          default = { };
          description = "Default extra environment variables for all server instances.";
        };
      };
    in
    {
      package = mkPackageOption pkgs "opencode" {
        extraDescription = ''
          Must be opencode 2.x or newer: the generated command line and the
          log levels are 2.x vocabulary, and an older package fails evaluation
          rather than crashing the unit.

          Keep this equal to the version of the `opencode` CLI -- and of any
          other client -- that shares the same database: opencode runs its
          SQLite migrations on startup and does not tolerate a schema newer
          than the code writing to it. A server one minor behind its client
          fails every prompt with a NOT NULL constraint violation on
          `session_message.seq`.
        '';
      };

      defaultOptions = shared;

      servers = mkOption {
        type = types.attrsOf (
          types.submodule (
            { name, ... }:
            {
              options = {
                enable = mkEnableOption "opencode server instance";

                workspaceDir = mkOption {
                  type = types.path;
                  default = cfg.defaultOptions.workspaceDir;
                  description = ''
                    Project root the server runs in. opencode scopes sessions
                    and tools to the working directory, so this is the tree the
                    server will read and write.
                  '';
                };

                port = mkOption {
                  type = types.port;
                  default = cfg.defaultOptions.port;
                  description = "HTTP listen port.";
                };

                bindHost = mkOption {
                  type = types.str;
                  default = cfg.defaultOptions.bindHost;
                  description = "Network interface to bind to.";
                };

                corsOrigins = mkOption {
                  type = types.listOf types.str;
                  default = cfg.defaultOptions.corsOrigins;
                  description = ''
                    Allowed CORS origins, passed to `opencode serve --cors` once
                    each.
                  '';
                };

                logLevel = mkOption {
                  type = types.nullOr types.str;
                  default = cfg.defaultOptions.logLevel;
                  description = ''
                    Log level, accepted by `--log-level` case-insensitively:
                    all, trace, debug, info, warn, warning, error, fatal, none.
                    null uses opencode's own default.
                  '';
                };

                printLogs = mkOption {
                  type = types.bool;
                  default = cfg.defaultOptions.printLogs;
                  description = "Print logs to stderr, where the journal captures them.";
                };

                openFirewall = mkOption {
                  type = types.bool;
                  default = false;
                  description = ''
                    Open the firewall for the port this instance listens on.

                    The server speaks plain HTTP, and a password protects the
                    API rather than the endpoint, so leave this closed unless
                    the port is already behind TLS or a private network.
                  '';
                };

                settings = mkOption {
                  type = types.submodule {
                    freeformType = types.attrsOf settingsFormat.type;
                  };
                  default = { };
                  example = lib.literalExpression ''
                    {
                      model = "anthropic/claude-sonnet-4-20250514";
                      permissions = [
                        { action = "external_directory"; resource = "*"; effect = "ask"; }
                      ];
                    }
                  '';
                  description = ''
                    opencode configuration for this instance, written as
                    JSONC. Refer to the upstream documentation for the
                    available keys.

                    The service does not read the operator's own
                    `~/.config/opencode/opencode.jsonc`: its `HOME` is the state
                    directory, so a file in the invoking user's home is only
                    visible to a server you run yourself. Put what the server
                    should know here, or in an `opencode.jsonc` inside
                    {option}`workspaceDir`.
                  '';
                };

                extraEnv = mkOption {
                  type = types.attrsOf types.str;
                  default = cfg.defaultOptions.extraEnv;
                  description = ''
                    Extra environment variables for the service. Added after
                    the ones the module sets and before `PATH`.
                  '';
                };

                user = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  example = "opencode";
                  description = ''
                    System user the service runs as. When null, the module
                    creates `opencode-<name>` and runs the service as it.

                    Setting this hands both the user and the group back to
                    you: the module then creates neither, so both have to
                    exist already.
                  '';
                };

                group = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  description = ''
                    System group the service runs as. When null, the group is
                    the effective user's own group.

                    Setting this means the module creates no group, so it has
                    to exist already.
                  '';
                };

                authentication = mkOption {
                  description = ''
                    HTTP basic authentication for this server.

                    opencode 2.x has no unauthenticated mode: a server started
                    without a password generates a random one and never prints
                    it, which locks every API call out of the server, so one of
                    the two options below is required.
                  '';
                  default = { };
                  type = types.submodule {
                    options = {
                      password = mkOption {
                        type = types.nullOr types.str;
                        default = null;
                        description = ''
                          Password in plain text. Prefer
                          {option}`passwordFile`: this value is written into a
                          store path that the unit executes, which is
                          world-readable.
                        '';
                      };

                      passwordFile = mkOption {
                        type = types.nullOr types.path;
                        default = null;
                        example = "/run/secrets/opencode-password";
                        description = ''
                          Path to a file whose entire contents are the
                          password, for instance
                          `config.sops.secrets.<name>.path` under sops-nix.

                          The file is handed to the service through systemd's
                          `LoadCredential`, so the service needs no read access
                          to the secret itself and the password never appears
                          in the unit file. A sops secret owned by root and
                          unreadable by the service user is enough.

                          The basic-auth username is always `opencode`:
                          opencode 2.x removed `OPENCODE_SERVER_USERNAME` and
                          hardcodes it.
                        '';
                      };
                    };
                  };
                };
              };
            }
          )
        );
        default = { };
        example = lib.literalExpression ''
          {
            default.enable = true;
            work = {
              enable = true;
              port = 4097;
              workspaceDir = "/home/alice/project";
            };
          }
        '';
        description = ''
          Named opencode server instances. Each enabled entry produces the
          systemd service `opencode-<name>.service`, and, unless you set
          {option}`user`, the system user and group `opencode-<name>`.
        '';
      };
    };

  config =
    let
      enabled = filterAttrs (_: server: server.enable) cfg.servers;

      # Refuse packages older than 2.x at evaluation time.
      # opencode 1.x used a different --log-level vocabulary and still supported --mdns.
      isOpenCode2 =
        package:
        package == null
        || (
          let
            version = package.version or null;
          in
          version == null
          || lib.toInt (lib.versions.major version) >= 2
        );
    in
    mkIf (enabled != { }) {
      assertions =
        (lib.optional (!isOpenCode2 cfg.package) {
          message = ''
            services.opencode.package: ${cfg.package.name or "the given package"} is opencode ${
              cfg.package.version or "of unknown version"
            }, but this module requires opencode 2.x or newer. opencode 1.x takes a different --log-level vocabulary and still supports --mdns, both of which 2.x removed.
          '';
          assertion = false;
        })
        ++ lib.concatLists (lib.mapAttrsToList mkAssertions enabled);

      # Generated configuration is placed where opencode looks for it.
      environment.etc = lib.mapAttrs' (
        name: server:
        lib.nameValuePair "opencode-${name}/opencode/opencode.jsonc" {
          source = settingsFormat.generate "opencode-${name}-config.json" server.settings;
        }
      ) (filterAttrs (_: server: server.settings != { }) enabled);

      networking.firewall.allowedTCPPorts = lib.concatMap (
        server: lib.optional server.openFirewall server.port
      ) (lib.attrValues enabled);

      users.users = lib.mapAttrs' (
        name: server:
        let
          identity = identityOf name server;
        in
        lib.nameValuePair identity.user {
          isSystemUser = true;
          group = identity.group;
          home = identity.stateDir;
          # systemd's StateDirectory creates it with the right ownership at activation.
          createHome = false;
        }
      ) (filterAttrs (n: s: (identityOf n s).managedUser) enabled);

      users.groups = lib.mapAttrs' (
        name: server:
        let
          identity = identityOf name server;
        in
        lib.nameValuePair identity.group { }
      ) (filterAttrs (n: s: (identityOf n s).managedGroup) enabled);

      systemd.services = lib.mapAttrs' (
        name: server:
        let
          identity = identityOf name server;
          argv = mkArgv name server;
          command = "${lib.getExe cfg.package} ${escapeShellArgs argv}";
          delivered = mkDelivery name command (mkSecret server) (mkCredential server);
        in
        lib.nameValuePair "opencode-${name}" {
          description = "OpenCode Server: ${name}";
          wantedBy = [ "multi-user.target" ];
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];

          serviceConfig = {
            Type = "exec";
            # A default, not forced: caller can override in systemd.services."opencode-<name>".serviceConfig
            Restart = lib.mkDefault "on-failure";
            User = identity.user;
            Group = identity.group;
            ExecStart = delivered.execStart;

            LoadCredential = lib.optional (
              delivered.loadCredential != null
            ) "${delivered.loadCredential.name}:${toString delivered.loadCredential.path}";

            WorkingDirectory = toString server.workspaceDir;

            StateDirectory = "opencode-${name}";
            PrivateTmp = lib.mkDefault true;

            Environment = mkEnv name server identity;
          };
        }
      ) enabled;
    };

  meta = {
    maintainers = with lib.maintainers; [ gerrydoro ];
  };
}

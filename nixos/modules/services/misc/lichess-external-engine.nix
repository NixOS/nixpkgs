{ config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.lichess-external-engine;
in
{
  options = {
    services.lichess-external-engine = {
      enable = lib.mkEnableOption "Run a lichess.org external engine provider";

      package = lib.mkPackageOption pkgs "lichess-external-engine" { };

      engine = lib.mkOption {
        description = ''
          Shell command to launch a UCI engine. This is passed to the
          example provider's `--engine` flag and is evaluated by a shell,
          so you can pass a plain command (e.g. `stockfish`) or an absolute
          path (e.g. `${pkgs.stockfish}/bin/stockfish`).
        '';
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "${pkgs.stockfish}/bin/stockfish";
      };

      tokenFile = lib.mkOption {
        description = ''
          Path to a file containing the Lichess API token. This is the
          preferred way to provide credentials to the service; the file
          contents are loaded with systemd's LoadCredential and made
          available via `systemd-creds cat` at service start time.
        '';
        type = lib.types.nullOr lib.types.path;
        default = null;
      };

      token = lib.mkOption {
        description = ''
          Lichess API token as a string. Embedding secrets in the Nix
          configuration is discouraged; prefer `tokenFile`. If both are
          present, `token` takes precedence.
        '';
        type = lib.types.nullOr lib.types.str;
        default = null;
      };

      providerSecretFile = lib.mkOption {
        description = ''
          Path to a file containing an optional provider secret. If set,
          the file will be loaded via systemd's LoadCredential and exposed
          to the service as an environment variable at runtime.
        '';
        type = lib.types.nullOr lib.types.path;
        default = null;
      };

      providerSecret = lib.mkOption {
        description = ''
          Provider secret as a string. Embedding secrets in the Nix
          configuration is discouraged; prefer `providerSecretFile`.
        '';
        type = lib.types.nullOr lib.types.str;
        default = null;
      };

      name = lib.mkOption {
        description = "Engine name used when registering with lichess (the `--name` flag).";
        type = lib.types.nullOr lib.types.str;
        default = null;
      };

      maxThreads = lib.mkOption {
        description = "Maximum number of available threads to advertise to lichess (the `--max-threads` flag).";
        type = lib.types.nullOr lib.types.int;
        default = null;
      };

      maxHash = lib.mkOption {
        description = "Maximum hash table size in MiB (the `--max-hash` flag).";
        type = lib.types.int;
        default = 512;
      };

      keepAlive = lib.mkOption {
        description = "Seconds to keep an idle engine process alive (the `--keep-alive` flag).";
        type = lib.types.int;
        default = 300;
      };

      logLevel = lib.mkOption {
        description = ''
          Logging verbosity (the `--log-level` flag).
          Valid values are: "critical", "error", "warning", "info", "debug", "notset".
        '';
        type = lib.types.str;
        default = "info";
      };

      lichess = lib.mkOption {
        description = "URL of the lichess instance (defaults to https://lichess.org).";
        type = lib.types.str;
        default = "https://lichess.org";
      };

      broker = lib.mkOption {
        description = "URL of the lichess engine broker (defaults to https://engine.lichess.ovh).";
        type = lib.types.str;
        default = "https://engine.lichess.ovh";
      };

      extraArgs = lib.mkOption {
        description = ''
          Additional command-line arguments passed to `lichess-external-engine`.
          These are appended verbatim to the command line.
        '';
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.engine != null;
        message = "services.lichess-external-engine.engine must be set (a shell command to launch the UCI engine).";
      }
      {
        assertion = (cfg.tokenFile != null) || (cfg.token != null);
        message = "Either services.lichess-external-engine.tokenFile or services.lichess-external-engine.token must be defined.";
      }
    ];

    systemd.services."lichess-external-engine" = {
      description = "Lichess external engine provider";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        Restart = "on-failure";
        PrivateTmp = true;
        NoNewPrivileges = true;
        ProtectSystem = "full";
        ProtectHome = true;
        StateDirectory = "lichess-external-engine";
        # LoadCredential accepts a list; use it when token/secret files are provided.
        LoadCredential =
          lib.optional (cfg.tokenFile != null) "LICHESS_TOKEN:${cfg.tokenFile}"
          ++ lib.optional (cfg.providerSecretFile != null) "PROVIDER_SECRET:${cfg.providerSecretFile}";
      };

      # The script makes the loaded credentials available to the process and
      # then execs the packaged example provider.
      script = ''
        ${lib.optionalString (cfg.tokenFile != null) ''
          # Export token from a credential loaded by systemd
          export LICHESS_API_TOKEN=$(systemd-creds cat LICHESS_TOKEN)
        ''}
        ${lib.optionalString (cfg.token != null) ''
          # Export token provided directly in the configuration (discouraged)
          export LICHESS_API_TOKEN=${lib.escapeShellArg cfg.token}
        ''}
        ${lib.optionalString (cfg.providerSecretFile != null) ''
          # Export provider secret from a credential loaded by systemd
          export PROVIDER_SECRET=$(systemd-creds cat PROVIDER_SECRET)
        ''}
        ${lib.optionalString (cfg.providerSecret != null) ''
          # Export provider secret provided directly in the configuration (discouraged)
          export PROVIDER_SECRET=${lib.escapeShellArg cfg.providerSecret}
        ''}

        ${lib.optionalString (
          (cfg.providerSecret != null) || (cfg.providerSecretFile != null)
        ) ''provider_secret_arg="--provider-secret=$PROVIDER_SECRET"''}

        exec ${cfg.package}/bin/lichess-external-engine \
          --engine ${lib.escapeShellArg cfg.engine} \
          ${lib.optionalString (cfg.name != null) ("--name " + lib.escapeShellArg cfg.name)} \
          ${
            lib.optionalString (cfg.maxThreads != null) (
              "--max-threads " + lib.escapeShellArg (toString cfg.maxThreads)
            )
          } \
          ${
            lib.optionalString (cfg.maxHash != null) ("--max-hash " + lib.escapeShellArg (toString cfg.maxHash))
          } \
          ${
            lib.optionalString (cfg.keepAlive != null) (
              "--keep-alive " + lib.escapeShellArg (toString cfg.keepAlive)
            )
          } \
          --log-level ${lib.escapeShellArg cfg.logLevel} \
          --lichess ${lib.escapeShellArg cfg.lichess} \
          --broker ${lib.escapeShellArg cfg.broker} \
          $provider_secret_arg \
          ${lib.escapeShellArgs cfg.extraArgs}
      '';
    };
  };

  meta = {
    description = "NixOS module to run lichess.org external-engine providers (example provider)";
    maintainers = with lib.maintainers; [ malix ];
    platforms = lib.platforms.unix;
  };
}

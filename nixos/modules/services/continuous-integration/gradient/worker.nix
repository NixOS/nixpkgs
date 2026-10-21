{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.gradient.worker;
  env = cfg.environmentVariables;
  gcrootsDir = env.GRADIENT_WORKER_GCROOTS_DIR or "";
  traceDir = env.GRADIENT_WORKER_LOG_TRACE_DIR or null;
in
{
  options.services.gradient.worker = {
    enable = lib.mkEnableOption "the Gradient worker";
    packages = {
      gradient = lib.mkPackageOption pkgs "gradient" { };
      nix = lib.mkOption {
        type = lib.types.package;
        default = cfg.packages.gradient.nix;
        defaultText = lib.literalExpression "config.services.gradient.worker.packages.gradient.nix";
        description = ''
          Nix package providing the {command}`nix` for system feature detection.
          The default is Gradient's Nix fork, matching the worker's embedded evaluator.
        '';
      };

      git = lib.mkOption {
        type = lib.types.package;
        default = config.programs.git.package;
        defaultText = lib.literalExpression "config.programs.git.package";
        description = "Git package available to the worker for cloning repositories.";
      };

      ssh = lib.mkOption {
        type = lib.types.package;
        default = config.programs.ssh.package;
        defaultText = lib.literalExpression "config.programs.ssh.package";
        description = ''
          OpenSSH package used as {env}`GIT_SSH_COMMAND` to fetch private flake inputs.
        '';
      };
    };

    environmentVariables = lib.mkOption {
      type =
        with lib.types;
        lazyAttrsOf (
          nullOr (oneOf [
            bool
            int
            str
            path
          ])
        );

      default = { };
      example = {
        GRADIENT_WORKER_BUILD_MAX_CONCURRENT = 8;
      };
      description = ''
        Environment variables of the Gradient worker.
        The [configuration reference](https://wavelens.github.io/gradient/reference/configuration) lists every variable and its default.
        Set a variable to `null` to unset it.
      '';
    };

    peersFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        File of peer tokens for challenge-response authentication with the server,
        with `peer_id:token` per line and `#` starting a comment.

        ```
        <uuid>:<token>
        *:<token>
        ```

        Use peer ID `*` to match any UUID in the server's challenge.
        Tokens are 48 byte random secrets, for example from {command}`openssl rand -base64 48`.
        Register them via the API through `POST /api/v1/projects/{project}/workers`.
        Set it to `null` for open mode without authentication; avoid that in a production setup.
      '';
    };

    id = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "00000000-0000-0000-0000-000000000000";
      description = "UUID identifying the worker to the Gradient server.";
    };

    serverUrl = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "wss://gradient.example.com/proto";
      description = "WebSocket URL of the Gradient server the worker connects to.";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      gradient.worker.environmentVariables = lib.mapAttrs (_: lib.mkDefault) {
        GRADIENT_WORKER_BASE_DIR = "/var/lib/gradient-worker";
        GRADIENT_WORKER_GCROOTS_DIR = "/nix/var/nix/gcroots/gradient";
        GRADIENT_WORKER_LISTEN_ADDR = "127.0.0.1";
        GRADIENT_WORKER_PORT = 3100;
        GRADIENT_WORKER_NIX_BIN = lib.getExe' cfg.packages.nix "nix";
        GRADIENT_WORKER_SSH_BIN = lib.getExe' cfg.packages.ssh "ssh";
        GRADIENT_WORKER_CAPABILITIES_FETCH = true;
        GRADIENT_WORKER_CAPABILITIES_EVAL = true;
        GRADIENT_WORKER_CAPABILITIES_BUILD = true;
      };
    };

    systemd = {
      tmpfiles.settings."10-gradient-worker" =
        lib.optionalAttrs (gcrootsDir != "") {
          ${gcrootsDir}.d = {
            user = "gradient-worker";
            group = "gradient-worker";
            mode = "0755";
          };
        }
        // lib.optionalAttrs (traceDir != null) {
          ${traceDir}.d = {
            user = "gradient-worker";
            group = "gradient-worker";
            mode = "0750";
          };
        };

      services.gradient-worker = {
        wantedBy = [ "multi-user.target" ];
        after = [
          "network.target"
          "systemd-tmpfiles-setup.service"
        ];
        path = [
          cfg.packages.git
          cfg.packages.nix
          cfg.packages.ssh
        ];

        serviceConfig = {
          Type = "notify";
          ExecStart = lib.getExe' cfg.packages.gradient "gradient-worker";
          StateDirectory = "gradient-worker";
          User = "gradient-worker";
          Group = "gradient-worker";
          PrivateTmp = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          ReadWritePaths = [
            env.GRADIENT_WORKER_BASE_DIR
          ]
          ++ lib.optional (gcrootsDir != "") gcrootsDir
          ++ lib.optional (traceDir != null) traceDir;
          Restart = "on-failure";
          RestartSec = 10;
          KillMode = "mixed";
          LimitNOFILE = 65535;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          WorkingDirectory = env.GRADIENT_WORKER_BASE_DIR;
          LoadCredential = lib.optional (cfg.peersFile != null) "gradient_worker_peers:${cfg.peersFile}";
        };

        unitConfig = {
          StartLimitIntervalSec = 60;
          StartLimitBurst = 5;
        };

        environment =
          lib.mapAttrs (
            _: value: if lib.isBool value then lib.boolToString value else lib.mapNullable toString value
          ) env
          // {
            NIX_REMOTE = "daemon";
            XDG_CACHE_HOME = "${env.GRADIENT_WORKER_BASE_DIR}/www/.cache";
          }
          // lib.optionalAttrs (cfg.peersFile != null) {
            GRADIENT_WORKER_PEERS_FILE = "%d/gradient_worker_peers";
          }
          // lib.optionalAttrs (cfg.id != null) {
            GRADIENT_WORKER_ID = cfg.id;
          }
          // lib.optionalAttrs (cfg.serverUrl != null) {
            GRADIENT_WORKER_SERVER_URL = cfg.serverUrl;
          };
      };
    };

    nix.settings = {
      trusted-users = [ "gradient-worker" ];
      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
      ];
    };

    users = {
      groups.gradient-worker = { };
      users.gradient-worker = {
        description = "Gradient Worker user";
        isSystemUser = true;
        home = env.GRADIENT_WORKER_BASE_DIR;
        createHome = true;
        group = "gradient-worker";
      };
    };
  };
}

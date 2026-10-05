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
        default = pkgs.gradient-nix;
        defaultText = lib.literalExpression "pkgs.gradient-nix";
        description = ''
          Nix package providing the {command}`nix` for system feature detection. The default is
          Gradient's Nix fork, matching the worker's embedded evaluator.
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
      type = lib.types.lazyAttrsOf (
        lib.types.nullOr (
          lib.types.oneOf [
            lib.types.bool
            lib.types.int
            lib.types.str
            lib.types.path
          ]
        )
      );
      default = { };
      example = {
        GRADIENT_WORKER_SERVER_URL = "wss://gradient.example.com/proto";
        GRADIENT_WORKER_BUILD_MAX_CONCURRENT = 8;
      };
      description = ''
        Environment variables of the Gradient worker. The
        [configuration reference](https://github.com/wavelens/gradient) lists every variable and
        its default. `null` unsets a variable.
      '';
    };

    peersFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        File of peer tokens for challenge-response authentication with the server, with
        `peer_id:token` per line and `#` starting a comment.

        ```
        <uuid>:<token>
        *:<token>
        ```

        Use peer ID `*` to match any UUID in the server's challenge. Tokens are 48 byte random
        secrets, for example from {command}`openssl rand -base64 48`. Register them through
        `POST /api/v1/projects/{project}/workers`. Set it to `null` for open mode without a token.
      '';
    };

    acceptedServerTokensFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        File of token hashes required from connecting servers, with `peer_id:hash` per line and
        `#` starting a comment. Hashes are argon2 PHC strings or lowercase SHA-256 hex values of
        the tokens, for example from {command}`printf %s "$TOKEN" | sha256sum`. Use peer ID `*`
        to match any peer. Workers only read the file with {env}`GRADIENT_WORKER_DISCOVERABLE`
        set. Set it to `null` to accept every server, with a warning at start.
      '';
    };

    nginx = {
      enable = lib.mkEnableOption "an nginx virtual host for the worker listener";

      domain = lib.mkOption {
        type = lib.types.str;
        example = "worker.example.com";
        description = "Domain of the worker's nginx virtual host.";
      };

      useTls = lib.mkEnableOption "TLS on the worker's nginx virtual host" // {
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.gradient.worker.environmentVariables = lib.mapAttrs (_: lib.mkDefault) {
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

    systemd = {
      tmpfiles.settings."10-gradient" =
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
        after = [ "network.target" ];
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
          ReadWritePaths =
            lib.optional (gcrootsDir != "") gcrootsDir ++ lib.optional (traceDir != null) traceDir;
          Restart = "on-failure";
          RestartSec = 10;
          KillMode = "mixed";
          LimitNOFILE = 65535;
          # Secrets are mlock'd to keep them off swap. The lock is failing with EPERM below this
          # limit and flooding the log on every SSH-key git operation.
          LimitMEMLOCK = "128M";
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          WorkingDirectory = env.GRADIENT_WORKER_BASE_DIR;
          LoadCredential =
            lib.optional (cfg.peersFile != null) "gradient_worker_peers:${cfg.peersFile}"
            ++ lib.optional (
              cfg.acceptedServerTokensFile != null
            ) "gradient_worker_accepted_server_tokens:${cfg.acceptedServerTokensFile}";
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
          // lib.optionalAttrs (cfg.acceptedServerTokensFile != null) {
            GRADIENT_WORKER_ACCEPTED_SERVER_TOKENS_FILE = "%d/gradient_worker_accepted_server_tokens";
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

    services.nginx = lib.mkIf cfg.nginx.enable {
      enable = true;
      virtualHosts.${cfg.nginx.domain} = {
        enableACME = cfg.nginx.useTls;
        forceSSL = cfg.nginx.useTls;
        locations."/proto" = {
          proxyPass = "http://${env.GRADIENT_WORKER_LISTEN_ADDR}:${toString env.GRADIENT_WORKER_PORT}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_buffer_size 256k;
            proxy_buffers 4 256k;
            proxy_connect_timeout 90d;
            proxy_send_timeout 90d;
            proxy_read_timeout 90d;
          '';
        };
      };
    };

    users = {
      groups.gradient-worker = { };
      users.gradient-worker = {
        description = "Gradient Worker user";
        isSystemUser = true;
        group = "gradient-worker";
      };
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.sshpiper;

  stateDir = "/var/lib/sshpiper";
  authorizedKeysPath = "${stateDir}/authorized_keys";
  upstreamKeyPath = "${stateDir}/upstream_key";

  fromSubmodule = lib.types.submodule {
    options = {
      username = lib.mkOption {
        type = lib.types.str;
        description = ''
          Username to match on the downstream (client) side.
          Can be a regex pattern when {option}`usernameRegexMatch` is set.
        '';
      };

      usernameRegexMatch = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to interpret {option}`username` as a regular expression.
          When enabled, capture groups can be referenced in the upstream
          username with `$0`, `$1`, etc.
        '';
      };
    };
  };

  toSubmodule = lib.types.submodule {
    options = {
      host = lib.mkOption {
        type = lib.types.str;
        description = ''
          Address of the upstream SSH server in `host:port` format.
        '';
        example = "127.0.0.1:22";
      };

      username = lib.mkOption {
        type = lib.types.str;
        description = ''
          Username for the upstream connection. Supports capture group
          references (`$0`, `$1`, ...) when the corresponding `from` entry
          uses regex matching.
        '';
      };

      ignoreHostkey = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to skip host key verification for the upstream server.
        '';
      };
    };
  };

  pipeSubmodule = lib.types.submodule {
    options = {
      from = lib.mkOption {
        type = lib.types.listOf fromSubmodule;
        description = ''
          List of downstream matching rules. A connection matches this pipe
          when any entry in the list matches.
        '';
      };

      to = lib.mkOption {
        type = toSubmodule;
        description = ''
          Upstream server to connect to when this pipe matches.
        '';
      };
    };
  };

  # Build the yaml config, injecting authorized_keys and upstream key paths
  # into every pipe so users don't have to manage these manually.
  processedPipes = map (
    pipe:
    let
      fromEntries = map (
        f:
        {
          username = f.username;
        }
        // lib.optionalAttrs f.usernameRegexMatch {
          username_regex_match = true;
        }
        // lib.optionalAttrs (cfg.authorizedKeys != [ ]) {
          authorized_keys = authorizedKeysPath;
        }
      ) pipe.from;

      toEntry = {
        inherit (pipe.to) host username;
        private_key = upstreamKeyPath;
      }
      // lib.optionalAttrs pipe.to.ignoreHostkey {
        ignore_hostkey = true;
      };
    in
    {
      from = fromEntries;
      to = toEntry;
    }
  ) cfg.pipes;

  configFile = pkgs.writeText "sshpiper.yaml" (
    builtins.toJSON {
      version = "1.0";
      pipes = processedPipes;
    }
  );

  authorizedKeysFile = pkgs.writeText "sshpiper-authorized-keys" (
    lib.concatStringsSep "\n" cfg.authorizedKeys
  );
in
{
  options.services.sshpiper = {
    enable = lib.mkEnableOption "sshpiper, a reverse proxy for SSH";

    package = lib.mkPackageOption pkgs "sshpiper" { };

    address = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = ''
        Address for sshpiper to listen on.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 2222;
      description = ''
        Port for sshpiper to listen on.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open the listening port in the firewall.
      '';
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [
        "trace"
        "debug"
        "info"
        "warn"
        "error"
      ];
      default = "info";
      description = ''
        Log verbosity level.
      '';
    };

    serverKeyPath = lib.mkOption {
      type = lib.types.str;
      default = "${stateDir}/server_key";
      description = ''
        Path to the server host key. The key is presented to connecting
        clients during the SSH handshake.
      '';
    };

    serverKeyGenerateMode = lib.mkOption {
      type = lib.types.enum [
        "disable"
        "notexist"
        "always"
      ];
      default = "notexist";
      description = ''
        Controls automatic generation of the server host key.

        - `disable`: never generate a key; one must be provided.
        - `notexist`: generate a key only when {option}`serverKeyPath` does
          not exist yet.
        - `always`: regenerate the key on every start.
      '';
    };

    pipes = lib.mkOption {
      type = lib.types.listOf pipeSubmodule;
      default = [ ];
      description = ''
        List of routing pipes. Each pipe maps one or more downstream
        username patterns to an upstream SSH server.
      '';
      example = lib.literalExpression ''
        [
          {
            from = [
              { username = "git"; }
            ];
            to = {
              host = "127.0.0.1:3000";
              username = "git";
            };
          }
          {
            from = [
              { username = ".*"; usernameRegexMatch = true; }
            ];
            to = {
              host = "127.0.0.1:22";
              username = "$0";
            };
          }
        ]
      '';
    };

    authorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        SSH public keys that are allowed to connect through sshpiper.
        These are written to an authorized_keys file and referenced by
        every pipe's `from` entries.
      '';
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Additional command-line arguments passed to `sshpiperd` before the
        plugin arguments. Can be used to set options not covered by this
        module, such as `--banner-text` or `--login-grace-time`.
      '';
      example = [
        "--login-grace-time"
        "60s"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    systemd.services.sshpiper = {
      description = "sshpiper SSH reverse proxy";

      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        if [ ! -f ${upstreamKeyPath} ]; then
          ${lib.getExe' pkgs.openssh "ssh-keygen"} -t ed25519 \
            -f ${upstreamKeyPath} -N "" -C "sshpiper-upstream"
        fi
        chmod 0600 ${upstreamKeyPath}
        chmod 0644 ${upstreamKeyPath}.pub
      ''
      + lib.optionalString (cfg.authorizedKeys != [ ]) ''
        cp -f ${authorizedKeysFile} ${authorizedKeysPath}
        chmod 0644 ${authorizedKeysPath}
      '';

      serviceConfig = {
        ExecStart =
          let
            args = [
              (lib.getExe cfg.package)
              "--address"
              cfg.address
              "--port"
              (toString cfg.port)
              "--server-key"
              cfg.serverKeyPath
              "--server-key-generate-mode"
              cfg.serverKeyGenerateMode
              "--log-level"
              cfg.logLevel
            ]
            ++ cfg.extraArgs
            ++ [
              "${cfg.package}/lib/sshpiper/plugins/yaml"
              "--no-check-perm"
              "--config"
              (toString configFile)
            ];
          in
          lib.concatStringsSep " " args;

        StateDirectory = "sshpiper";
        RuntimeDirectory = "sshpiper";

        DynamicUser = true;

        Restart = "on-failure";
        RestartSec = 5;

        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
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
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ cashmeredev ];
}

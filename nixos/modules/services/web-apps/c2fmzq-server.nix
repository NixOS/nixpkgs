{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.services.c2fmzq-server;

  argsFormat = {
    type =
      with lib.types;
      attrsOf (
        nullOr (oneOf [
          bool
          int
          str
        ])
      );
    generate = lib.cli.toGNUCommandLineShell {
      mkBool = k: v: [
        "--${k}=${if v then "true" else "false"}"
      ];
    };
  };
in
{
  options.services.c2fmzq-server = {
    enable = lib.mkEnableOption "c2fmzq-server";

    bindIP = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "The local address to use.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "The local port to use.";
    };

    passphraseFile = lib.mkOption {
      type = lib.types.str;
      example = "/run/secrets/c2fmzq/pwfile";
      description = "Path to file containing the database passphrase";
    };

    package = lib.mkPackageOption pkgs "c2fmzq" { };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = argsFormat.type;

        options = {
          address = lib.mkOption {
            internal = true;
            type = lib.types.str;
            default = "${cfg.bindIP}:${toString cfg.port}";
          };

          database = lib.mkOption {
            type = lib.types.str;
            default = "%S/c2fmzq-server/data";
            description = "Path of the database";
          };

          verbose = lib.mkOption {
            type = lib.types.ints.between 1 3;
            default = 2;
            description = "The level of logging verbosity: 1:Error 2:Info 3:Debug";
          };
        };
      };
      description = ''
        Configuration for c2FmZQ-server passed as CLI arguments.
        Run {command}`c2FmZQ-server help` for supported values.
      '';
      example = {
        verbose = 3;
        allow-new-accounts = true;
        auto-approve-new-accounts = true;
        encrypt-metadata = true;
        enable-webapp = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.c2fmzq-server = {
      description = "c2FmZQ-server";
      documentation = [ "https://github.com/c2FmZQ/c2FmZQ/blob/main/README.md" ];
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [
        "network.target"
        "network-online.target"
      ];

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} ${argsFormat.generate cfg.settings}";
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        DynamicUser = true;
        Environment = "C2FMZQ_PASSPHRASE_FILE=%d/passphrase-file";
        IPAccounting = true;
        IPAddressAllow = cfg.bindIP;
        IPAddressDeny = "any";
        LoadCredential = "passphrase-file:${cfg.passphraseFile}";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateIPC = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SocketBindAllow = cfg.port;
        SocketBindDeny = "any";
        StateDirectory = "c2fmzq-server";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged @obsolete"
        ];
      };
    };
  };

  meta = {
    doc = ./c2fmzq-server.md;
    maintainers = with lib.maintainers; [ hmenke ];
  };
}

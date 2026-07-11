{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    ;

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
    generate = lib.cli.toCommandLineShellGNU {
      explicitBool = true;
    };
  };
in
{
  options.services.c2fmzq-server = {
    enable = mkEnableOption "c2fmzq-server";

    bindIP = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "The local address to use.";
    };

    port = mkOption {
      type = types.port;
      default = 8080;
      description = "The local port to use.";
    };

    passphraseFile = mkOption {
      type = types.str;
      example = "/run/secrets/c2fmzq/pwfile";
      description = "Path to file containing the database passphrase";
    };

    package = mkPackageOption pkgs "c2fmzq" { };

    settings = mkOption {
      type = types.submodule {
        freeformType = argsFormat.type;

        options = {
          address = mkOption {
            internal = true;
            type = types.str;
            default = "${cfg.bindIP}:${toString cfg.port}";
          };

          database = mkOption {
            type = types.str;
            default = "%S/c2fmzq-server/data";
            description = "Path of the database";
          };

          verbose = mkOption {
            type = types.ints.between 1 3;
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

{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let

  cfg = config.services.erigon;

  settingsFormat = pkgs.formats.toml { };
  configFile = settingsFormat.generate "config.toml" cfg.settings;
in
{

  options = {
    services.erigon = {
      enable = mkEnableOption "Ethereum implementation on the efficiency frontier";

      package = mkPackageOption pkgs "erigon" { };

      extraArgs = mkOption {
        type = types.listOf types.str;
        description = "Additional arguments passed to Erigon";
        default = [ ];
      };

      secretJwtPath = mkOption {
        type = types.path;
        description = ''
          Path to the secret jwt used for the http api authentication.
        '';
        default = "";
        example = "config.age.secrets.ERIGON_JWT.path";
      };

      settings = mkOption {
        description = ''
          Configuration for Erigon
          Refer to <https://github.com/ledgerwatch/erigon#usage> for details on supported values.
        '';

        type = settingsFormat.type;

        example = {
          datadir = "/var/lib/erigon";
          chain = "mainnet";
          http = true;
          "http.port" = 8545;
          "http.api" = [
            "eth"
            "debug"
            "net"
            "trace"
            "web3"
            "erigon"
          ];
          ws = true;
          port = 30303;
          "authrpc.port" = 8551;
          "torrent.port" = 42069;
          "private.api.addr" = "localhost:9090";
          "log.console.verbosity" = 3; # info
        };

        defaultText = literalExpression ''
          {
            datadir = "/var/lib/erigon";
            chain = "mainnet";
            http = true;
            "http.port" = 8545;
            "http.api" = ["eth" "debug" "net" "trace" "web3" "erigon"];
            ws = true;
            port = 30303;
            "authrpc.port" = 8551;
            "torrent.port" = 42069;
            "private.api.addr" = "localhost:9090";
            "log.console.verbosity" = 3; # info
          }
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    # Default values are the same as in the binary, they are just written here for convenience.
    services.erigon.settings = {
      datadir = mkDefault "/var/lib/erigon";
      chain = mkDefault "mainnet";
      http = mkDefault true;
      "http.port" = mkDefault 8545;
      "http.api" = mkDefault [
        "eth"
        "debug"
        "net"
        "trace"
        "web3"
        "erigon"
      ];
      ws = mkDefault true;
      port = mkDefault 30303;
      "authrpc.port" = mkDefault 8551;
      "torrent.port" = mkDefault 42069;
      "private.api.addr" = mkDefault "localhost:9090";
      "log.console.verbosity" = mkDefault 3; # info
    };

    systemd.services.erigon = {
      description = "Erigon ethereum implemenntation";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        LoadCredential = "ERIGON_JWT:${cfg.secretJwtPath}";
        ExecStart = "${cfg.package}/bin/erigon --config ${configFile} --authrpc.jwtsecret=%d/ERIGON_JWT ${lib.escapeShellArgs cfg.extraArgs}";
        DynamicUser = true;
        Restart = "on-failure";
        StateDirectory = "erigon";
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectClock = true;
        ProtectProc = "noaccess";
        ProcSubset = "pid";
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        RestrictSUIDSGID = true;
        RestrictRealtime = true;
        RestrictNamespaces = true;
        LockPersonality = true;
        RemoveIPC = true;
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
      };
    };
  };
}

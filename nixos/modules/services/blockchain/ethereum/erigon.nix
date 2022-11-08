{ config, lib, pkgs, ... }:

with lib;
let

  cfg = config.services.erigon;

  settingsFormat = pkgs.formats.toml { };
  configFile = settingsFormat.generate "config.toml" cfg.settings;
in {

  options = {
    services.erigon = {
      enable = mkEnableOption (lib.mdDoc "Ethereum implementation on the efficiency frontier");

      group = mkOption {
        type = types.str;
        default = "ethereum";
        description = lib.mdDoc ''
          Group of the user running the lighthouse process. This is used to share the jwt
          secret with the execution layer.
        '';
      };

      settings = mkOption {
        description = lib.mdDoc ''
          Configuration for Erigon
          Refer to <https://github.com/ledgerwatch/erigon#usage> for details on supported values.
        '';

        type = settingsFormat.type;

        example = {
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
    users = {
      users.erigon = {
        name = "erigon";
        group = cfg.group;
        description = "Erigon user";
        home = "/var/lib/erigon";
        isSystemUser = true;
      };
      groups = mkIf (cfg.group == "ethereum") {
        ethereum = {};
      };
    };

    # Default values are the same as in the binary, they are just written here for convenience.
    services.erigon.settings = {
      datadir = mkDefault "/var/lib/erigon";
      chain = mkDefault "mainnet";
      http = mkDefault true;
      "http.port" = mkDefault 8545;
      "http.api" = mkDefault ["eth" "debug" "net" "trace" "web3" "erigon"];
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
        ExecStart = "${pkgs.erigon}/bin/erigon --config ${configFile}";
        User = "erigon";
        Group = cfg.group;
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
        SystemCallFilter = [ "@system-service" "~@privileged" ];
      };
    };
  };
}

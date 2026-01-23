{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  cfg = config.services.nats;

  format = pkgs.formats.json { };

  validateConfig =
    file:
    pkgs.callPackage (
      { runCommand, nats-server }:
      runCommand "validate-nats-conf"
        {
          nativeBuildInputs = [ nats-server ];
        }
        ''
          nats-server --config "${file}" -t
          ln -s "${file}" "$out"
        ''
    ) { };

  unvalidatedConfigFile = format.generate "nats.conf" cfg.settings;

  configFile =
    if cfg.validateConfig then validateConfig unvalidatedConfigFile else unvalidatedConfigFile;
in
{

  ### Interface

  options = {
    services.nats = {
      enable = mkEnableOption "NATS messaging system";

      user = mkOption {
        type = types.str;
        default = "nats";
        description = "User account under which NATS runs.";
      };

      group = mkOption {
        type = types.str;
        default = "nats";
        description = "Group under which NATS runs.";
      };

      serverName = mkOption {
        default = "nats";
        example = "n1-c3";
        type = types.str;
        description = ''
          Name of the NATS server, must be unique if clustered.
        '';
      };

      jetstream = mkEnableOption "JetStream";

      port = mkOption {
        default = 4222;
        type = types.port;
        description = ''
          Port on which to listen.
        '';
      };

      dataDir = mkOption {
        default = "/var/lib/nats";
        type = types.path;
        description = ''
          The NATS data directory. Only used if JetStream is enabled, for
          storing stream metadata and messages.

          If left as the default value this directory will automatically be
          created before the NATS server starts, otherwise the sysadmin is
          responsible for ensuring the directory exists with appropriate
          ownership and permissions.
        '';
      };

      settings = mkOption {
        default = { };
        type = format.type;
        example = literalExpression ''
          {
            jetstream = {
              max_mem = "1G";
              max_file = "10G";
            };
          };
        '';
        description = ''
          Declarative NATS configuration. See the
          [
          NATS documentation](https://docs.nats.io/nats-server/configuration) for a list of options.
        '';
      };

      validateConfig = mkOption {
        type = types.bool;
        default = true;
        description = ''
          If true, validate nats config at build time. When the config can't
          be checked during build time, for example when it includes other
          files, disable this option.
        '';
      };
    };
  };

  ### Implementation

  config = mkIf cfg.enable {
    services.nats.settings = {
      server_name = cfg.serverName;
      port = cfg.port;
      jetstream = optionalAttrs cfg.jetstream { store_dir = cfg.dataDir; };
    };

    systemd.services.nats = {
      description = "NATS messaging system";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = mkMerge [
        (mkIf (cfg.dataDir == "/var/lib/nats") {
          StateDirectory = "nats";
          StateDirectoryMode = "0750";
        })
        {
          Type = "simple";
          ExecStart = "${pkgs.nats-server}/bin/nats-server -c ${configFile}";
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";

          KillMode = "mixed";
          KillSignal = "SIGUSR2";
          SuccessExitStatus = [
            0
            "SIGUSR2"
          ];

          TimeoutStopSec = "150"; # must exceed lame_duck_duration, which defaults to 2min
          Restart = "on-failure";

          User = cfg.user;
          Group = cfg.group;

          # Hardening
          CapabilityBoundingSet = "";
          LimitNOFILE = 800000; # JetStream requires 2 FDs open per stream.
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateTmp = true;
          PrivateUsers = true;
          ProcSubset = "pid";
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          ReadOnlyPaths = [ ];
          ReadWritePaths = [ cfg.dataDir ];
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
          ];
          UMask = "0077";
        }
      ];
    };

    users.users = mkIf (cfg.user == "nats") {
      nats = {
        description = "NATS daemon user";
        isSystemUser = true;
        group = cfg.group;
        home = cfg.dataDir;
      };
    };

    users.groups = mkIf (cfg.group == "nats") { nats = { }; };
  };

}

{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.rust-federation-tester;

  configFile = "/run/rust-federation-tester/config.yaml";
  commonServiceConfig = {
    DynamicUser = true;
    RuntimeDirectory = "rust-federation-tester";
    RuntimeDirectoryPreserve = true;
    StateDirectory = "rust-federation-tester";
    User = "rust-federation-tester";
    WorkingDirectory = "%t/rust-federation-tester";

    # Hardening
    UMask = "0077";
    CapabilityBoundingSet = [ "" ];
    DevicePolicy = "closed";
    PrivateTmp = true;
    ProtectHome = true;
    ProtectSystem = "strict";
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    LockPersonality = true;
    PrivateDevices = true;
    PrivateMounts = true;
    ProcSubset = "pid";
    ProtectClock = true;
    ProtectControlGroups = true;
    ProtectHostname = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectProc = "invisible";
    RemoveIPC = true;
    RestrictAddressFamilies = [
      "AF_INET"
      "AF_INET6"
      "AF_UNIX"
    ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
    ];
  };

  secretsInjection = utils.genJqSecretsReplacement {
    loadCredential = true;
  } cfg.settings configFile;
in
{
  options.services.rust-federation-tester = {
    enable = lib.mkEnableOption "rust-federation-tester";

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.json;
        options = {
          frontend_url = lib.mkOption {
            type = lib.types.str;
            example = "federation-tester.example.org";
            description = ''
              URL of the service's frontend.
            '';
          };

          database_url = lib.mkOption {
            type = lib.types.str;
            default = "sqlite:///var/lib/rust-federation-tester/db?mode=rwc";
            example = "postgres://localhost/db?currentSchema=schema";
            description = ''
              The database to store accounts and statistics.
            '';
          };

          smtp = {
            enabled = lib.mkEnableOption "mail delivery for configured alerts";
          };

          listen_addr = lib.mkOption {
            type = lib.types.str;
            default = "[::]:8080";
            example = "unix:/run/rust-federation-tester/rust-federation-tester.sock";
            description = ''
              Address the API server should listen on.
            '';
          };
        };
      };

      description = ''
        Settings representing the values in {flle}`config.yaml` of the service.

        Refer to [`config.yaml.example`] for supported values.

        [`config.yaml.example`]: https://github.com/MTRNord/rust-federation-tester/blob/main/config.yaml.example
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.sockets.rust-federation-tester = {
      description = "Matrix-Federation-Tester in Rust socket";
      wantedBy = [ "sockets.target" ];
      listenStreams = [ (lib.removePrefix "unix:" cfg.settings.listen_addr) ];
    };

    systemd.services.rust-federation-tester-setup = {
      description = "Matrix-Federation-Tester in Rust";
      path = [ pkgs.rust-federation-tester ];

      serviceConfig = lib.mkMerge [
        commonServiceConfig
        {
          Type = "oneshot";
          RemainAfterExit = true;
          LoadCredential = secretsInjection.credentials;
          ExecStart = "${pkgs.writeShellScript "rust-federation-tester-setup" ''
            ${secretsInjection.script}

            migration up
          ''}";
        }
      ];
    };

    systemd.services.rust-federation-tester = {
      description = "Matrix-Federation-Tester in Rust";
      wantedBy = [ "multi-user.target" ];
      documentation = [ "https://github.com/MTRNord/rust-federation-tester" ];
      after = [ "rust-federation-tester-setup.service" ];
      requires = [ "rust-federation-tester-setup.service" ];

      serviceConfig = lib.mkMerge [
        commonServiceConfig
        {
          ExecSearchPath = lib.makeBinPath [ pkgs.rust-federation-tester ];
          ExecStart = "rust-federation-tester";
          Restart = "on-failure";
        }
      ];
    };
  };
}

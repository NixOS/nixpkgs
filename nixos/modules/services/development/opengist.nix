{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.opengist;

  settingsFormat = pkgs.formats.json { };
  configurationFile = settingsFormat.generate "opengist_settings.json" cfg.settings;
in
{

  options = {

    services.opengist = {
      enable = lib.mkEnableOption "Opengist";

      package = lib.mkPackageOption pkgs "opengist" { };

      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        description = ''
          Environment file as defined in {manpage}`systemd.exec(5)`.

          This is used to provide secrets to Opengist.

          For available and default option values reference the
          [Opengist configuration cheat sheet](https://opengist.io/docs/configuration/cheat-sheet.html).

          Example file contents:

          ```
          OG_SECRET_KEY=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
          OG_OIDC_SECRET=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
          ```
        '';
        example = [ "/run/secrets/opengist.env" ];
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type;
          options = {
            log-level = lib.mkOption {
              default = "warn";
              description = "Logging level.";
              type = lib.types.enum [
                "debug"
                "info"
                "warn"
                "error"
                "fatal"
              ];
              example = "debug";
            };
            log-output = lib.mkOption {
              default = "stdout";
              description = "Logging output format.";
              type = lib.types.str;
              example = "file";
            };
            opengist-home = lib.mkOption {
              default = "/var/lib/opengist";
              description = "Path to the directory where Opengist stores its data.";
              type = lib.types.path;
            };
            external-url = lib.mkOption {
              default = null;
              description = "Public URL to access to Opengist.";
              type = lib.types.nullOr lib.types.str;
              example = "opengist.example.com";
            };
            "http.git-enabled" = lib.mkEnableOption "git operations (clone, pull, push) via HTTP";
            "http.host" = lib.mkOption {
              default = "127.0.0.1";
              description = "The host on which the HTTP server should bind.";
              type = lib.types.str;
              example = "0.0.0.0";
            };
            "http.port" = lib.mkOption {
              default = 6157;
              description = "The port on which the HTTP server should listen.";
              type = lib.types.port;
            };
            "ssh.git-enabled" = lib.mkEnableOption "git operations (clone, pull, push) via SSH";
            "ssh.host" = lib.mkOption {
              default = "127.0.0.1";
              description = "The host on which the SSH server should bind.";
              type = lib.types.str;
              example = "0.0.0.0";
            };
            "ssh.port" = lib.mkOption {
              default = 2222;
              description = "The port on which the SSH server should listen.";
              type = lib.types.port;
            };
          };
        };
        default = { };
        description = ''
          Extra configuration options to append or override.
          For available and default option values reference the
          [Opengist configuration cheat sheet](https://opengist.io/docs/configuration/cheat-sheet.html).

          Do not use this for secrets, values here will be world-readable in the
          nix store.
          Use {option}`services.opengist.environmentFiles` for secrets.
        '';
      };
    };

  };

  config = lib.mkIf cfg.enable {

    systemd.services.opengist = {
      description = "Opengist server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [
        pkgs.git
      ]
      ++ lib.optionals cfg.settings."ssh.git-enabled" [
        pkgs.openssh
      ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe cfg.package} --config ${configurationFile}";
        Restart = "on-failure";
        RestartSec = 300;
        EnvironmentFile = cfg.environmentFiles;

        # hardening
        DynamicUser = true;
        DevicePolicy = "closed";
        CapabilityBoundingSet = "";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        DeviceAllow = "";
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        BindPaths = [ ];
        StateDirectory = "opengist";
        MemoryDenyWriteExecute = true;
        LockPersonality = true;
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        ProtectProc = "invisible";
        ProtectHostname = true;
        UMask = "0077";
        ProcSubset = "pid";
      };
    };

  };

  meta.maintainers = with lib.maintainers; [ newam ];
}

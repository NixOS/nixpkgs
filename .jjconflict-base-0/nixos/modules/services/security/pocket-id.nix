{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    optionalAttrs
    optional
    mkPackageOption
    ;
  inherit (lib.types)
    bool
    path
    str
    submodule
    ;

  cfg = config.services.pocket-id;

  format = pkgs.formats.keyValue { };
  settingsFile = format.generate "pocket-id-env-vars" cfg.settings;
in
{
  meta.maintainers = with lib.maintainers; [
    gepbird
    ymstnt
  ];

  options.services.pocket-id = {
    enable = mkEnableOption "Pocket ID server";

    package = mkPackageOption pkgs "pocket-id" { };

    environmentFile = mkOption {
      type = path;
      description = ''
        Path to an environment file loaded for the Pocket ID service.

        This can be used to securely store tokens and secrets outside of the world-readable Nix store.

        Example contents of the file:
        MAXMIND_LICENSE_KEY=your-license-key
      '';
      default = "/dev/null";
      example = "/var/lib/secrets/pocket-id";
    };

    settings = mkOption {
      type = submodule {
        freeformType = format.type;

        options = {
          PUBLIC_APP_URL = mkOption {
            type = str;
            description = ''
              The URL where you will access the app.
            '';
            default = "http://localhost";
          };

          TRUST_PROXY = mkOption {
            type = bool;
            description = ''
              Whether the app is behind a reverse proxy.
            '';
            default = false;
          };
        };
      };

      default = { };

      description = ''
        Environment variables that will be passed to Pocket ID, see
        [configuration options](https://pocket-id.org/docs/configuration/environment-variables)
        for supported values.
      '';
    };

    dataDir = mkOption {
      type = path;
      default = "/var/lib/pocket-id";
      description = ''
        The directory where Pocket ID will store its data, such as the database.
      '';
    };

    user = mkOption {
      type = str;
      default = "pocket-id";
      description = "User account under which Pocket ID runs.";
    };

    group = mkOption {
      type = str;
      default = "pocket-id";
      description = "Group account under which Pocket ID runs.";
    };
  };

  config = mkIf cfg.enable {
    warnings = (
      optional (cfg.settings ? MAXMIND_LICENSE_KEY)
        "config.services.pocket-id.settings.MAXMIND_LICENSE_KEY will be stored as plaintext in the Nix store. Use config.services.pocket-id.environmentFile instead."
    );

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 ${cfg.user} ${cfg.group}"
    ];

    systemd.services = {
      pocket-id-backend = {
        description = "Pocket ID backend";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        restartTriggers = [
          cfg.package
          cfg.environmentFile
          settingsFile
        ];

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = cfg.dataDir;
          ExecStart = "${cfg.package}/bin/pocket-id-backend";
          Restart = "always";
          EnvironmentFile = [
            cfg.environmentFile
            settingsFile
          ];

          # Hardening
          AmbientCapabilities = "";
          CapabilityBoundingSet = "";
          DeviceAllow = "";
          DevicePolicy = "closed";
          #IPAddressDeny = "any"; # communicates with the frontend
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateNetwork = false; # communicates with the frontend
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
          ProtectSystem = "full"; # needs to write in cfg.dataDir
          RemoveIPC = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = lib.concatStringsSep " " [
            "~"
            "@clock"
            "@cpu-emulation"
            "@debug"
            "@module"
            "@mount"
            "@obsolete"
            "@privileged"
            "@raw-io"
            "@reboot"
            #"@resources" # vm test segfaults
            "@swap"
          ];
          UMask = "0077";
        };
      };

      pocket-id-frontend = {
        description = "Pocket ID frontend";
        after = [
          "network.target"
          "pocket-id-backend.service"
        ];
        wantedBy = [ "multi-user.target" ];
        restartTriggers = [
          cfg.package
          cfg.environmentFile
          settingsFile
        ];

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          ExecStart = "${cfg.package}/bin/pocket-id-frontend";
          Restart = "always";
          EnvironmentFile = [
            cfg.environmentFile
            settingsFile
          ];

          # Hardening
          AmbientCapabilities = "";
          CapabilityBoundingSet = "";
          DeviceAllow = "";
          DevicePolicy = "closed";
          #IPAddressDeny = "any"; # communicates with the backend and client
          LockPersonality = true;
          MemoryDenyWriteExecute = false; # V8_Fatal segfault
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateNetwork = false; # communicates with the backend and client
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
          RemoveIPC = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = lib.concatStringsSep " " [
            "~"
            "@clock"
            "@cpu-emulation"
            "@debug"
            "@module"
            "@mount"
            "@obsolete"
            "@privileged"
            "@raw-io"
            "@reboot"
            "@resources"
            "@swap"
          ];
          UMask = "0077";
        };
      };
    };

    users.users = optionalAttrs (cfg.user == "pocket-id") {
      pocket-id = {
        isSystemUser = true;
        group = cfg.group;
        description = "Pocket ID backend user";
        home = cfg.dataDir;
      };
    };

    users.groups = optionalAttrs (cfg.group == "pocket-id") {
      pocket-id = { };
    };
  };
}

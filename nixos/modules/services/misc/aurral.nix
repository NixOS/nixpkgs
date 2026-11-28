{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.aurral;
  libraryFolder = cfg.environment.LIBRARY_FOLDER or (cfg.environment.DOWNLOAD_FOLDER or null);
  pluginIdType = lib.types.strMatching "[a-z0-9][a-z0-9-]*";
in
{
  options = {
    services.aurral = {
      enable = lib.mkEnableOption "Aurral, a self-hosted music discovery, library management, and streaming service";

      package = lib.mkPackageOption pkgs "aurral" { };

      plugins = lib.mkOption {
        type = lib.types.listOf (
          lib.types.addCheck lib.types.package (p: pluginIdType.check (p.pluginId or null))
        );
        default = [ ];
        example = lib.literalExpression "with pkgs.aurralPlugins; [ lidarr metadata ]";
        description = ''
          Plugin packages to install alongside plugins from the web interface.
          Enable plugins and configure their settings in Aurral. Update or remove
          packaged plugins through this option. A packaged plugin takes precedence
          over a web-installed copy with the same ID while it is listed here.
          Removing a packaged plugin can leave an empty directory under
          `plugins/` in the data directory. If Aurral reports a missing
          manifest for that plugin, remove the empty directory with `rmdir`.

          Each package must provide `passthru.pluginId` matching its manifest ID
          and install `manifest.json` and `index.js` at the root of its output.
        '';
      };

      directories = lib.mkOption {
        type = lib.types.listOf lib.types.externalPath;
        default = [ ];
        description = ''
          Additional directories to expose to Aurral.
          The module also exposes the path in `LIBRARY_FOLDER`, falling back to the deprecated `DOWNLOAD_FOLDER`.
          See BindPaths in {manpage}`systemd.exec(5)`.
        '';
      };

      dataDir = lib.mkOption {
        type = lib.types.externalPath;
        default = "/var/lib/aurral";
        description = ''
          The directory where Aurral stores its stateful data.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 3001;
        description = "Port number";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open ports in the firewall for Aurral.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "aurral";
        description = ''
          User account under which Aurral runs.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "aurral";
        description = ''
          Group under which Aurral runs.
        '';
      };

      environment = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        example = {
          LIBRARY_FOLDER = "/media/music";
          TRUST_PROXY = "true";
        };
        description = ''
          Environment variables passed to the service.
        '';
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Environment file as defined in {manpage}`systemd.exec(5)` passed to the service.
        '';
      };

    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = lib.allUnique (map (p: p.pluginId) cfg.plugins);
        message = "services.aurral.plugins must contain at most one package per plugin ID.";
      }
    ];

    systemd.services.aurral = {
      description = "Aurral";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = cfg.environment // {
        AURRAL_DATA_DIR = cfg.dataDir;
        PORT = toString cfg.port;
      };

      path = [ cfg.package ];

      serviceConfig = {
        Type = "simple";
        # Reap orphaned plugin and download processes inside the private PID namespace.
        ExecStart = "${lib.getExe pkgs.catatonit} -- ${lib.getExe cfg.package}";
        Restart = "always";
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        StateDirectory = lib.mkIf (cfg.dataDir == "/var/lib/aurral") "aurral";
        WorkingDirectory = cfg.dataDir;
        ReadWritePaths = "";
        ProtectSystem = "strict";
        BindPaths = [
          cfg.dataDir
        ]
        ++ (lib.map (x: "-" + x) cfg.directories)
        ++ lib.optional (libraryFolder != null) libraryFolder;
        BindReadOnlyPaths = [
          builtins.storeDir
          "${config.security.pki.caBundle}:/etc/ssl/certs/ca-certificates.crt"
          "-/etc/resolv.conf"
        ]
        ++ lib.optionals config.services.resolved.enable [
          "/run/systemd/resolve/stub-resolv.conf"
          "/run/systemd/resolve/resolv.conf"
        ]
        ++ map (p: "${p}:${cfg.dataDir}/plugins/${p.pluginId}") cfg.plugins;
        RestrictSUIDSGID = true;
        CapabilityBoundingSet = "";
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        # cloudflared's QUIC transport requires binding dynamically allocated UDP ports.
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0007";
        SystemCallArchitectures = "native";
        ProtectProc = "invisible";
        ProcSubset = "pid";
        LockPersonality = true;
        NoNewPrivileges = true;
        DevicePolicy = "closed";
        PrivateIPC = true;
        PrivatePIDs = true;
        ProtectClock = true;
        ProtectHome = true;
        ProtectKernelLogs = true;
        ProtectHostname = true;
        RemoveIPC = true;
        RestrictRealtime = true;
        RestrictNamespaces = true;
        MemoryDenyWriteExecute = false;
      };

      confinement.enable = true;
    };

    systemd.tmpfiles.settings."10-aurral" = lib.mkIf (libraryFolder != null) {
      ${libraryFolder}.d = {
        inherit (cfg) user group;
        mode = "0770";
      };
    };

    # Create the writable parent before systemd sets up the read-only mounts.
    systemd.tmpfiles.settings."10-aurral-plugins" = lib.mkIf (cfg.plugins != [ ]) {
      "${cfg.dataDir}/plugins".d = {
        inherit (cfg) user group;
        mode = "0750";
      };
    };

    users.users = lib.mkIf (cfg.user == "aurral") {
      aurral = {
        isSystemUser = true;
        home = cfg.dataDir;
        group = cfg.group;
      };
    };

    users.groups = lib.mkIf (cfg.group == "aurral") {
      aurral = { };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}

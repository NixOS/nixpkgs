{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    getExe
    maintainers
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    ;
  inherit (lib.types)
    bool
    path
    port
    str
    submodule
    ;
  cfg = config.services.qui;

  stateDir = "/var/lib/qui";
  configFormat = pkgs.formats.toml { };
  configFile = configFormat.generate "qui.toml" cfg.settings;
in
{
  options = {
    services.qui = {
      enable = mkEnableOption "qui";

      package = mkPackageOption pkgs "qui" { };

      user = mkOption {
        type = str;
        default = "qui";
        description = "User to run qui as.";
      };

      group = mkOption {
        type = str;
        default = "qui";
        example = "torrents";
        description = "Group to run qui as.";
      };

      openFirewall = mkOption {
        type = bool;
        default = false;
        description = "Whether or not to open ports in the firewall for qui.";
      };

      secretFile = mkOption {
        type = path;
        example = "/run/secrets/qui-session.txt";
        description = ''
          Path to a file that contains the session secret. The session secret
          can be generated with `openssl rand -hex 32`.
        '';
      };

      settings = mkOption {
        default = { };
        example = {
          port = 7777;
          logLevel = "DEBUG";
          metricsEnabled = true;
        };
        type = submodule {
          freeformType = configFormat.type;
          options = {
            host = mkOption {
              type = str;
              default = "127.0.0.1";
              description = "The host address qui listens on.";
            };

            port = mkOption {
              type = port;
              default = 7476;
              description = "The port qui listens on.";
            };
          };
        };
        description = ''
          qui configuration options.

          Refer to the [template config](https://github.com/autobrr/qui/blob/main/internal/config/config.go)
          in the source code for the available options.
          The documentation contains the available [environment variables](https://getqui.com/docs/configuration/environment/),
          this can be used to get an overview.
        '';
      };

    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.settings ? sessionSecret);
        message = ''
          Session secrets should not be passed via settings, as
          these are stored in the world-readable nix store.

          Use the secretFile option instead.'';
      }
    ];

    systemd.services.qui = {
      description = "qui: alternative qBittorrent webUI";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;

        LoadCredential = "sessionSecret:${cfg.secretFile}";
        Environment = [ "QUI__SESSION_SECRET_FILE=%d/sessionSecret" ];
        StateDirectory = "qui";

        ExecStartPre = ''
          ${pkgs.coreutils}/bin/install -m 600 '${configFile}' '%S/qui/config.toml'
        '';
        ExecStart = "${getExe cfg.package} serve --config-dir %S/qui";
        Restart = "on-failure";

        # Based on qbittorrent and nemorosa hardening settings
        # Similar to what systemd hardening helper suggests
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateNetwork = false;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = "yes";
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        # This should allow for hardlinking to torrent client files
        ProtectSystem = "full";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" ];
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.port ];
    };

    users = {
      users = mkIf (cfg.user == "qui") {
        qui = {
          group = cfg.group;
          description = "qui user";
          isSystemUser = true;
          home = stateDir;
        };
      };

      groups = mkIf (cfg.group == "qui") {
        qui = { };
      };
    };
  };

  meta.maintainers = with maintainers; [ undefined-landmark ];
}

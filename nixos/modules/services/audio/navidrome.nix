{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    maintainers
    ;
  inherit (lib.types)
    bool
    port
    str
    submodule
    ;
  cfg = config.services.navidrome;
  settingsFormat = pkgs.formats.json { };
in
{
  options = {
    services.navidrome = {

      enable = mkEnableOption "Navidrome music server";

      package = mkPackageOption pkgs "navidrome" { };

      settings = mkOption {
        type = submodule {
          freeformType = settingsFormat.type;

          options = {
            Address = mkOption {
              default = "127.0.0.1";
              description = "Address to run Navidrome on.";
              type = str;
            };

            Port = mkOption {
              default = 4533;
              description = "Port to run Navidrome on.";
              type = port;
            };

            EnableInsightsCollector = mkOption {
              default = false;
              description = "Enable anonymous usage data collection, see <https://www.navidrome.org/docs/getting-started/insights/> for details.";
              type = bool;
            };
          };
        };
        default = { };
        example = {
          MusicFolder = "/mnt/music";
        };
        description = "Configuration for Navidrome, see <https://www.navidrome.org/docs/usage/configuration-options/> for supported values.";
      };

      user = mkOption {
        type = str;
        default = "navidrome";
        description = "User under which Navidrome runs.";
      };

      group = mkOption {
        type = str;
        default = "navidrome";
        description = "Group under which Navidrome runs.";
      };

      openFirewall = mkOption {
        type = bool;
        default = false;
        description = "Whether to open the TCP port in the firewall";
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Environment file, used to set any secret ND_* environment variables.";
      };
    };
  };

  config =
    let
      inherit (lib) mkIf optional getExe;
      WorkingDirectory = "/var/lib/navidrome";
    in
    mkIf cfg.enable {
      systemd = {
        tmpfiles.settings.navidromeDirs = {
          "${cfg.settings.DataFolder or WorkingDirectory}"."d" = {
            mode = "700";
            inherit (cfg) user group;
          };
          "${cfg.settings.CacheFolder or (WorkingDirectory + "/cache")}"."d" = {
            mode = "700";
            inherit (cfg) user group;
          };
          "${cfg.settings.MusicFolder or (WorkingDirectory + "/music")}"."d" = {
            mode = ":700";
            user = ":${cfg.user}";
            group = ":${cfg.group}";
          };
        };
        services.navidrome = {
          description = "Navidrome Media Server";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = ''
              ${getExe cfg.package} --configfile ${settingsFormat.generate "navidrome.json" cfg.settings}
            '';
            EnvironmentFile = lib.mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
            User = cfg.user;
            Group = cfg.group;
            StateDirectory = "navidrome";
            inherit WorkingDirectory;
            RuntimeDirectory = "navidrome";
            RootDirectory = "/run/navidrome";
            ReadWritePaths = "";
            BindPaths =
              optional (cfg.settings ? DataFolder) cfg.settings.DataFolder
              ++ optional (cfg.settings ? CacheFolder) cfg.settings.CacheFolder;
            BindReadOnlyPaths = [
              # navidrome uses online services to download additional album metadata / covers
              "${config.security.pki.caBundle}:/etc/ssl/certs/ca-certificates.crt"
              builtins.storeDir
              "/etc"
            ]
            ++ optional (cfg.settings ? MusicFolder) cfg.settings.MusicFolder
            ++ lib.optionals config.services.resolved.enable [
              "/run/systemd/resolve/stub-resolv.conf"
              "/run/systemd/resolve/resolv.conf"
            ];
            CapabilityBoundingSet = "";
            RestrictAddressFamilies = [
              "AF_UNIX"
              "AF_INET"
              "AF_INET6"
            ];
            RestrictNamespaces = true;
            PrivateDevices = true;
            PrivateUsers = true;
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHome = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            SystemCallArchitectures = "native";
            SystemCallFilter = [
              "@system-service"
              "~@privileged"
            ];
            RestrictRealtime = true;
            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            UMask = "0066";
            ProtectHostname = true;
          };
        };
      };

      users.users = mkIf (cfg.user == "navidrome") {
        navidrome = {
          inherit (cfg) group;
          isSystemUser = true;
        };
      };

      users.groups = mkIf (cfg.group == "navidrome") { navidrome = { }; };

      networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.settings.Port ];
    };
  meta.maintainers = with maintainers; [ fsnkty ];
}

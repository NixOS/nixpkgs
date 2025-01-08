{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.navidrome;
  settingsFormat = pkgs.formats.json { };
in
{
  options = {
    services.navidrome = {

      enable = lib.mkEnableOption "Navidrome music server";

      package = lib.mkPackageOption pkgs "navidrome" { };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type;

          options = {
            Address = lib.mkOption {
              default = "127.0.0.1";
              description = "Address to run Navidrome on.";
              type = lib.types.str;
            };

            Port = lib.mkOption {
              default = 4533;
              description = "Port to run Navidrome on.";
              type = lib.types.port;
            };

            EnableInsightsCollector = lib.mkOption {
              default = false;
              description = "Enable anonymous usage data collection, see <https://www.navidrome.org/docs/getting-started/insights/> for details.";
              type = lib.types.bool;
            };
          };
        };
        default = { };
        example = {
          MusicFolder = "/mnt/music";
        };
        description = "Configuration for Navidrome, see <https://www.navidrome.org/docs/usage/configuration-options/> for supported values.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "navidrome";
        description = "User under which Navidrome runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "navidrome";
        description = "Group under which Navidrome runs.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to open the TCP port in the firewall";
      };
    };
  };

  config =
    let
      WorkingDirectory = "/var/lib/navidrome";
    in
    lib.mkIf cfg.enable {
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
        };
        services.navidrome = {
          description = "Navidrome Media Server";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = ''
              ${lib.getExe cfg.package} --configfile ${settingsFormat.generate "navidrome.json" cfg.settings}
            '';
            User = cfg.user;
            Group = cfg.group;
            StateDirectory = "navidrome";
            inherit WorkingDirectory;
            RuntimeDirectory = "navidrome";
            RootDirectory = "/run/navidrome";
            ReadWritePaths = "";
            BindPaths =
              lib.optional (cfg.settings ? DataFolder) cfg.settings.DataFolder
              ++ lib.optional (cfg.settings ? CacheFolder) cfg.settings.CacheFolder;
            BindReadOnlyPaths =
              [
                # navidrome uses online services to download additional album metadata / covers
                "${
                  config.environment.etc."ssl/certs/ca-certificates.crt".source
                }:/etc/ssl/certs/ca-certificates.crt"
                builtins.storeDir
                "/etc"
              ]
              ++ lib.optional (cfg.settings ? MusicFolder) cfg.settings.MusicFolder
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

      users.users = lib.mkIf (cfg.user == "navidrome") {
        navidrome = {
          inherit (cfg) group;
          isSystemUser = true;
        };
      };

      users.groups = lib.mkIf (cfg.group == "navidrome") { navidrome = { }; };

      networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.settings.Port ];
    };
  meta.maintainers = with lib.maintainers; [ fsnkty ];
}

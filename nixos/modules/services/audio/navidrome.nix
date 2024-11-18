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
    path
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

      credentialsFile = mkOption {
        type = path;
        description = ''
          Path to a JSON file to be merged with the settings.
          Useful to merge a file which is better kept out of the Nix store
          to set secret config parameters like api keys.
        '';
        default = "/dev/null";
        example = "/var/lib/secrets/navidrome/settings.json";
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
      rootDir = "/run/navidrome";
      settingsFile = settingsFormat.generate "navidrome.json" cfg.settings;
    in
    mkIf cfg.enable {
      system.activationScripts = {
        navidrome-demon = ''
          install -d -m 700 '${WorkingDirectory}'
          chown -R '${cfg.user}:${cfg.group}' ${WorkingDirectory}
        '';
      };
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
            ExecStartPre = [
              (
                "+"
                + pkgs.writeShellScript "navidrome-prestart" ''
                  ${pkgs.jq}/bin/jq --slurp add ${settingsFile} '${cfg.credentialsFile}' |
                  install -D -m 600 -o '${cfg.user}' -g '${cfg.group}' /dev/stdin "${rootDir}/settings.json"
                ''
              )
            ];
            ExecStart = ''
              ${getExe cfg.package} --configfile %t/navidrome/settings.json
            '';
            EnvironmentFile = lib.mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
            User = cfg.user;
            Group = cfg.group;
            StateDirectory = baseNameOf rootDir;
            RuntimeDirectory = baseNameOf rootDir;
            inherit WorkingDirectory;
            MountAPIVFS = true;
            BindPaths =
              [
                "${WorkingDirectory}"
                "/run"
              ]
              ++ optional (cfg.settings ? DataFolder) cfg.settings.DataFolder
              ++ optional (cfg.settings ? CacheFolder) cfg.settings.CacheFolder;
            BindReadOnlyPaths =
              [
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

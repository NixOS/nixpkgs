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
    recursiveUpdate
    ;
  inherit (lib.types) bool str;
  cfg = config.services.navidrome;
  settingsFormat = pkgs.formats.json { };
in
{
  options = {
    services.navidrome = {

      enable = mkEnableOption "Navidrome music server";

      package = mkPackageOption pkgs "navidrome" { };

      settings = mkOption rec {
        type = settingsFormat.type;
        apply = recursiveUpdate default;
        default = {
          Address = "127.0.0.1";
          Port = 4533;
        };
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
    };
  };

  config =
    let
      inherit (lib) mkIf optional;
    in
    mkIf cfg.enable {
      systemd.services.navidrome = {
        description = "Navidrome Media Server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = ''
            ${cfg.package}/bin/navidrome --configfile ${settingsFormat.generate "navidrome.json" cfg.settings}
          '';
          User = cfg.user;
          Group = cfg.group;
          StateDirectory = "navidrome";
          WorkingDirectory = "/var/lib/navidrome";
          RuntimeDirectory = "navidrome";
          RootDirectory = "/run/navidrome";
          ReadWritePaths = "";
          BindPaths = optional (cfg.settings ? DataFolder) cfg.settings.DataFolder;
          BindReadOnlyPaths = [
            # navidrome uses online services to download additional album metadata / covers
            "${
              config.environment.etc."ssl/certs/ca-certificates.crt".source
            }:/etc/ssl/certs/ca-certificates.crt"
            builtins.storeDir
            "/etc"
          ] ++ optional (cfg.settings ? MusicFolder) cfg.settings.MusicFolder;
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

      users.users = mkIf (cfg.user == "navidrome") {
        navidrome = {
          inherit (cfg) group;
          isSystemUser = true;
        };
      };

      users.groups = mkIf (cfg.group == "navidrome") { navidrome = { }; };

      networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.settings.Port ];
    };
}

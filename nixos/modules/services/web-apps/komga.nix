{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.komga;
  inherit (lib) mkOption mkEnableOption maintainers;
  inherit (lib.types) port str bool;
in
{
  options = {
    services.komga = {
      enable = mkEnableOption "Komga, a free and open source comics/mangas media server";

      port = mkOption {
        type = port;
        default = 8080;
        description = "The port that Komga will listen on.";
      };

      user = mkOption {
        type = str;
        default = "komga";
        description = "User account under which Komga runs.";
      };

      group = mkOption {
        type = str;
        default = "komga";
        description = "Group under which Komga runs.";
      };

      stateDir = mkOption {
        type = str;
        default = "/var/lib/komga";
        description = "State and configuration directory Komga will use.";
      };

      openFirewall = mkOption {
        type = bool;
        default = false;
        description = "Whether to open the firewall for the port in {option}`services.komga.port`.";
      };
    };
  };

  config =
    let
      inherit (lib) mkIf getExe;
    in
    mkIf cfg.enable {

      networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

      users.groups = mkIf (cfg.group == "komga") { komga = { }; };

      users.users = mkIf (cfg.user == "komga") {
        komga = {
          group = cfg.group;
          home = cfg.stateDir;
          description = "Komga Daemon user";
          isSystemUser = true;
        };
      };

      systemd.services.komga = {
        environment = {
          SERVER_PORT = builtins.toString cfg.port;
          KOMGA_CONFIGDIR = cfg.stateDir;
        };

        description = "Komga is a free and open source comics/mangas media server";

        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];

        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;

          Type = "simple";
          Restart = "on-failure";
          ExecStart = getExe pkgs.komga;

          StateDirectory = mkIf (cfg.stateDir == "/var/lib/komga") "komga";

          RemoveIPC = true;
          NoNewPrivileges = true;
          CapabilityBoundingSet = "";
          SystemCallFilter = [ "@system-service" ];
          ProtectSystem = "full";
          PrivateTmp = true;
          ProtectProc = "invisible";
          ProtectClock = true;
          ProcSubset = "pid";
          PrivateUsers = true;
          PrivateDevices = true;
          ProtectHostname = true;
          ProtectKernelTunables = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_NETLINK"
          ];
          LockPersonality = true;
          RestrictNamespaces = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          ProtectKernelModules = true;
          SystemCallArchitectures = "native";
          RestrictSUIDSGID = true;
          RestrictRealtime = true;
        };
      };
    };

  meta.maintainers = with maintainers; [ govanify ];
}

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.qbittorrent-nox;
in {
  options = {
    services = {
      qbittorrent-nox = {
        enable = mkEnableOption (lib.mdDoc "qbittorrent-nox daemon");

        web = {
          port = mkOption {
            type = types.port;
            default = 8080;
            description = lib.mdDoc ''
              qbittorrent-nox web UI port.
            '';
          };
          openFirewall = mkOption {
            type = types.bool;
            default = false;
            description = lib.mdDoc ''
              Whether to open the firewall for the ports in
              {option}`services.qbittorrent-nox.web.port`.
            '';
          };
        };

        torrenting = {
          port = mkOption {
            type = types.port;
            default = 48197;
            description = lib.mdDoc ''
              qbittorrent-nox web UI port.
            '';
          };

          openFirewall = mkOption {
            default = false;
            type = types.bool;
            description = lib.mdDoc ''
              Whether to open the firewall for the ports in
              {option}`services.qbittorrent-nox.torrenting.port`.
            '';
          };
        };

        dataDir = mkOption {
          type = types.path;
          default = "/var/lib/qbittorrent-nox";
          description = lib.mdDoc ''
            The directory where qbittorrent-nox will create files.
          '';
        };

        user = mkOption {
          type = types.str;
          default = "qbittorrent";
          description = lib.mdDoc ''
            User account under which qbittorrent-nox runs.
          '';
        };

        group = mkOption {
          type = types.str;
          default = "qbittorrent";
          description = lib.mdDoc ''
            Group under which qbittorrent-nox runs.
          '';
        };

        package = mkPackageOption pkgs "qbittorrent-nox" { };
      };
    };
  };

  config = mkIf cfg.enable {

    services.qbittorrent-nox.package = mkDefault (pkgs.qbittorrent-nox);

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0770 ${cfg.user} ${cfg.group}"
      "d '${cfg.dataDir}/.config' 0770 ${cfg.user} ${cfg.group}"
      "d '${cfg.dataDir}/.config/qBittorrent' 0770 ${cfg.user} ${cfg.group}"
    ];

    systemd.services.qbittorrent-nox = {
      after = [ "network.target" "local-fs.target" "network-online.target" "nss-lookup.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ cfg.package ];
      unitConfig = {
        Description = "qBittorrent-nox Daemon";
        Documentation = "man:qbittorrent-nox(1)";
      };
      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/qbittorrent-nox \
            --profile=${cfg.dataDir} \
            --webui-port=${toString cfg.web.port} \
            --torrenting-port=${toString cfg.torrenting.port}
        '';
        Type = "exec";
        User = cfg.user;
        Group = cfg.group;
        UMask = "0002";
        PrivateTmp = "false";
        TimeoutStopSec = 1800;
      };
      # preStart = preStart;
    };

    networking.firewall = mkMerge [
      (mkIf (cfg.torrenting.openFirewall) {
        allowedTCPPorts = [ cfg.torrenting.port ];
        allowedUDPPorts = [ cfg.torrenting.port ];
      })
      (mkIf (cfg.web.openFirewall) {
        allowedTCPPorts = [ cfg.web.port ];
      })
    ];

    environment.systemPackages = [ cfg.package ];

    users.users = mkIf (cfg.user == "qbittorrent") {
      qbittorrent = {
        group = cfg.group;
        uid = config.ids.uids.qbittorrent-nox;
        home = cfg.dataDir;
        description = "qbittorrent daemon user";
      };
    };

    users.groups = mkIf (cfg.group == "qbittorrent") {
      qbittorrent = {
        gid = config.ids.gids.qbittorrent-nox;
      };
    };
  };
}

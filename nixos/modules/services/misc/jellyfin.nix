{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    mkIf
    getExe
    maintainers
    mkEnableOption
    mkOption
    mkPackageOption
    ;
  inherit (lib.types) str path bool;
  cfg = config.services.jellyfin;
in
{
  options = {
    services.jellyfin = {
      enable = mkEnableOption "Jellyfin Media Server";

      package = mkPackageOption pkgs "jellyfin" { };

      user = mkOption {
        type = str;
        default = "jellyfin";
        description = "User account under which Jellyfin runs.";
      };

      group = mkOption {
        type = str;
        default = "jellyfin";
        description = "Group under which jellyfin runs.";
      };

      dataDir = mkOption {
        type = path;
        default = "/var/lib/jellyfin";
        description = ''
          Base data directory,
          passed with `--datadir` see [#data-directory](https://jellyfin.org/docs/general/administration/configuration/#data-directory)
        '';
      };

      configDir = mkOption {
        type = path;
        default = "${cfg.dataDir}/config";
        defaultText = "\${cfg.dataDir}/config";
        description = ''
          Directory containing the server configuration files,
          passed with `--configdir` see [configuration-directory](https://jellyfin.org/docs/general/administration/configuration/#configuration-directory)
        '';
      };

      cacheDir = mkOption {
        type = path;
        default = "/var/cache/jellyfin";
        description = ''
          Directory containing the jellyfin server cache,
          passed with `--cachedir` see [#cache-directory](https://jellyfin.org/docs/general/administration/configuration/#cache-directory)
        '';
      };

      logDir = mkOption {
        type = path;
        default = "${cfg.dataDir}/log";
        defaultText = "\${cfg.dataDir}/log";
        description = ''
          Directory where the Jellyfin logs will be stored,
          passed with `--logdir` see [#log-directory](https://jellyfin.org/docs/general/administration/configuration/#log-directory)
        '';
      };

      openFirewall = mkOption {
        type = bool;
        default = false;
        description = ''
          Open the default ports in the firewall for the media server. The
          HTTP/HTTPS ports can be changed in the Web UI, so this option should
          only be used if they are unchanged, see [Port Bindings](https://jellyfin.org/docs/general/networking/#port-bindings).
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd = {
      tmpfiles.settings.jellyfinDirs = {
        "${cfg.dataDir}"."d" = {
          mode = "700";
          inherit (cfg) user group;
        };
        "${cfg.configDir}"."d" = {
          mode = "700";
          inherit (cfg) user group;
        };
        "${cfg.logDir}"."d" = {
          mode = "700";
          inherit (cfg) user group;
        };
        "${cfg.cacheDir}"."d" = {
          mode = "700";
          inherit (cfg) user group;
        };
      };
      services.jellyfin = {
        description = "Jellyfin Media Server";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        # This is mostly follows: https://github.com/jellyfin/jellyfin/blob/master/fedora/jellyfin.service
        # Upstream also disable some hardenings when running in LXC, we do the same with the isContainer option
        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          UMask = "0077";
          WorkingDirectory = cfg.dataDir;
          ExecStart = "${getExe cfg.package} --datadir '${cfg.dataDir}' --configdir '${cfg.configDir}' --cachedir '${cfg.cacheDir}' --logdir '${cfg.logDir}'";
          Restart = "on-failure";
          TimeoutSec = 15;
          SuccessExitStatus = [
            "0"
            "143"
          ];

          # Security options:
          NoNewPrivileges = true;
          SystemCallArchitectures = "native";
          # AF_NETLINK needed because Jellyfin monitors the network connection
          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
            "AF_NETLINK"
          ];
          RestrictNamespaces = !config.boot.isContainer;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          ProtectControlGroups = !config.boot.isContainer;
          ProtectHostname = true;
          ProtectKernelLogs = !config.boot.isContainer;
          ProtectKernelModules = !config.boot.isContainer;
          ProtectKernelTunables = !config.boot.isContainer;
          LockPersonality = true;
          PrivateTmp = !config.boot.isContainer;
          # needed for hardware acceleration
          PrivateDevices = false;
          PrivateUsers = true;
          RemoveIPC = true;

          SystemCallFilter = [
            "~@clock"
            "~@aio"
            "~@chown"
            "~@cpu-emulation"
            "~@debug"
            "~@keyring"
            "~@memlock"
            "~@module"
            "~@mount"
            "~@obsolete"
            "~@privileged"
            "~@raw-io"
            "~@reboot"
            "~@setuid"
            "~@swap"
          ];
          SystemCallErrorNumber = "EPERM";
        };
      };
    };

    users.users = mkIf (cfg.user == "jellyfin") {
      jellyfin = {
        inherit (cfg) group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "jellyfin") {
      jellyfin = { };
    };

    networking.firewall = mkIf cfg.openFirewall {
      # from https://jellyfin.org/docs/general/networking/index.html
      allowedTCPPorts = [
        8096
        8920
      ];
      allowedUDPPorts = [
        1900
        7359
      ];
    };

  };

  meta.maintainers = with maintainers; [
    minijackson
    fsnkty
  ];
}

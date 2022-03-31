{ config, pkgs, lib, ... }:

with lib;

let cfg = config.services.jellyfin;
in {
  options = {
    services.jellyfin = {
      enable = mkEnableOption "Jellyfin Media Server";

      user = mkOption {
        type = types.str;
        default = "jellyfin";
        description = "User account under which Jellyfin runs.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.jellyfin;
        defaultText = literalExpression "pkgs.jellyfin";
        description = ''
          Jellyfin package to use.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "jellyfin";
        description = "Group under which jellyfin runs.";
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/jellyfin";
        description =
          "This is the directory that will hold all Jellyfin data, and is also used as a default base directory.";
      };

      cacheDir = mkOption {
        type = types.str;
        default = "/var/cache/jellyfin";
        description = "This is the directory containing the server cache.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open the default ports in the firewall for the media server. The
          HTTP/HTTPS ports can be changed in the Web UI, so this option should
          only be used if they are unchanged.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.jellyfin = {
      description = "Jellyfin Media Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = rec {
        User = cfg.user;
        Group = cfg.group;
        ExecStart =
          "${cfg.package}/bin/jellyfin --datadir '${cfg.dataDir}' --cachedir '${cfg.cacheDir}'";
        Restart = "on-failure";

        # Security options:

        NoNewPrivileges = true;

        AmbientCapabilities = "";
        CapabilityBoundingSet = "";

        # ProtectClock= adds DeviceAllow=char-rtc r
        DeviceAllow = "";

        LockPersonality = true;

        PrivateTmp = true;
        # Disabled to allow Jellyfin to access hw accel devices endpoints
        # PrivateDevices = true;
        PrivateUsers = true;

        # Disabled as it does not allow Jellyfin to interface with CUDA devices
        # ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;

        RemoveIPC = true;

        RestrictNamespaces = true;
        # AF_NETLINK needed because Jellyfin monitors the network connection
        RestrictAddressFamilies =
          [ "AF_NETLINK" "AF_INET" "AF_INET6" "AF_UNIX" ];
        RestrictRealtime = true;
        RestrictSUIDSGID = true;

        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [
          "@system-service"
          "~@cpu-emulation"
          "~@debug"
          "~@keyring"
          "~@memlock"
          "~@obsolete"
          "~@privileged"
          "~@setuid"
        ];
      };
    };

    users.users = mkIf (cfg.user == "jellyfin") {
      jellyfin = {
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "jellyfin") { jellyfin = { }; };

    networking.firewall = mkIf cfg.openFirewall {
      # from https://jellyfin.org/docs/general/networking/index.html
      allowedTCPPorts = [ 8096 8920 ];
      allowedUDPPorts = [ 1900 7359 ];
    };

  };

  meta.maintainers = with lib.maintainers; [ minijackson ];
}

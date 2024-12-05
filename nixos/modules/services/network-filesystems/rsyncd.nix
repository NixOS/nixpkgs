{ config, pkgs, lib, ... }:
let
  cfg = config.services.rsyncd;
  settingsFormat = pkgs.formats.ini { };
  configFile = settingsFormat.generate "rsyncd.conf" cfg.settings;
in {
  options = {
    services.rsyncd = {

      enable = lib.mkEnableOption "the rsync daemon";

      port = lib.mkOption {
        default = 873;
        type = lib.types.port;
        description = "TCP port the daemon will listen on.";
      };

      settings = lib.mkOption {
        inherit (settingsFormat) type;
        default = { };
        example = {
          global = {
            uid = "nobody";
            gid = "nobody";
            "use chroot" = true;
            "max connections" = 4;
          };
          ftp = {
            path = "/var/ftp/./pub";
            comment = "whole ftp area";
          };
          cvs = {
            path = "/data/cvs";
            comment = "CVS repository (requires authentication)";
            "auth users" = [ "tridge" "susan" ];
            "secrets file" = "/etc/rsyncd.secrets";
          };
        };
        description = ''
          Configuration for rsyncd. See
          {manpage}`rsyncd.conf(5)`.
        '';
      };

      socketActivated = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "If enabled Rsync will be socket-activated rather than run persistently.";
      };

    };
  };

  imports = (map (option:
    lib.mkRemovedOptionModule [ "services" "rsyncd" option ]
    "This option was removed in favor of `services.rsyncd.settings`.") [
      "address"
      "extraConfig"
      "motd"
      "user"
      "group"
    ]);

  config = lib.mkIf cfg.enable {

    services.rsyncd.settings.global.port = toString cfg.port;

    systemd = let
      serviceConfigSecurity = {
        ProtectSystem = "full";
        PrivateDevices = "on";
        NoNewPrivileges = "on";
      };
    in {
      services.rsync = {
        enable = !cfg.socketActivated;
        aliases = [ "rsyncd.service" ];

        description = "fast remote file copy program daemon";
        after = [ "network.target" ];
        documentation = [ "man:rsync(1)" "man:rsyncd.conf(5)" ];

        serviceConfig = serviceConfigSecurity // {
          ExecStart =
            "${pkgs.rsync}/bin/rsync --daemon --no-detach --config=${configFile}";
          RestartSec = 1;
        };

        wantedBy = [ "multi-user.target" ];
      };

      services."rsync@" = {
        description = "fast remote file copy program daemon";
        after = [ "network.target" ];

        serviceConfig = serviceConfigSecurity // {
          ExecStart = "${pkgs.rsync}/bin/rsync --daemon --config=${configFile}";
          StandardInput = "socket";
          StandardOutput = "inherit";
          StandardError = "journal";
        };
      };

      sockets.rsync = {
        enable = cfg.socketActivated;

        description = "socket for fast remote file copy program daemon";
        conflicts = [ "rsync.service" ];

        listenStreams = [ (toString cfg.port) ];
        socketConfig.Accept = true;

        wantedBy = [ "sockets.target" ];
      };
    };

  };

  meta.maintainers = with lib.maintainers; [ ehmry ];

  # TODO: socket activated rsyncd

}

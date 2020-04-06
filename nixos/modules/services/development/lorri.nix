{ config, lib, pkgs, ... }:

let
  cfg = config.services.lorri;
  socketPath = "lorri/daemon.socket";
in {
  options = {
    services.lorri = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Enables the daemon for `lorri`, a nix-shell replacement for project
          development. The socket-activated daemon starts on the first request
          issued by the `lorri` command.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.sockets.lorri = {
      description = "Socket for Lorri Daemon";
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenStream = "%t/${socketPath}";
        RuntimeDirectory = "lorri";
      };
    };

    systemd.user.services.lorri = {
      description = "Lorri Daemon";
      requires = [ "lorri.socket" ];
      after = [ "lorri.socket" ];
      path = with pkgs; [ config.nix.package git gnutar gzip ];
      serviceConfig = {
        ExecStart = "${pkgs.lorri}/bin/lorri daemon";
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        Restart = "on-failure";
      };
    };

    environment.systemPackages = [ pkgs.lorri ];
  };
}

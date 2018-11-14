{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.fcgiwrap;
in {

  options = {
    services.fcgiwrap = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable fcgiwrap, a server for running CGI applications over FastCGI.";
      };

      preforkProcesses = mkOption {
        type = types.int;
        default = 1;
        description = "Number of processes to prefork.";
      };

      socketAddress = mkOption {
        type = types.str;
        default = "/run/fcgiwrap.sock";
        example = "1.2.3.4:5678";
        description = ''
          Socket address as defined in
          <citerefentry><refentrytitle>systemd.socket</refentrytitle><manvolnum>5</manvolnum></citerefentry>
          for <literal>ListemStream</literal>.
        '';
      };

      socketUser = mkOption {
        type = types.str;
        default = "root";
        description = "Owner of the socket if it is defined as a Unix socket.";
      };

      socketGroup = mkOption {
        type = types.str;
        default = "root";
        description = "Group of the socket if it is defined as a Unix socket.";
      };

      socketMode = mkOption {
        type = types.str;
        default = "0660";
        description = "File mode of the socket if it is defined as a Unix socket.";
      };

      user = mkOption {
        type = types.str;
        default = "nobody";
        description = "User permissions for the socket.";
      };

      group = mkOption {
        type = types.str;
        default = "nogroup";
        description = "Group permissions for the socket.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.fcgiwrap = {
      after = [ "nss-user-lookup.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.fcgiwrap}/sbin/fcgiwrap -c ${toString cfg.preforkProcesses}";
        User = cfg.user;
        Group = cfg.group;
      };
    };

    systemd.sockets.fcgiwrap = {
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenStream = cfg.socketAddress;
        SocketUser = cfg.socketUser;
        SocketGroup = cfg.socketGroup;
        SocketMode = cfg.socketMode;
      };
    };
  };
}

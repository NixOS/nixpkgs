{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.virtualisation.containerd;
in
{
  options.virtualisation.containerd = {
    enable = mkEnableOption "Containerd container runtime";

    listenOptions = mkOption {
      type = types.listOf types.str;
      default = [ "/run/containerd/containerd.sock" ];
      description =
        ''
          A list of unix and TCP socket containerd should listen to. The format follows
          ListenStream as described in systemd.socket(5).
        '';
    };

    packages = mkOption {
      type = types.listOf types.package;
      default = [ pkgs.runc ];
      defaultText = "[ pkgs.runc ]";
      description = "List of packages to be added to containerd service path";
    };

    extraOptions = mkOption {
      type = types.separatedString " ";
      default = "";
      description =
        ''
          The extra command-line options to pass to
          <command>containerd</command> daemon.
        '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.containerd ];
    systemd.packages = [ pkgs.containerd ];

    systemd.services.containerd = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.containerd}/bin/containerd ${cfg.extraOptions}";
      };
      path = [ pkgs.containerd ] ++ cfg.packages;
    };


    systemd.sockets.containerd = {
      description = "Containerd Socket for the API";
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenStream = cfg.listenOptions;
        SocketMode = "0660";
        SocketUser = "root";
        SocketGroup = "root";
      };
    };

  };


}

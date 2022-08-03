{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.irkerd;
  ports = [ 6659 ];
in
{
  options.services.irkerd = {
    enable = mkOption {
      description = lib.mdDoc "Whether to enable irker, an IRC notification daemon.";
      default = false;
      type = types.bool;
    };

    openPorts = mkOption {
      description = lib.mdDoc "Open ports in the firewall for irkerd";
      default = false;
      type = types.bool;
    };

    listenAddress = mkOption {
      default = "localhost";
      example = "0.0.0.0";
      type = types.str;
      description = lib.mdDoc ''
        Specifies the bind address on which the irker daemon listens.
        The default is localhost.

        Irker authors strongly warn about the risks of running this on
        a publicly accessible interface, so change this with caution.
      '';
    };

    nick = mkOption {
      default = "irker";
      type = types.str;
      description = lib.mdDoc "Nick to use for irker";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.irkerd = {
      description = "Internet Relay Chat (IRC) notification daemon";
      documentation = [ "man:irkerd(8)" "man:irkerhook(1)" "man:irk(1)" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.irker}/bin/irkerd -H ${cfg.listenAddress} -n ${cfg.nick}";
        User = "irkerd";
      };
    };

    environment.systemPackages = [ pkgs.irker ];

    users.users.irkerd = {
      description = "Irker daemon user";
      isSystemUser = true;
      group = "irkerd";
    };
    users.groups.irkerd = {};

    networking.firewall.allowedTCPPorts = mkIf cfg.openPorts ports;
    networking.firewall.allowedUDPPorts = mkIf cfg.openPorts ports;
  };
}

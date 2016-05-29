{ config, stdenv, pkgs, lib, ... }:

with lib;

{
  options = {
    services.toxvpn = {
      enable = mkOption {
        type        = types.bool;
        default     = false;
        description = "enable toxvpn running on startup";
      };

      localip = mkOption {
        type        = types.string;
        default     = "10.123.123.1";
        description = "your ip on the vpn";
      };

      port = mkOption {
        type        = types.int;
        default     = 33445;
        description = "udp port for toxcore, port-forward to help with connectivity if you run many nodes behind one NAT";
      };
    };
  };

  config = mkIf config.services.toxvpn.enable {
    systemd.services.toxvpn = {
      description = "toxvpn daemon";

      requires = [ "network-online.target" ]; # consider replacing by NetworkManager-wait-online.service
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        mkdir -p /run/toxvpn || true
        chown toxvpn /run/toxvpn
      '';

      serviceConfig = {
        ExecStart = "${pkgs.toxvpn}/bin/toxvpn -i ${config.services.toxvpn.localip} -l /run/toxvpn/control -u toxvpn -p ${toString config.services.toxvpn.port}";
        KillMode  = "process";
        Restart   = "on-success";
        Type      = "notify";
      };
    };

    users.extraUsers = {
      toxvpn = {
        uid        = config.ids.uids.toxvpn;
        home       = "/var/lib/toxvpn";
        createHome = true;
      };
    };
  };
}

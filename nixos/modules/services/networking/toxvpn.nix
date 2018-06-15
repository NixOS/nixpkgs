{ config, stdenv, pkgs, lib, ... }:

with lib;

{
  options = {
    services.toxvpn = {
      enable = mkEnableOption "enable toxvpn running on startup";

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

      auto_add_peers = mkOption {
        type        = types.listOf types.string;
        default     = [];
        example     = ''[ "toxid1" "toxid2" ]'';
        description = "peers to automacally connect to on startup";
      };
    };
  };

  config = mkIf config.services.toxvpn.enable {
    systemd.services.toxvpn = {
      description = "toxvpn daemon";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      preStart = ''
        mkdir -p /run/toxvpn || true
        chown toxvpn /run/toxvpn
      '';

      path = [ pkgs.toxvpn ];

      script = ''
        exec toxvpn -i ${config.services.toxvpn.localip} -l /run/toxvpn/control -u toxvpn -p ${toString config.services.toxvpn.port} ${lib.concatMapStringsSep " " (x: "-a ${x}") config.services.toxvpn.auto_add_peers}
      '';

      serviceConfig = {
        KillMode  = "process";
        Restart   = "on-success";
        Type      = "notify";
      };

      restartIfChanged = false; # Likely to be used for remote admin
    };

    environment.systemPackages = [ pkgs.toxvpn ];

    users.extraUsers = {
      toxvpn = {
        uid        = config.ids.uids.toxvpn;
        home       = "/var/lib/toxvpn";
        createHome = true;
      };
    };
  };
}

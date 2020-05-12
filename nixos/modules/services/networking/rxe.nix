{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.rxe;

in {
  ###### interface

  options = {
    networking.rxe = {
      enable = mkEnableOption "RDMA over converged ethernet";
      interfaces = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "eth0" ];
        description = ''
          Enable RDMA on the listed interfaces. The corresponding virtual
          RDMA interfaces will be named rxe_&lt;interface&gt;.
          UDP port 4791 must be open on the respective ethernet interfaces.
        '';
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.rxe = {
      description = "RoCE interfaces";

      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-modules-load.service" "network-online.target" ];
      wants = [ "network-pre.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = map ( x:
          "${pkgs.iproute}/bin/rdma link add rxe_${x} type rxe netdev ${x}"
          ) cfg.interfaces;

        ExecStop = map ( x:
          "${pkgs.iproute}/bin/rdma link delete rxe_${x}"
          ) cfg.interfaces;
      };
    };
  };
}


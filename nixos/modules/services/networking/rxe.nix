{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.rxe;

  runRxeCmd = cmd: ifcs:
    concatStrings ( map (x: "${pkgs.rdma-core}/bin/rxe_cfg -n ${cmd} ${x};") ifcs);

  startScript = pkgs.writeShellScriptBin "rxe-start" ''
    ${pkgs.rdma-core}/bin/rxe_cfg -n start
    ${runRxeCmd "add" cfg.interfaces}
    ${pkgs.rdma-core}/bin/rxe_cfg
  '';

  stopScript = pkgs.writeShellScriptBin "rxe-stop" ''
    ${runRxeCmd "remove" cfg.interfaces }
    ${pkgs.rdma-core}/bin/rxe_cfg -n stop
  '';

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
          RDMA interfaces will be named rxe0 ... rxeN where the ordering
          will be as they are named in the list. UDP port 4791 must be
          open on the respective ethernet interfaces.
        '';
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.rxe = {
      path = with pkgs; [ kmod rdma-core ];
      description = "RoCE interfaces";

      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-modules-load.service" "network-online.target" ];
      wants = [ "network-pre.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${startScript}/bin/rxe-start";
        ExecStop = "${stopScript}/bin/rxe-stop";
      };
    };
  };
}


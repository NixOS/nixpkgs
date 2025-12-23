{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.hardware.infiniband;
  opensm-services = {
    "opensm@" = {
      enable = true;
      description = "Starts OpenSM Infiniband fabric Subnet Managers";
      before = [ "network.target" ];
      unitConfig = {
        ConditionPathExists = "/sys/class/infiniband_mad/abi_version";
      };
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.opensm}/bin/opensm --guid %I --log_file /var/log/opensm.%I.log";
      };
    };
  }
  // (builtins.listToAttrs (
    map (guid: {
      name = "opensm@${guid}";
      value = {
        enable = true;
        wantedBy = [ "machines.target" ];
        overrideStrategy = "asDropin";
      };
    }) cfg.guids
  ));

in

{
  options.hardware.infiniband = {
    enable = lib.mkEnableOption "Infiniband support";
    guids = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      example = [ "0xe8ebd30000eee2e1" ];
      description = ''
        A list of infiniband port guids on the system. This is discoverable using `ibstat -p`
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot.initrd.kernelModules = [
      "mlx5_core"
      "mlx5_ib"
      "ib_cm"
      "rdma_cm"
      "rdma_ucm"
      "rpcrdma"
      "ib_ipoib"
      "ib_isert"
      "ib_umad"
      "ib_uverbs"
    ];
    # rdma-core exposes ibstat, mstflint exposes mstconfig (which can be needed for
    # setting link configurations), qperf needed to affirm link speeds
    environment.systemPackages = with pkgs; [
      rdma-core
      mstflint
      qperf
    ];
    systemd.services = opensm-services;
  };
}

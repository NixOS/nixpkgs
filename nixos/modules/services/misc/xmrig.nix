{ config, pkgs, lib, ... }:


let
  cfg = config.services.xmrig;
  settings =
    if cfg.cuda.enable then {
      cuda.enabled = true;
      cuda.loader = "${pkgs.xmrig-cuda}/lib/libxmrig-cuda.so";
      cuda.nvml = "/run/opengl-driver/lib/libnvidia-ml.so";
    } // cfg.settings
    else cfg.settings;

  json = pkgs.formats.json { };
  configFile = json.generate "config.json" settings;
in

with lib;

{
  options = {
    services.xmrig = {
      enable = mkEnableOption (lib.mdDoc "XMRig Mining Software");

      package = mkOption {
        type = types.package;
        default = pkgs.xmrig;
        defaultText = literalExpression "pkgs.xmrig";
        example = literalExpression "pkgs.xmrig-mo";
        description = lib.mdDoc "XMRig package to use.";
      };

      settings = mkOption {
        default = { };
        type = json.type;
        example = literalExpression ''
          {
            autosave = true;
            cpu = true;
            opencl = false;
            cuda = false;
            pools = [
              {
                url = "pool.supportxmr.com:443";
                user = "your-wallet";
                keepalive = true;
                tls = true;
              }
            ]
          }
        '';
        description = lib.mdDoc ''
          XMRig configuration. Refer to
          <https://xmrig.com/docs/miner/config>
          for details on supported values.
        '';
      };

      cuda.enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Enable CUDA plugin.";
      };
      cuda.archectictures = mkOption {
        type = types.listOf types.int;
        default = [ 30 35 60 70 75 80 ];
        description = lib.mdDoc ''
          List of supported CUDA versions.
          Select for your GPU: https://developer.nvidia.com/cuda-gpus#compute
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "msr" ];

    systemd.services.xmrig = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "XMRig Mining Software Service";
      serviceConfig = {
        ExecStartPre = "${cfg.package}/bin/xmrig --config=${configFile} --dry-run";
        ExecStart = "${cfg.package}/bin/xmrig --config=${configFile}";
        # https://xmrig.com/docs/miner/randomx-optimization-guide/msr
        # If you use recent XMRig with root privileges (Linux) or admin
        # privileges (Windows) the miner configure all MSR registers
        # automatically.
        DynamicUser = lib.mkDefault false;
      };
    };
  };

  meta = with lib; {
    maintainers = with maintainers; [ ratsclub ];
  };
}

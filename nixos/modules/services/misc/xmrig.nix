{ config, pkgs, lib, addOpenGLRunpath, ... }:


let
  cfg = config.services.xmrig;
  settings =
    if cfg.cuda.enable then {
      cuda.enabled = true;
      cuda.loader = "${pkgs.xmrig-cuda}/lib/libxmrig-cuda.so";
      cuda.nvml = "${addOpenGLRunpath.driverLink}/lib/libnvidia-ml.so";
    } // cfg.settings
    else cfg.settings;

  json = pkgs.formats.json { };
  configFile = json.generate "config.json" settings;
in

with lib;

{
  options = {
    services.xmrig = {
      enable = mkEnableOption "XMRig Mining Software";

      package = mkPackageOption pkgs "xmrig" {
        example = "xmrig-mo";
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
        description = ''
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
    };
  };

  config = mkIf cfg.enable {
    hardware.cpu.x86.msr.enable = true;

    systemd.services.xmrig = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "XMRig Mining Software Service";
      serviceConfig = {
        ExecStartPre = "${lib.getExe cfg.package} --config=${configFile} --dry-run";
        ExecStart = "${lib.getExe cfg.package} --config=${configFile}";
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

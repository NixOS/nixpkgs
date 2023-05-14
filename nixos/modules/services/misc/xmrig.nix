{ config, pkgs, lib, ... }:


let
  cfg = config.services.xmrig;

  json = pkgs.formats.json { };
  configFile = json.generate "config.json" cfg.settings;
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

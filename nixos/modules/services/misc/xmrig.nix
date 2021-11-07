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
      enable = mkEnableOption "XMRig Mining Software";

      package = mkOption {
        type = types.package;
        default = pkgs.xmrig;
        example = literalExpression "pkgs.xmrig-mo";
        description = "XMRig package to use.";
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
          <link xlink:href="https://xmrig.com/docs/miner/config"/>
          for details on supported values.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.xmrig = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "XMRig Mining Software Service";
      serviceConfig = {
        ExecStartPre = "${cfg.package}/bin/xmrig --config=${configFile} --dry-run";
        ExecStart = "${cfg.package}/bin/xmrig --config=${configFile}";
        DynamicUser = true;
      };
    };
  };

  meta = with lib; {
    description = "XMRig Mining Software Service";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ratsclub ];
  };
}

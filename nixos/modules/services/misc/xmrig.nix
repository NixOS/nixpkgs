{ config, pkgs, lib, ... }:


let
  cfg = config.services.xmrig;

  json = pkgs.formats.json { };

  configJSON = builtins.toJSON cfg.config;
  configFile = builtins.toFile "config.json" configJSON;
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
        description = "XMRig package to use";
      };

      config = lib.mkOption {
        default = {};
        type = json.type;
        example = literalExpression ''
          {
            "autosave": true,
            "cpu": true,
            "opencl": false,
            "cuda": false,
            "pools": [
              {
                "url": "pool.supportxmr.com:443",
                "user": "your-wallet",
                "keepalive": true,
                "tls": true
              }
            ]
          }
        '';
        description = "Configuration that would go into config.json file";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.xmrig = {
      wantedBy = [ "multi-target.target" ];
      after = [ "network.target" ];
      description = "XMRig Mining Software Service";
      serviceConfig = {
        Type = "forking";
        ExecStart = "${cfg.package}/bin/xmrig --config=${configFile}";
      };
    };
  };

  meta = with lib; {
    description = "XMRig Mining Software Service";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ratsclub ];
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

let
  globalCfg = config.services.scion;
  cfg = config.services.scion.scion-ip-gateway;
  toml = pkgs.formats.toml { };
  json = pkgs.formats.json { };
  connectionDir = if globalCfg.stateless then "/run" else "/var/lib";
  defaultConfig = {
    tunnel = { };
    gateway = {
      traffic_policy_file = "${trafficConfigFile}";
    };
  };
  defaultTrafficConfig = {
    ASes = { };
    ConfigVersion = 9001;
  };
  configFile = toml.generate "scion-ip-gateway.toml" (lib.recursiveUpdate defaultConfig cfg.config);
  trafficConfigFile = json.generate "scion-ip-gateway-traffic.json" (
    lib.recursiveUpdate defaultTrafficConfig cfg.trafficConfig
  );
in
{
  options.services.scion.scion-ip-gateway = {
    enable = lib.mkEnableOption "the scion-ip-gateway service";
    config = lib.mkOption {
      default = { };
      type = toml.type;
      example = lib.literalExpression ''
        {
          tunnel = {
            src_ipv4 = "172.16.100.1";
          };
        }
      '';
      description = ''
        scion-ip-gateway daemon configuration
      '';
    };
    trafficConfig = lib.mkOption {
      default = { };
      type = json.type;
      example = lib.literalExpression ''
        {
          ASes = {
            "2-ffaa:0:b" = {
              Nets = [
                  "172.16.1.0/24"
              ];
            };
          };
          ConfigVersion = 9001;
        }
      '';
      description = ''
        scion-ip-gateway traffic configuration
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.scion-ip-gateway = {
      description = "SCION IP Gateway Service";
      after = [
        "network-online.target"
        "scion-dispatcher.service"
      ];
      wants = [
        "network-online.target"
        "scion-dispatcher.service"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        Group = if (config.services.scion.scion-dispatcher.enable == true) then "scion" else null;
        ExecStart = "${globalCfg.package}/bin/scion-ip-gateway --config ${configFile}";
        DynamicUser = true;
        AmbientCapabilities = [ "CAP_NET_ADMIN" ];
        Restart = "on-failure";
        KillMode = "control-group";
        RemainAfterExit = false;
      };
    };
  };
}

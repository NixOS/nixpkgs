{ config, lib, pkgs, ... }:

with lib;

let
  globalCfg = config.services.scion;
  cfg = config.services.scion.scion-router;
  toml = pkgs.formats.toml { };
  defaultConfig = {
    general = {
      id = "br";
      config_dir = "/etc/scion";
    };
  };
  configFile = toml.generate "scion-router.toml" (recursiveUpdate defaultConfig cfg.settings);
in
{
  options.services.scion.scion-router = {
    enable = mkEnableOption "the scion-router service";
    settings = mkOption {
      default = { };
      type = toml.type;
      example = literalExpression ''
        {
          general.id = "br";
        }
      '';
      description = ''
        scion-router configuration. Refer to
        <https://docs.scion.org/en/latest/manuals/common.html>
        for details on supported values.
      '';
    };
  };
  config = mkIf cfg.enable {
    systemd.services.scion-router = {
      description = "SCION Router";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${globalCfg.package}/bin/scion-router --config ${configFile}";
        Restart = "on-failure";
        DynamicUser = true;
        ${if globalCfg.stateless then "RuntimeDirectory" else "StateDirectory"} = "scion-router";
      };
    };
  };
}

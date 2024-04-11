{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.scion.scion-router;
  toml = pkgs.formats.toml { };
  defaultConfig = {
    general = {
      id = "br";
      config_dir = "/etc/scion";
    };
  };
  configFile = toml.generate "scion-router.toml" (defaultConfig // cfg.settings);
in
{
  options.services.scion.scion-router = {
    enable = mkEnableOption (lib.mdDoc "the scion-router service");
    settings = mkOption {
      default = { };
      type = toml.type;
      example = literalExpression ''
        {
          general.id = "br";
        }
      '';
      description = lib.mdDoc ''
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
        ExecStart = "${pkgs.scion}/bin/scion-router --config ${configFile}";
        Restart = "on-failure";
        DynamicUser = true;
        StateDirectory = "scion-router";
      };
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.scion.scion-control;
  toml = pkgs.formats.toml { };
  defaultConfig = {
    general = {
      id = "cs";
      config_dir = "/etc/scion";
      reconnect_to_dispatcher = true;
    };
    beacon_db = {
      connection = "/var/lib/scion-control/control.beacon.db";
    };
    path_db = {
      connection = "/var/lib/scion-control/control.path.db";
    };
    trust_db = {
      connection = "/var/lib/scion-control/control.trust.db";
    };
    log.console = {
      level = "info";
    };
  };
  configFile = toml.generate "scion-control.toml" (defaultConfig // cfg.settings);
in
{
  options.services.scion.scion-control = {
    enable = mkEnableOption "the scion-control service";
    settings = mkOption {
      default = { };
      type = toml.type;
      example = literalExpression ''
        {
          path_db = {
            connection = "/var/lib/scion-control/control.path.db";
          };
          log.console = {
            level = "info";
          };
        }
      '';
      description = ''
        scion-control configuration. Refer to
        <https://docs.scion.org/en/latest/manuals/common.html>
        for details on supported values.
      '';
    };
  };
  config = mkIf cfg.enable {
    systemd.services.scion-control = {
      description = "SCION Control Service";
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
        ExecStart = "${pkgs.scion}/bin/scion-control --config ${configFile}";
        DynamicUser = true;
        Restart = "on-failure";
        BindPaths = [ "/dev/shm:/run/shm" ];
        StateDirectory = "scion-control";
      };
    };
  };
}

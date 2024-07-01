{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.scion.scion-daemon;
  toml = pkgs.formats.toml { };
  defaultConfig = {
    general = {
      id = "sd";
      config_dir = "/etc/scion";
      reconnect_to_dispatcher = true;
    };
    path_db = {
      connection = "/run/scion-daemon/sd.path.db";
    };
    trust_db = {
      connection = "/run/scion-daemon/sd.trust.db";
    };
    log.console = {
      level = "info";
    };
  };
  configFile = toml.generate "scion-daemon.toml" (recursiveUpdate defaultConfig cfg.settings);
in
{
  options.services.scion.scion-daemon = {
    enable = mkEnableOption "the scion-daemon service";
    settings = mkOption {
      default = { };
      type = toml.type;
      example = literalExpression ''
        {
          path_db = {
            connection = "/run/scion-daemon/sd.path.db";
          };
          log.console = {
            level = "info";
          };
        }
      '';
      description = ''
        scion-daemon configuration. Refer to
        <https://docs.scion.org/en/latest/manuals/common.html>
        for details on supported values.
      '';
    };
  };
  config = mkIf cfg.enable {
    systemd.services.scion-daemon = {
      description = "SCION Daemon";
      after = [ "network-online.target" "scion-dispatcher.service" ];
      wants = [ "network-online.target" "scion-dispatcher.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.scion}/bin/scion-daemon --config ${configFile}";
        Restart = "on-failure";
        DynamicUser = true;
        RuntimeDirectory = "scion-daemon";
      };
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.fluentd;

  pluginArgs = lib.concatStringsSep " " (map (x: "-p ${x}") cfg.plugins);
in
{
  ###### interface

  options = {

    services.fluentd = {
      enable = lib.mkEnableOption "fluentd, a data/log collector";

      config = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Fluentd config.";
      };

      package = lib.mkPackageOption pkgs "fluentd" { };

      plugins = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        description = ''
          A list of plugin paths to pass into fluentd. It will make plugins defined in ruby files
          there available in your config.
        '';
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    systemd.services.fluentd = {
      description = "Fluentd Daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/fluentd -c ${pkgs.writeText "fluentd.conf" cfg.config} ${pluginArgs}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
    };
  };
}

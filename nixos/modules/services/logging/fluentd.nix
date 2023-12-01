{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.fluentd;

  pluginArgs = concatStringsSep " " (map (x: "-p ${x}") cfg.plugins);
in {
  ###### interface

  options = {

    services.fluentd = {
      enable = mkEnableOption (lib.mdDoc "fluentd");

      config = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc "Fluentd config.";
      };

      package = mkPackageOption pkgs "fluentd" { };

      plugins = mkOption {
        type = types.listOf types.path;
        default = [];
        description = lib.mdDoc ''
          A list of plugin paths to pass into fluentd. It will make plugins defined in ruby files
          there available in your config.
        '';
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.fluentd = with pkgs; {
      description = "Fluentd Daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/fluentd -c ${pkgs.writeText "fluentd.conf" cfg.config} ${pluginArgs}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
    };
  };
}

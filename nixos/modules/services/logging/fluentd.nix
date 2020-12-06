{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.fluentd;

  pluginArgs = concatStringsSep " " (map (x: "-p ${x}") cfg.plugins);
in {
  ###### interface

  options = {

    services.fluentd = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable fluentd.";
      };

      config = mkOption {
        type = types.lines;
        default = "";
        description = "Fluentd config.";
      };

      package = mkOption {
        type = types.path;
        default = pkgs.fluentd;
        defaultText = "pkgs.fluentd";
        description = "The fluentd package to use.";
      };

      plugins = mkOption {
        type = types.listOf types.path;
        default = [];
        description = ''
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

{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.taskwarrior-web;
in {

  options = {
    services.taskwarrior-web = {
      enable = mkEnableOption "taskwarrior-web service";

      user = mkOption {
        default = 'taskwarriorweb';
        example = 'taskweb';
        description = ''
          User under which taskwarrior-web should run
        '';
        type = types.str;
      };

      host = mkOption {
        default = '0.0.0.0';
        example = '0.0.0.0';
        description = ''
          Host to listen on.
        '';
        type = types.str;
      };

      port = mkOption {
        default = '5678';
        example = '9099';
        description = ''
          Port.
        '';
        type = types.int;
      };

      appdir = mkOption {
        default = '/tmp/taskwarrior_web/';
        example = '/home/user/.taskwarrior_web';
        description = ''
          Set the app dir where files are stored
        '';
        type = types.str;
      };

      pidfile = mkOption {
        default = '${appdir}/taskwarrior_web.pid';
        example = '/tmp/.taskwarrior_web.pid';
        description = ''
          Set the path to the pid file
        '';
        type = types.str;
      };

      logfile = mkOption {
        default = '${appdir}/taskwarrior_web.log';
        example = '/tmp/.taskwarrior_web.log';
        description = ''
          Set the path to the log file
        '';
        type = types.str;
      };

      urlfile = mkOption {
        default = '${appdir}/taskwarrior_web.url';
        example = '/tmp/.taskwarrior_web.url';
        description = ''
          Set the path to the URL file
        '';
        type = types.str;
      };

    };

  };


  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.taskwarrior-web ];

    systemd.services.taskwarrior-web = {
      path = [ pkgs.taskwarrior-web ];

      after = [ "network.target" "display-manager.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = ''
          ${pkgs.taskwarrior-web/bin/task-web}  \
          --no-launch                           \
          --foreground                          \
          --host ${cfg.host}                    \
          --port ${cfg.port}                    \
          --app-dir ${cfg.appdir}               \
          --pid-file ${cfg.pidfile}             \
          --log-file ${cfg.logfile}             \
          --url-file ${cfg.urlfile}
        ''

        User = cfg.user;

        ExecStop = "${pkgs.taskwarrior-web/bin/task-web} --kill";
      };
    };

  };

}

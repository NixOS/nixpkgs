{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types literalExpression;

  cfg = config.services.timetagger;
in {

  options = {
    services.timetagger = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Tag your time, get the insight

          <note><para>
            This app does not do authentication.
            You must setup authentication yourself or run it in an environment where
            only allowed users have access.
          </para></note>
        '';
      };

      bindAddr = mkOption {
        description = "Address to bind to.";
        type = types.str;
        default = "127.0.0.1";
      };

      port = mkOption {
        description = "Port to bind to.";
        type = types.port;
        default = 8080;
      };

      package = mkOption {
        description = ''
          Use own package for starting timetagger web application.

          The ${literalExpression ''pkgs.timetagger''} package only provides a
          "run.py" script for the actual package
          ${literalExpression ''pkgs.python3Packages.timetagger''}.

          If you want to provide a "run.py" script for starting timetagger
          yourself, you can do so with this option.
          If you do so, the 'bindAddr' and 'port' options are ignored.
        '';

        default = pkgs.timetagger.override { addr = cfg.bindAddr; port = cfg.port; };
        defaultText = literalExpression ''
          pkgs.timetagger.override {
            addr = ${cfg.bindAddr};
            port = ${cfg.port};
          };
        '';
        type = types.package;
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.timetagger = {
      description = "Timetagger service";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "timetagger";
        Group = "timetagger";
        StateDirectory = "timetagger";

        ExecStart = "${cfg.package}/bin/timetagger";

        Restart = "on-failure";
        RestartSec = 1;
      };
    };
  };
}


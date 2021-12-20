{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types literalExpression;

  cfg = config.services.timetagger;
in {

  options = {
    services.timetagger = {
      enable = mkEnableOption ''
        Tag your time, get the insight

        <note><para>
          This app does not do authentication.
          You must setup authentication yourself or run it in an environment where
          only allowed users have access.
        </para></note>
      '';

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

        default = null;
        type = types.package;
      };
    };
  };

  config = let
    timetaggerPkg = if !isNull cfg.package then cfg.package else
      pkgs.timetagger.overwriteAttrs {
        addr = cfg.bindAddr;
        port = cfg.port;
      };

  in mkIf cfg.enable {
    systemd.services.timetagger = {
      description = "Timetagger service";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "timetagger";
        Group = "timetagger";
        StateDirectory = "timetagger";

        ExecStart = "${timetaggerPkg}/bin/timetagger";

        Restart = "on-failure";
        RestartSec = 1;
      };
    };
  };
}


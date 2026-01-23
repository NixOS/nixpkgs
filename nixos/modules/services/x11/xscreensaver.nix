{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xscreensaver;
in
{
  options.services.xscreensaver = {
    enable = lib.mkEnableOption "xscreensaver user service";

    package = lib.mkPackageOption pkgs "xscreensaver" { };

    hooks = lib.mkOption {
      type = with lib.types; attrsOf lines;
      description = ''
        An attrset of events and commands to run upon each event.
        Refer to <https://www.jwz.org/xscreensaver/man3.html> for supported events.
      '';
      defaultText = lib.literalExpression "{ }";
      default = { };
      example = lib.literalExpression ''
        # Reconfigure autorandr on screen wake up
        {
          "RUN" = "''${lib.getExe pkgs.autorandr} --change --ignore-lid";
        };
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Make xscreensaver-auth setuid root so that it can (try to) prevent the OOM
    # killer from unlocking the screen.
    security.wrappers.xscreensaver-auth = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${pkgs.xscreensaver}/libexec/xscreensaver/xscreensaver-auth";
    };

    systemd.user.services = {
      xscreensaver = {
        enable = true;
        description = "XScreenSaver";
        after = [ "graphical-session-pre.target" ];
        partOf = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        path = [ cfg.package ];
        serviceConfig.ExecStart = "${cfg.package}/bin/xscreensaver -no-splash";
      };

      xscreensaver-hooks = lib.mkIf (cfg.enable && cfg.hooks != { }) {
        enable = true;
        description = "Run commands on XScreenSaver events";
        after = [
          "graphical-session.target"
          "xscreensaver.service"
        ];
        partOf = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        path = [ cfg.package ];
        serviceConfig = {
          Restart = "always";
        };
        script =
          let
            handlers = lib.concatMapAttrsStringSep "\n" (event: action: ''
              "${event}")
                      ( ${action}
                      )
                      ;;
            '') cfg.hooks;
          in
          ''
            xscreensaver-command -watch | while read event rest; do
              echo "XScreenSaver handler script got \"$event\""
              case $event in
                ${handlers}
              esac
            done
          '';
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    vancluever
  ];
}

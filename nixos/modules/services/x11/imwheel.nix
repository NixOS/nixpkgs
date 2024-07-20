{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.xserver.imwheel;
in
  {
    options = {
      services.xserver.imwheel = {
        enable = mkEnableOption "IMWheel service";

        extraOptions = mkOption {
          type = types.listOf types.str;
          default = [ "--buttons=45" ];
          example = [ "--debug" ];
          description = ''
            Additional command-line arguments to pass to
            {command}`imwheel`.
          '';
        };

        rules = mkOption {
          type = types.attrsOf types.str;
          default = {};
          example = literalExpression ''
            {
              ".*" = '''
                None,      Up,   Button4, 8
                None,      Down, Button5, 8
                Shift_L,   Up,   Shift_L|Button4, 4
                Shift_L,   Down, Shift_L|Button5, 4
                Control_L, Up,   Control_L|Button4
                Control_L, Down, Control_L|Button5
              ''';
            }
          '';
          description = ''
            Window class translation rules.
            /etc/X11/imwheelrc is generated based on this config
            which means this config is global for all users.
            See [official man pages](https://imwheel.sourceforge.net/imwheel.1.html)
            for more information.
          '';
        };
      };
    };

    config = mkIf cfg.enable {
      environment.systemPackages = [ pkgs.imwheel ];

      environment.etc."X11/imwheel/imwheelrc".source =
        pkgs.writeText "imwheelrc" (concatStringsSep "\n\n"
          (mapAttrsToList
            (rule: conf: "\"${rule}\"\n${conf}") cfg.rules
          ));

      systemd.user.services.imwheel = {
        description = "imwheel service";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.imwheel}/bin/imwheel " + escapeShellArgs ([
            "--detach"
            "--kill"
          ] ++ cfg.extraOptions);
          ExecStop = "${pkgs.procps}/bin/pkill imwheel";
          RestartSec = 3;
          Restart = "always";
        };
      };
    };
  }

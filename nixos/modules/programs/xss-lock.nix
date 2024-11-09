{ config, pkgs, lib, ... }:

let
  cfg = config.programs.xss-lock;
in
{
  options.programs.xss-lock = {
    enable = lib.mkEnableOption "xss-lock";

    lockerCommand = lib.mkOption {
      default = "${pkgs.i3lock}/bin/i3lock";
      defaultText = lib.literalExpression ''"''${pkgs.i3lock}/bin/i3lock"'';
      example = lib.literalExpression ''"''${pkgs.i3lock-fancy}/bin/i3lock-fancy"'';
      type = lib.types.separatedString " ";
      description = "Locker to be used with xsslock";
    };

    extraOptions = lib.mkOption {
      default = [ ];
      example = [ "--ignore-sleep" ];
      type = lib.types.listOf lib.types.str;
      description = ''
        Additional command-line arguments to pass to
        {command}`xss-lock`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.xss-lock = {
      description = "XSS Lock Daemon";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig.ExecStart =
        builtins.concatStringsSep " " ([
            "${pkgs.xss-lock}/bin/xss-lock" "--session \${XDG_SESSION_ID}"
          ] ++ (builtins.map lib.escapeShellArg cfg.extraOptions) ++ [
            "--"
            cfg.lockerCommand
        ]);
      serviceConfig.Restart = "always";
    };

    warnings = lib.mkIf (config.services.xserver.displayManager.startx.enable) [
      "xss-lock service only works if a displayManager is set; it doesn't work when services.xserver.displayManager.startx.enable = true"
    ];

  };
}

{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.xss-lock;
in
{
  options.programs.xss-lock = {
    enable = mkEnableOption "xss-lock";

    lockerCommand = mkOption {
      default = "${pkgs.i3lock}/bin/i3lock";
      defaultText = literalExpression ''"''${pkgs.i3lock}/bin/i3lock"'';
      example = literalExpression ''"''${pkgs.i3lock-fancy}/bin/i3lock-fancy"'';
      type = types.separatedString " ";
      description = lib.mdDoc "Locker to be used with xsslock";
    };

    extraOptions = mkOption {
      default = [ ];
      example = [ "--ignore-sleep" ];
      type = types.listOf types.str;
      description = lib.mdDoc ''
        Additional command-line arguments to pass to
        {command}`xss-lock`.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.xss-lock = {
      description = "XSS Lock Daemon";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig.ExecStart = with lib;
        strings.concatStringsSep " " ([
            "${pkgs.xss-lock}/bin/xss-lock" "--session \${XDG_SESSION_ID}"
          ] ++ (map escapeShellArg cfg.extraOptions) ++ [
            "--"
            cfg.lockerCommand
        ]);
    };
  };
}

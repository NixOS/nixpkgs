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
      example = literalExample ''''${pkgs.i3lock-fancy}/bin/i3lock-fancy'';
      type = types.string;
      description = "Locker to be used with xsslock";
    };

    extraOptions = mkOption {
      default = [ ];
      example = [ "--ignore-sleep" ];
      type = types.listOf types.str;
      description = ''
        Additional command-line arguments to pass to
        <command>xss-lock</command>.
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
            "${pkgs.xss-lock}/bin/xss-lock"
          ] ++ (map escapeShellArg cfg.extraOptions) ++ [
            "--"
            cfg.lockerCommand
        ]);
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.xautolock;
in
{
  options = {
    services.xserver.xautolock = {
      enable = lib.mkEnableOption "xautolock";
      enableNotifier = lib.mkEnableOption "xautolock.notify" // {
        description = ''
          Whether to enable the notifier feature of xautolock.
          This publishes a notification before the autolock.
        '';
      };

      time = lib.mkOption {
        default = 15;
        type = lib.types.int;

        description = ''
          Idle time (in minutes) to wait until xautolock locks the computer.
        '';
      };

      locker = lib.mkOption {
        default = "${pkgs.xlockmore}/bin/xlock"; # default according to `man xautolock`
        defaultText = lib.literalExpression ''"''${pkgs.xlockmore}/bin/xlock"'';
        example = lib.literalExpression ''"''${pkgs.i3lock}/bin/i3lock -i /path/to/img"'';
        type = lib.types.str;

        description = ''
          The script to use when automatically locking the computer.
        '';
      };

      nowlocker = lib.mkOption {
        default = null;
        example = lib.literalExpression ''"''${pkgs.i3lock}/bin/i3lock -i /path/to/img"'';
        type = lib.types.nullOr lib.types.str;

        description = ''
          The script to use when manually locking the computer with {command}`xautolock -locknow`.
        '';
      };

      notify = lib.mkOption {
        default = 10;
        type = lib.types.int;

        description = ''
          Time (in seconds) before the actual lock when the notification about the pending lock should be published.
        '';
      };

      notifier = lib.mkOption {
        default = null;
        example = lib.literalExpression ''"''${pkgs.libnotify}/bin/notify-send 'Locking in 10 seconds'"'';
        type = lib.types.nullOr lib.types.str;

        description = ''
          Notification script to be used to warn about the pending autolock.
        '';
      };

      killer = lib.mkOption {
        default = null; # default according to `man xautolock` is none
        example = "/run/current-system/systemd/bin/systemctl suspend";
        type = lib.types.nullOr lib.types.str;

        description = ''
          The script to use when nothing has happened for as long as {option}`killtime`
        '';
      };

      killtime = lib.mkOption {
        default = 20; # default according to `man xautolock`
        type = lib.types.int;

        description = ''
          Minutes xautolock waits until it executes the script specified in {option}`killer`
          (Has to be at least 10 minutes)
        '';
      };

      extraOptions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "-detectsleep" ];
        description = ''
          Additional command-line arguments to pass to
          {command}`xautolock`.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ xautolock ];
    systemd.user.services.xautolock = {
      description = "xautolock service";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = lib.strings.concatStringsSep " " (
          [
            "${pkgs.xautolock}/bin/xautolock"
            "-noclose"
            "-time ${toString cfg.time}"
            "-locker '${cfg.locker}'"
          ]
          ++ lib.optionals cfg.enableNotifier [
            "-notify ${toString cfg.notify}"
            "-notifier '${cfg.notifier}'"
          ]
          ++ lib.optionals (cfg.nowlocker != null) [
            "-nowlocker '${cfg.nowlocker}'"
          ]
          ++ lib.optionals (cfg.killer != null) [
            "-killer '${cfg.killer}'"
            "-killtime ${toString cfg.killtime}"
          ]
          ++ cfg.extraOptions
        );
        Restart = "always";
      };
    };
    assertions =
      [
        {
          assertion = cfg.enableNotifier -> cfg.notifier != null;
          message = "When enabling the notifier for xautolock, you also need to specify the notify script";
        }
        {
          assertion = cfg.killer != null -> cfg.killtime >= 10;
          message = "killtime has to be at least 10 minutes according to `man xautolock`";
        }
      ]
      ++ (lib.forEach [ "locker" "notifier" "nowlocker" "killer" ] (option: {
        assertion = cfg.${option} != null -> builtins.substring 0 1 cfg.${option} == "/";
        message = "Please specify a canonical path for `services.xserver.xautolock.${option}`";
      }));
  };
}

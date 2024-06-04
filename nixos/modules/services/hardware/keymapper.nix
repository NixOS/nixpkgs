{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.services.keymapper;
in
{
  options.services.keymapper = {
    enable = lib.mkEnableOption null // {
      description = ''
        Whether to enable keymapper, A cross-platform context-aware key remapper.

        The program is split into two parts:
        - {command}`keymapperd` is the service which needs to be given the permissions to grab the keyboard devices and inject keys.
        - {command}`keymapper` should be run as normal user in a graphical environment. It loads the configuration, informs the service about it and the active context and also executes mapped terminal commands.
        This module only enables {command}`keymapperd`. You have to add {command}`keymapper` to the desktop environment's auto-started application.
      '';
    };

    package = lib.mkPackageOption pkgs "keymapper" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.keymapperd = {
      description = "Keymapper Daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "exec";
        ExecStart = "${cfg.package}/bin/keymapperd -v";
        Restart = "always";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ spitulax ];
}

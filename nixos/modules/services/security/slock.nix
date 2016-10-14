{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.slock;
in {
  ###### interface

  options = {

    services.slock = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the <command>slock</command> screen locking
          mechanism.

          Enable this and then run <command>systemctl start slock</command> to
          lock the screen.
        '';
      };

      lockOn = {

        suspend = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether to lock screen with slock just before suspend.
          '';
        };

        hibernate = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether to lock screen with slock just before hibernate.
          '';
        };

        extraTargets = mkOption {
          type = types.listOf types.str;
          default = [];
          example = [ "display-manager.service" ];
          description = ''
            Other targets to lock the screen just before.

            Useful if you want to e.g. both autologin to X11 so that
            your <filename>~/.xsession</filename> gets executed and
            still to have the screen locked so that the system can be
            booted relatively unattended.
          '';
        };
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.slock ];

    systemd.services.slock = {
      enable = true;
      description = "${pkgs.slock.meta.description}";
      wantedBy = optional cfg.lockOn.suspend   "suspend.target"
              ++ optional cfg.lockOn.hibernate "hibernate.target"
              ++ cfg.lockOn.extraTargets;
      before   = optional cfg.lockOn.suspend   "systemd-suspend.service"
              ++ optional cfg.lockOn.hibernate "systemd-hibernate.service"
              ++ cfg.lockOn.extraTargets;
      serviceConfig.ExecStart = "${pkgs.slock}/bin/slock";
      environment = {
        DISPLAY = ":${toString (
          let display = config.services.xserver.display;
          in if display != null then display else 0
        )}";
      };
    };
  };

}

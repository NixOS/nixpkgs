{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.physlock;
in

{

  ###### interface

  options = {

    services.physlock = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable the {command}`physlock` screen locking mechanism.

          Enable this and then run {command}`systemctl start physlock`
          to securely lock the screen.

          This will switch to a new virtual terminal, turn off console
          switching and disable SysRq mechanism (when
          {option}`services.physlock.disableSysRq` is set)
          until the root or user password is given.
        '';
      };

      allowAnyUser = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to allow any user to lock the screen. This will install a
          setuid wrapper to allow any user to start physlock as root, which
          is a minor security risk. Call the physlock binary to use this instead
          of using the systemd service.
        '';
      };

      disableSysRq = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to disable SysRq when locked with physlock.
        '';
      };

      lockMessage = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Message to show on physlock login terminal.
        '';
      };

      muteKernelMessages = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Disable kernel messages on console while physlock is running.
        '';
      };

      lockOn = {

        suspend = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Whether to lock screen with physlock just before suspend.
          '';
        };

        hibernate = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Whether to lock screen with physlock just before hibernate.
          '';
        };

        extraTargets = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [ "display-manager.service" ];
          description = ''
            Other targets to lock the screen just before.

            Useful if you want to e.g. both autologin to X11 so that
            your {file}`~/.xsession` gets executed and
            still to have the screen locked so that the system can be
            booted relatively unattended.
          '';
        };

      };

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {

        # for physlock -l and physlock -L
        environment.systemPackages = [ pkgs.physlock ];

        systemd.services.physlock = {
          enable = true;
          documentation = [ "man:physlock(1)" ];
          description = "Physlock";
          wantedBy =
            lib.optional cfg.lockOn.suspend "suspend.target"
            ++ lib.optional cfg.lockOn.hibernate "hibernate.target"
            ++ cfg.lockOn.extraTargets;
          before =
            lib.optional cfg.lockOn.suspend "systemd-suspend.service"
            ++ lib.optional cfg.lockOn.hibernate "systemd-hibernate.service"
            ++ lib.optional (
              cfg.lockOn.hibernate || cfg.lockOn.suspend
            ) "systemd-suspend-then-hibernate.service"
            ++ cfg.lockOn.extraTargets;
          serviceConfig = {
            Type = "forking";
            ExecStart = "${pkgs.physlock}/bin/physlock -d${lib.optionalString cfg.muteKernelMessages "m"}${lib.optionalString cfg.disableSysRq "s"}${
              lib.optionalString (cfg.lockMessage != "") " -p \"${cfg.lockMessage}\""
            }";
          };
        };

        security.pam.services.physlock = { };

      }

      (lib.mkIf cfg.allowAnyUser {

        security.wrappers.physlock = {
          setuid = true;
          owner = "root";
          group = "root";
          source = "${pkgs.physlock}/bin/physlock";
        };

      })
    ]
  );

}

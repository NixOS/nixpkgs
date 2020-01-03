{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.physlock;
in

{

  ###### interface

  options = {

    services.physlock = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the <command>physlock</command> screen locking mechanism.

          Enable this and then run <command>systemctl start physlock</command>
          to securely lock the screen.

          This will switch to a new virtual terminal, turn off console
          switching and disable SysRq mechanism (when
          <option>services.physlock.disableSysRq</option> is set)
          until the root or user password is given.
        '';
      };

      allowAnyUser = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to allow any user to lock the screen. This will install a
          setuid wrapper to allow any user to start physlock as root, which
          is a minor security risk. Call the physlock binary to use this instead
          of using the systemd service.

          Note that you might need to relog to have the correct binary in your
          PATH upon changing this option.
        '';
      };

      disableSysRq = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to disable SysRq when locked with physlock.
        '';
      };

      lockOn = {

        suspend = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether to lock screen with physlock just before suspend.
          '';
        };

        hibernate = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether to lock screen with physlock just before hibernate.
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

  config = mkIf cfg.enable (mkMerge [
    {

      # for physlock -l and physlock -L
      environment.systemPackages = [ pkgs.physlock ];

      systemd.services.physlock = {
        enable = true;
        description = "Physlock";
        wantedBy = optional cfg.lockOn.suspend   "suspend.target"
                ++ optional cfg.lockOn.hibernate "hibernate.target"
                ++ cfg.lockOn.extraTargets;
        before   = optional cfg.lockOn.suspend   "systemd-suspend.service"
                ++ optional cfg.lockOn.hibernate "systemd-hibernate.service"
                ++ cfg.lockOn.extraTargets;
        serviceConfig = {
          Type = "forking";
          ExecStart = "${pkgs.physlock}/bin/physlock -d${optionalString cfg.disableSysRq "s"}";
        };
      };

      security.pam.services.physlock = {};

    }

    (mkIf cfg.allowAnyUser {

      security.wrappers.physlock = { source = "${pkgs.physlock}/bin/physlock"; user = "root"; };

    })
  ]);

}

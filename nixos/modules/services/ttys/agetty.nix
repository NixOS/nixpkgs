{ config, lib, pkgs, ... }:

with lib;

let

  autologinArg = optionalString (config.services.mingetty.autologinUser != null) "--autologin ${config.services.mingetty.autologinUser}";
  gettyCmd = extraArgs: "@${pkgs.utillinux}/sbin/agetty agetty --login-program ${pkgs.shadow}/bin/login ${autologinArg} ${extraArgs}";

in

{

  ###### interface

  options = {

    services.mingetty = {

      autologinUser = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Username of the account that will be automatically logged in at the console.
          If unspecified, a login prompt is shown as usual.
        '';
      };

      greetingLine = mkOption {
        type = types.str;
        description = ''
          Welcome line printed by mingetty.
          The default shows current NixOS version label, machine type and tty.
        '';
      };

      helpLine = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Help line printed by mingetty below the welcome line.
          Used by the installation CD to give some hints on
          how to proceed.
        '';
      };

      serialSpeed = mkOption {
        type = types.listOf types.int;
        default = [ 115200 57600 38400 9600 ];
        example = [ 38400 9600 ];
        description = ''
            Bitrates to allow for agetty's listening on serial ports. Listing more
            bitrates gives more interoperability but at the cost of long delays
            for getting a sync on the line.
        '';
      };

    };

  };


  ###### implementation

  config = {
    # Note: this is set here rather than up there so that changing
    # nixosLabel would not rebuild manual pages
    services.mingetty.greetingLine = mkDefault ''<<< Welcome to NixOS ${config.system.nixosLabel} (\m) - \l >>>'';

    systemd.services."getty@" =
      { serviceConfig.ExecStart = gettyCmd "--noclear --keep-baud %I 115200,38400,9600 $TERM";
        restartIfChanged = false;
      };

    systemd.services."serial-getty@" =
      { serviceConfig.ExecStart =
          let speeds = concatStringsSep "," (map toString config.services.mingetty.serialSpeed);
          in gettyCmd "%I ${speeds} $TERM";
        restartIfChanged = false;
      };

    systemd.services."container-getty@" =
      { unitConfig.ConditionPathExists = "/dev/pts/%I"; # Work around being respawned when "machinectl login" exits.
        serviceConfig.ExecStart = gettyCmd "--noclear --keep-baud pts/%I 115200,38400,9600 $TERM";
        restartIfChanged = false;
      };

    systemd.services."console-getty" =
      { serviceConfig.ExecStart = gettyCmd "--noclear --keep-baud console 115200,38400,9600 $TERM";
        serviceConfig.Restart = "always";
        restartIfChanged = false;
        enable = mkDefault config.boot.isContainer;
      };

    environment.etc = singleton
      { # Friendly greeting on the virtual consoles.
        source = pkgs.writeText "issue" ''

          [1;32m${config.services.mingetty.greetingLine}[0m
          ${config.services.mingetty.helpLine}

        '';
        target = "issue";
      };

  };

}

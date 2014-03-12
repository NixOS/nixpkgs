{ config, pkgs, ... }:

with pkgs.lib;

{

  ###### interface

  options = {

    services.mingetty = {

      greetingLine = mkOption {
        type = types.str;
        default = ''<<< Welcome to NixOS ${config.system.nixosVersion} (\m) - \l >>>'';
        description = ''
          Welcome line printed by mingetty.
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

    systemd.services."getty@" =
      { baseUnit = pkgs.runCommand "getty.service" {}
          ''
            sed '/ExecStart/ d' < ${config.systemd.package}/example/systemd/system/getty@.service > $out
          '';
        serviceConfig.ExecStart = "@${pkgs.utillinux}/sbin/agetty agetty --noclear --login-program ${pkgs.shadow}/bin/login %I 38400";
        restartIfChanged = false;
      };

    systemd.services."serial-getty@" =
      { baseUnit = pkgs.runCommand "serial-getty.service" {}
          ''
            sed '/ExecStart/ d' < ${config.systemd.package}/example/systemd/system/serial-getty@.service > $out
          '';
        serviceConfig.ExecStart =
          let speeds = concatStringsSep "," (map toString config.services.mingetty.serialSpeed);
          in "@${pkgs.utillinux}/sbin/agetty agetty --login-program ${pkgs.shadow}/bin/login %I ${speeds}";
        restartIfChanged = false;
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

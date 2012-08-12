{ config, pkgs, ... }:

with pkgs.lib;

{

  ###### interface

  options = {

    services.mingetty = {

      ttys = mkOption {
        default =
          if pkgs.stdenv.isArm
          then [ "ttyS0" ] # presumably an embedded platform such as a plug
          else [ "tty1" "tty2" "tty3" "tty4" "tty5" "tty6" ];
        description = ''
          The list of tty devices on which to start a login prompt.
        '';
      };

      waitOnMounts = mkOption {
        default = false;
        description = ''
          Whether the login prompts on the virtual consoles will be
          started before or after all file systems have been mounted.  By
          default we don't wait, but if for example your /home is on a
          separate partition, you may want to turn this on.
        '';
      };

      greetingLine = mkOption {
        default = ''<<< Welcome to NixOS ${config.system.nixosVersion} (\m) - \l >>>'';
        description = ''
          Welcome line printed by mingetty.
        '';
      };

      helpLine = mkOption {
        default = "";
        description = ''
          Help line printed by mingetty below the welcome line.
          Used by the installation CD to give some hints on
          how to proceed.
        '';
      };

      dontRestart = mkOption {
        default = false;
        description = ''
          Don't restart mingetty processes as this will result in active
          sessions to be logged out, for example on activation of the system's
          configuration.
        '';
      };
    };

  };


  ###### implementation

  config = {

    # Generate a separate job for each tty.
    jobs = listToAttrs (map (tty: nameValuePair tty {

      startOn =
        # On tty1 we should always wait for mountall, since it may
        # start an emergency-shell job.
        if config.services.mingetty.waitOnMounts || tty == "tty1"
        then "stopped udevtrigger and filesystem"
        else "stopped udevtrigger"; # !!! should start as soon as the tty device is created

      path = [ pkgs.mingetty ];

      exec = "mingetty --loginprog=${pkgs.shadow}/bin/login --noclear ${tty}";

      restartIfChanged = !config.services.mingetty.dontRestart;

      environment.LOCALE_ARCHIVE = "/run/current-system/sw/lib/locale/locale-archive";

    }) config.services.mingetty.ttys);

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

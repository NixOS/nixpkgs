{ config, pkgs, ... }:

let

  options = {

    boot = {
      postBootCommands = pkgs.lib.mkOption {
        default = "";
        example = "rm -f /var/log/messages";
        type = with pkgs.lib.types; string;
        description = ''
          Shell commands to be executed just before Upstart is started.
        '';
      };

      devSize = pkgs.lib.mkOption {
        default = "5%";
        example = "32m";
        description = ''
          Size limit for the /dev tmpfs. Look at mount(8), tmpfs size option,
          for the accepted syntax.
        '';
      };

      devShmSize = pkgs.lib.mkOption {
        default = "50%";
        example = "256m";
        description = ''
          Size limit for the /dev/shm tmpfs. Look at mount(8), tmpfs size option,
          for the accepted syntax.
        '';
      };

      runSize = pkgs.lib.mkOption {
        default = "25%";
        example = "256m";
        description = ''
          Size limit for the /run tmpfs. Look at mount(8), tmpfs size option,
          for the accepted syntax.
        '';
      };

      cleanTmpDir = pkgs.lib.mkOption {
        default = false;
        example = true;
        description = ''
          Delete all files in /tmp/ during boot.
        '';
      };
    };

  };

  kernel = config.boot.kernelPackages.kernel;
  activateConfiguration = config.system.activationScripts.script;

  bootStage2 = pkgs.substituteAll {
    src = ./stage-2-init.sh;
    shellDebug = "${pkgs.bashInteractive}/bin/bash";
    isExecutable = true;
    inherit (config.boot) devShmSize runSize cleanTmpDir;
    ttyGid = config.ids.gids.tty;
    path =
      [ pkgs.coreutils
        pkgs.utillinux
        pkgs.udev
        pkgs.sysvtools
      ] ++ pkgs.lib.optional config.boot.cleanTmpDir pkgs.findutils;
    postBootCommands = pkgs.writeText "local-cmds"
      ''
        ${config.boot.postBootCommands}
        ${config.powerManagement.powerUpCommands}
      '';
  };

in

{
  require = [options];

  system.build.bootStage2 = bootStage2;
}

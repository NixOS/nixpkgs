{pkgs, config, ...}:

let

  options = {

    boot = {
      postBootCommands = pkgs.lib.mkOption {
        default = "";
        example = "rm -f /var/log/messages";
        merge = pkgs.lib.mergeStringOption;
        description = ''
          Shell commands to be executed just before Upstart is started.
        '';
      };

      devSize = pkgs.lib.mkOption {
        default = "50%";
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

    };

  };

  inherit (pkgs) substituteAll writeText coreutils utillinux udev;
  kernel = config.boot.kernelPackages.kernel;
  activateConfiguration = config.system.activationScripts.script;

  bootStage2 = substituteAll {
    src = ./stage-2-init.sh;
    isExecutable = true;
    inherit kernel activateConfiguration;
    inherit (config.boot) devSize devShmSize;
    ttyGid = config.ids.gids.tty;
    upstart = config.system.build.upstart;
    path =
      [ coreutils
        utillinux
        udev
      ];
    postBootCommands = writeText "local-cmds"
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

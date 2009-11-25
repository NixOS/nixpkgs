{pkgs, config, ...}:

let

  options = {

    boot.postBootCommands = pkgs.lib.mkOption {
      default = "";
      example = "rm -f /var/log/messages";
      merge = pkgs.lib.mergeStringOption;
      description = ''
        Shell commands to be executed just before Upstart is started.
      '';
    };

  };

  inherit (pkgs) substituteAll writeText coreutils utillinux udev;
  kernel = config.boot.kernelPackages.kernel;
  activateConfiguration = config.system.activationScripts.script;

  bootStage2 = substituteAll {
    src = ./stage-2-init.sh;
    isExecutable = true;
    inherit kernel activateConfiguration;
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

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
  upstart = config.system.build.upstart;

  # Path for Upstart jobs.  Should be quite minimal.
  upstartPath =
    [ pkgs.coreutils
      pkgs.findutils
      pkgs.gnugrep
      pkgs.gnused
      upstart
    ];

  bootStage2 = substituteAll {
    src = ./stage-2-init.sh;
    isExecutable = true;
    inherit kernel upstart activateConfiguration upstartPath;
    path =
      [ coreutils
        utillinux
        udev
        upstart
      ];
    postBootCommands = writeText "local-cmds" config.boot.postBootCommands;
  };
  
in

{
  require = [options];

  system.build.bootStage2 = bootStage2;
}

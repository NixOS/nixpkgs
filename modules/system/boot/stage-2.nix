{pkgs, config, ...}:

let

  options = {

    boot.localCommands = pkgs.lib.mkOption {
      default = "";
      example = "text=anything; echo You can put $text here.";
      description = "
        Shell commands to be executed just before Upstart is started.
      ";
    };

  };

  inherit (pkgs) substituteAll writeText coreutils utillinux udev upstart;
  kernel = config.boot.kernelPackages.kernel;
  activateConfiguration = config.system.activationScripts.script;

  # Path for Upstart jobs.  Should be quite minimal.
  upstartPath = [
    pkgs.coreutils
    pkgs.findutils
    pkgs.gnugrep
    pkgs.gnused
    pkgs.upstart
  ];

  bootLocal = config.boot.localCommands;

  bootStage2 = substituteAll {
    src = ./stage-2-init.sh;
    isExecutable = true;
    inherit kernel upstart activateConfiguration upstartPath;
    path = [
      coreutils
      utillinux
      udev
      upstart
    ];
    bootLocal = writeText "local-cmds" bootLocal;
  };
in

{
  require = [options];

  system = {
    build = {
      inherit bootStage2;
    };
  };
}

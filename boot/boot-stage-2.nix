{pkgs, config, ...}:

let
  inherit (pkgs) substituteAll writeText coreutils utillinux udev upstart;
  kernel = config.boot.kernelPackages.kernel;
  activateConfiguration = config.system.activationScripts.script;
  inherit (config.boot) isLiveCD;

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
    src = ./boot-stage-2-init.sh;
    isExecutable = true;
    inherit kernel upstart isLiveCD activateConfiguration upstartPath;
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
  require = [
    # config.boot.localCommands
    # config.boot.kernelPackages

    # config.system.activationScripts
    (import ../system/activate-configuration.nix)

    # config.system.build
    (import ../system/system-options.nix)
  ];

  system = {
    build = {
      inherit bootStage2;
    };
  };
}

{ config, pkgs, ... }:

with pkgs.lib;

let

  kernel = config.boot.kernelPackages.kernel;
  activateConfiguration = config.system.activationScripts.script;

  readonlyMountpoint = pkgs.runCommand "readonly-mountpoint" {} ''
    mkdir -p $out/bin
    cc -O3 ${./readonly-mountpoint.c} -o $out/bin/readonly-mountpoint
    strip -s $out/bin/readonly-mountpoint
  '';

  bootStage2 = pkgs.substituteAll {
    src = ./stage-2-init.sh;
    shellDebug = "${pkgs.bashInteractive}/bin/bash";
    isExecutable = true;
    inherit (config.boot) devShmSize runSize cleanTmpDir;
    inherit (config.nix) readOnlyStore;
    ttyGid = config.ids.gids.tty;
    path =
      [ pkgs.coreutils
        pkgs.utillinux
        pkgs.sysvtools
      ] ++ (optional config.boot.cleanTmpDir pkgs.findutils)
      ++ optional config.nix.readOnlyStore readonlyMountpoint;
    postBootCommands = pkgs.writeText "local-cmds"
      ''
        ${config.boot.postBootCommands}
        ${config.powerManagement.powerUpCommands}
      '';
  };

in

{
  options = {

    boot = {

      postBootCommands = mkOption {
        default = "";
        example = "rm -f /var/log/messages";
        type = types.string;
        description = ''
          Shell commands to be executed just before systemd is started.
        '';
      };

      devSize = mkOption {
        default = "5%";
        example = "32m";
        type = types.uniq types.string;
        description = ''
          Size limit for the /dev tmpfs. Look at mount(8), tmpfs size option,
          for the accepted syntax.
        '';
      };

      devShmSize = mkOption {
        default = "50%";
        example = "256m";
        type = types.uniq types.string;
        description = ''
          Size limit for the /dev/shm tmpfs. Look at mount(8), tmpfs size option,
          for the accepted syntax.
        '';
      };

      runSize = mkOption {
        default = "25%";
        example = "256m";
        type = types.uniq types.string;
        description = ''
          Size limit for the /run tmpfs. Look at mount(8), tmpfs size option,
          for the accepted syntax.
        '';
      };

      cleanTmpDir = mkOption {
        default = false;
        example = true;
        description = ''
          Delete all files in /tmp/ during boot.
        '';
      };

    };

  };


  config = {

    system.build.bootStage2 = bootStage2;

  };
}

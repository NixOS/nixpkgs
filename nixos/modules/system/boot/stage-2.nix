{ config, lib, pkgs, ... }:

with lib;

let

  useHostResolvConf = config.networking.resolvconf.enable && config.networking.useHostResolvConf;

  bootStage2 = pkgs.substituteAll {
    src = ./stage-2-init.sh;
    shellDebug = "${pkgs.bashInteractive}/bin/bash";
    shell = "${pkgs.bash}/bin/bash";
    inherit (config.boot) systemdExecutable;
    isExecutable = true;
    inherit (config.nix) readOnlyStore;
    inherit useHostResolvConf;
    inherit (config.system.build) earlyMountScript;
    path = lib.makeBinPath ([
      pkgs.coreutils
      pkgs.utillinux
    ] ++ lib.optional useHostResolvConf pkgs.openresolv);
    fsPackagesPath = lib.makeBinPath config.system.fsPackages;
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
        type = types.lines;
        description = ''
          Shell commands to be executed just before systemd is started.
        '';
      };

      devSize = mkOption {
        default = "5%";
        example = "32m";
        type = types.str;
        description = ''
          Size limit for the /dev tmpfs. Look at mount(8), tmpfs size option,
          for the accepted syntax.
        '';
      };

      devShmSize = mkOption {
        default = "50%";
        example = "256m";
        type = types.str;
        description = ''
          Size limit for the /dev/shm tmpfs. Look at mount(8), tmpfs size option,
          for the accepted syntax.
        '';
      };

      runSize = mkOption {
        default = "25%";
        example = "256m";
        type = types.str;
        description = ''
          Size limit for the /run tmpfs. Look at mount(8), tmpfs size option,
          for the accepted syntax.
        '';
      };

      systemdExecutable = mkOption {
        default = "systemd";
        type = types.str;
        description = ''
          The program to execute to start systemd. Typically
          <literal>systemd</literal>, which will find systemd in the
          PATH.
        '';
      };
    };

  };


  config = {

    system.build.bootStage2 = bootStage2;

  };
}

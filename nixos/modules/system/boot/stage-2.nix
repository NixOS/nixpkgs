{ config, lib, pkgs, ... }:

with lib;

let

  useHostResolvConf = config.networking.resolvconf.enable && config.networking.useHostResolvConf;

  bootStage2 = pkgs.substituteAll {
    src = ./stage-2-init.sh;
    shellDebug = "${pkgs.bashInteractive}/bin/bash";
    shell = "${pkgs.bash}/bin/bash";
    inherit (config.boot) systemdExecutable extraSystemdUnitPaths;
    isExecutable = true;
    inherit (config.nix) readOnlyStore;
    inherit useHostResolvConf;
    inherit (config.system.build) earlyMountScript;
    path = lib.makeBinPath ([
      pkgs.coreutils
      pkgs.util-linux
    ] ++ lib.optional useHostResolvConf pkgs.openresolv);
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
        description = lib.mdDoc ''
          Shell commands to be executed just before systemd is started.
        '';
      };

      systemdExecutable = mkOption {
        default = "/run/current-system/systemd/lib/systemd/systemd";
        type = types.str;
        description = lib.mdDoc ''
          The program to execute to start systemd.
        '';
      };

      extraSystemdUnitPaths = mkOption {
        default = [];
        type = types.listOf types.str;
        description = lib.mdDoc ''
          Additional paths that get appended to the SYSTEMD_UNIT_PATH environment variable
          that can contain mutable unit files.
        '';
      };
    };

  };


  config = {

    system.build.bootStage2 = bootStage2;

  };
}

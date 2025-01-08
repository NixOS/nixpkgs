{
  config,
  lib,
  pkgs,
  ...
}:

let

  useHostResolvConf = config.networking.resolvconf.enable && config.networking.useHostResolvConf;

  bootStage2 = pkgs.substituteAll {
    src = ./stage-2-init.sh;
    shellDebug = "${pkgs.bashInteractive}/bin/bash";
    shell = "${pkgs.bash}/bin/bash";
    inherit (config.boot) readOnlyNixStore systemdExecutable extraSystemdUnitPaths;
    inherit (config.system.nixos) distroName;
    isExecutable = true;
    inherit useHostResolvConf;
    inherit (config.system.build) earlyMountScript;
    path = lib.makeBinPath (
      [
        pkgs.coreutils
        pkgs.util-linux
      ]
      ++ lib.optional useHostResolvConf pkgs.openresolv
    );
    postBootCommands = pkgs.writeText "local-cmds" ''
      ${config.boot.postBootCommands}
      ${config.powerManagement.powerUpCommands}
    '';
  };

in

{
  options = {

    boot = {

      postBootCommands = lib.mkOption {
        default = "";
        example = "rm -f /var/log/messages";
        type = lib.types.lines;
        description = ''
          Shell commands to be executed just before systemd is started.
        '';
      };

      readOnlyNixStore = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          If set, NixOS will enforce the immutability of the Nix store
          by making {file}`/nix/store` a read-only bind
          mount.  Nix will automatically make the store writable when
          needed.
        '';
      };

      systemdExecutable = lib.mkOption {
        default = "/run/current-system/systemd/lib/systemd/systemd";
        type = lib.types.str;
        description = ''
          The program to execute to start systemd.
        '';
      };

      extraSystemdUnitPaths = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.str;
        description = ''
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

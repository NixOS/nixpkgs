{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  useHostResolvConf = config.networking.resolvconf.enable && config.networking.useHostResolvConf;

  bootStage2 = pkgs.replaceVarsWith {
    src = ./stage-2-init.sh;
    isExecutable = true;
    replacements = {
      shell = "${pkgs.bash}/bin/bash";
      systemConfig = null; # replaced in ../activation/top-level.nix
      inherit (config.boot) systemdExecutable;
      nixStoreMountOpts = lib.concatStringsSep " " (map lib.escapeShellArg config.boot.nixStoreMountOpts);
      inherit (config.system.nixos) distroName;
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
  };

in

{
  imports = [
    (lib.mkRemovedOptionModule
      [
        "boot"
        "readOnlyNixStore"
      ]
      "Please use the `boot.nixStoreMountOpts' option to define mount options for the Nix store, including 'ro'"
    )
  ];

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

      nixStoreMountOpts = mkOption {
        type = types.listOf types.nonEmptyStr;
        default = [
          "ro"
          "nodev"
          "nosuid"
        ];
        description = ''
          Defines the mount options used on a bind mount for the {file}`/nix/store`.
          This affects the whole system except the nix store daemon, which will undo the bind mount.

          `ro` enforces immutability of the Nix store.
          The store daemon should already not put device mappers or suid binaries in the store,
          meaning `nosuid` and `nodev` enforce what should already be the case.
        '';
      };

      systemdExecutable = mkOption {
        default = "/run/current-system/systemd/lib/systemd/systemd";
        type = types.str;
        description = ''
          The program to execute to start systemd.
        '';
      };

      extraSystemdUnitPaths = mkOption {
        default = [ ];
        type = types.listOf types.str;
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

{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.kbfs;

in {

  ###### interface

  options = {

    services.kbfs = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to mount the Keybase filesystem.";
      };

      mountPoint = mkOption {
        type = types.str;
        default = "/keybase";
        example = "/home/user/keybase";
        description = "Mountpoint for the Keybase filesystem.";
      };

      createMountPoint = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to create the mount point directory at startup time.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.kbfs;
        defaultText = "pkgs.kbfs";
        example = literalExample "pkgs.kbfs";
        description = "Keybase filesystem derivation to use.";
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [
          "-label kbfs"
          "-mount-type normal"
        ];
        description = ''
          Additional flags to pass to the Keybase filesystem on launch.
        '';
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    systemd.user.services.kbfs = {
      description = "Keybase File System";
      path = [ "/run/wrappers" ];
      preStart = ''
      ${optionalString cfg.createMountPoint
      "test -d ${cfg.mountPoint} || mkdir -p ${cfg.mountPoint}"
      }'';
      postStop = "fusermount -u ${cfg.mountPoint}";
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/kbfsfuse ${toString cfg.extraFlags} ${cfg.mountPoint}";
        RestartSec = 3;
        Restart = "on-failure";
      };
    };

    environment.systemPackages = [ cfg.package ];
  };
}

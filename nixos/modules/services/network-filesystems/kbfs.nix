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
        default = "%h/keybase";
        example = "/keybase";
        description = "Mountpoint for the Keybase filesystem.";
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
      requires = [ "keybase.service" ];
      after = [ "keybase.service" ];
      path = [ "/run/wrappers" ];
      serviceConfig = {
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${cfg.mountPoint}";
        ExecStart = "${pkgs.kbfs}/bin/kbfsfuse ${toString cfg.extraFlags} ${cfg.mountPoint}";
        ExecStopPost = "/run/wrappers/bin/fusermount -u ${cfg.mountPoint}";
        Restart = "on-failure";
        PrivateTmp = true;
      };
    };

    services.keybase.enable = true;
  };
}

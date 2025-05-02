{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.s3fs-fuse;

  mountModule = types.submodule {
    options = {
      mountPoint = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          The point where to mount the s3 filesystem. (second argument to s3fs)
        '';
        example = ''
          "/mnt/s3"
        '';
      };

      bucket = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          The name of the bucket you want to mount. (first argument to s3fs)
        '';
      };

      useChattr = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to use chattr to make the mount point immutable.
          This is useful to prevent files being written to the mount point when it is not mounted.
        '';
      };

      options = mkOption {
        type = types.listOf types.str;
        description = lib.mdDoc ''
          The options passed to the s3fs command
        '';
        example = ''
          [
            "passwd_file=/root/.passwd-s3fs"
            "use_path_request_style"
            "allow_other"
            "url=https://s3.example.com/"
          ]
        '';
      };
    };
  };
in
{
  options = {
    services.s3fs-fuse = {
      enable = mkEnableOption (lib.mdDoc ''
        Whether to enable s3fs-fuse mounts.
      '');

      package = mkOption {
        type = types.package;
        default = pkgs.s3fs;
        defaultText = literalExpression "pkgs.s3fs-fuse";
        description = lib.mdDoc "Which s3fs-fuse package to use.";
      };

      mounts = mkOption {
        type = types.attrsOf mountModule;
        description = lib.mdDoc ''
          A set of the s3 filesystems you want to mount.
          The name of the attribute is only used for naming the running service.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.services = mapAttrs'
      (name: mountSet:
        let
          mount = mountSet.mountPoint;
          inherit (mountSet) bucket options;
        in
        nameValuePair
          "s3fs-${name}"
          {
            description = "S3FS mount";
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              ExecStartPre = [
                "${pkgs.coreutils}/bin/mkdir -m 0500 -pv ${mount}"
              ] ++ optional mountSet.useChattr (
                "${pkgs.e2fsprogs}/bin/chattr +i ${mount}" # make mount point immutable so that it is not accidentally deleted
              );
              ExecStart = "${cfg.package}/bin/s3fs ${bucket} ${mount} -f "
                + lib.concatMapStringsSep " " (opt: "-o ${opt}") options;
              ExecStopPost = "-${pkgs.fuse}/bin/fusermount -u ${mount}";
              KillMode = "process";
              Restart = "on-failure";
            };
          })
      cfg.mounts;
  };

  meta = {
    maintainers = with lib.maintainers; [ alexnortung ];
  };
}

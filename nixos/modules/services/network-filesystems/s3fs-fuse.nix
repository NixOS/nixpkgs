{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.s3fs-fuse;

  mountModule = lib.types.submodule {
    options = {
      mountPoint = lib.mkOption {
        type = lib.types.str;
        description = ''
          The point where to mount the s3 filesystem. (second argument to s3fs)
        '';
        example = ''
          "/mnt/s3"
        '';
      };

      bucket = lib.mkOption {
        type = lib.types.str;
        description = ''
          The name of the bucket you want to mount. (first argument to s3fs)
        '';
      };

      useChattr = lib.mkEnableOption null // {
        description = ''
          Whether to use chattr to make the mount point immutable.
          This is useful to prevent files being written to the mount point when it is not mounted.
        '';
      };

      options = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = ''
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
      enable = lib.mkEnableOption "s3fs-fuse mounts";

      package = lib.mkPackageOption pkgs "s3fs" { example = [ "s3fs-fuse" ]; };

      mounts = lib.mkOption {
        type = lib.types.attrsOf mountModule;
        description = ''
          A set of the s3 filesystems you want to mount.
          The name of the attribute is only used for naming the running service.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.services = lib.mapAttrs' (
      name: mountSet:
      let
        mount = mountSet.mountPoint;
        inherit (mountSet) bucket options;
      in
      lib.nameValuePair "s3fs-${name}" {
        description = "S3FS mount";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStartPre =
            [
              "${pkgs.coreutils}/bin/mkdir -m 0500 -pv ${mount}"
            ]
            ++ lib.optional mountSet.useChattr (
              "${pkgs.e2fsprogs}/bin/chattr +i ${mount}" # make mount point immutable so that it is not accidentally deleted
            );
          ExecStart =
            "${cfg.package}/bin/s3fs ${bucket} ${mount} -f "
            + lib.concatMapStringsSep " " (opt: "-o ${opt}") options;
          ExecStopPost = "-${pkgs.fuse}/bin/fusermount -u ${mount}";
          KillMode = "process";
          Restart = "on-failure";
        };
      }
    ) cfg.mounts;
  };

  meta = {
    maintainers = with lib.maintainers; [ alexnortung ];
  };
}

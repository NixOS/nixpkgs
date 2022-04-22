{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.s3backer;
  mountOption = { name, ... }: {
    options = {
      accessFile = mkOption {
        default = null;
        type = types.nullOr types.path;
        description = ''
          Specify a file containing `accessID:accessKey' pairs, one per-line.  Blank lines and lines beginning with a `#' are ignored.
          If no --accessKey or --accessKeyEnv is specified, this file will be searched for the entry matching the access ID specified via --accessId;
          if no --accessId is specified, the first entry in this file will be used. If not specified, $HOME/.s3backer_passwd will be used.
        '';
      };
      bucketPath = mkOption {
        type = types.str;
        description = ''
          Bucket and optional key within bucket to create backing file for.
        '';
        example = "bucket_name/subdir";
      };
      encrypt = mkOption {
        default = false;
        type = types.nullOr types.bool;
        description = ''
          Enable encryption and authentication of block data.
        '';
      };
      passwordFile = mkOption {
        default = null;
        type = types.nullOr types.path;
        description = ''
          File containing the encryption password for the 'encrypt' option.
        '';
      };
      mountPoint = mkOption {
        default = "/var/lib/s3backer/${name}";
        type = types.str;
        description = "Mount point for s3backer FUSE filesystem";
      };
      size = mkOption {
        type = types.str;
        description = ''
          Specify the size (in bytes) of the backed file to be exported by the filesystem.
          The size may have an optional suffix 'K' for Kilobytes, 'M' for Megabytes, 'G' for Gigabytes, 'T' for Terabytes, 'E' for Exabytes, 'Z' for Zettabytes, or 'Y' for Yottabytes.
        '';
      };
      filename = mkOption {
        default = "file";
        type = types.str;
        description = ''
          The name of the backed file that appears in the s3backer filesystem.
        '';
      };
      extraOptions = mkOption {
        default = null;
        type = types.nullOr types.lines;
        description = ''
          Extra command-line arguments to be passed to s3backer.

          Leading and trailing whitespace is trimmed from each line, and blank lines and lines starting with # are ignored.
          Each line contains exactly one command line argument (including internal whitespace, if any).
        '';
      };
    };
  };
in
{
  options.services.s3backer = {
    package = mkPackageOption pkgs "s3backer" { };
    mounts = mkOption {
      default = { };
      type = types.attrsOf (types.submodule mountOption);
      description = ''
        Configuration for s3backer mount points.
      '';
    };
  };
  config.systemd.services = mapAttrs'
    (name: mount:
      let options = [
        (lib.optionalString (mount.accessFile != null) "--accessFile=${mount.accessFile}")
        (lib.optionalString mount.encrypt "--encrypt")
        (lib.optionalString (mount.passwordFile != null) "--passwordFile=${mount.passwordFile}")
        "--size=${mount.size}"
        "--filename=${mount.filename}"
        "--configFile=${pkgs.writeText "s3backer-${name}-extra.conf" mount.extraOptions}"
      ];
      in
      nameValuePair ("s3backer-${name}") {
        path = [ cfg.package ];
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        restartIfChanged = true;
        preStart = ''
          mkdir -p ${mount.mountPoint}
        '';
        script = ''
          s3backer -f ${concatStringsSep " " options} ${mount.bucketPath} ${mount.mountPoint}
        '';
      })
    cfg.mounts;
}

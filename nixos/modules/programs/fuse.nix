{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.fuse;
in
{
  meta.maintainers = [ ];

  options.programs.fuse = {
    enable = lib.mkEnableOption "fuse";

    mountMax = lib.mkOption {
      # In the C code it's an "int" (i.e. signed and at least 16 bit), but
      # negative numbers obviously make no sense:
      type = lib.types.ints.between 0 32767; # 2^15 - 1
      default = 1000;
      description = ''
        Set the maximum number of FUSE mounts allowed to non-root users.
      '';
    };

    userAllowOther = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Allow non-root users to specify the allow_other or allow_root mount
        options, see mount.fuse3(8).
      '';
    };
  };

  config =
    let
      umount-fuse-script = pkgs.writeShellScriptBin "umount.fuse" ''
        FUSERMOUNT=/run/wrappers/bin/fusermount3 # SUID bit needed

        usage() {
            echo "Usage: umount.fuse {directory|device} [-flnrv] [-N namespace] [-t type.subtype]" >&2
            echo "See umount(8) man page" >&2
            exit 1 # same error code as umount
        }

        # the first positional argument is always the target mountpoint/device.
        (( $# >= 1 )) || usage
        TARGET="$1"
        shift

        fuse_args=()
        fuse_args+=("-u") # unmount flag

        while (( $# > 0 )); do
            case "$1" in
                -f) echo "umount.fuse: warning: -f (force) is not supported by this helper, ignoring" >&2 ;;
                -l) fuse_args+=("-z") ;; # lazy mount
                -n) echo "umount.fuse: warning: -n (no-mtab) is not supported by this helper, ignoring" >&2 ;;
                -r) echo "umount.fuse: warning: -r (read-only fallback) is not supported by this helper, ignoring" >&2 ;;
                -v) ;; # not used by fusermount
                -N)
                    echo "umount.fuse: -N (namespace) is not supported by this helper" >&2
                    exit 1
                    ;;
                -t)
                    echo "umount.fuse: warning: -t (type) is not supported by this helper, ignoring" >&2
                    shift
                    ;;
                *)
                    echo "umount.fuse: unexpected argument: $1" >&2
                    usage
                    ;;
            esac
            shift
        done

        fuse_args+=("--") # ensures that a mountpoint starting with '-' is correctly interpreted
        fuse_args+=("$TARGET")

        exec "$FUSERMOUNT" "''${fuse_args[@]}"

        echo "umount.fuse: exec failed: $FUSERMOUNT" >&2
        exit 2 # same error code as umount: system error (cannot fork, etc.)
      '';
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = [
        pkgs.fuse
        pkgs.fuse3
        umount-fuse-script
      ];

      security.wrappers =
        let
          mkSetuidRoot = source: {
            setuid = true;
            owner = "root";
            group = "root";
            inherit source;
          };
        in
        {
          fusermount = mkSetuidRoot "${lib.getBin pkgs.fuse}/bin/fusermount";
          fusermount3 = mkSetuidRoot "${lib.getBin pkgs.fuse3}/bin/fusermount3";
        };

      environment.etc."fuse.conf".text = ''
        ${lib.optionalString (!cfg.userAllowOther) "#"}user_allow_other
        mount_max = ${toString cfg.mountMax}
      '';

    };
}

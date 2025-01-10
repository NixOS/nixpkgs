{ config, lib, ... }:

let
  cfg = config.programs.fuse;
in
{
  meta.maintainers = with lib.maintainers; [ primeos ];

  options.programs.fuse = {
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

  config = {
    environment.etc."fuse.conf".text = ''
      ${lib.optionalString (!cfg.userAllowOther) "#"}user_allow_other
      mount_max = ${builtins.toString cfg.mountMax}
    '';
  };
}

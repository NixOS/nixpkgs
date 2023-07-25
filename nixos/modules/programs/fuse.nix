{ config, lib, ... }:

with lib;

let
  cfg = config.programs.fuse;
in {
  meta.maintainers = with maintainers; [ primeos ];

  options.programs.fuse = {
    mountMax = mkOption {
      # In the C code it's an "int" (i.e. signed and at least 16 bit), but
      # negative numbers obviously make no sense:
      type = types.ints.between 0 32767; # 2^15 - 1
      default = 1000;
      description = lib.mdDoc ''
        Set the maximum number of FUSE mounts allowed to non-root users.
      '';
    };

    userAllowOther = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Allow non-root users to specify the allow_other or allow_root mount
        options, see mount.fuse3(8).
      '';
    };
  };

  config =  {
    environment.etc."fuse.conf".text = ''
      ${optionalString (!cfg.userAllowOther) "#"}user_allow_other
      mount_max = ${toString cfg.mountMax}
    '';
  };
}

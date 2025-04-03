{ config, lib, ... }:
let
  cfg = config.security;
in
{
  options = {
    security.lsm = lib.mkOption {
      type = lib.types.uniq (lib.types.listOf lib.types.str);
      default = [ ];
      description = ''
        A list of the LSMs to initialize in order.
      '';
    };
  };

  config = lib.mkIf (lib.lists.length cfg.lsm > 0) {
    assertions = [
      {
        assertion = builtins.length (lib.filter (lib.hasPrefix "security=") config.boot.kernelParams) == 0;
        message = "security parameter in boot.kernelParams cannot be used when security.lsm is used";
      }
    ];

    boot.kernelParams = [
      "lsm=${lib.concatStringsSep "," cfg.lsm}"
    ];
  };
}

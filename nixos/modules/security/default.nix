{ config, lib, ... }:
let
  cfg = config.security;
in
{
  options = {
    security.lsm = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        A list of the LSMs to initialize.
      '';
    };
  };

  config = lib.mkIf (lib.lists.length cfg.lsm > 0) {
    boot.kernelParams = [
      "lsm=${lib.concatStringsSep "," cfg.lsm}"
    ];
  };
}

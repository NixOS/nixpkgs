{ config, lib, ... }:
{
  options.system.boot.extraInitrd = {
    paths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        List of paths relative to the ESP that are combined with the NixOS
        main initrd before being passed to the kernel.
      '';
    };
  };

  config = {
    boot.bootspec.extensions = lib.mkIf (config.system.boot.extraInitrd.paths != [ ]) {
      "org.nixos.extra-initrd.v1" = {
        inherit (config.system.boot.extraInitrd) paths;
      };
    };
  };
}

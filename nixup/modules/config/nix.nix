{ config, lib, pkgs, ... }:

with lib;

{

  options = {

    nix.package = mkOption {
      type = types.package;
      default = pkgs.nix;
      description = ''
        This option specifies the Nix package instance to use
        within the nixuser-rebuild command.
      '';
    };

  };

}

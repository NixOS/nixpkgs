{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.nixpkgs.licenses;

in

{
  options = {

    nixpkgs.licenses = {

      allowUnfree = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Allow all unfree licenses. If false packages with an
          unfree license cannot be installed from nixpkgs.
        '';
      };

    };

  };


  config = {

    nixpkgs.config = {

      allowUnfree = cfg.allowUnfree;

    };

  };

}

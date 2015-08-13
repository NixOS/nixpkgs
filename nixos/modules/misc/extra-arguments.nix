{ lib, pkgs, config, ... }:

{
  _module.args = {
    pkgs_i686 = import ../../.. {
      system = "i686-linux";
      config.allowUnfree = config.nixpkgs.licenses.allowUnfree;
    };

    utils = import ../../lib/utils.nix pkgs;
  };
}

{ lib, pkgs, config, ... }:

{
  _module.args = {
    pkgs_i686 = import ../../.. {
      system = "i686-linux";
      # FIXME: we enable config.allowUnfree to make packages like
      # nvidia-x11 available. This isn't a problem because if the user has
      # ‘nixpkgs.config.allowUnfree = false’, then evaluation will fail on
      # the 64-bit package anyway. However, it would be cleaner to respect
      # nixpkgs.config here.
      config.allowUnfree = true;
    };

    utils = import ../../lib/utils.nix config pkgs;
  };
}

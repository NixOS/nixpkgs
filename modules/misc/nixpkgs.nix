{ config, pkgs, ... }:

{
  options = {

    nixpkgs.config = pkgs.lib.mkOption {
      default = {};
      example = {
        firefox.enableGeckoMediaPlayer = true;
      };
      description = ''
        The configuration of the Nix Packages collection.
      '';
    };

  };
}

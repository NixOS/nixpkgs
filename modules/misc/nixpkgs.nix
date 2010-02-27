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

    nixpkgs.platform = pkgs.lib.mkOption {
      default = pkgs.platforms.pc;
      description = ''
        The platform for the Nix Packages collection.
      '';
    };

  };
}

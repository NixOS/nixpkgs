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

    nixpkgs.system = pkgs.lib.mkOption {
      default = "";
      description = ''
        Specifies the Nix platform type for which NixOS should be built.
        If unset, it defaults to the platform type of your host system
        (<literal>${builtins.currentSystem}</literal>).
        Specifying this option is useful when doing distributed
        multi-platform deployment, or when building virtual machines.
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

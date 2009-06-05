# From an end-user configuration file (`configuration'), build a NixOS
# configuration object (`config') from which we can retrieve option
# values.

{ configuration
, system ? builtins.currentSystem
, nixpkgs ? import ./from-env.nix "NIXPKGS" /etc/nixos/nixpkgs
, pkgs ? import nixpkgs {inherit system;}
}:

rec {
  inherit nixpkgs pkgs;

  configComponents = [
    configuration
    {
      require = import ../modules/module-list.nix;
      environment.checkConfigurationOptions = pkgs.lib.mkOption {
        default = true;
        example = false;
        description = ''
          Whether to check the validity of the entire configuration.
        '';
      };
    }
  ];

  config_ =
    pkgs.lib.fixOptionSets
      pkgs.lib.mergeOptionSets
      pkgs configComponents;

  optionDeclarations =
    pkgs.lib.fixOptionSetsFun
      pkgs.lib.filterOptionSets
      pkgs configComponents
      config_;
      
  # Optionally check wether all config values have corresponding
  # option declarations.
  config = pkgs.checker config_
    config_.environment.checkConfigurationOptions
    optionDeclarations config_;
}

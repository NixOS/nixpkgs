let

  fromEnv = name: default:
    let env = builtins.getEnv name; in
    if env == "" then default else env;
    
  configuration = import (fromEnv "NIXOS_CONFIG" /etc/nixos/configuration.nix);
  
  nixpkgs = fromEnv "NIXPKGS" /etc/nixos/nixpkgs;

  pkgs = import nixpkgs {system = builtins.currentSystem;};
  
  #system = import system/system.nix { inherit configuration nixpkgs; };

  configComponents = [
    configuration
    (import ./system/options.nix)
  ];

  # Make a configuration object from which we can retrieve option
  # values.
  config =
    pkgs.lib.fixOptionSets
      pkgs.lib.mergeOptionSets
      pkgs configComponents;

  optionDeclarations =
    pkgs.lib.fixOptionSetsFun
      pkgs.lib.filterOptionSets
      pkgs configComponents
      config;
  
in

{

  # Optionally check wether all config values have corresponding
  # option declarations.
  system = pkgs.checker config.system.build.system
    config.environment.checkConfigurationOptions
    optionDeclarations config;

  nix = config.environment.nix;
  
  nixFallback = pkgs.nixUnstable;

  manifests = config.installer.manifests; # exported here because nixos-rebuild uses it

  tests = config.tests;
}

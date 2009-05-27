let

  fromEnv = name: default:
    let env = builtins.getEnv name; in
    if env == "" then default else env;
    
  configuration = import (fromEnv "NIXOS_CONFIG" /etc/nixos/configuration.nix);
  
  nixpkgs = fromEnv "NIXPKGS" /etc/nixos/nixpkgs;

  pkgs = import nixpkgs {system = builtins.currentSystem;};

  inherit
    (import ./lib/eval-config.nix {inherit configuration pkgs;})
    config optionDeclarations;

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

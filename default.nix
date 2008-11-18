let

  fromEnv = name : default :
    let env = builtins.getEnv name; in
    if env == "" then default else env;
  configuration = import (fromEnv "NIXOS_CONFIG" /etc/nixos/configuration.nix);
  nixpkgsPath   =         fromEnv "NIXPKGS"      /etc/nixos/nixpkgs;

  system = import system/system.nix { inherit configuration nixpkgsPath; };

in

{ inherit (system)
    activateConfiguration
    bootStage2
    etc
    grubMenuBuilder
    kernel
    modulesTree
    nix
    system
    systemPath
    config
    ;

  inherit (system.nixosTools)
    nixosCheckout
    nixosHardwareScan
    nixosInstall
    nixosRebuild
    nixosGenSeccureKeys
    ;

  inherit (system.initialRamdiskStuff)
    bootStage1
    extraUtils
    initialRamdisk
    modulesClosure
    ;
    
  nixFallback = system.nix;

  manifests = system.config.installer.manifests; # exported here because nixos-rebuild uses it

  tests = system.config.tests;
}

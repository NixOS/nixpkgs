{ lib }:

let
  inherit (lib.nixos) publicModules evalModules core;
in {
  publicModules = {
    # Attributes that refer to modules that are unique to certain kinds of systems.
    # For instance, some systems are bootable, some can rebuild themselves, whereas
    # need only very minimal facilities.
    # These form the public interface to the module graph.

    invokeNixpkgs = ./modules/misc/nixpkgs.nix;
    invokeNixpkgsImpure = { modules, ... }: {
      imports = [ modules.invokeNixpkgs ];
      nixpkgs.system = builtins.currentSystem;
    };
  };

  evalModules = {
    prefix ? [],
    modules ? [],
    specialArgs ? {},
  }: lib.evalModules {
    inherit prefix;
    modules = modules;
    specialArgs = {
      modulesPath = builtins.toString ../modules;
      modules = publicModules;
    } // specialArgs;
  };

  core = module: evalModules {
    modules = [ module ];
  };

}

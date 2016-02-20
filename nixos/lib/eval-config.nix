# From an end-user configuration file (`configuration'), build a NixOS
# configuration object (`config') from which we can retrieve option
# values.

# !!! Please think twice before adding to this argument list!
# Ideally eval-config.nix would be an extremely thin wrapper
# around lib.evalModules, so that modular systems that have nixos configs
# as subcomponents (e.g. the container feature, or nixops if network
# expressions are ever made modular at the top level) can just use
# types.submodule instead of using eval-config.nix
{ # !!! system can be set modularly, would be nice to remove
  system ? builtins.currentSystem
, # !!! is this argument needed any more? The pkgs argument can
  # be set modularly anyway.
  pkgs ? null
, # !!! what do we gain by making this configurable?
  baseModules ? import ../modules/module-list.nix
, # !!! See comment about args in lib/modules.nix
  extraArgs ? {}
, # !!! See comment about args in lib/modules.nix
  specialArgs ? {}
, modules
, # Pass through a configuration of the internal modules declared
  # in lib/modules.nix.
  _module ? {}
, # !!! See comment about typeInference in lib/modules.nix
  typeInference ? null
, # !!! See comment about check in lib/modules.nix
  check ? null
, prefix ? []
, lib ? import ../../lib
}:

let extraArgs_ = extraArgs; pkgs_ = pkgs; system_ = system;
    extraModules = let e = builtins.getEnv "NIXOS_EXTRA_MODULE_PATH";
                   in if e == "" then [] else [(import (builtins.toPath e))];
in

let
  pkgsModule = rec {
    _file = ./eval-config.nix;
    key = _file;
    config = {
      nixpkgs.system = lib.mkDefault system_;
      _module.args.pkgs = lib.mkIf (pkgs_ != null) (lib.mkForce pkgs_);
    };
  };

  internalModule = { _module = (_module
                     // (if isNull check then {} else { inherit check; })
                     // (if isNull typeInference then {} else { inherit typeInference; })); };

in rec {

  # Merge the option definitions in all modules, forming the full
  # system configuration.
  inherit (lib.evalModules {
    inherit prefix;
    modules = modules ++ extraModules ++ baseModules ++ [ pkgsModule ] ++ [ internalModule ];
    args = extraArgs;
    specialArgs = { modulesPath = ../modules; } // specialArgs;
  }) config options;

  # These are the extra arguments passed to every module.  In
  # particular, Nixpkgs is passed through the "pkgs" argument.
  extraArgs = extraArgs_ // {
    inherit modules baseModules;
  };

  inherit (config._module.args) pkgs;
}

# From an end-user configuration file (`configuration.nix'), build a NixOS
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
, # !!! See comment about check in lib/modules.nix
  check ? true
, prefix ? []
, lib ? import ../../lib
}:

let extraArgs_ = extraArgs; pkgs_ = pkgs;
    extraModules = let e = builtins.getEnv "NIXOS_EXTRA_MODULE_PATH";
                   in if e == "" then [] else [(import e)];
in

let
  pkgsModule = rec {
    _file = ./eval-config.nix;
    key = _file;
    config = {
      # Explicit `nixpkgs.system` or `nixpkgs.localSystem` should override
      # this.  Since the latter defaults to the former, the former should
      # default to the argument. That way this new default could propagate all
      # they way through, but has the last priority behind everything else.
      nixpkgs.system = lib.mkDefault system;
      _module.args.pkgs = lib.mkIf (pkgs_ != null) (lib.mkForce pkgs_);
    };
  };

in rec {

  # Merge the option definitions in all modules, forming the full
  # system configuration.
  inherit (lib.evalModules {
    inherit prefix check;
    modules = modules ++ extraModules ++ baseModules ++ [ pkgsModule ];
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

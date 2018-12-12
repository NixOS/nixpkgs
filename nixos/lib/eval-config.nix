# From an end-user configuration file (`configuration.nix'), build a NixOS
# configuration object (`config') from which we can retrieve option
# values.

# !!! Please think twice before adding to this argument list!
# Ideally eval-config.nix would be an extremely thin wrapper
# around lib.evalModules, so that modular systems that have nixos configs
# as subcomponents (e.g. the container feature, or nixops if network
# expressions are ever made modular at the top level) can just use
# types.submodule instead of using eval-config.nix
# !!! All these arguments can be configured in a modular way
# via the 'configureModules' attribute.
{ modules
, baseModules ? import ../modules/module-list.nix
, prefix ? []
, extraArgs ? {}
, specialArgs ? {}
, lib ? import ../../lib
, system ? builtins.currentSystem
, pkgs ? null
, check ? true
}:

let
  # These bindings will be shadowed by the rec attrset.
  extraArgs_ = extraArgs; pkgs_ = pkgs;

  # The option `nixpkgs.system` cannot be set inside `eval-modules.nix`,
  # because it is dependent on being present in the supplied module list,
  # which is not always the case for calls to `evalModules`, e.g. for submodules.
  pkgsModule = rec {
    _file = toString ./eval-config.nix;
    key = _file;
    config = {
      # Explicit `nixpkgs.system` or `nixpkgs.localSystem` should override
      # this. Since the latter defaults to the former, the former should
      # default to the argument. That way this new default could propagate all
      # they way through, but has the last priority behind everything else.
      nixpkgs.system = lib.mkDefault system;
    };
  };

in rec {
  # Merge the option definitions in all modules, forming the full
  # system configuration.
  inherit (import ../../lib/eval-modules.nix {
    inherit prefix specialArgs lib check;
    pkgs = pkgs_;
    modules = modules ++ baseModules ++ [ pkgsModule ];
    args = extraArgs;
  }) config options;

  # These are the extra arguments passed to every module.  In
  # particular, Nixpkgs is passed through the "pkgs" argument.
  extraArgs = extraArgs_ // {
    inherit modules baseModules;
  };

  inherit (config._module.args) pkgs;
}

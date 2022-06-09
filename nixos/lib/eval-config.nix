# From an end-user configuration file (`configuration.nix'), build a NixOS
# configuration object (`config') from which we can retrieve option
# values.

# !!! Please think twice before adding to this argument list!
# Ideally eval-config.nix would be an extremely thin wrapper
# around lib.evalModules, so that modular systems that have nixos configs
# as subcomponents (e.g. the container feature, or nixops if network
# expressions are ever made modular at the top level) can just use
# types.submodule instead of using eval-config.nix
evalConfigArgs@
{ # !!! system can be set modularly, would be nice to remove,
  #     however, removing or changing this default is too much
  #     of a breaking change. To set it modularly, pass `null`.
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
, modulesLocation ? (builtins.unsafeGetAttrPos "modules" evalConfigArgs).file or null
, # !!! See comment about check in lib/modules.nix
  check ? true
, prefix ? []
, lib ? import ../../lib
, extraModules ? let e = builtins.getEnv "NIXOS_EXTRA_MODULE_PATH";
                 in if e == "" then [] else [(import e)]
}:

let pkgs_ = pkgs;
in

let
  evalModulesMinimal = (import ./default.nix {
    inherit lib;
    # Implicit use of feature is noted in implementation.
    featureFlags.minimalModules = { };
  }).evalModules;

  pkgsModule = rec {
    _file = ./eval-config.nix;
    key = _file;
    config = {
      # Explicit `nixpkgs.system` or `nixpkgs.localSystem` should override
      # this.  Since the latter defaults to the former, the former should
      # default to the argument. That way this new default could propagate all
      # they way through, but has the last priority behind everything else.
      nixpkgs.system = lib.mkIf (system != null) (lib.mkDefault system);

      _module.args.pkgs = lib.mkIf (pkgs_ != null) (lib.mkForce pkgs_);
    };
  };

  withWarnings = x:
    lib.warnIf (evalConfigArgs?extraArgs) "The extraArgs argument to eval-config.nix is deprecated. Please set config._module.args instead."
    lib.warnIf (evalConfigArgs?check) "The check argument to eval-config.nix is deprecated. Please set config._module.check instead."
    x;

  legacyModules =
    lib.optional (evalConfigArgs?extraArgs) {
      config = {
        _module.args = extraArgs;
      };
    }
    ++ lib.optional (evalConfigArgs?check) {
      config = {
        _module.check = lib.mkDefault check;
      };
    };

  allUserModules =
    let
      # Add the invoking file (or specified modulesLocation) as error message location
      # for modules that don't have their own locations; presumably inline modules.
      locatedModules =
        if modulesLocation == null then
          modules
        else
          map (lib.setDefaultModuleLocation modulesLocation) modules;
    in
      locatedModules ++ legacyModules;

  noUserModules = evalModulesMinimal ({
    inherit prefix specialArgs;
    modules = baseModules ++ extraModules ++ [ pkgsModule modulesModule ];
  });

  # Extra arguments that are useful for constructing a similar configuration.
  modulesModule = {
    config = {
      _module.args = {
        inherit noUserModules baseModules extraModules modules;
      };
    };
  };

  nixosWithUserModules = noUserModules.extendModules { modules = allUserModules; };

in
withWarnings nixosWithUserModules // {
  inherit extraArgs;
  inherit (nixosWithUserModules._module.args) pkgs;
}

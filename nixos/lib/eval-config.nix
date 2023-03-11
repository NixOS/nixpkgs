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
{
  modules
, modulesLocation ? (builtins.unsafeGetAttrPos "modules" evalConfigArgs).file or null
, prefix ? []

, # !!! See comment about args in lib/modules.nix
  specialArgs ? {}

  # --- deprecated arguments ----------
  # them being set emits warnings below
, # !!! See comment about args in lib/modules.nix
  extraArgs ? null
, # !!! See comment about check in lib/modules.nix
  check ? null
, # !!! is this argument needed any more? The pkgs argument can
  # be set modularly anyway.
  pkgs ? null
, # !!! what do we gain by making this configurable?
  #     we can add modules that are included in specialisations, regardless
  #     of inheritParentConfig.
  baseModules ? import ../modules/module-list.nix
, extraModules ? let e = builtins.getEnv "NIXOS_EXTRA_MODULE_PATH";
                 in if e == "" then [] else [(import e)]
, # !!! system can be set modularly, would be nice to remove,
  #     however, removing or changing this default is too much
  #     of a breaking change. To set it modularly, don't define it.
  system ? null
, # !!! the nixos lib eval shims already use the minmial necessary lib
  #     for bootstrapping the module evaluation itself.
  #     This evaluation bootstrapping should be endogenous
  #     to the lib eval shim and not be changed under its feet via
  #     intransparent lib overloading. For all the rest, i.e. pass
  #     a custom lib to the module system, use _module.args.lib.
  lib ? import ../../lib
  # -----------------------------------
}:
let
  evalModulesMinimal = (import ./default.nix {
    inherit lib;
    # Implicit use of feature is noted in implementation.
    featureFlags.minimalModules = { };
  }).evalModules;

  inherit (import ./eval-config-legacy.nix { inherit lib evalConfigArgs; })
    legacyModules
    legacyPkgsModules;

  withWarnings = x:
    lib.warnIf (evalConfigArgs?extraArgs) "The extraArgs argument to eval-config.nix is deprecated. Please set config._module.args instead."
    lib.warnIf (evalConfigArgs?check) "The check argument to eval-config.nix is deprecated. Please set config._module.check instead."
    lib.warnIf (evalConfigArgs?pkgs) "The pkgs argument to eval-config.nix is deprecated. Please set config.pkgs instead."
    lib.warnIf (evalConfigArgs?system) "The system argument to eval-config.nix is deprecated. Please set config.nixpkgs.system instead."
    lib.warnIf (evalConfigArgs?baseModules) "The baseModules argument to eval-config.nix is deprecated."
    lib.warnIf (evalConfigArgs?extraModules) "The extraModules argument to eval-config.nix is deprecated."
    lib.warnIf (evalConfigArgs?lib) "The lib argument to eval-config.nix is deprecated. Please set config._module.args.lib instead."
    x;

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
    modules = baseModules ++ extraModules ++ legacyPkgsModules ++ [ modulesModule ];
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

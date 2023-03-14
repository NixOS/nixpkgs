# DO NOT IMPORT. Use nixpkgsFlake.lib.nixos, or import (nixpkgs + "/nixos/lib")
{ lib }: # read -^

let

  # Base: Use the miminal module evaluation
  evalModulesMinimal = (import ./default.nix {
    inherit lib;
    # Implicit use of feature is noted in implementation.
    featureFlags.minimalModules = { };
  }).evalModules;

  baseModules = import ../modules/module-list.nix;

  # See nixos/doc/manual/development/lib-modules-eval.section.md
  # or https://nixos.org/manual/nixos/unstable/index.html#sec-modules-evaluation
  # NOTE: We keep this interface simple, because almost everything can and should be done through `modules`!
  evalSystemConfiguration = args@{ prefix ? [], modules ? [], specialArgs ? {} }: let

    # Locate Modules: Ensure custom modules are located to guarantee a better user experience.
    #                 Non-located modules are inline modules and ones imported from value instead
    #                 of a file reference from which the importer could infer the location.
    #                 For example when idiomatically consuming a public interface via
    #                 `flake.nixosModules.my-module` instead of a private one via - say -
    #                 `(flake + /modules/my-module.nix)`.
    # Note: `setDefaultModuleLocation` only sets a location, if not set. So if you want to configure
    #       this yourself, just ensure that all modules in the `modules` list already have one set.
    modulesLocation = (builtins.unsafeGetAttrPos "modules" args).file or null;
    locatedModules = if modulesLocation == null then modules
      else map (lib.setDefaultModuleLocation modulesLocation) modules;

    # `noUserModules` is a contract consumed by
    # modules/system/activation/specialisation.nix
    # TODO (during review): critically revise & discuss! (and then remove this line :-)
    noUserModules = standardModules;

    # Standard Modules: Gather standard modules that are always part of a standard
    #                   configuration and place them into extra arguments so that
    #                   a configuration can reproduce a variant of itself inside
    #                   the module system.
    standardModules = let
      # Extra arguments that are useful for constructing a similar configuration.
      modulesModule = {
        config._module.args = { modules = locatedModules; inherit baseModules noUserModules; };
      };
    in evalModulesMinimal {
      inherit prefix specialArgs;
      modules = baseModules ++ [modulesModule];
    };

  in standardModules.extendModules { modules = locatedModules; };

in
{
  inherit evalSystemConfiguration baseModules;
}

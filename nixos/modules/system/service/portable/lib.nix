{ lib, ... }:
let
  inherit (lib)
    concatLists
    mapAttrsToList
    showOption
    types
    ;
in
rec {
  flattenMapServicesConfigToList =
    f: loc: config:
    f loc config
    ++ concatLists (
      mapAttrsToList (
        k: v:
        flattenMapServicesConfigToList f (
          loc
          ++ [
            "services"
            k
          ]
        ) v
      ) config.services
    );

  getWarnings = flattenMapServicesConfigToList (
    loc: config: map (msg: "in ${showOption loc}: ${msg}") config.warnings
  );

  getAssertions = flattenMapServicesConfigToList (
    loc: config:
    map (ass: {
      message = "in ${showOption loc}: ${ass.message}";
      assertion = ass.assertion;
    }) config.assertions
  );

  /**
    This is the entrypoint for the portable part of modular services.

    It provides the various options that are consumed by service manager implementations.

    # Inputs

    `serviceManagerPkgs`: A Nixpkgs instance which will be used for built-in logic such as converting `configData.<path>.text` to a store path.

    `extraRootModules`: Modules to be loaded into the "root" service submodule, but not into its sub-`services`. That's the modules' own responsibility.

    `extraRootSpecialArgs`: Fixed module arguments that are provided in a similar manner to `extraRootModules`.

    # Output

    An attribute set.

    `serviceSubmodule`: a Module System option type which is a `submodule` with the portable modules and this function's inputs loaded into it.
  */
  configure =
    {
      serviceManagerPkgs,
      extraRootModules ? [ ],
      extraRootSpecialArgs ? { },
    }:
    let
      modules = [
        (lib.modules.importApply ./service.nix { pkgs = serviceManagerPkgs; })
      ];
      serviceSubmodule = types.submoduleWith {
        class = "service";
        modules = modules ++ extraRootModules;
        specialArgs = extraRootSpecialArgs;
      };
    in
    {
      inherit serviceSubmodule;
    };
}

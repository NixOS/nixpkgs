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
    Entrypoint for integrating modular services into a containing module system.

    Each containing system (NixOS, ...) calls `configure` to
    obtain a `serviceSubmodule` type for its services option. The returned submodule
    includes the portable service base and any service-manager-specific modules
    passed via `extraRootModules`.

    **Implementing for a new system** (e.g. home-manager, nix-darwin):

    ```nix
    # darwin/modules/services/system.nix
    { lib, config, pkgs, ... }:
    let
      portable-lib = import <nixpkgs/lib/services/lib.nix> { inherit lib; };

      modularServiceConfiguration = portable-lib.configure {
        serviceManagerPkgs = pkgs;
        extraRootModules = [
          ./launchd-service.nix    # launchd-specific options (plist generation, etc.)
        ];
      };
    in
    {
      options.services = lib.mkOption {
        type = lib.types.attrsOf modularServiceConfiguration.serviceSubmodule;
        default = { };
      };

      config = {
        # Convert service tree -> launchd plists, assertions, etc.
        # (analogous to how NixOS converts to systemd units)
        launchd.agents = ...;
        assertions = ...;
        warnings = ...;
      };
    }
    ```

    lib.services.configure :: AttrSet -> { serviceSubmodule :: SubmoduleType }

    # Inputs

    `serviceManagerPkgs`

    : 1\. A Nixpkgs instance used for built-in logic such as converting
    `configData.<path>.text` to a store path.

    `extraRootModules`

    : 2\. Modules to be loaded into the "root" service submodule, but not
    into its sub-`services`. That's the modules' own responsibility.
    Typically contains service-manager-specific option modules
    (e.g. systemd unit options, launchd plist options).

    `extraRootSpecialArgs`

    : 3\. Fixed module arguments provided alongside `extraRootModules`.

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
